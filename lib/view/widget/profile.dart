import 'package:attendance_project/api/profile_service.dart';
import 'package:attendance_project/extension/navigator.dart';
import 'package:attendance_project/model/profile_model.dart';
import 'package:attendance_project/utils/app_color.dart';
import 'package:attendance_project/view/auth/login.dart';
import 'package:attendance_project/view/widget/otp_request.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<GetProfileModel> _profileFuture;

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
        backgroundColor: Colors.teal.withOpacity(0.15),
        child: Icon(icon, color: Colors.teal),
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
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.teal, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profile.profilePhotoUrl),
                    ),
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
                    title: "Edit Name",
                    onTap: () {
                      final controller = TextEditingController(
                        text: profile.name,
                      );
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Edit Name"),
                            content: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                labelText: "Name",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Batal"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await ProfileAPI.updateProfile(
                                      name: controller.text,
                                    );
                                    Navigator.pop(context);
                                    _refreshProfile();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Nama berhasil diperbarui",
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Gagal update: $e"),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Simpan"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Divider(),

                  _buildMenuItem(
                    icon: Icons.lock_reset,
                    title: "Reset Password",
                    onTap: () {
                      context.push(ForgotResetPasswordPage());
                    },
                  ),
                  const Divider(),

                  _buildMenuItem(
                    icon: Icons.info,
                    title: "About App",
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: "Attendance Project",
                        applicationVersion: "1.0.0",
                        applicationLegalese: "© 2025 Attendance App",
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
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.pushReplacement(LoginPage());
                      },
                      icon: Icon(Icons.logout, color: Colors.white),
                      label: Text(
                        "Log Out",
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
