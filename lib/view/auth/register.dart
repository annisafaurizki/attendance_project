import 'dart:io';

import 'package:attendance_project/api/register_service.dart';
import 'package:attendance_project/extension/navigator.dart';
import 'package:attendance_project/model/list_batch.dart';
import 'package:attendance_project/model/list_kejuruan.dart';
import 'package:attendance_project/model/register_model.dart';
import 'package:attendance_project/share_preferences/share_preferences.dart';
import 'package:attendance_project/utils/app_color.dart';
import 'package:attendance_project/view/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

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

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field wajib diisi")));
      return;
    }
    PreferenceHandler.saveToken(user?.data.token.toString() ?? "");

    if (selectedGender == null ||
        selectedBatch == null ||
        selectedTraining == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih gender, batch, dan training")),
      );
      return;
    }
    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto profil belum dipilih")),
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? "Register berhasil")),
      );
      context.push(const LoginPage());
    } catch (e) {
      setState(() => errorMessage = e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal daftar: $errorMessage")));
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Foto Profil
              pickedFile != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(File(pickedFile!.path)),
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: pickFoto,
                icon: const Icon(Icons.camera_alt, color: Colors.blueGrey),
                label: const Text(
                  "Pilih Foto Profil",
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
              const SizedBox(height: 16),

              /// Nama
              TextField(
                controller: nameController,
                decoration: _inputDecoration("Your Name"),
              ),
              const SizedBox(height: 16),

              /// Email
              TextField(
                controller: emailController,
                decoration: _inputDecoration("Email"),
              ),
              const SizedBox(height: 16),

              /// Password
              TextField(
                controller: passController,
                obscureText: hidePassword,
                decoration: _inputDecoration("Create Password").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => hidePassword = !hidePassword),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Gender
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: genderList
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => selectedGender = val),
                decoration: _inputDecoration("Choose Gender"),
              ),
              const SizedBox(height: 16),

              /// Batch (from API)
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
                decoration: _inputDecoration("Choose Batch"),
              ),
              const SizedBox(height: 16),

              /// Training (from API)
              DropdownButtonFormField<Datum>(
                value: selectedTraining,
                items: trainingList
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: SizedBox(
                          width: 220, // atur sesuai kebutuhan
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
                decoration: _inputDecoration("Trainings"),
              ),

              const SizedBox(height: 32),

              /// Tombol Daftar
              ElevatedButton(
                onPressed: isLoading ? null : registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AttendanceColors.button,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      )
                    : GestureDetector(
                        onTap: () => context.push(LoginPage()),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => context.push(const LoginPage()),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: AttendanceColors.button,
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
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
    );
  }
}
