import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmj_finalproject/model/config.dart';
import 'package:tmj_finalproject/model/user.dart';
import 'mainpage.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    checkAndLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(image: 
          DecorationImage(
            image: AssetImage('assets/images/splash.jpg'),
            fit: BoxFit.cover
          ))
        ),
        Padding(padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(height: 350),
            CircularProgressIndicator(),
            SizedBox(height: 250),
            Text("Version 0.1", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          ],
        ),)
      ],
    );
  }

    checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String pass = (prefs.getString('pass')) ?? '';
    late User user;
    if (email.length > 1 && pass.length > 1) {
      http.post(Uri.parse(PCConfig.server + "/tmj/php/login_user.php"),
          body: {"email": email, "password": pass}).then((response) {
        if (response.statusCode == 200 && response.body != "failed") {
          final jsonResponse = json.decode(response.body);
          user = User.fromJson(jsonResponse);
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainPage(user: user))));
        } else {
          // create dummy data to pass to main page
          user = User(
              id: "na",
              name: "na",
              email: "na",
              phone: "na",
              address: "na",
              otp: "na");
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainPage(user: user))));
        }
      }).timeout(const Duration(seconds: 5));
    } else {
      user = User(
          id: "na",
          name: "na",
          email: "na",
          phone: "na",
          address: "na",
          otp: "na");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainPage(user: user))));
    }
  }
}