import 'dart:math';

import 'package:action_slider/action_slider.dart';
import 'package:attendance_project/api/absen_check_in_service.dart';
import 'package:attendance_project/model/absen_keluar_model.dart';
import 'package:attendance_project/model/absen_model.dart';
import 'package:attendance_project/utils/app_color.dart';
import 'package:attendance_project/view/widget/lottie.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({super.key});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  GoogleMapController? mapController;
  LatLng _currentPosition = LatLng(-6.200000, 106.816666); // Default Jakarta
  String _currentAddress = "Alamat tidak ditemukan";
  Marker? _marker;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AttendanceColors.background,
      body: Stack(
        children: [
          /// Google Maps
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            markers: _marker != null ? {_marker!} : {},
            onMapCreated: (controller) => mapController = controller,
          ),

          
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AttendanceColors.background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Lokasi
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Location",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentAddress,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Column(
                        children: [
                          Text("Check In"),
                          SizedBox(height: 4),
                          Text(
                            "10:07",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Check Out"),
                          SizedBox(height: 4),
                          Text(
                            "17:00",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  /// Slider Action
                  ActionSlider.dual(
                    backgroundBorderRadius: BorderRadius.circular(10.0),
                    foregroundBorderRadius: BorderRadius.circular(10.0),
                    width: 300.0,

                    // Warna track (latar belakang slider)
                    backgroundColor: AttendanceColors.pastelgrey,

                    // Warna tombol/knob slider
                    toggleColor: const Color(0xFF898AC4), // 🔴 knob merah

                    startChild: const Text('Check Out'),
                    endChild: const Text('Check In'),
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: Transform.rotate(
                        angle: 0.5 * pi,
                        child: const Icon(
                          Icons.unfold_more_rounded,
                          size: 28.0,
                          color: Colors.white, // warna icon dalam knob
                        ),
                      ),
                    ),

                    // Action CheckOut
                    startAction: (controller) async {
                      controller.loading();
                      try {
                        await _absenCheckOut();
                        controller.success();
                      } catch (e) {
                        controller.failure();
                      }
                      await Future.delayed(const Duration(seconds: 1));
                      controller.reset();
                    },

                    // Action CheckIn
                    endAction: (controller) async {
                      controller.loading();
                      try {
                        await _absenCheckIn();
                        controller.success();
                      } catch (e) {
                        controller.failure();
                      }
                      await Future.delayed(const Duration(seconds: 1));
                      controller.reset();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fungsi ambil lokasi + marker
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _marker = Marker(
        markerId: const MarkerId("lokasi_saya"),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: 'Lokasi Anda',
          snippet: "${place.street}, ${place.locality}",
        ),
      );

      _currentAddress =
          "${place.name}, ${place.street}, ${place.locality}, ${place.country}";

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 16),
        ),
      );
    });
  }

  /// Fungsi check in API
  Future<void> _absenCheckIn() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = "Alamat tidak ditemukan";
      String locationName = "Lokasi Tidak Diketahui";

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        address =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        locationName = place.locality ?? "Lokasi Tidak Diketahui";
      }

      AbsenCheckInModel? result = await AttendanceAPI.checkInUser(
        checkInLat: position.latitude,
        checkInLng: position.longitude,
        checkInLocation: locationName,
        checkInAddress: address,
      );

      if (!mounted) return;

      if (result != null && result.data != null) {
        await showLottieDialog(
          context: context,
          asset: "assets/lottie/checkin.json",
          message: result.message ?? "Berhasil Check-In!",
          onClose: () {},
        );
      } else {
        await showLottieDialog(
          context: context,
          asset: "assets/lottie/checkFailed.json",
          message: result?.message ?? "Sudah absen hari ini",
          onClose: () {},
        );
      }
    } catch (e) {
      if (!mounted) return;
      await showLottieDialog(
        context: context,
        asset: "assets/lottie/checkFailed.json",
        message: "Error: $e",
        onClose: () {},
      );
    }
  }

  /// Fungsi check out API
  Future<void> _absenCheckOut() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = "Alamat tidak ditemukan";
      String locationName = "Lokasi Tidak Diketahui";

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        address =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        locationName = place.locality ?? "Lokasi Tidak Diketahui";
      }

      AbsenCheckOutModels result = await AttendanceAPI.checkOut(
        checkOutLat: position.latitude,
        checkOutLng: position.longitude,
        checkOutLocation: locationName,
        checkOutAddress: address,
      );

      if (!mounted) return;

      if (result.data != null) {
        await showLottieDialog(
          context: context,
          asset: "assets/lottie/checkin.json",
          message: result.message ?? "Berhasil Check-Out!",
          onClose: () {},
        );
      } else {
        await showLottieDialog(
          context: context,
          asset: "assets/lottie/checkFailed.json",
          message: result.message ?? "Gagal Check-Out",
          onClose: () {},
        );
      }
    } catch (e) {
      if (!mounted) return;
      await showLottieDialog(
        context: context,
        asset: "assets/lottie/checkFailed.json",
        message: "Error: $e",
        onClose: () {},
      );
    }
  }
}
