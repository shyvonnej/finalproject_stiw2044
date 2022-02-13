
class Product{
  String? prid;
  String? prname;
  String? prprice;
  String? prqty;
  String? prdesc;

  Product(
    {
      required this.prid,
      required this.prname,
      required this.prprice,
      required this.prqty,
      required this.prdesc,
    }
  );

    Product.fromJson(Map<String, dynamic> json){
    prid = json['products']['prid'];
    prname = json['products']['prname'];
    prprice = json['products']['prprice'];
    prqty = json['products']['prqty'];
    prdesc = json['products']['desc'];
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prid'] = prid;
    data['prname'] = prname;
    data['prprice'] = prprice;
    data['prqty'] = prqty;
    data['prdesc'] = prdesc;
    return data;
  }
}