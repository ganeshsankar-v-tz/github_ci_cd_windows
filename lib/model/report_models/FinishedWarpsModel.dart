class FinishedWarpsModel {
  int? weaverId;
  String? weaverName;
  int? loom;
  dynamic productQuantity;
  dynamic meter;
  dynamic recivedQty;
  dynamic recivedMeter;
  int? productId;
  String? productName;
  int? weavNo;
  String? finishedDate;

  FinishedWarpsModel(
      {this.weaverId,
      this.weaverName,
      this.loom,
      this.productQuantity,
      this.meter,
      this.recivedQty,
      this.recivedMeter,
      this.productId,
      this.productName,
      this.weavNo,
      this.finishedDate});

  FinishedWarpsModel.fromJson(Map<String, dynamic> json) {
    weaverId = json['weaver_id'];
    weaverName = json['weaver_name'];
    loom = json['loom'];
    productQuantity = json['product_quantity'];
    meter = json['meter'];
    recivedQty = json['recived_qty'];
    recivedMeter = json['recived_meter'];
    productId = json['product_id'];
    productName = json['product_name'];
    weavNo = json['weav_no'];
    finishedDate = json['finished_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weaver_id'] = this.weaverId;
    data['weaver_name'] = this.weaverName;
    data['loom'] = this.loom;
    data['product_quantity'] = this.productQuantity;
    data['meter'] = this.meter;
    data['recived_qty'] = this.recivedQty;
    data['recived_meter'] = this.recivedMeter;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['weav_no'] = this.weavNo;
    data['finished_date'] = this.finishedDate;
    return data;
  }
}
