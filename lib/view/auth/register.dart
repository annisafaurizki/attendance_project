import 'package:attendance_project/extension/navigator.dart';
import 'package:attendance_project/utils/app_color.dart';
import 'package:attendance_project/view/auth/login.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => __RegisterPageStateState();
}

class __RegisterPageStateState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  String? pilihKejuruan;
  String? pilihBatch;
  bool isVisibility = false;
  bool isLoading = true;
  List<Map<String, dynamic>> listKejuruan = [];
  List<Map<String, dynamic>> listBatch = [];

  @override
  void initState() {
    super.initState();
    _fetchKejuruanData();
    _fetchBatch();
  }

  Future<void> _fetchBatch() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      listBatch = [
        {'id': '1', 'name': 'Batch 1'},
        {'id': '2', 'name': 'Batch 2'},
        {'id': '3', 'name': 'Batch 3'},
      ];
      isLoading = false;
    });
  }

  Future<void> _fetchKejuruanData() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      listKejuruan = [
        {'id': '1', 'name': 'Perhotelan', 'code': 'PH'},
        {'id': '2', 'name': 'Mobile Programming', 'code': 'MP'},
        {'id': '3', 'name': 'Design Konstruksi', 'code': 'DK'},
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AttendanceColors.background,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Image.asset("assets/images/slideremovebg.png"),
              ),
              Text("Name", textAlign: TextAlign.left),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AttendanceColors.pastelgrey,
                  hintText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Text("Kejuruan"),
              FutureBuilder(
                future: _fetchKejuruanData(),
                builder: (context, snapshot) {
                  if (isLoading) {
                    return const CircularProgressIndicator();
                  }

                  return DropdownButtonFormField<String>(
                    value: pilihKejuruan,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AttendanceColors.pastelgrey,
                      hintText: "Pilih Kejuruan",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    items: listKejuruan.map((kejuruan) {
                      return DropdownMenuItem<String>(
                        value: kejuruan['id'].toString(),
                        child: Text(
                          '${kejuruan['name']} (${kejuruan['code']})',
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        pilihKejuruan = newValue;
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              Text("Batch"),
              FutureBuilder(
                future: _fetchBatch(),
                builder: (context, snapshot) {
                  if (isLoading) {
                    return const CircularProgressIndicator();
                  }

                  return DropdownButtonFormField<String>(
                    value: pilihBatch,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AttendanceColors.pastelgrey,
                      hintText: "Pilih Batch",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    items: listBatch.map((batch) {
                      return DropdownMenuItem<String>(
                        value: batch['id'].toString(),
                        child: Text('${batch['name']})'),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        pilihBatch = newValue;
                      });
                    },
                  );
                },
              ),

              SizedBox(height: 20),
              Text("Email"),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AttendanceColors.pastelgrey,
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Text("Password"),
              TextField(
                controller: passwordController,
                obscureText: !isVisibility,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AttendanceColors.pastelgrey,
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisibility = !isVisibility;
                      });
                    },
                    icon: Icon(
                      isVisibility ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AttendanceColors.button,
                  ),
                  onPressed: () {},
                  child: Text("Sign Up", style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an acoount?"),
                  TextButton(
                    onPressed: () {
                      context.push(LoginPage());
                    },
                    child: Text("Sign In"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
