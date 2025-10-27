class JariTwistingYarnInwardModel {
  int? id;
  int? warperId;
  String? warperName;
  int? yarnId;
  String? yarnName;
  int? firmId;
  String? firmName;
  int? wagesAno;
  String? wagesAccount;
  String? stockIn;
  int? lessQuantity;
  String? eDate;
  String? boxNo;
  int? pck;
  int? wages;
  num? netAmount;
  int? colorId;
  String? colorName;
  num? quantity;
  int? crNo;
  String? details;
  int? slipNo;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  List<ItemDetails>? itemDetails;

  JariTwistingYarnInwardModel({
    this.id,
    this.warperId,
    this.warperName,
    this.yarnId,
    this.yarnName,
    this.firmId,
    this.firmName,
    this.wagesAno,
    this.wagesAccount,
    this.stockIn,
    this.lessQuantity,
    this.eDate,
    this.boxNo,
    this.pck,
    this.wages,
    this.netAmount,
    this.colorId,
    this.colorName,
    this.quantity,
    this.crNo,
    this.details,
    this.slipNo,
    this.itemDetails,
    this.creatorName,
    this.updatedName,
    this.createdAt,
    this.updatedAt,
  });

  JariTwistingYarnInwardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warperId = json['warper_id'];
    warperName = json['warper_name'];
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    wagesAno = json['wages_ano'];
    wagesAccount = json['wages_account'];
    stockIn = json['stock_in'];
    lessQuantity = json['less_quantity'];
    eDate = json['e_date'];
    boxNo = json['box_no'];
    pck = json['pck'];
    wages = json['wages'];
    netAmount = json['net_amount'];
    colorId = json['color_id'];
    colorName = json['color_name'];
    quantity = json['quantity'];
    crNo = json['cr_no'];
    details = json['details'];
    slipNo = json['slip_no'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['warper_id'] = warperId;
    data['warper_name'] = warperName;
    data['yarn_id'] = yarnId;
    data['yarn_name'] = yarnName;
    data['firm_id'] = firmId;
    data['firm_name'] = firmName;
    data['wages_ano'] = wagesAno;
    data['wages_account'] = wagesAccount;
    data['stock_in'] = stockIn;
    data['less_quantity'] = lessQuantity;
    data['e_date'] = eDate;
    data['box_no'] = boxNo;
    data['pck'] = pck;
    data['wages'] = wages;
    data['net_amount'] = netAmount;
    data['color_id'] = colorId;
    data['color_name'] = colorName;
    data['quantity'] = quantity;
    data['cr_no'] = crNo;
    data['details'] = details;
    data['slip_no'] = slipNo;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? jariTwistingYarnInwardId;
  int? yarnId;
  int? colorId;
  num? quantity;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? yarnName;
  String? colorName;
  dynamic usage;

  ItemDetails(
      {this.id,
      this.jariTwistingYarnInwardId,
      this.yarnId,
      this.colorId,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.yarnName,
      this.colorName,
      this.usage});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jariTwistingYarnInwardId = json['jari_twisting_yarn_inward_id'];
    yarnId = json['yarn_id'];
    colorId = json['color_id'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
    usage = json['usage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['jari_twisting_yarn_inward_id'] = jariTwistingYarnInwardId;
    data['yarn_id'] = yarnId;
    data['color_id'] = colorId;
    data['quantity'] = quantity;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['yarn_name'] = yarnName;
    data['color_name'] = colorName;
    data['usage'] = usage;
    return data;
  }
}
