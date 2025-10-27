class WarpSupplierSingleYarnRateModel {
  int? id;
  int? supplierId;
  String? supplierName;
  dynamic yarnRateTotal;
  String? createdAt;
  List<ItemDetails>? itemDetails;

  WarpSupplierSingleYarnRateModel(
      {this.id,
        this.supplierId,
        this.supplierName,
        this.yarnRateTotal,
        this.createdAt,
        this.itemDetails});

  WarpSupplierSingleYarnRateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supplierId = json['supplier_id'];
    supplierName = json['supplier_name'];
    yarnRateTotal = json['yarn_rate_total'];
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
    data['supplier_id'] = this.supplierId;
    data['supplier_name'] = this.supplierName;
    data['yarn_rate_total'] = this.yarnRateTotal;
    data['created_at'] = this.createdAt;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? yarnId;
  String? lengthType;
  dynamic yarnLength;
  dynamic rate;
  int? wrapSuppliersId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? yarnName;

  ItemDetails(
      {this.id,
        this.yarnId,
        this.lengthType,
        this.yarnLength,
        this.rate,
        this.wrapSuppliersId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.yarnName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnId = json['yarn_id'];
    lengthType = json['length_type'];
    yarnLength = json['yarn_length'];
    rate = json['rate'];
    wrapSuppliersId = json['wrap_suppliers_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    yarnName = json['yarn_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yarn_id'] = this.yarnId;
    data['length_type'] = this.lengthType;
    data['yarn_length'] = this.yarnLength;
    data['rate'] = this.rate;
    data['wrap_suppliers_id'] = this.wrapSuppliersId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['yarn_name'] = this.yarnName;
    return data;
  }
}