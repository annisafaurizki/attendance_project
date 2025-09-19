import 'package:attendance_project/api/profile_service.dart';
import 'package:attendance_project/model/profile_model.dart';
import 'package:attendance_project/utils/app_color.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AttendanceColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<GetProfileModel>(
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
                const SizedBox(height: 40),
                // ===== CARD PROFILE =====
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
                    child: Column(
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
                            radius: 45,
                            backgroundImage: NetworkImage(
                              profile.profilePhotoUrl,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
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
                  ),
                ),

                const SizedBox(height: 20),

                // ===== CARD INFO DETAIL =====
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AttendanceColors.background,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("Email", profile.email),
                        _buildInfoRow("Batch", profile.batchKe),
                        _buildInfoRow(
                          "Jenis Kelamin",
                          profile.jenisKelamin?.toString() ?? "-",
                        ),
                        _buildInfoRow("Kejuruan", profile.training.title),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Log Out"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Flexible(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
