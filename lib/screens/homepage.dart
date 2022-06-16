import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/models/user.dart';
import 'package:firebase_authentication/services/authservice.dart';
import 'package:firebase_authentication/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                const snackBar = SnackBar(content: Text("Logging out"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                await auth.signOut();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: StreamBuilder<User?>(
          stream: auth.user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder<UserModel?>(
                stream: DBService(uid: snapshot.data?.uid).userData,
                builder: (context, snap) {
                  if (snap.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              snap.data!.imageUrl,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Welcome ${snap.data?.name}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
