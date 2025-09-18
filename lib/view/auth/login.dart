import 'package:attendance_project/api/register_service.dart';
import 'package:attendance_project/extension/navigator.dart';
import 'package:attendance_project/navigator/bottom_nav.dart';
import 'package:attendance_project/share_preferences/share_preferences.dart';
import 'package:attendance_project/utils/app_color.dart';
import 'package:attendance_project/view/auth/register.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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

  Future<void> Login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      try {
        final loginResponse = await AuthenticationAPI.loginUser(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // aman dari null
        final token = loginResponse.data.token.toString() ?? "";
        if (token.isEmpty) {
          throw Exception("Token kosong dari API");
        }

        PreferenceHandler.saveToken(token);
        context.pushReplacement(BottomNavigator());
      } catch (e) {
        setState(() {
          errorMessage = e.toString();
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login Gagal: $e")));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
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
                  child: Image.asset("assets/images/slideremovebg.png"),
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
                SizedBox(height: 30),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AttendanceColors.button,
                    ),
                    onPressed: () {
                      Login();
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
