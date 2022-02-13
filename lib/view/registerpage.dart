import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:tmj_finalproject/model/config.dart';
import 'loginpage.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double screenHeight, screenWidth;
  bool _passwordVisible = true;
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();
  String eula = "";

  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _password2EditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [upperHalf(context), lowerHalf(context)],
      ),
    );
  }

    upperHalf(BuildContext context) {
    return SizedBox(
      height: screenHeight/2.0,
      width: screenWidth,
      child: Image.asset('assets/images/logo.gif', fit: BoxFit.cover),
      );
  }

  lowerHalf(BuildContext context) {
  return Container(
      height:screenHeight/1.2,
      width: screenWidth,
      margin: EdgeInsets.only(top: screenHeight/5),
      padding: const EdgeInsets.only(left:10, right:10),
      child: SingleChildScrollView(
        child:
        Column(children: [
          Card(elevation: 40,
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
              child: Column(children:[
                const SizedBox(height: 20,),
                const Text("Register New Account", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600,)),
                const SizedBox(height: 20,),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (val) => val!.isEmpty || (val.length<3)
                  ? "name must be longer than 3 characters." 
                  : null,
                  onFieldSubmitted: (v){
                    FocusScope.of(context).requestFocus(focus);
                  },
                  controller: _nameEditingController,
                  cursorColor: Colors.grey[50],
                  decoration: const
                    InputDecoration(labelStyle: TextStyle(color: Colors.white,),
                    labelText: 'Name',
                    icon: Icon(Icons.person, color: Colors.blueGrey,),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0, color: Colors.white,),
                    ))),
                
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (val) => val!.isEmpty || !val.contains("@") || !val.contains(".")
                    ? "enter a valid email"
                    : null,
                  focusNode: focus,
                  onFieldSubmitted: (v){
                    FocusScope.of(context).requestFocus(focus1);
                  },
                  controller: _emailEditingController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.grey[50],
                  decoration: const
                    InputDecoration(labelStyle: TextStyle(color: Colors.white,),
                    labelText: 'Email',
                    icon: Icon(Icons.mail, color: Colors.blueGrey,),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0, color: Colors.white,),
                ))),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (val) => validatePassword(val.toString()),
                  focusNode: focus1,
                  onFieldSubmitted: (v){
                    FocusScope.of(context).requestFocus(focus2);
                  },
                  controller: _passwordEditingController,
                  cursorColor: Colors.grey[50],
                  decoration:
                    InputDecoration(labelStyle: const TextStyle(color: Colors.white,),
                    labelText: 'Password',
                    icon: const Icon(Icons.vpn_key, color: Colors.blueGrey,),
                    suffixIcon: IconButton(icon: Icon(_passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0, color: Colors.white,),
                )),
                obscureText: _passwordVisible),

                TextFormField(
                  textInputAction: TextInputAction.done,
                  validator: (val) {
                    validatePassword(val.toString());
                    if (val != _passwordEditingController.text) {
                      return "password do not match";
                    } else {
                      return null;
                    }
                  },
                  focusNode: focus2,
                  onFieldSubmitted: (v){
                    FocusScope.of(context).requestFocus(focus3);
                  },
                  controller: _password2EditingController,
                  cursorColor: Colors.grey[50],
                  decoration:
                    InputDecoration(labelStyle: const TextStyle(color: Colors.white,),
                    labelText: 'Re-type Password',
                    icon: const Icon(Icons.vpn_key, color: Colors.blueGrey,),
                    suffixIcon: IconButton(icon: Icon(_passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                      ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0, color: Colors.white,),
                  )),
                  obscureText: _passwordVisible),

                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value){
                          setState(() {
                            _isChecked = value!;
                          });
                        }
                      ),
                      Flexible(child:
                      GestureDetector(onTap: _showEULA, child: const Text('Agree with terms',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white,)),)
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth/3, 50)),
                        child: const Text('Register'),
                        onPressed: _registerAccount,
                      ),]
                    )],
                  )),
                )),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: <Widget>[
                    const Text("Already Register? ",
                    style: TextStyle(fontSize: 16.0, )), 
                    GestureDetector(
                      onTap: () => {
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                          const LoginPage()
                        ))
                      }, 
                      child: const Text("Login here", 
                      style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 5,), 
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: const Text("Back to Home", 
                style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                ),
              ),
          ],))
    );
  }

  String? validatePassword(String value) {
  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$'; 
  RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
    if (!regex.hasMatch(value)) { 
      return 'Enter valid password';
    } else { 
      return null;
    }}
  }

  void _showEULA() {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("EULA",),
          content: SizedBox(height: screenHeight / 1.5,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,child: SingleChildScrollView(
                    child: RichText(
                    softWrap: true, textAlign: TextAlign.justify,
                    text: TextSpan(style: const TextStyle(fontSize: 12.0, color: Colors.white,),
                    text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close", style: TextStyle(),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

    loadEula() async {
    eula = await rootBundle.loadString('assets/eula.txt');
  }

  void _registerAccount() {
    if (!_formKey.currentState!.validate()) {
    Fluttertoast.showToast(
      msg: "Please complete the registration form first", 
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM, 
      timeInSecForIosWeb: 1, 
      textColor: Colors.red, 
      fontSize: 14.0);
    return;
  }
    if (!_isChecked) {Fluttertoast.showToast(
      msg: "Please accept the terms and conditions", 
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM, 
      timeInSecForIosWeb: 1, 
      textColor: Colors.red, 
      fontSize: 14.0);
    return;
    }

    showDialog(
    context: context,
    builder: (BuildContext context) { 
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))), 
          title: const Text("Register new account?", style: TextStyle(color: Colors.white,),),
          content: const Text("Are you sure?",style: TextStyle(color: Colors.white)), 
        actions: <Widget>[TextButton(
          child: const Text("Yes",style: TextStyle( color: Colors.teal,),),
          onPressed: () { Navigator.of(context).pop();
          _registerUserAccount();
          },
        ),
      TextButton(
        child: const Text("No", style: TextStyle(color: Colors.teal,),),
        onPressed: () { Navigator.of(context).pop();
      },
    ),
  ],
);},);
  }
  
  void _registerUserAccount() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _name = _nameEditingController.text;
    String _email = _emailEditingController.text;
    String _password = _passwordEditingController.text;
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
    message: const Text("Registration in progress.."),
    title: const Text("Registering..."));
    progressDialog.show();

    http.post(Uri.parse(PCConfig.server + "/tmj/php/register_user.php"),
    body: {"name": _name, "email": _email, "password": _password}).then((response)
    {
      var data = jsonDecode(response.body);
      if(response.statusCode == 200 && data['status'] == 'success'){
        Fluttertoast.showToast(
          msg: "Registration Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
          progressDialog.dismiss();
          return;
      } else {
        Fluttertoast.showToast(
          msg: "Registration Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
          progressDialog.dismiss();
          return;
      }
    });
  }
}