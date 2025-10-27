class WeaverCurrentProductModel {
  String? currentStatus;
  String? productName;
  String? warpName;
  String? warpType;
  int? balanceQty;
  num? balanceMeter;
  String? warpId;

  WeaverCurrentProductModel(
      {this.currentStatus,
      this.productName,
      this.warpName,
      this.warpType,
      this.balanceQty,
      this.balanceMeter,
      this.warpId});

  WeaverCurrentProductModel.fromJson(Map<String, dynamic> json) {
    currentStatus = json['current_status'];
    productName = json['product_name'];
    warpName = json['warp_name'];
    warpType = json['warp_type'];
    balanceQty = json['balance_qty'];
    balanceMeter = json['balance_meter'];
    warpId = json['warp_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_status'] = currentStatus;
    data['product_name'] = productName;
    data['warp_name'] = warpName;
    data['warp_type'] = warpType;
    data['balance_qty'] = balanceQty;
    data['balance_meter'] = balanceMeter;
    data['warp_id'] = warpId;
    return data;
  }
}
