import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tmj_finalproject/model/user.dart';
import 'historypage.dart';
import 'loginpage.dart';
import 'profilepage.dart';
import 'registerpage.dart';
import 'dart:io';

class TabPage2 extends StatefulWidget {
  final User user;
  const TabPage2({Key? key, required this.user}) : super(key: key);

  @override
  State<TabPage2> createState() => _TabPage2State();
}

class _TabPage2State extends State<TabPage2> {
  @override
  Widget build(BuildContext context) { 
    return Scaffold(        
      appBar: AppBar(
          title: const Text('TMJ Resources'),
        ),
      body: Center(
      child: Column(children: [
        Flexible(flex: 5,
        child: Column(
          children: [
            const SizedBox(height: 70),
            Text("Name: " + widget.user.name.toString(), style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20,),
            Text("Email: " + widget.user.email.toString(), style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20,),
            Text("Phone: " + widget.user.phone.toString(), style: const TextStyle(fontSize: 20,)),
            const SizedBox(height: 20,),
            Text("Address: " + widget.user.address.toString(), style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20,)
            ])
          ),
        Flexible(
          flex: 5,
          child: Column(
            children: [
              Container(
              color: Colors.tealAccent,
              child: const Center(
                child: Text("S E T T I N G", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ))),
              Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                shrinkWrap: true,
                children: [
                  MaterialButton(
                    onPressed: _profilepage,
                    child: const Text("EDIT PROFILE"),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.tealAccent,
                  ),
                  MaterialButton(
                    onPressed: _purchaseHistory,
                    child: const Text("HISTORY"),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.tealAccent,
                  ),
                  MaterialButton(
                    onPressed: _registerAcc,
                    child: const Text("NEW REGISTERATION"),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.tealAccent,
                  ),
                  MaterialButton(
                    onPressed: _loginAcc,
                    child: const Text("LOGIN"),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.tealAccent,
                  ),
                  MaterialButton(
                    onPressed: ()=> exit(0),
                    child: const Text("EXIT"),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.tealAccent,
                  ),
                ]
              )
            )],
          )
        )
      ],)
      )
    );
  }

  void _registerAcc() {
    if (widget.user.email == "na") {
      showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: const Text("Register New Account", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure?", style: TextStyle(color: Colors.white)),
        actions: <Widget>[TextButton(
          child: const Text("Yes", style: TextStyle(color: Colors.tealAccent)),
          onPressed:(){
            Navigator.of(context).pop();
            Navigator.push(
              context, MaterialPageRoute(builder: (BuildContext context) => const RegisterPage())
            );
          }),
          TextButton(
            child: const Text("No", style: TextStyle(color: Colors.tealAccent)),
            onPressed:(){
              Navigator.of(context).pop();
            }
          )]
      );
    });
    return;
    }
    Fluttertoast.showToast(
      msg: "You are logged",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.red,
      fontSize: 14.0);
  }

  void _loginAcc() {
    if (widget.user.email == "na") {
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: const Text("Login Account", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure?", style: TextStyle(color: Colors.white)),
        actions: <Widget>[TextButton(
          child: const Text("Yes", style: TextStyle(color: Colors.tealAccent)),
          onPressed:(){ 
            Navigator.of(context).pop();
            Navigator.push(
              context, MaterialPageRoute(builder: (BuildContext context) => const LoginPage())
            );
          }),
          TextButton(
            child: const Text("No", style: TextStyle(color: Colors.tealAccent)),
            onPressed:(){
              Navigator.of(context).pop();
            }
          )]
      );
    });
    return;
  }
    Fluttertoast.showToast(
    msg: "You are logged",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    textColor: Colors.red,
    fontSize: 14.0);
  }

  void _purchaseHistory() {
    if (widget.user.email == "na") {
      Fluttertoast.showToast(
          msg: "Can be access after login.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.red,
          fontSize: 14.0);
      return;
    }
    Navigator.push(
      context, MaterialPageRoute(builder: (BuildContext context) => HistoryPage(user: widget.user))
    );
    }
  
  void _profilepage() {
    if (widget.user.email == "na") {
      Fluttertoast.showToast(
          msg: "Can be access after login.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.red,
          fontSize: 14.0);
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProfilePage(user: widget.user)));
  }
}