import 'dart:async';

import 'package:attendance_project/api/register_service.dart';
import 'package:attendance_project/extension/navigator.dart';
import 'package:attendance_project/model/login_model.dart';
import 'package:attendance_project/navigator/bottom_nav.dart';
import 'package:attendance_project/share_preferences/share_preferences.dart';
import 'package:attendance_project/utils/app_color.dart';
import 'package:attendance_project/view/auth/register.dart';
import 'package:attendance_project/view/widget/otp_request.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const id = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isVisibility = false;
  bool isLoading = false;
  String? errorMessage;
  RegisterUserModel? user;

  Future<void> showLottieDialog(
    BuildContext context, {
    required String asset,
    required String message,
  }) async {
    final completer = Completer<void>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 120,
                  child: Lottie.asset(
                    asset,
                    repeat: false,
                    onLoaded: (composition) {
                      Future.delayed(composition.duration, () {
                        if (Navigator.canPop(dialogContext)) {
                          Navigator.of(
                            dialogContext,
                            rootNavigator: true,
                          ).pop();
                          completer.complete();
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return completer.future;
  }

  void loginUser() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      await showLottieDialog(
        context,
        asset: "assets/lottie/emptybox.json",
        message: "Email dan password tidak boleh kosong",
      );
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      return;
    }
    try {
      final results = await AuthenticationAPI.loginUser(
        email: email,
        password: password,
      );
      if (!mounted) return;
      setState(() {
        user = results;
      });
      if (!mounted) return;
      await showLottieDialog(
        context,
        asset: "assets/lottie/succes.json",
        message: "Login berhasil",
      );
      await PreferenceHandler.saveToken(user?.data?.token.toString() ?? "");
      final savedUserId = await PreferenceHandler.getUserId();
      print("Saved User Id: $savedUserId");

      if (!mounted) return;
      context.pushReplacement(BottomNavigator());
    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
      });
      if (!mounted) return;
      await showLottieDialog(
        context,
        asset: "assets/lottie/failed(2).json",
        message: "Login gagal\n$errorMessage",
      );
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AttendanceColors.background,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Image.asset("assets/images/logoSlide2.png"),
                ),
                Text("Hi! Welcome back, you've been missed"),
                SizedBox(height: 20),
                Text("Email"),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    filled: true,
                    fillColor: AttendanceColors.pastelgrey,
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
                    hintText: "Password",
                    filled: true,
                    fillColor: AttendanceColors.pastelgrey,
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
                TextButton(
                  onPressed: () {
                    context.push(ForgotResetPasswordPage());
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF67548e),
                    ),
                    onPressed: () {
                      loginUser();
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an acoount?"),
                    TextButton(
                      onPressed: () {
                        context.push(RegisterPage());
                      },
                      child: Text("Sign Up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
