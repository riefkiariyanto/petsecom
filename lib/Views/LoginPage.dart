import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petsecom/Constants/constants.dart';
import 'package:petsecom/Controllers/auth.dart';
import 'package:petsecom/Views/HomePage.dart';
import 'package:petsecom/Views/RegisterPage.dart';
import 'package:petsecom/genTextFormField.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Image(
                    image: AssetImage("images/Login.PNG"),
                    height: 200.0,
                    width: 235.0,
                    fit: BoxFit.fill,
                  ),
                  Text(
                    'Hello !',
                    style: GoogleFonts.roboto(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'login for use',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),

                  //user ID
                  getTextFormField(
                    icon: Icons.person,
                    hintName: 'User Name',
                    controller: _usernameController,
                  ),
                  SizedBox(height: 10),
                  //password
                  getTextFormField(
                    icon: Icons.lock,
                    hintName: 'Password',
                    controller: _passwordController,
                    isObscureText: true,
                  ),
                  SizedBox(height: 10),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () async {
                        await _authController.login(
                          username: _usernameController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                      },
                      child: Obx(() {
                        return _authController.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.deepOrange,
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    'login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                      }),
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member ? ',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RegistePage()));
                        },
                        child: Text(
                          'Register Now',
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Colors.deepOrange[300],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
