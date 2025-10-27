class WinderInwardYarnColorQtyModel {
  int? yarnId;
  String? yarnName;
  int? colorId;
  String? colorName;
  num? balanceQty;

  WinderInwardYarnColorQtyModel({
    this.yarnId,
    this.yarnName,
    this.colorId,
    this.colorName,
    this.balanceQty,
  });

  WinderInwardYarnColorQtyModel.fromJson(Map<String, dynamic> json) {
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    colorId = json['color_id'];
    colorName = json['color_name'];
    balanceQty = json['balance_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['yarn_id'] = yarnId;
    data['yarn_name'] = yarnName;
    data['color_id'] = colorId;
    data['color_name'] = colorName;
    data['balance_qty'] = balanceQty;
    return data;
  }
}
