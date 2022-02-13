// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison, avoid_print, unrelated_type_equality_checks

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmj_finalproject/model/config.dart';
import 'package:tmj_finalproject/model/order.dart';
import 'package:tmj_finalproject/model/user.dart';
import 'package:http/http.dart' as http;
import 'orderdetails.dart';

class HistoryPage extends StatefulWidget {
  final User user;
  const HistoryPage({Key? key, required this.user}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List _paymentdata = [];
  String titlecenter = "Loading payment history...";
  final f = DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  late double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('PAYMENT HISTORY'),
        ),
        body: Center(
        child: Column(children: <Widget>[
          const SizedBox(height: 20,),
          const Text("Payment History",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _paymentdata == null
            ? const Flexible(
              child: Center(
              child: Text("Loading payment history...",
              style: TextStyle(color: Color.fromRGBO(101, 255, 218, 50), fontSize: 22, fontWeight: FontWeight.bold),
              )))
            : Expanded(
              child: ListView.builder(
                itemCount: _paymentdata == null 
                ? 0 
                : _paymentdata.length,
                itemBuilder: (context, index) {
                  return Padding(padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                    child: InkWell(
                      onTap: () => loadOrderDetails(index),
                      child: Card(elevation: 10,
                      child: Row(
                        crossAxisAlignment:CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(flex: 1,
                          child: Text((index + 1).toString(),
                            style: const TextStyle(color: Colors.white),
                            )),
                          Expanded(flex: 2,
                            child: Text("RM " + _paymentdata[index]['total'],
                              style: const TextStyle(color: Colors.white),
                            )),
                          Expanded(flex: 4,
                            child: Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_paymentdata[index]['orderid'],
                                  style: const TextStyle(color: Colors.white),
                                  ),
                                Text(_paymentdata[index]['billid'],
                                  style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            ),
                            Expanded(
                              child: Text(f.format(DateTime.parse(_paymentdata[index]['date'])),
                                style: const TextStyle(color: Colors.white),
                                ),
                                flex: 3,
                              ),
                            ],
                          ),
                        )));
                      }))
        ]),
      ),
    );
  }

  Future<void> _loadPaymentHistory() async {
    await http.post(Uri.parse(PCConfig.server + "/tmj/php/paymenthistory.php"), 
    body: {"user_email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata == null;
          const Text("No Previous Payment");
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["tbl_payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadOrderDetails(int index) {
    Order order = Order(
        bill_id: _paymentdata[index]['billid'],
        order_id: _paymentdata[index]['orderid'],
        total: _paymentdata[index]['total'],
        dateorder: _paymentdata[index]['date']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderDetailsPage(order: order,
    )));
  }
}