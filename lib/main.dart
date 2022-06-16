import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/models/sizeconfig.dart';
import 'package:firebase_authentication/screens/homepage.dart';
import 'package:firebase_authentication/screens/login_page.dart';
import 'package:firebase_authentication/screens/signup_page.dart';
import 'package:firebase_authentication/services/authservice.dart';
import 'package:firebase_authentication/services/database_service.dart';
import 'package:firebase_authentication/services/internet_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);

            return MultiProvider(
              providers: [
                Provider<AuthService>(create: (_) => AuthService()),
                Provider<DBService>(
                  create: (_) => DBService(),
                ),
                Provider<InterentConnectionService>(
                  create: (_) => InterentConnectionService(),
                ),
              ],
              child: MaterialApp(
                theme: ThemeData(primarySwatch: Colors.deepPurple),
                title: 'firebase auth task',
                initialRoute: '/',
                routes: <String, WidgetBuilder>{
                  '/': (context) => const Wrapper(),
                  '/signup': (context) => SignupPage(),
                },
              ),
            );
          },
        );
      },
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final connectionStatus = Provider.of<InterentConnectionService>(context);
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<ConnectivityResult?>(
        initialData: null,
        stream: connectionStatus.connection,
        builder: (_, snap) {
          if (snap.data == ConnectivityResult.mobile ||
              snap.data == ConnectivityResult.wifi) {
            return StreamBuilder<User?>(
              stream: authService.user,
              initialData: null,
              builder: (_, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return snapshot.data == null ? LoginPage() : HomePage();
                } else {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          } else {
            return const Scaffold(
              body: Center(child: Text('No Internet Connection')),
            );
          }
        });
  }
}
