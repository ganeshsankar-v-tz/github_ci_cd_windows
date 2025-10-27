class WeaverTransferYarnModel {
  int? productId;
  String? productName;
  int? yarnId;
  String? yarnName;
  String? weftType;
  num? weftBalance;

  WeaverTransferYarnModel(
      {this.productId,
      this.productName,
      this.yarnId,
      this.yarnName,
      this.weftType,
      this.weftBalance});

  WeaverTransferYarnModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    weftType = json['weft_type'];
    weftBalance = json['weft_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['yarn_id'] = yarnId;
    data['yarn_name'] = yarnName;
    data['weft_type'] = weftType;
    data['weft_balance'] = weftBalance;
    return data;
  }

  @override
  String toString() {
    return "$yarnName";
  }
}
