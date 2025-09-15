// import 'package:action_slider/action_slider.dart';
import 'package:attendance_project/utils/app_color.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AttendanceColors.background,

      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.location_on_outlined)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_active_outlined),
          ),
        ],
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
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AttendanceColors.pastelgrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.location_on_outlined),
                  SizedBox(width: 8),
                  Text(" No address is selected"),
                  TextButton(onPressed: () {}, child: Text("Select One")),
                ],
              ),
            ),
            EasyDateTimeLinePicker(
              focusedDate: _selectedDate,
              firstDate: DateTime(2024, 11, 15),
              lastDate: DateTime(2030, 3, 18),
              onDateChange: (date) {
                // Handle the selected date.
              },
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
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
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
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
            // ActionSlider.standard(
            //   child: const Text('Slide to confirm'),
            //   action: (controller) async {
            //     controller.loading(); //starts loading animation
            //     await Future.delayed(const Duration(seconds: 3));
            //     controller.success(); //starts success animation
            //   },

            // ),
          ],
        ),
      ),
    );
  }
}
