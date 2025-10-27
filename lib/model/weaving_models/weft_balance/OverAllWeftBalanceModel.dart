class OverAllWeftBalanceModel {
  List<WeftBalance>? weftBalance;
  ProductDetails? productDetails;

  OverAllWeftBalanceModel({this.weftBalance, this.productDetails});

  OverAllWeftBalanceModel.fromJson(Map<String, dynamic> json) {
    if (json['weft_balance'] != null) {
      weftBalance = <WeftBalance>[];
      json['weft_balance'].forEach((v) {
        weftBalance!.add(WeftBalance.fromJson(v));
      });
    }
    productDetails = json['product_details'] != null
        ? ProductDetails.fromJson(json['product_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (weftBalance != null) {
      data['weft_balance'] = weftBalance!.map((v) => v.toJson()).toList();
    }
    if (productDetails != null) {
      data['product_details'] = productDetails!.toJson();
    }
    return data;
  }
}

class WeftBalance {
  int? yarnId;
  String? yarnName;
  num? weftQty;
  num? reqWeft;
  num? deliWeft;
  num? balWeft;
  num? useWeft;
  num? wevStock;
  String? unit;

  WeftBalance(
      {this.yarnId,
      this.yarnName,
      this.weftQty,
      this.reqWeft,
      this.deliWeft,
      this.balWeft,
      this.useWeft,
      this.wevStock,
      this.unit});

  WeftBalance.fromJson(Map<String, dynamic> json) {
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    weftQty = json['weft_qty'];
    reqWeft = json['req_weft'];
    deliWeft = json['deli_weft'];
    balWeft = json['bal_weft'];
    useWeft = json['use_weft'];
    wevStock = json['wev_stock'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['yarn_id'] = yarnId;
    data['yarn_name'] = yarnName;
    data['weft_qty'] = weftQty;
    data['req_weft'] = reqWeft;
    data['deli_weft'] = deliWeft;
    data['bal_weft'] = balWeft;
    data['use_weft'] = useWeft;
    data['wev_stock'] = wevStock;
    data['unit'] = unit;
    return data;
  }
}

class ProductDetails {
  int? deliveryQty;
  int? receviedQty;
  int? balanceQty;

  ProductDetails({this.deliveryQty, this.receviedQty, this.balanceQty});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    deliveryQty = json['delivery_qty'];
    receviedQty = json['recevied_qty'];
    balanceQty = json['balance_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['delivery_qty'] = deliveryQty;
    data['recevied_qty'] = receviedQty;
    data['balance_qty'] = balanceQty;
    return data;
  }
}
