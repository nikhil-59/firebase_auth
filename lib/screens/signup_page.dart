import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/models/sizeconfig.dart';
import 'package:firebase_authentication/services/authservice.dart';
import 'package:firebase_authentication/services/internet_service.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  File? photo;
  final _picker = ImagePicker();
  Future imgFromDevice(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);

    final nameField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.name,
      controller: nameController,
      decoration: const InputDecoration(
        hintText: "Name",
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter name";
        }
        if (!RegExp(r'^.{3,}$').hasMatch(value)) {
          return "Minimum length of 3";
        }
        return null;
      },
      onSaved: (newValue) {
        nameController.value = newValue as TextEditingValue;
      },
      textInputAction: TextInputAction.next,
    );
    final emailField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter email";
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return "Please enter valid email";
        }
        return null;
      },
      onSaved: (newValue) {
        emailController.value = newValue as TextEditingValue;
      },
      textInputAction: TextInputAction.next,
    );
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      decoration: const InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter password";
        }
        if (!RegExp(r'^.{6,}$').hasMatch(value)) {
          return "Minimum length of 6";
        }
      },
      onSaved: (newValue) {
        passwordController.value = newValue as TextEditingValue;
      },
      textInputAction: TextInputAction.next,
    );
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordController,
      decoration: const InputDecoration(
        hintText: "Re-enter password",
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (passwordController.text != value) {
          return "Passwords dont match";
        }
        return null;
      },
      obscureText: true,
      onSaved: (newValue) {
        confirmPasswordController.value = newValue as TextEditingValue;
      },
      textInputAction: TextInputAction.done,
    );
    final connectionStatus = Provider.of<InterentConnectionService>(context);
    return StreamBuilder<ConnectivityResult?>(
        initialData: ConnectivityResult.mobile,
        stream: connectionStatus.connection,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.hasData) {
            if (snapshot.data == ConnectivityResult.mobile ||
                snapshot.data == ConnectivityResult.wifi) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 0,
                  title: const Text('Flutter task'),
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      width: 75 * SizeConfig.widthMultiplier,
                      margin: EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create account',
                              style: TextStyle(
                                fontSize: 5 * SizeConfig.textMultiplier,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 80,
                                    backgroundImage: photo == null
                                        ? const AssetImage("assets/pfp.png")
                                        : FileImage(File(photo!.path))
                                            as ImageProvider,
                                  ),
                                  Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                height: 15 *
                                                    SizeConfig.heightMultiplier,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                      'Choose profile photo',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            imgFromDevice(
                                                                ImageSource
                                                                    .camera);
                                                          },
                                                          icon: const Icon(
                                                            Icons.camera,
                                                            size: 40,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            imgFromDevice(
                                                                ImageSource
                                                                    .gallery);
                                                          },
                                                          icon: const Icon(
                                                            Icons.image,
                                                            size: 40,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: const [
                                                        Text('Camera'),
                                                        Text('Gallery'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      icon: const Icon(
                                        Icons.camera_alt_sharp,
                                        color: Colors.deepPurple,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Name:',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            nameField,
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Email:',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            emailField,
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Password:',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            passwordField,
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Confirm Password:',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            confirmPasswordField,
                            const SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: SizedBox(
                                width: 75 * SizeConfig.widthMultiplier,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        auth.showDialogue(context);
                                        final result = await auth.signUp(
                                            emailController.text,
                                            passwordController.text,
                                            nameController.text,
                                            photo);
                                        if (result == null) {
                                          const snackBar = SnackBar(
                                              content:
                                                  Text("Email already in use"));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else {
                                          Navigator.pop(context);
                                          auth.hideProgressDialogue(context);
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        SnackBar snackBar =
                                            SnackBar(content: Text(e.message!));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Create account',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Scaffold(
                body: Center(child: Text('No internet connection')),
              );
            }
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
