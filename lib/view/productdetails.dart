// ignore_for_file: avoid_print, deprecated_member_use
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tmj_finalproject/model/config.dart';
import 'package:tmj_finalproject/model/product.dart';
import 'package:http/http.dart' as http;
import 'package:tmj_finalproject/model/user.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  final User user;
  const ProductDetails({Key? key, required this.product, required this.user}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List productList = [];
  int numProduct = 0;
  String cartquantity = "0";
  int quantity = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      title: const Text("PRODUCT DETAILS"),
    ),
    body: Center(
    child: SizedBox(
      width: resWidth * 2,
      height: screenHeight,
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              widget.product.prname!,
              textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: resWidth * 0.05,
                fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CachedNetworkImage(
              height: 300, width: 300, fit: BoxFit.scaleDown,
              imageUrl: PCConfig.server + "/tmj/images/products/" + widget.product.prid! + ".jpg",
              placeholder: (context, url) => const LinearProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error_outline_sharp)),
            SizedBox(height: screenHeight * 0.03),
            Row(children: [
              const Icon(Icons.money_rounded),
              SizedBox(width: resWidth * 0.05),
              Flexible(
              child: Text("Price: RM" +
                widget.product.prprice!,
                style: TextStyle(
                fontSize: resWidth * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: screenHeight * 0.03),
            Row(children: [
              const Icon(Icons.production_quantity_limits),
              SizedBox(width: resWidth * 0.05),
              Flexible(
              child: Text("Available Quantity: " +
                widget.product.prqty!,
                style: TextStyle(
                fontSize: resWidth * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: screenHeight * 0.03),
            Row(children: [
              const Icon(Icons.description_sharp),
              SizedBox(width: resWidth * 0.05),
              Flexible(
              // ignore: prefer_adjacent_string_concatenation
              child: Text("Description: " + "\n" +
                widget.product.prdesc!,
                style: TextStyle(
                fontSize: resWidth * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 50)),
                child: const Text('Add to Cart'),
                onPressed: _addtocartdialog,
              )
          ]
          )
        )
      )
    ))
    );
  }

    _addtocartdialog() {
    int index = int.parse(widget.product.prid!);
    if (widget.user.email == "na") {
      Fluttertoast.showToast(
        msg:"Please register/login to use this function",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0);
      return;
    } else {
    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: Text("Add " + widget.product.prname! + " to Cart?",
              style: const TextStyle(color: Colors.white,),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text("Select quantity of product",
                  style: TextStyle(color: Colors.white,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => { 
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            },
                            child: const Icon(Icons.remove, color: Colors.white,
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(color: Colors.white,),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity < (int.parse(widget.product.prqty!) - 2)) {
                                  quantity++;
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Quantity not available",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    fontSize: 14.0);
                                  }
                                })
                              },
                            child: const Icon(Icons.add, color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () {
                      _addtocart(index);
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("Yes",
                    style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50),),
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
            );
          });
        });
      }
    }

  void _addtocart(int index) {
    int cquantity = quantity;
      if (cquantity > 0) {
        http.post(Uri.parse(PCConfig.server + "/tmj/php/insert_cart.php"),
         body: { "user_email": widget.user.email, "prid": index.toString(), "quantity": quantity.toString()}).then((response) {
            if (response.statusCode == 200) {
            var parsedJson = jsonDecode(response.body);
            var data = parsedJson['status'];
          if (data == "success") {
            List respond = response.body.split(",");
            setState(() {
              cartquantity = respond[1];
              widget.user.quantity = cartquantity;
            });
            Fluttertoast.showToast(
              msg: "Success add to cart",
              toastLength: Toast.LENGTH_LONG, 
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1, 
              fontSize: 14);
          }
      } else {
        Fluttertoast.showToast(
          msg: "Out of stock",
          toastLength: Toast.LENGTH_LONG, 
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1, 
          fontSize: 14);
        }
      }
    );}
  }
}