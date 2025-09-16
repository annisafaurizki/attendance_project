import 'package:attendance_project/utils/app_color.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AttendanceColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Card(
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(color: AttendanceColors.lightgrey),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AttendanceColors.button,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AttendanceColors.button,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage(
                            "assets/images/catprofile.jpg",
                          ),
                          child: Text(""),
                        ),
                      ),
                    ),
                    Text(
                      "Annisa Faurizki",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Mobile Programming"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
