class WeavingWeftBalanceModel {
  String? productQuantity;
  int? yarnId;
  String? yarnName;
  dynamic weftQty;
  dynamic reqYarn;
  dynamic deliverdYarn;
  dynamic deliveryBalance;
  dynamic usedYarn;
  dynamic weaverYarnStock;

  WeavingWeftBalanceModel(
      {this.productQuantity,
      this.yarnId,
      this.yarnName,
      this.weftQty,
      this.reqYarn,
      this.deliverdYarn,
      this.deliveryBalance,
      this.usedYarn,
      this.weaverYarnStock});

  WeavingWeftBalanceModel.fromJson(Map<String, dynamic> json) {
    productQuantity = json['product_quantity'];
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    weftQty = json['weft_qty'];
    reqYarn = json['req_yarn'];
    deliverdYarn = json['deliverd_yarn'];
    deliveryBalance = json['delivery_balance'];
    usedYarn = json['used_yarn'];
    weaverYarnStock = json['weaver_yarn_stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_quantity'] = this.productQuantity;
    data['yarn_id'] = this.yarnId;
    data['yarn_name'] = this.yarnName;
    data['weft_qty'] = this.weftQty;
    data['req_yarn'] = this.reqYarn;
    data['deliverd_yarn'] = this.deliverdYarn;
    data['delivery_balance'] = this.deliveryBalance;
    data['used_yarn'] = this.usedYarn;
    data['weaver_yarn_stock'] = this.weaverYarnStock;
    return data;
  }

  @override
  String toString() {
    return "$yarnName";
  }
}
