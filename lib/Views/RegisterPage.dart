import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petsecom/Controllers/auth.dart';
import '../Controllers/input_widgets.dart';
import 'LoginPage.dart';

class RegistePage extends StatefulWidget {
  const RegistePage({super.key});

  @override
  State<RegistePage> createState() => _RegistePageState();
}

class _RegistePageState extends State<RegistePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _imagesController = TextEditingController();

  // final TextEditingController _ImagesController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.05),
                Text(
                  'Here to Get',
                  style: GoogleFonts.roboto(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Welcomed!',
                  style: GoogleFonts.roboto(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                InputWidget(
                  labelText: 'name',
                  isObscureText: false,
                  controller: _nameController,
                ),
                SizedBox(height: height * 0.01),
                InputWidget(
                  labelText: 'username',
                  isObscureText: false,
                  controller: _usernameController,
                ),
                inputNumber(
                  labelText: 'phone',
                  isObscureText: false,
                  controller: _phoneController,
                ),
                InputWidget(
                  labelText: 'address',
                  isObscureText: false,
                  controller: _addressController,
                ),
                SizedBox(height: height * 0.01),
                InputWidget(
                  labelText: 'email',
                  isObscureText: false,
                  controller: _emailController,
                ),
                SizedBox(height: height * 0.01),
                InputWidget(
                  labelText: 'password',
                  isObscureText: true,
                  controller: _passwordController,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sign up",
                      style: GoogleFonts.roboto(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(() {
                      return _authController.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.deepOrange,
                              ),
                            )
                          : Container(
                              child: Material(
                                color: Colors.white,
                                child: Center(
                                  child: Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors.deepPurple,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                          Icons.arrow_forward_ios_rounded),
                                      color: Colors.white,
                                      onPressed: () async {
                                        await _authController.register(
                                          name: _nameController.text.trim(),
                                          username:
                                              _usernameController.text.trim(),
                                          phone: _phoneController.text.trim(),
                                          address:
                                              _addressController.text.trim(),
                                          email: _emailController.text.trim(),
                                          password:
                                              _passwordController.text.trim(),
                                          images: _imagesController.text.trim(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                    }),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      ' Have account ',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage()),
                            (Route<dynamic> route) => false);
                      },
                      child: Text(
                        'Login Now',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
