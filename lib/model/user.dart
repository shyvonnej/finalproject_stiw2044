class User { 
  String? id; 
  String? name; 
  String? email; 
  String? phone; 
  String? address; 
  String? otp;
  String? quantity;

User({
  required this.id,
  required this.name, 
  required this.email, 
  required this.phone, 
  required this.address, 
  required this.otp,
  this.quantity});

User.fromJson(Map<String, dynamic> json) { 
  id = json['id'];
  name = json['name']; 
  email = json['email']; 
  phone = json['phone'];
  address = json['address']; 
  otp = json['otp'];
  quantity = json['cart_quantity'];
  }
}