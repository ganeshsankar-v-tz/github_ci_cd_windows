import 'package:abtxt/utils/constant.dart';

class DeliveryYarn {
  late int? id;
  int? dyerId;
  Null? dyarName;
  int? yarnId;
  String? yarnName;
  int? dcNo;
  String? entryDate;
  String? entryType;
  String? details;
  String? deliveryFrom;
  int? stock;
  int? pack;
  int? quantity;
  int? less;
  int? netQuantity;
  List<ItemDetails>? itemDetails;

  DeliveryYarn(
      {required this.id,
      this.dyerId,
      this.dyarName,
      this.yarnId,
      this.yarnName,
      this.dcNo,
      this.entryDate,
      this.entryType,
      this.details,
      this.deliveryFrom,
      this.stock,
      this.pack,
      this.quantity,
      this.less,
      this.netQuantity,
      this.itemDetails});

  DeliveryYarn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dyerId = json['dyer_id'];
    dyarName = json['dyar_name'];
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    dcNo = json['dc_no'];
    entryDate = json['entry_date'];
    entryType = json['entry_type'];
    details = json['details'];
    deliveryFrom = json['delivery_from'];
    stock = json['stock'];
    pack = json['pack'];
    quantity = json['quantity'];
    less = json['less'];
    netQuantity = json['net_quantity'];
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
    data['yarn_id'] = this.yarnId;
    data['yarn_name'] = this.yarnName;
    data['dc_no'] = this.dcNo;
    data['entry_date'] = this.entryDate;
    data['entry_type'] = this.entryType;
    data['details'] = this.details;
    data['delivery_from'] = this.deliveryFrom;
    data['stock'] = this.stock;
    data['pack'] = this.pack;
    data['quantity'] = this.quantity;
    data['less'] = this.less;
    data['net_quantity'] = this.netQuantity;
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
  int? qty;
  int? status;
  String? createdAt;
  String? updatedAt;

  ItemDetails(
      {this.id,
      this.yarnDeliveryToDyerId,
      this.colorId,
      this.pack,
      this.qty,
      this.status,
      this.createdAt,
      this.updatedAt});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnDeliveryToDyerId = json['yarn_delivery_to_dyer_id'];
    colorId = json['color_id'];
    pack = json['pack'];
    qty = json['qty'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}
