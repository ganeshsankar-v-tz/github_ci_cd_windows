 class DyerYarnOpeningBalanceModel {
  int? id;
  int? dyerId;
  String? dyerName;
  int? recordNo;
  String? details;
  int? qtyTotal;
  int? packTotal;
  String? createdAt;
  List<ItemDetails>? itemDetails;

  DyerYarnOpeningBalanceModel(
  {this.id,
  this.dyerId,
  this.dyerName,
  this.recordNo,
  this.details,
  this.qtyTotal,
  this.packTotal,
  this.createdAt,
  this.itemDetails});

  DyerYarnOpeningBalanceModel.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  dyerId = json['dyer_id'];
  dyerName = json['dyer_name'];
  recordNo = json['record_no'];
  details = json['details'];
  qtyTotal = json['qty_total'];
  packTotal = json['pack_total'];
  createdAt = json['created_at'];
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
  data['dyer_name'] = this.dyerName;
  data['record_no'] = this.recordNo;
  data['details'] = this.details;
  data['qty_total'] = this.qtyTotal;
  data['pack_total'] = this.packTotal;
  data['created_at'] = this.createdAt;
  if (this.itemDetails != null) {
  data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
  }
  return data;
  }
  }

  class ItemDetails {
  int? id;
  int? dyarYarnOpeningStockId;
  int? yarnId;
  int? colourId;
  int? pack;
  int? quantity;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? yarnName;
  String? colorName;

  ItemDetails(
  {this.id,
  this.dyarYarnOpeningStockId,
  this.yarnId,
  this.colourId,
  this.pack,
  this.quantity,
  this.status,
  this.createdAt,
  this.updatedAt,
  this.yarnName,
  this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  dyarYarnOpeningStockId = json['dyar_yarn_opening_stock_id'];
  yarnId = json['yarn_id'];
  colourId = json['colour_id'];
  pack = json['pack'];
  quantity = json['quantity'];
  status = json['status'];
  createdAt = json['created_at'];
  updatedAt = json['updated_at'];
  yarnName = json['yarn_name'];
  colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['dyar_yarn_opening_stock_id'] = this.dyarYarnOpeningStockId;
  data['yarn_id'] = this.yarnId;
  data['colour_id'] = this.colourId;
  data['pack'] = this.pack;
  data['quantity'] = this.quantity;
  data['status'] = this.status;
  data['created_at'] = this.createdAt;
  data['updated_at'] = this.updatedAt;
  data['yarn_name'] = this.yarnName;
  data['color_name'] = this.colorName;
  return data;
  }
  }