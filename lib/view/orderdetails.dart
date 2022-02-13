// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tmj_finalproject/model/config.dart';
import 'package:tmj_finalproject/model/order.dart';
import 'package:http/http.dart' as http;

class OrderDetailsPage extends StatefulWidget {
  final Order order;
  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late List _orderdetails;
  late double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
     screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          const Text("Order Details",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _orderdetails == null
            ? const Flexible(
              child: Center(
              child: Text("Loading order details...",
                style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50), fontSize: 22, fontWeight: FontWeight.bold),
              )))
            : Expanded(
              child: ListView.builder(
                itemCount:_orderdetails == null 
                ? 0 
                : _orderdetails.length,
                itemBuilder: (context, index) {
                  return Padding(padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                    child: InkWell(onTap: null,
                    child: Card(elevation: 10,
                    child: Padding(padding: const EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(flex: 1,
                          child: Text((index + 1).toString(),
                          style: const TextStyle(color: Colors.white),
                        )),
                        Expanded(flex: 2,
                          child: Padding(padding: const EdgeInsets.all(3),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: PCConfig.server + "/tmj/images/product/${_orderdetails[index]['id']}.jpg",
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            )),
                          ),
                        Expanded(flex: 4,
                          child: Text(_orderdetails[index]['name'],
                          style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(flex: 1,
                          child: Text(_orderdetails[index]['cart_quantity'],
                          style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Text("RM "+ _orderdetails[index]['price'],
                          style: const TextStyle(color: Colors.white),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                  )
                )));
              }
            )
          )
        ]),
      ),
    );
  }

  _loadOrderDetails() async {
    await http.post(Uri.parse(PCConfig.server), body: {
      "orderid": widget.order.order_id,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _orderdetails == null;
          const Text("No Previous Payment");
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _orderdetails = extractdata["carthistory"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}