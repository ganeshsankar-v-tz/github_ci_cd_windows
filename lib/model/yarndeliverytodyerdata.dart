class YarnDeliverytoDyerModel {
  int? id;
  int? dyerId;
  String? dyarName;
  String? dcNo;
  String? entryDate;
  String? details;
  String? entryType;
  int? yarnId;
  String? yarnName;
  int? colorId;
  String? colorName;
  String? deliveryFrom;
  String? boxNo;
  int? stock;
  int? pack;
  dynamic? quantity;
  dynamic? less;
  dynamic? netQuantity;
  dynamic? totalQuantity;
  int? totalPackQuantity;
  List<ItemDetails>? itemDetails;

  YarnDeliverytoDyerModel(
      {this.id,
      this.dyerId,
      this.dyarName,
      this.dcNo,
      this.entryDate,
      this.details,
      this.entryType,
      this.yarnId,
      this.yarnName,
      this.colorId,
      this.colorName,
      this.deliveryFrom,
      this.boxNo,
      this.stock,
      this.pack,
      this.quantity,
      this.less,
      this.netQuantity,
      this.totalQuantity,
      this.totalPackQuantity,
      this.itemDetails});

  YarnDeliverytoDyerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dyerId = json['dyer_id'];
    dyarName = json['dyar_name'];
    dcNo = json['dc_no'];
    entryDate = json['entry_date'];
    details = json['details'];
    entryType = json['entry_type'];
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    colorId = json['color_id'];
    colorName = json['color_name'];
    deliveryFrom = json['delivery_from'];
    boxNo = json['box_no'];
    stock = json['stock'];
    pack = json['pack'];
    quantity = json['quantity'];
    less = json['less'];
    netQuantity = json['net_quantity'];
    totalQuantity = json['total_quantity'];
    totalPackQuantity = json['total_pack_quantity'];
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(new ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dyer_id'] = this.dyerId;
    data['dyar_name'] = this.dyarName;
    data['dc_no'] = this.dcNo;
    data['entry_date'] = this.entryDate;
    data['details'] = this.details;
    data['entry_type'] = this.entryType;
    data['yarn_id'] = this.yarnId;
    data['yarn_name'] = this.yarnName;
    data['color_id'] = this.colorId;
    data['color_name'] = this.colorName;
    data['delivery_from'] = this.deliveryFrom;
    data['box_no'] = this.boxNo;
    data['stock'] = this.stock;
    data['pack'] = this.pack;
    data['quantity'] = this.quantity;
    data['less'] = this.less;
    data['net_quantity'] = this.netQuantity;
    data['total_quantity'] = this.totalQuantity;
    data['total_pack_quantity'] = this.totalPackQuantity;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? yarnDeliveryToDyerId;
  int? colorId;
  int? pack;
  dynamic? qty;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? colorName;

  ItemDetails(
      {this.id,
      this.yarnDeliveryToDyerId,
      this.colorId,
      this.pack,
      this.qty,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnDeliveryToDyerId = json['yarn_delivery_to_dyer_id'];
    colorId = json['color_id'];
    pack = json['pack'];
    qty = json['qty'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yarn_delivery_to_dyer_id'] = this.yarnDeliveryToDyerId;
    data['color_id'] = this.colorId;
    data['pack'] = this.pack;
    data['qty'] = this.qty;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['color_name'] = this.colorName;
    return data;
  }
}
