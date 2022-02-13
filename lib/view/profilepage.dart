// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tmj_finalproject/model/config.dart';
import 'package:tmj_finalproject/model/user.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double screenHeight, screenWidth, resWidth;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();

  final TextEditingController _nameeditingController = TextEditingController();
  final TextEditingController _phoneeditingController = TextEditingController();
  final TextEditingController _addresseditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameeditingController.text = widget.user.name.toString();
    _phoneeditingController.text = widget.user.phone.toString();
    _addresseditingController.text = widget.user.address.toString();

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
     
    return Scaffold(
      appBar: AppBar(
        title: const Text('EDIT PROFILE'),
      ),
      body: Container(
      padding: const EdgeInsets.only(left: 20, top: 25, right: 20),
      child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
        const SizedBox(height: 30,),
        Text("Email: " + widget.user.email!, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 10,),
            TextField(
              controller: _nameeditingController,
              cursorColor: Colors.grey[50],
              decoration: const
                InputDecoration(labelStyle: TextStyle(color: Colors.white,),
                icon: Icon(Icons.person, color: Colors.blueGrey,),
                focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0, color: Colors.white,),
              ))),
            const SizedBox(height: 20,),
            TextField(
              controller: _phoneeditingController,
              cursorColor: Colors.grey[50],
              decoration: const
                InputDecoration(labelStyle: TextStyle(color: Colors.white,),
                icon: Icon(Icons.phone, color: Colors.blueGrey,),
                focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0, color: Colors.white,),
              ))),
            const SizedBox(height: 20,),
            TextField(
              controller: _addresseditingController,
              cursorColor: Colors.grey[50],
              decoration: const
                InputDecoration(labelStyle: TextStyle(color: Colors.white,),
                icon: Icon(Icons.house, color: Colors.blueGrey,),
                focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0, color: Colors.white,),
              ))),
            const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              ElevatedButton(
                child: const Text("CANCEL",style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
              ElevatedButton(
                child: const Text("SAVE", style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                  http.post(Uri.parse(PCConfig.server + "/tmj/php/update_profile.php"),
                  body:{
                    "name": _nameeditingController.text,
                    "phone": _phoneeditingController.text,
                    "address": _addresseditingController.text,
                    "userid": widget.user.id
                  }).then((response){
                    var data = jsonDecode(response.body);
                    print(data);
                    if(response.statusCode == 200 && data['status'] == 'success'){
                      Fluttertoast.showToast(
                        msg: "Success",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.green,
                        fontSize: 14.0);
                        setState((){
                          widget.user.name = _nameeditingController.text;
                          widget.user.phone = _phoneeditingController.text;
                          widget.user.address = _addresseditingController.text;
                        });
                    }else{
                      Fluttertoast.showToast(
                        msg: "Failed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.red,
                        fontSize: 14.0);
                      }
                    });
                  },
                  )
                ]
              )
            ]
          )    
        ),
      ),
    );
  }
}