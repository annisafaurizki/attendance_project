import 'package:attendance_project/api/history_service.dart';
import 'package:attendance_project/api/profile_service.dart';
import 'package:attendance_project/api/statistic_absen_service.dart';
import 'package:attendance_project/model/history_model.dart';
import 'package:attendance_project/model/profile_model.dart';
import 'package:attendance_project/utils/app_color.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  DateTime? _selectedDate;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AttendanceColors.background,

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FutureBuilder<GetProfileModel>(
              future: ProfileAPI.getProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text("Tidak ada data"));
                }

                final profile = snapshot.data!.data;

                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AttendanceColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AttendanceColors.button,
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  profile.profilePhotoUrl,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              children: [
                                Text(
                                  profile.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  profile.trainingTitle,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    FutureBuilder(
                      future: StatsAPI.getStats(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: Error ${snapshot.error}"),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.data == null) {
                          return Center(
                            child: Text("Belum ada data statistik"),
                          );
                        }

                        final stats = snapshot.data!.data!;

                        return Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.green.shade100,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Present"),
                                      Text(
                                        (stats.totalMasuk ?? 0).toString(),
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.red.shade100,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Absent"),
                                      Text(
                                        (stats.totalAbsen ?? 0).toString(),
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    FutureBuilder<GetHistoryModel>(
                      future: HistoryAPI.getHistory(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text("❌ Error: ${snapshot.error}"),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
                          return const Center(
                            child: Text("Belum ada riwayat booking"),
                          );
                        }

                        // filter status = cancelled
                        final bookings = snapshot.data!.data!;

                        if (bookings.isEmpty) {
                          return const Center(
                            child: Text("Belum ada riwayat booking"),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(16),
                          itemCount: bookings.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final history = bookings[index];

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: ListTile(
                                title: Text(
                                  history.status ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                // subtitle: Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Text(
                                //       "Dipesan: ${DateFormat('dd MMM yyyy, HH:mm').format(booking.bookingTime)}",
                                //     ),
                                //     Text("Status: ${booking.status}"),
                                //   ],
                                // ),
                                // trailing: Text(
                                //   "Rp ${service.price}",
                                //   style: const TextStyle(
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.red,
                                //   ),
                                // ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
