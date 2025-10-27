class JariTwistingModel {
  int? id;
  int? yarnId;
  String? yarnName;
  String? details;
  dynamic defaultQty;
  dynamic wages;
  String? createdBy;
  List<ItemDetails>? itemDetails;

  JariTwistingModel(
      {this.id,
      this.yarnId,
      this.yarnName,
      this.details,
      this.defaultQty,
      this.wages,
      this.createdBy,
      this.itemDetails});

  JariTwistingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    details = json['details'];
    defaultQty = json['default_qty'];
    wages = json['wages'];
    createdBy = json['created_by'];
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
    data['yarn_id'] = this.yarnId;
    data['yarn_name'] = this.yarnName;
    data['details'] = this.details;
    data['default_qty'] = this.defaultQty;
    data['wages'] = this.wages;
    data['created_by'] = this.createdBy;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return "$yarnName";
  }
}

class ItemDetails {
  int? id;
  int? jariTwistingId;
  int? rowNo;
  int? yarnId;
  dynamic usage;
  String? colourName;
  int? colourId;
  int? status;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  String? yarnName;
  String? colorName;

  ItemDetails(
      {this.id,
      this.jariTwistingId,
      this.rowNo,
      this.yarnId,
      this.usage,
      this.colourName,
      this.colourId,
      this.status,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.yarnName,
      this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jariTwistingId = json['jari_twisting_id'];
    rowNo = json['row_no'];
    yarnId = json['yarn_id'];
    usage = json['usage'];
    colourName = json['colour_name'];
    colourId = json['colour_id'];
    status = json['status'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['jari_twisting_id'] = this.jariTwistingId;
    data['row_no'] = this.rowNo;
    data['yarn_id'] = this.yarnId;
    data['usage'] = this.usage;
    data['colour_name'] = this.colourName;
    data['colour_id'] = this.colourId;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['yarn_name'] = this.yarnName;
    data['color_name'] = this.colorName;
    return data;
  }
}
