class WarpsOrder {
  int? id;
  String? warpOrderType;
  String? orderFor;
  int? ledgerId;
  String? ledgerName;
  String? orderNo;
  String? orderDate;
  String? warpIdNo;
  String? warpDeliveryTo;
  String? fromNotification;
  int? warpNo;
  int? weaverId;
  String? weaverName;
  int? loomNo;
  String? weavingStatus;
  int? productId;
  String? productName;
  int? productMeter;
  int? warpDesignId;
  String? warpDesign;
  String? warpType;
  String? weavingBreak;
  int? qty;
  int? warpMetter;
  String? emptyDelivery;
  int? emptyQty;
  WarpColor? warpColor;
  String? details;
  String? weavingNo;

  WarpsOrder(
      {this.id,
      this.warpOrderType,
      this.orderFor,
      this.ledgerId,
      this.ledgerName,
      this.orderNo,
      this.orderDate,
      this.warpIdNo,
      this.warpDeliveryTo,
      this.fromNotification,
      this.warpNo,
      this.weaverId,
      this.weaverName,
      this.loomNo,
      this.weavingStatus,
      this.productId,
      this.productName,
      this.productMeter,
      this.warpDesignId,
      this.warpDesign,
      this.warpType,
      this.weavingBreak,
      this.qty,
      this.warpMetter,
      this.emptyDelivery,
      this.emptyQty,
      this.warpColor,
      this.details,
      this.weavingNo});

  WarpsOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warpOrderType = json['warp_order_type'];
    orderFor = json['order_for'];
    ledgerId = json['ledger_id'];
    ledgerName = json['ledger_name'];
    orderNo = json['order_no'];
    orderDate = json['order_date'];
    warpIdNo = json['warp_id_no'];
    warpDeliveryTo = json['warp_delivery_to'];
    fromNotification = json['from_notification'];
    warpNo = json['warp_no'];
    weaverId = json['weaver_id'];
    weaverName = json['weaver_name'];
    loomNo = json['loom_no'];
    weavingStatus = json['weaving_status'];
    productId = json['product_id'];
    productName = json['product_name'];
    productMeter = json['product_meter'];
    warpDesignId = json['warp_design_id'];
    warpDesign = json['warp_design'];
    warpType = json['warp_type'];
    weavingBreak = json['weaving_break'];
    qty = json['qty'];
    warpMetter = json['warp_metter'];
    emptyDelivery = json['empty_delivery'];
    emptyQty = json['empty_qty'];
    warpColor = json['warp_color'] != null
        ? new WarpColor.fromJson(json['warp_color'])
        : null;
    details = json['details'];
    weavingNo = json['weaving_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warp_order_type'] = this.warpOrderType;
    data['order_for'] = this.orderFor;
    data['ledger_id'] = this.ledgerId;
    data['ledger_name'] = this.ledgerName;
    data['order_no'] = this.orderNo;
    data['order_date'] = this.orderDate;
    data['warp_id_no'] = this.warpIdNo;
    data['warp_delivery_to'] = this.warpDeliveryTo;
    data['from_notification'] = this.fromNotification;
    data['warp_no'] = this.warpNo;
    data['weaver_id'] = this.weaverId;
    data['weaver_name'] = this.weaverName;
    data['loom_no'] = this.loomNo;
    data['weaving_status'] = this.weavingStatus;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_meter'] = this.productMeter;
    data['warp_design_id'] = this.warpDesignId;
    data['warp_design'] = this.warpDesign;
    data['warp_type'] = this.warpType;
    data['weaving_break'] = this.weavingBreak;
    data['qty'] = this.qty;
    data['warp_metter'] = this.warpMetter;
    data['empty_delivery'] = this.emptyDelivery;
    data['empty_qty'] = this.emptyQty;
    if (this.warpColor != null) {
      data['warp_color'] = this.warpColor!.toJson();
    }
    data['details'] = this.details;
    data['weaving_no'] = this.weavingNo;
    return data;
  }
}

class WarpColor {
  String? warpColor;

  WarpColor({this.warpColor});

  WarpColor.fromJson(Map<String, dynamic> json) {
    warpColor = json['warp_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warp_color'] = this.warpColor;
    return data;
  }
}
