class WarperBalanceDetailsModel {
  int? yarnId;
  String? yarnName;
  int? colorId;
  String? colorName;
  String? stockIn;
  num? balQuantity;

  WarperBalanceDetailsModel({
    this.yarnId,
    this.yarnName,
    this.colorId,
    this.colorName,
    this.stockIn,
    this.balQuantity,
  });

  WarperBalanceDetailsModel.fromJson(Map<String, dynamic> json) {
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    colorId = json['color_id'];
    colorName = json['color_name'];
    stockIn = json['stock_in'];
    balQuantity = json['bal_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['yarn_id'] = yarnId;
    data['yarn_name'] = yarnName;
    data['color_id'] = colorId;
    data['color_name'] = colorName;
    data['stock_in'] = stockIn;
    data['bal_quantity'] = balQuantity;
    return data;
  }
}
