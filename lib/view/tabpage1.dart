import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tmj_finalproject/model/config.dart';
import 'package:tmj_finalproject/model/product.dart';
import 'package:tmj_finalproject/model/user.dart';
import 'cartpage.dart';
import 'productdetails.dart';

class TabPage1 extends StatefulWidget {
  final User user;
  const TabPage1({Key? key, required this.user}) : super(key: key);

  @override
  State<TabPage1> createState() => _TabPage1State();
}

class _TabPage1State extends State<TabPage1> {
  List productList = [];
  int numProduct = 0;
  late ScrollController _scrollController;
  int scrollcount = 5;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    late double screenHeight, screenWidth, resWidth;

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 700) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75; 
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMJ Resources'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, size: 26.0),
            onPressed:(){
              Navigator.of(context).push(
                MaterialPageRoute(builder:(context) => CartPage(user:widget.user,))
              );
            }
          )
        ]
      ),
      body: Center(
      child: SizedBox(
        width: resWidth * 2, height: screenHeight,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text("PRODUCTS", 
              style: TextStyle(fontSize: resWidth * 0.05,fontWeight: FontWeight.bold,),
              ),
              SizedBox(height: screenHeight * 0.035),
              Expanded(child: GridView.count(
                crossAxisSpacing: 5, 
                mainAxisSpacing: 5, 
                crossAxisCount: 2,
                children: List.generate(numProduct,(index){ 
                  return SingleChildScrollView(
                    child: InkWell(
                      onTap: (() => {_productDetails(index),}),
                    child: Stack(children:[
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                        children: [
                        CachedNetworkImage(
                          width: screenWidth, fit: BoxFit.cover,
                          imageUrl: PCConfig.server + "/tmj/images/products/" + productList[index]['prid'] + ".jpg",
                          placeholder: (context, url) => const LinearProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error_outline_sharp)),
                        ],
                      ),
                    ),
                    Container(
                      width: 300,
                      color: Colors.black54,
                      padding: const EdgeInsets.all(10),
                      child: Text(productList[index]['prname'], style: TextStyle(fontSize: resWidth * 0.030, color: Colors.white))
                    ),
                  ]
                ),
              ));
            }
          )
        )
      )
      ]))))
    );
  }

  _loadProducts() {
    http.post(Uri.parse(PCConfig.server + "/tmj/php/product.php")).then((response){
      if(response.statusCode == 200 && response.body != "failed"){
        var parsedJson = json.decode(response.body);
        productList = parsedJson['data']['products'];
      setState(() {
          numProduct = productList.length;
        });
      }
    });
  }

 _productDetails(int index) async {
    Product product = Product(
      prid: productList[index]['prid'],
      prname: productList[index]['prname'],
      prprice: productList[index]['prprice'],
      prqty: productList[index]['prqty'],
      prdesc: productList[index]['prdesc'],
    );

    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProductDetails(product: product, user: widget.user))
      );
}

  void _scrollListener() {
    if(_scrollController.offset >=
      _scrollController.position.maxScrollExtent &&
    !_scrollController.position.outOfRange){
      setState((){
        if(productList.length > scrollcount){
          scrollcount = scrollcount + 5;
          if (scrollcount > productList.length){
            scrollcount = productList.length;
          }
        }
      });
    }
  }
}