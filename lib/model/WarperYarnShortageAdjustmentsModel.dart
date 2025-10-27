class WarperYarnShortageAdjustmentsModel {
  int? id;
  int? warperId;
  String? warperName;
  String? eDate;
  String? details;
  int? transNo;
  List<ItemDetails>? itemDetails;

  WarperYarnShortageAdjustmentsModel(
      {this.id,
        this.warperId,
        this.warperName,
        this.eDate,
        this.details,
        this.transNo,
        this.itemDetails});

  WarperYarnShortageAdjustmentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warperId = json['warper_id'];
    warperName = json['warper_name'];
    eDate = json['e_date'];
    details = json['details'];
    transNo = json['trans_no'];
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
    data['warper_id'] = this.warperId;
    data['warper_name'] = this.warperName;
    data['e_date'] = this.eDate;
    data['details'] = this.details;
    data['trans_no'] = this.transNo;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? warperYarnShortageAdjustmentsId;
  int? yarnId;
  int? colorId;
  int? stockBalance;
  int? qty;
  String? createdAt;
  String? updatedAt;
  int? status;
  String? createdBy;
  String? updatedBy;
  String? yarnName;
  String? colorName;

  ItemDetails(
      {this.id,
        this.warperYarnShortageAdjustmentsId,
        this.yarnId,
        this.colorId,
        this.stockBalance,
        this.qty,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.createdBy,
        this.updatedBy,
        this.yarnName,
        this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warperYarnShortageAdjustmentsId =
    json['warper_yarn_shortage_adjustments_id'];
    yarnId = json['yarn_id'];
    colorId = json['color_id'];
    stockBalance = json['stock_balance'];
    qty = json['qty'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warper_yarn_shortage_adjustments_id'] =
        this.warperYarnShortageAdjustmentsId;
    data['yarn_id'] = this.yarnId;
    data['color_id'] = this.colorId;
    data['stock_balance'] = this.stockBalance;
    data['qty'] = this.qty;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['yarn_name'] = this.yarnName;
    data['color_name'] = this.colorName;
    return data;
  }
}
