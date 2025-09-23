import 'dart:io';

import 'package:attendance_project/api/edit_foto_service.dart';
import 'package:attendance_project/api/profile_service.dart';
import 'package:attendance_project/extension/navigator.dart';
import 'package:attendance_project/model/profile_model.dart';
import 'package:attendance_project/share_preferences/share_preferences.dart';
import 'package:attendance_project/utils/app_color.dart';
import 'package:attendance_project/view/auth/login.dart';
import 'package:attendance_project/view/widget/lottie.dart';
import 'package:attendance_project/view/widget/otp_request.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<GetProfileModel> _profileFuture;
  File? _selectedImage;
  bool _isUploading = false;

Future<void> _pickAndUploadImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      _selectedImage = File(pickedFile.path);
      _isUploading = true;
    });

    try {
      final result = await PhotoAPI.updatePhotoProfile(profilePhoto: _selectedImage!);
      await showLottieDialog(
        context: context,
        asset: "assets/lottie/succes.json",
        message: result.message ?? "Foto berhasil diubah",
        onClose: () {
          _refreshProfile();
        },
      );

    } catch (e) {
      await showLottieDialog(
        context: context,
        asset: "assets/lottie/Fail (1).json",
        message: "Gagal ubah foto: $e",
        onClose: () {},
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }
}


  

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileAPI.getProfile();
  }

  void _refreshProfile() {
    setState(() {
      _profileFuture = ProfileAPI.getProfile();
    });
  }

  

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: const Color(0xFF898AC4).withOpacity(0.15),
        child: Icon(icon, color: const Color(0xFF898AC4)),
      ),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AttendanceColors.background,
      body: FutureBuilder<GetProfileModel>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("Tidak ada data"));
          }

          final profile = snapshot.data!.data;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Profile",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Stack(
  children: [
    Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF898AC4),
          width: 3,
        ),
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: _selectedImage != null
            ? FileImage(_selectedImage!)
            : NetworkImage(profile.profilePhotoUrl) as ImageProvider,
      ),
    ),
    Positioned(
      bottom: 0,
      right: 0,
      child: InkWell(
        onTap: _isUploading ? null : _pickAndUploadImage,
        child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Icon(Icons.camera_alt, size: 20, color: Colors.grey[800]),
        ),
      ),
    ),
    if (_isUploading)
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
        ),
      ),
  ],
),

                  const SizedBox(height: 12),
                  Text(
                    profile.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    profile.trainingTitle,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  _buildMenuItem(
                    icon: Icons.edit,
                    title: "Ubah Nama",
                    onTap: () {
                      final controller = TextEditingController(
                        text: profile.name,
                      );
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // sudut dialog melengkung
                            ),
                            title: const Text(
                              "Ubah Nama",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    labelText: "Nama",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xFF67548e),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            actionsPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            actions: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: const BorderSide(color: Colors.grey),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Batal"),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF67548e),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () async {
                                  final newName = controller.text.trim();
                                  if (newName.isEmpty) return;

                                  try {
                                    final result = await ProfileAPI.updateProfile(name: newName);

                                    
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Lottie.asset(
                                                "assets/lottie/succes.json",
                                                width: 120,
                                                height: 120,
                                                repeat: false,
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                result.message ?? "Nama berhasil diubah",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                  
                                    Future.delayed(const Duration(seconds: 2), () {
                                      context.pop(context); 
                                      context.pop(context); 
                                      _refreshProfile();      
                                    });

                                  } catch (e) {
                                    
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Lottie.asset(
                                                "assets/lottie/Fail (1).json",
                                                width: 120,
                                                height: 120,
                                                repeat: false,
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                "Gagal ubah nama: $e",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 14, color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                    // ⏳ Tutup dialog otomatis setelah 2 detik
                                    Future.delayed(const Duration(seconds: 2), () {
                                      Navigator.pop(context);
                                    });
                                  }
                                },
                                child: const Text("Simpan"),
                              )


                            ],
                          );
                        },
                      );
                    },
                  ),
                  Divider(),

                  _buildMenuItem(
                    icon: Icons.lock_reset,
                    title: "Atur Ulang Kata Sandi",
                    onTap: () {
                      context.push(ForgotResetPasswordPage());
                    },
                  ),
                  const Divider(),

                  _buildMenuItem(
  icon: Icons.info,
  title: "Tentang Aplikasi",
  onTap: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Slide In",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Attendance Project",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("Versi 1.0.0"),
              SizedBox(height: 12),
              Text(
                "Aplikasi ini dibuat oleh Annisa Faurizki untuk "
                "mempermudah pencatatan absensi dan monitoring statistik.",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  },
),

                  Divider(),

                  // === Logout Button ===
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF898AC4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        PreferenceHandler.removeToken();
                        PreferenceHandler.removeLogin();

                        context.pushReplacement(const LoginPage());
                      },
                      icon: Icon(Icons.logout, color: Colors.white),
                      label: Text(
                        "Keluar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
