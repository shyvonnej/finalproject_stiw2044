// ignore_for_file: unnecessary_null_comparison, avoid_print, unused_element, unused_local_variable

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tmj_finalproject/model/config.dart';
import 'package:tmj_finalproject/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:nonce/nonce.dart';

import 'mainpage.dart';

class CartPage extends StatefulWidget {
  final User user;
  const CartPage({Key? key, required this.user}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List cartList = [];
  late double deliverycharge, payableamount;
  bool pickup = true;
  bool delivery = false;
  double totalprice = 0.0;

   @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
  // ignore: unused_local_variable
  late double screenHeight, screenWidth, resWidth;
  screenHeight = MediaQuery.of(context).size.height;
  screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth <= 600) {
    resWidth = screenWidth;
  } else {
    resWidth = screenWidth * 0.70;
  }

    return Scaffold(
        appBar: AppBar(
          title: const Text('CART'), actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteAll();
            },
          ),]
        ),

        body: Column(
          children: <Widget>[
        const Text("Item in Cart",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          cartList == null
            ? const Flexible(child: Center(
              child: Text("Loading your cart..",
                style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50),fontSize: 22, fontWeight: FontWeight.bold),
                  )))
            : Expanded(child: ListView.builder(
              itemCount:cartList == null 
              ? 1 
              : cartList.length + 2,
              itemBuilder: (context, index){
                if (index == cartList.length) {
                  return SizedBox(
                    height: screenHeight / 2.4,
                    width: screenWidth / 2.5,
                    child: InkWell(
                      onLongPress: () => {print("Delete")},
                      child: Card(elevation: 5,
                        child: Column(
                          children: <Widget>[const SizedBox(height: 10,),
                          const Text("Delivery Option",
                             style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: Column(
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                      Checkbox(
                                        value: pickup,
                                        onChanged:(bool? value){
                                          _pickup(value!);
                                        },
                                      ),
                                    const Text("Self Pickup",
                                      style: TextStyle(color: Colors.white,),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
                              child: SizedBox(width: 2,
                                child: Container(color: Colors.grey,))),
                            Expanded(
                              child: SizedBox(width: screenWidth / 2,
                                child: Column(
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Checkbox(
                                      value: delivery,
                                      onChanged:(bool? value) {
                                        _delivery(value!);
                                      },
                                    ),
                                  const Text("Home Delivery",
                                    style: TextStyle(color: Colors.white,),
                                  ),
                                ],
                              ),
                            ]
                          )
                        )
                      )
                    ]
                  )
                )
              ]
            )
          )
        )
      );
    }
  if (index == cartList.length + 1) {
    return Card(elevation: 5,
    child: Column(
      children: <Widget>[
        const SizedBox(height: 10,),
        const Text("Payment",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Table(
            defaultColumnWidth:const FlexColumnWidth(1.0),
            // ignore: prefer_const_literals_to_create_immutables
            columnWidths: {
              0: const FlexColumnWidth(7),
              1: const FlexColumnWidth(3),
            },
            children: [
              TableRow(children: [
              TableCell(
                child: Container(
                alignment:Alignment.centerLeft, height: 20,
                child: const Text("Total Item Price ",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                ),
              ),
              TableCell(
                child: Container(
                 alignment:Alignment.centerLeft, height: 20,
                 child: Text("RM" + totalprice.toStringAsFixed(2),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  ),
                ),
              ]
            ),
            TableRow(children: [
              TableCell(
                child: Container(
                alignment: Alignment.centerLeft, height: 20,
                child: const Text("Delivery Charge ",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                ),
              TableCell(
                child: Container(
                alignment:Alignment.centerLeft, height: 20,
                  child: Text("RM" + deliverycharge.toStringAsFixed(2),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  ),
                ),
              ]
            ),
            TableRow(children: [
              TableCell(
                child: Container(
                alignment: Alignment.centerLeft, height: 20,
                child: const Text("Total Amount ",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                  ),
                ),
              TableCell(
                child: Container(
                  alignment: Alignment.centerLeft, height: 20,
                  child: Text("RM" + payableamount.toStringAsFixed(2),
                    style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                    ),
                  ),
                ]
              ),
            ]
          )
        ),
        const SizedBox(height: 10,),
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
              minWidth: 200,
              height: 40,
              child: const Text('Make Payment'),
                color: const Color.fromRGBO(101, 255, 218, 50),
                textColor: Colors.black,
                elevation: 10,
                onPressed: _checkoutdialog,
                ),
              ],
            ),
          );
        }
        index -= 0;
        return Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(children: <Widget>[
              Column(
                children: <Widget>[
                SizedBox(
                  height: screenHeight / 8,
                  width: screenWidth / 5,
                  child: ClipOval(
                  child: CachedNetworkImage(
                    fit: BoxFit.scaleDown,
                    imageUrl: PCConfig.server + "/tmj/productimage/${cartList[index]['id']}.jpg",
                    placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      )
                    ),
                  ),
                Text("RM " + cartList[index]['price'],
                  style: const TextStyle(color: Colors.white,),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 1, 10, 1),
              child: SizedBox(width: 2,
                child: Container(
                  height: screenWidth / 3.5,
                  color: Colors.grey,
                  )
                )
              ),
            SizedBox(
              width: screenWidth / 1.45,
              child: Row(
                children: <Widget>[
                Flexible(
                  child: Column(
                    children: <Widget>[
                    Text(cartList[index]['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                      maxLines: 1,),
                    Text("Available " + cartList[index]['quantity'] + " unit",
                      style: const TextStyle(color: Colors.white,),
                    ),
                    Text("Your Quantity " + cartList[index]['cart_quantity'],
                      style: const TextStyle(color: Colors.white,),
                    ),
                    SizedBox(height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () => {
                              _updateCart(index, "add")
                              },
                            child: const Icon(Icons.add,
                              color: Color.fromRGBO(101,255,218,50),
                            ),
                          ),
                          Text(cartList[index]['cart_quantity'],
                            style: const TextStyle(color: Colors.white,),
                          ),
                          ElevatedButton(
                            onPressed: () => {
                              _updateCart(index,"remove")
                              },
                            child: const Icon(Icons.remove, color: Color.fromRGBO(101,255,218,50),
                            ),
                          ),
                        ],
                      )
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Total RM " + cartList[index]['yourprice'],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ElevatedButton(
                        onPressed: () => {
                          _deleteCart(index)
                          },
                        child: const Icon(Icons.delete, color: Color.fromRGBO(101, 255, 218, 50),
                        ),
                       ),
                      ],
                     ),
                    ],
                   ),
                  )
                 ],
                )
               ),
              ]
             )
            )
           );
          }
         )
        ),
       ],
      )
     );
    }

    void _checkoutdialog() {
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: const Text("Check Out", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure?", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
          child: const Text("Yes", style: TextStyle(color: Colors.tealAccent)),
          onPressed: () { Navigator.of(context).pop();
          _payatcounter();
          },
        ),
          TextButton(
            child: const Text("No", style: TextStyle(color: Colors.tealAccent)),
            onPressed:(){
              Navigator.of(context).pop();
            }
          )]
      );
    }
  );
}

  void _payatcounter() {
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: const Text("Thank You", style: TextStyle(color: Colors.white)),
        content: const Text("Please pay at the counter.", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
          child: const Text("Back",style: TextStyle( color: Colors.teal,),),
          onPressed: () => { Navigator.pushReplacement(context,
          MaterialPageRoute(
          builder: (BuildContext context) => MainPage(user: widget.user))),
          }
          )
        ]
      );
    });
  }

  void _makePaymentDialog() {
    showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text('Proceed with payment?',
        style: TextStyle(color: Colors.white,),
        ),
        content: const Text('Are you sure?',
        style: TextStyle(color: Colors.white,),
        ),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              makePayment();
            },
          child: const Text("Ok",
          style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )
            ),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel",
              style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50),),
              )
            ),
          ],
        );
      }
    );
  }

  void _loadCart() {
    totalprice = 0.0;
    payableamount = 0.0;
    deliverycharge = 0.0;
    http.post(Uri.parse(PCConfig.server + "/tmj/php/load_cart.php"), body: {
      "user_email": widget.user.email,
      }).then((res) {
        print(res.body); 
        if (res.body != "failed") {
          setState(() {
        var extractdata = json.decode(res.body);
        cartList = extractdata["tbl_cart"];
        for (int i = 0; i < cartList.length; i++) {
          totalprice = double.parse(cartList[i]['yourprice']) + totalprice;
        }
        payableamount = totalprice;
        print(totalprice);
      });
    }
  }
  );
}


void deleteAll() {
  showDialog(context: context,
    builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text('Delete all items?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(Uri.parse(PCConfig.server + "/tmj/php/delete_cart.php"), body: {
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Fluttertoast.showToast(
                      msg:"Failed",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      fontSize: 14.0);
                    return;
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: const Text("Yes",
                style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel",
                style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }

void _pickup(bool value) => setState(() {
        pickup = value;
        if (pickup) {
          delivery = false;
          _updatePayment();
        } else {
          //_homeDelivery = true;
          _updatePayment();
        }
      });

  void _delivery(bool? value) => setState(() {
    delivery = value!;
    if (delivery) {
      _updatePayment();
      pickup = false;
    } else {
      _updatePayment();
    }
  });

void _updatePayment() {
  totalprice = 0.0;
  payableamount = 0.0;
    setState(() {
      for (int i = 0; i < cartList.length; i++) {
        totalprice = double.parse(cartList[i]['yourprice']) + totalprice;
      }
      if (pickup) {
        deliverycharge = 0.0;
      } else {
        deliverycharge = 5.00;
      print("Delivery Charge:" + deliverycharge.toStringAsFixed(3));
      print(totalprice);
      }
    }
  ); 
}

Future<void> makePayment() async {
    if (pickup) {
      print("PICKUP");
      Fluttertoast.showToast(
      msg: "Self Pickup",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 14.0);
    return;
    } else if (delivery) {
      print("HOME DELIVERY");
      Fluttertoast.showToast(
        msg: "Home Delivery",
        toastLength: Toast.LENGTH_LONG, 
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 14.0);
    } else {
      Fluttertoast.showToast(
        msg: "Please select delivery option",
        toastLength: Toast.LENGTH_LONG, 
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 14.0);
    }
    var now = DateTime.now();
    var formatter = DateFormat('ddMMyyyy-');
    String orderid = Nonce.key().toString();
    print(orderid);
    _loadCart();
  }


_deleteCart(int index) {
  showDialog(context: context,
  builder: (BuildContext context){
    return AlertDialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: const Text('Delete item?',
      style: TextStyle(color: Colors.white,
      ),
    ),
    actions: <Widget>[
      MaterialButton(
        onPressed: () {
        Navigator.of(context).pop(false);
        http.post(Uri.parse(PCConfig.server + "/tmj/php/delete_cart.php"), 
        body: {
          "email": widget.user.email, "prid": cartList[index]['id'],
        }).then((res) {
          print(res.body);
      if (res.body == "success") {
        _loadCart();
      } else {
        Fluttertoast.showToast(
          msg: "Failed",
          toastLength: Toast.LENGTH_LONG, 
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.red,
          fontSize: 14.0);
        }
      }
    ).catchError((err) {
      print(err);
      }
    );
  },
    child: const Text("Yes",
      style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50),),
      )
    ),
    MaterialButton(
      onPressed: () {
      Navigator.of(context).pop(false);
      },
    child: const Text("Cancel",
      style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50),),
      )),
    ],
  );
  }); 
}

  _updateCart(int index, String op) {
    int curquantity = int.parse(cartList[index]['quantity']);
    int quantity = int.parse(cartList[index]['cquantity']);
    if (op == "add") {
      quantity++;
      if (quantity > (curquantity - 2)) {
        Fluttertoast.showToast(
          msg: "Quantity not available",
          toastLength: Toast.LENGTH_LONG, 
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 14.0);
        return;
      }
    }
    if (op == "remove") {
      quantity--; 
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }
    http.post(Uri.parse(PCConfig.server + "/tmj/php/update_cart.php"),
    body: {
      "email": widget.user.email,
      "prodid": cartList[index]['id'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Fluttertoast.showToast(
          msg: "Cart Updated",
          toastLength: Toast.LENGTH_LONG, 
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.green,
          fontSize: 14.0);
        _loadCart();
      } else {
        Fluttertoast.showToast(
          msg: "Failed",
          toastLength: Toast.LENGTH_LONG, 
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.red,
          fontSize: 14.0);
      }
    }).catchError((err) {
      print(err);
    });
  }

  String generateOrderid() {
    var now = DateTime.now();
    var formatter = DateFormat('ddMMyyyy-');
    String orderid = widget.user.email!.substring(1, 3) + "-" + formatter.format(now) + Nonce.key().toString();
    return orderid;
  }
}