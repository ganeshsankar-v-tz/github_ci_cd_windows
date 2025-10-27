class ProductDetailsGoodsInwardModel {
  int? productId;
  String? productName;
  String? designImage;
  String? designNo;
  num? width;
  num? pick;
  num? wages;
  num? meter;
  String? warpDetails;
  String? warpColor;
  int? deliverdQty;
  int? recivedQty;
  int? balanceQty;
  PreviousBill? previousBill;

  ProductDetailsGoodsInwardModel({
    this.productId,
    this.productName,
    this.designImage,
    this.designNo,
    this.width,
    this.pick,
    this.wages,
    this.meter,
    this.warpDetails,
    this.warpColor,
    this.deliverdQty,
    this.recivedQty,
    this.balanceQty,
    this.previousBill,
  });

  ProductDetailsGoodsInwardModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    designImage = json['design_image'];
    designNo = json['design_no'];
    width = json['width'];
    pick = json['pick'];
    wages = json['wages'];
    meter = json['meter'];
    warpDetails = json['warp_details'];
    warpColor = json['warp_color'];
    deliverdQty = json['deliverd_qty'];
    recivedQty = json['recived_qty'];
    balanceQty = json['balance_qty'];
    previousBill = json['previous_bill'] != null
        ? new PreviousBill.fromJson(json['previous_bill'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['design_image'] = this.designImage;
    data['design_no'] = this.designNo;
    data['width'] = this.width;
    data['pick'] = this.pick;
    data['wages'] = this.wages;
    data['meter'] = this.meter;
    data['warp_details'] = this.warpDetails;
    data['warp_color'] = this.warpColor;
    data['deliverd_qty'] = this.deliverdQty;
    data['recived_qty'] = this.recivedQty;
    data['balance_qty'] = this.balanceQty;
    if (this.previousBill != null) {
      data['previous_bill'] = this.previousBill!.toJson();
    }
    return data;
  }
}

class PreviousBill {
  int? productId;
  num? wages;
  String? productName;

  PreviousBill({this.productId, this.wages, this.productName});

  PreviousBill.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    wages = json['wages'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['wages'] = this.wages;
    data['product_name'] = this.productName;
    return data;
  }
}
