import 'dart:io';

import 'package:attendance_project/api/register_service.dart';
import 'package:attendance_project/extension/navigator.dart';
import 'package:attendance_project/model/list_batch.dart';
import 'package:attendance_project/model/list_kejuruan.dart';
import 'package:attendance_project/model/register_model.dart';
import 'package:attendance_project/share_preferences/share_preferences.dart';
import 'package:attendance_project/utils/app_color.dart';
import 'package:attendance_project/view/auth/login.dart';
import 'package:attendance_project/view/widget/lottie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
   RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool hidePassword = true;
  bool isLoading = false;
  String? errorMessage;
  Register? user;

  String? selectedGender;
  batches? selectedBatch;
  Datum? selectedTraining; // dari ListTrainingModel

  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  List<String> genderList = ["L", "P"];
  List<batches> batchList = [];
  List<Datum> trainingList = [];

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
  }

  Future<void> fetchDropdownData() async {
    try {
      final batchResponse = await AuthenticationAPI.getAllBatch();
      final trainingResponse = await AuthenticationAPI.getAllKejuruan();
      setState(() {
        batchList = batchResponse.data ?? [];
        trainingList = trainingResponse.data ?? [];
      });
    } catch (e) {
      print("Error fetch dropdown: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal load data dropdown: $e")));
    }
  }

  Future<void> pickFoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedFile = image;
    });
  }

  Future<void> registerUser() async {
  final name = nameController.text.trim();
  final email = emailController.text.trim();
  final pass = passController.text.trim();

  // Validasi field kosong
  if (name.isEmpty || email.isEmpty || pass.isEmpty) {
    await showLottieDialog(
      context: context,
      asset: "assets/lottie/emptybox.json",
      message: "Semua field wajib diisi",
      onClose: () {},
    );
    return;
  }

  if (selectedGender == null ||
      selectedBatch == null ||
      selectedTraining == null) {
    await showLottieDialog(
      context: context,
      asset: "assets/lottie/emptybox.json",
      message: "Pilih gender, batch, dan training",
      onClose: () {},
    );
    return;
  }

  if (pickedFile == null) {
    await showLottieDialog(
      context: context,
      asset: "assets/lottie/emptybox.json",
      message: "Foto profil belum dipilih",
      onClose: () {},
    );
    return;
  }

  setState(() {
    isLoading = true;
    errorMessage = null;
  });

  try {
    Register result = await AuthenticationAPI.registerUser(
      name: name,
      email: email,
      password: pass,
      jenisKelamin: selectedGender!,
      profilePhoto: File(pickedFile!.path),
      batchId: selectedBatch!.id!,
      trainingId: selectedTraining!.id!,
    );
    await showLottieDialog(
      context: context,
      asset: "assets/lottie/succes.json",
      message: result.message ?? "Register berhasil",
      onClose: () {
        context.pushReplacement( LoginPage());
      },
    );
  } catch (e) {
    setState(() => errorMessage = e.toString());
    await showLottieDialog(
      context: context,
      asset: "assets/lottie/failed(2).json",
      message: "Gagal daftar: $errorMessage",
      onClose: () {},
    );
  } finally {
    setState(() => isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AttendanceColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              pickedFile != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(File(pickedFile!.path)),
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      child:  Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF898AC4),
                      ),
                    ),
               SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: pickFoto,
                icon:  Icon(Icons.camera_alt, color: Colors.grey),
                label:  Text(
                  "Pilih Foto Profil",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
               SizedBox(height: 16),

            
              TextField(
                controller: nameController,
                decoration: _inputDecoration("Nama"),
              ),
               SizedBox(height: 16),

              
              TextField(
                controller: emailController,
                decoration: _inputDecoration("Email"),
              ),
               SizedBox(height: 16),

              
              TextField(
                controller: passController,
                obscureText: hidePassword,
                decoration: _inputDecoration("Buat Sandi").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xFF898AC4),
                    ),
                    onPressed: () =>
                        setState(() => hidePassword = !hidePassword),
                  ),
                ),
              ),
               SizedBox(height: 16),

            
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: genderList
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => selectedGender = val),
                decoration: _inputDecoration("Jenis Kelamin"),
              ),
               SizedBox(height: 16),

              
              DropdownButtonFormField<batches>(
                value: selectedBatch,
                items: batchList
                    .map(
                      (b) => DropdownMenuItem(
                        value: b,
                        child: Text(b.batchKe ?? "Batch ${b.id}"),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedBatch = val),
                decoration: _inputDecoration("Pilih Batch"),
              ),
               SizedBox(height: 16),

              
              DropdownButtonFormField<Datum>(
                value: selectedTraining,
                items: trainingList
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: SizedBox(
                          width: 220, 
                          child: Text(
                            t.title ?? "Pelatihan ${t.id}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedTraining = val),
                decoration: _inputDecoration("Kejuruan"),
              ),

               SizedBox(height: 32),

      
              ElevatedButton(
                onPressed: isLoading ? null : registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF898AC4),
                  minimumSize:  Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ?  CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      )
                    : GestureDetector(
                        onTap: () => context.push(LoginPage()),
                        child:  Text(
                          "Buat Akun",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
              ),
               SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text("Sudah punya akun?"),
                   SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => context.push( LoginPage()),
                    child:  Text(
                      "Masuk",
                      style: TextStyle(
                        color: Color(0xFF898AC4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AttendanceColors.background,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
    );
  }
}
