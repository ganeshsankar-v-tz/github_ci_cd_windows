class WindingYarnOpeningBalanceModel {
  int? id;
  int? winderId;
  String? winderName;
  String? recordNo;
  String? details;
  int? deTotalPack;
  dynamic? deTotalQty;
  dynamic? exTotalQty;
  String? createdAt;
  List<DeliveredDetails>? deliveredDetails;
  List<ExpectedDetails>? expectedDetails;

  WindingYarnOpeningBalanceModel(
      {this.id,
        this.winderId,
        this.winderName,
        this.recordNo,
        this.details,
        this.deTotalPack,
        this.deTotalQty,
        this.exTotalQty,
        this.createdAt,
        this.deliveredDetails,
        this.expectedDetails});

  WindingYarnOpeningBalanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    winderId = json['winder_id'];
    winderName = json['winder_name'];
    recordNo = json['record_no'];
    details = json['details'];
    deTotalPack = json['de_total_pack'];
    deTotalQty = json['de_total_qty'];
    exTotalQty = json['ex_total_qty'];
    createdAt = json['created_at'];
    if (json['delivered_details'] != null) {
      deliveredDetails = <DeliveredDetails>[];
      json['delivered_details'].forEach((v) {
        deliveredDetails!.add(new DeliveredDetails.fromJson(v));
      });
    }
    if (json['expected_details'] != null) {
      expectedDetails = <ExpectedDetails>[];
      json['expected_details'].forEach((v) {
        expectedDetails!.add(new ExpectedDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['winder_id'] = this.winderId;
    data['winder_name'] = this.winderName;
    data['record_no'] = this.recordNo;
    data['details'] = this.details;
    data['de_total_pack'] = this.deTotalPack;
    data['de_total_qty'] = this.deTotalQty;
    data['ex_total_qty'] = this.exTotalQty;
    data['created_at'] = this.createdAt;
    if (this.deliveredDetails != null) {
      data['delivered_details'] =
          this.deliveredDetails!.map((v) => v.toJson()).toList();
    }
    if (this.expectedDetails != null) {
      data['expected_details'] =
          this.expectedDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveredDetails {
  int? id;
  int? windingYarnOpeningStockId;
  int? deYarnId;
  int? deColourId;
  int? dePack;
  String? status;
  String? createdAt;
  String? updatedAt;
  dynamic? deQty;
  String? deYarnName;
  String? deColorName;

  DeliveredDetails(
      {this.id,
        this.windingYarnOpeningStockId,
        this.deYarnId,
        this.deColourId,
        this.dePack,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deQty,
        this.deYarnName,
        this.deColorName});

  DeliveredDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    windingYarnOpeningStockId = json['winding_yarn_opening_stock_id'];
    deYarnId = json['de_yarn_id'];
    deColourId = json['de_colour_id'];
    dePack = json['de_pack'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deQty = json['de_qty'];
    deYarnName = json['de_yarn_name'];
    deColorName = json['de_color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['winding_yarn_opening_stock_id'] = this.windingYarnOpeningStockId;
    data['de_yarn_id'] = this.deYarnId;
    data['de_colour_id'] = this.deColourId;
    data['de_pack'] = this.dePack;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['de_qty'] = this.deQty;
    data['de_yarn_name'] = this.deYarnName;
    data['de_color_name'] = this.deColorName;
    return data;
  }
}

class ExpectedDetails {
  int? id;
  int? windingYarnOpeningStockId;
  int? exYarnId;
  dynamic? exQty;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? exYarnName;

  ExpectedDetails(
      {this.id,
        this.windingYarnOpeningStockId,
        this.exYarnId,
        this.exQty,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.exYarnName});

  ExpectedDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    windingYarnOpeningStockId = json['winding_yarn_opening_stock_id'];
    exYarnId = json['ex_yarn_id'];
    exQty = json['ex_qty'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    exYarnName = json['ex_yarn_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['winding_yarn_opening_stock_id'] = this.windingYarnOpeningStockId;
    data['ex_yarn_id'] = this.exYarnId;
    data['ex_qty'] = this.exQty;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['ex_yarn_name'] = this.exYarnName;
    return data;
  }
}