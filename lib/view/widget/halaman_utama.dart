import 'package:attendance_project/utils/app_color.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final TextEditingController bulanController = TextEditingController();
  List<Map<String, dynamic>> listBulan = [];
  String? pilihBulan;
  DateTime? _selectedDate;
  bool isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchBulan();
  // }

  // Future<void> _fetchBulan() async {
  //   await Future.delayed(Duration(seconds: 1));

  //   setState(() {
  //     listBulan = [
  //       {'id': '1', 'bulan': 'Januari'},
  //       {'id': '1', 'bulan': 'Februari'},
  //       {'id': '1', 'bulan': 'Maret'},
  //       {'id': '1', 'bulan': 'April'},
  //       {'id': '1', 'bulan': 'Mei'},
  //       {'id': '1', 'bulan': 'Juni'},
  //       {'id': '1', 'bulan': 'Juli'},
  //       {'id': '1', 'bulan': 'Agustus'},
  //       {'id': '1', 'bulan': 'September'},
  //       {'id': '1', 'bulan': 'Oktober'},
  //       {'id': '1', 'bulan': 'November'},
  //       {'id': '1', 'bulan': 'Desember'},
  //     ];
  //     isLoading = false;
  //   });
  // }

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
            // FutureBuilder(
            //   future: _fetchBulan(),
            //   builder: (context, snapshot) {
            //     if (isLoading) {
            //       return const CircularProgressIndicator();
            //     }

            //     return DropdownButtonFormField<String>(
            //       value: pilihBulan,
            //       decoration: InputDecoration(
            //         filled: true,
            //         fillColor: AttendanceColors.pastelgrey,
            //         hintText: "Pilih Bulan",
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(32),
            //         ),
            //       ),
            //       items: listBulan.map((bulan) {
            //         return DropdownMenuItem<String>(
            //           value: bulan['id'].toString(),
            //           child: Text('${bulan['name']}'),
            //         );
            //       }).toList(),
            //       onChanged: (String? newValue) {
            //         setState(() {
            //           pilihBulan = newValue;
            //         });
            //       },
            //     );
            //   },
            // ),
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
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green.shade100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Present"),
                          Text("2", style: TextStyle(fontSize: 30)),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Absent"),
                          Text("2", style: TextStyle(fontSize: 30)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
