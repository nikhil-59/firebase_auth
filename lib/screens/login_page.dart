import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/models/sizeconfig.dart';
import 'package:firebase_authentication/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);
  InputDecoration inputDecoration(String text) {
    return InputDecoration(
      hintText: text,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey.shade200,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    final emailField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      decoration: inputDecoration('Email'),
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
      decoration: inputDecoration('Password'),
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Flutter task'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 75 * SizeConfig.widthMultiplier,
            margin: const EdgeInsets.all(10),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign-In',
                    style: TextStyle(
                        fontSize: 5 * SizeConfig.textMultiplier,
                        color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  emailField,
                  const SizedBox(
                    height: 10,
                  ),
                  passwordField,
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 75 * SizeConfig.widthMultiplier,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            try {
                              auth.showDialogue(context);
                              final result = await auth.signIn(
                                  emailController.text,
                                  passwordController.text);
                              if (result == null) {
                                const snackBar = SnackBar(
                                    content: Text("Account does not exist"));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
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
                          'Sign-In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: SizedBox(
                      width: 75 * SizeConfig.widthMultiplier,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final result = await auth.signinWithGoogle();

                            if (result == null) {
                              const snackBar = SnackBar(
                                  content: Text("Account does not exist"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } on FirebaseAuthException catch (e) {
                            SnackBar snackBar =
                                SnackBar(content: Text(e.message!));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                        ),
                        child: const Text(
                          'Sign in with google',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  const Center(
                    child: Text(
                      'New here?',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: SizedBox(
                      width: 75 * SizeConfig.widthMultiplier,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueGrey),
                        ),
                        child: const Text(
                          'Create a new account',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
