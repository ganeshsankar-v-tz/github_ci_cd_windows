class JariTwistingInwardV2Model {
  int? id;
  String? eDate;
  int? firmId;
  int? wagesAno;
  int? yarnId;
  int? machineId;
  String? machineType;
  dynamic deckType;
  String? windingType;
  String? spendile;
  num? hours;
  num? weight;
  num? meter;
  int? lots;
  int? wages;
  int? colorId;
  String? stockIn;
  String? boxNo;
  int? pck;
  num? grossAmount;
  num? grossQuantity;
  String? details;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;
  String? firmName;
  String? accountName;
  String? yarnName;
  String? machineName;
  String? colorName;
  String? createrName;
  String? updaterName;
  List<TwistingInwardDetails>? twistingInwardDetails;
  List<OperatorsDetails>? operatorsDetails;

  JariTwistingInwardV2Model({
    this.id,
    this.eDate,
    this.firmId,
    this.wagesAno,
    this.yarnId,
    this.machineId,
    this.machineType,
    this.deckType,
    this.windingType,
    this.spendile,
    this.hours,
    this.weight,
    this.meter,
    this.lots,
    this.wages,
    this.colorId,
    this.stockIn,
    this.boxNo,
    this.pck,
    this.grossAmount,
    this.grossQuantity,
    this.details,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.firmName,
    this.accountName,
    this.yarnName,
    this.machineName,
    this.colorName,
    this.createrName,
    this.updaterName,
    this.twistingInwardDetails,
    this.operatorsDetails,
  });

  JariTwistingInwardV2Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eDate = json['e_date'];
    firmId = json['firm_id'];
    wagesAno = json['wages_ano'];
    yarnId = json['yarn_id'];
    machineId = json['machine_id'];
    machineType = json['machine_type'];
    deckType = json['deck_type'];
    windingType = json['winding_type'];
    spendile = json['spendile'];
    hours = json['hours'];
    weight = json['weight'];
    meter = json['meter'];
    lots = json['lots'];
    wages = json['wages'];
    colorId = json['color_id'];
    stockIn = json['stock_in'];
    boxNo = json['box_no'];
    pck = json['pck'];
    grossAmount = json['gross_amount'];
    grossQuantity = json['gross_quantity'];
    details = json['details'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    firmName = json['firm_name'];
    accountName = json['account_name'];
    yarnName = json['yarn_name'];
    machineName = json['machine_name'];
    colorName = json['color_name'];
    createrName = json['creater_name'];
    updaterName = json['updater_name'];
    if (json['twisting_inward_details'] != null) {
      twistingInwardDetails = <TwistingInwardDetails>[];
      json['twisting_inward_details'].forEach((v) {
        twistingInwardDetails!.add(TwistingInwardDetails.fromJson(v));
      });
    }
    if (json['operators_details'] != null) {
      operatorsDetails = <OperatorsDetails>[];
      json['operators_details'].forEach((v) {
        operatorsDetails!.add(OperatorsDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['e_date'] = eDate;
    data['firm_id'] = firmId;
    data['wages_ano'] = wagesAno;
    data['yarn_id'] = yarnId;
    data['machine_id'] = machineId;
    data['machine_type'] = machineType;
    data['deck_type'] = deckType;
    data['winding_type'] = windingType;
    data['spendile'] = spendile;
    data['hours'] = hours;
    data['weight'] = weight;
    data['meter'] = meter;
    data['lots'] = lots;
    data['wages'] = wages;
    data['color_id'] = colorId;
    data['stock_in'] = stockIn;
    data['box_no'] = boxNo;
    data['pck'] = pck;
    data['gross_amount'] = grossAmount;
    data['gross_quantity'] = grossQuantity;
    data['details'] = details;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['firm_name'] = firmName;
    data['account_name'] = accountName;
    data['yarn_name'] = yarnName;
    data['machine_name'] = machineName;
    data['color_name'] = colorName;
    data['creater_name'] = createrName;
    data['updater_name'] = updaterName;
    if (twistingInwardDetails != null) {
      data['twisting_inward_details'] =
          twistingInwardDetails!.map((v) => v.toJson()).toList();
    }
    if (operatorsDetails != null) {
      data['operators_details'] =
          operatorsDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TwistingInwardDetails {
  int? id;
  int? twistingYarnInwardId;
  int? yarnId;
  int? colorId;
  num? quantity;
  String? yarnName;
  String? colorName;

  TwistingInwardDetails({
    this.id,
    this.twistingYarnInwardId,
    this.yarnId,
    this.colorId,
    this.quantity,
    this.yarnName,
    this.colorName,
  });

  TwistingInwardDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    twistingYarnInwardId = json['twisting_yarn_inward_id'];
    yarnId = json['yarn_id'];
    colorId = json['color_id'];
    quantity = json['quantity'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['twisting_yarn_inward_id'] = twistingYarnInwardId;
    data['yarn_id'] = yarnId;
    data['color_id'] = colorId;
    data['quantity'] = quantity;
    data['yarn_name'] = yarnName;
    data['color_name'] = colorName;
    return data;
  }
}

class OperatorsDetails {
  int? id;
  int? twistingYarnInwardId;
  int? operatorId;
  num? hours;
  num? weight;
  num? meter;
  int? lots;
  num? wages;
  String? details;
  String? operatorName;

  OperatorsDetails({
    this.id,
    this.twistingYarnInwardId,
    this.operatorId,
    this.hours,
    this.weight,
    this.meter,
    this.lots,
    this.wages,
    this.details,
    this.operatorName,
  });

  OperatorsDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    twistingYarnInwardId = json['twisting_yarn_inward_id'];
    operatorId = json['operator_id'];
    hours = json['hours'];
    weight = json['weight'];
    meter = json['meter'];
    lots = json['lots'];
    wages = json['wages'];
    details = json['details'];
    operatorName = json['operator_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['twisting_yarn_inward_id'] = twistingYarnInwardId;
    data['operator_id'] = operatorId;
    data['hours'] = hours;
    data['weight'] = weight;
    data['meter'] = meter;
    data['lots'] = lots;
    data['wages'] = wages;
    data['details'] = details;
    data['operator_name'] = operatorName;
    return data;
  }
}
