class WeavingProductListModel {
  int? id;
  String? productName;
  num? wages;

  WeavingProductListModel({this.id, this.wages, this.productName});

  WeavingProductListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    wages = json['wages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productName;
    data['wages'] = wages;
    return data;
  }

  @override
  String toString() {
    return "$productName";
  }
}
