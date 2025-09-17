// import 'package:action_slider/action_slider.dart';
import 'dart:math';

import 'package:action_slider/action_slider.dart';
import 'package:attendance_project/utils/app_color.dart';
import 'package:flutter/material.dart';

class AbsenHalaman extends StatefulWidget {
  const AbsenHalaman({super.key});

  @override
  State<AbsenHalaman> createState() => _AbsenHalamanState();
}

class _AbsenHalamanState extends State<AbsenHalaman> {
  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AttendanceColors.background,

      appBar: AppBar(
        backgroundColor: AttendanceColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),

          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/catprofile.jpg"),
              ),

              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Annisa Faurizki",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Mobile Programming",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Theme(
            //   data: Theme.of(context).copyWith(
            //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            //   ),
            //   child: Builder(
            //     builder: (context) {
            //       return EasyTheme(
            //         data: EasyTheme.of(context).copyWithState(
            //           selectedDayTheme: const DayThemeData(
            //             backgroundColor: AttendanceColors.button,
            //           ),
            //           unselectedDayTheme: const DayThemeData(
            //             backgroundColor: AttendanceColors.pastelgrey,
            //           ),
            //           disabledDayTheme: DayThemeData(
            //             backgroundColor: Colors.grey.shade100,
            //           ),
            //         ),
            //         child: EasyDateTimeLinePicker(
            //           focusedDate: _selectedDate,
            //           firstDate: DateTime(2024, 11, 15),
            //           lastDate: DateTime(2030, 3, 18),
            //           onDateChange: (date) {
            //             setState(() {
            //               _selectedDate = date;
            //             });
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AttendanceColors.pastelgrey,
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.login),
                        Text("Check In"),
                        Text("08:00 am"),
                        Text("On Time"),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AttendanceColors.pastelgrey,
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.logout),
                        Text("Check Out"),
                        Text("16:00 am"),
                        Text("On Time"),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage("assets/images/maps.png"),
                ),
              ),
            ),
            SizedBox(),
            ActionSlider.dual(
              backgroundBorderRadius: BorderRadius.circular(10.0),
              foregroundBorderRadius: BorderRadius.circular(10.0),
              width: 300.0,
              backgroundColor: AttendanceColors.pastelgrey,
              startChild: const Text('Check Out'),
              endChild: const Text('Check In'),
              icon: Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: Transform.rotate(
                  angle: 0.5 * pi,
                  child: const Icon(Icons.unfold_more_rounded, size: 28.0),
                ),
              ),
              startAction: (controller) async {
                controller.loading(); //starts loading animation
                await Future.delayed(const Duration(seconds: 3));
                controller.success(); //starts success animation
                await Future.delayed(const Duration(seconds: 1));
                controller.reset(); //resets the slider
              },
              endAction: (controller) async {
                controller.loading(); //starts loading animation
                await Future.delayed(const Duration(seconds: 3));
                controller.success(); //starts success animation
                await Future.delayed(const Duration(seconds: 1));
                controller.reset(); //resets the slider
              },
            ),
          ],
        ),
      ),
    );
  }
}
