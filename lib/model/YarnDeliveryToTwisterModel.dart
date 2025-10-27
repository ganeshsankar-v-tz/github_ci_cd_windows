class YarnDeliveryToTwisterModel {
  int? id;
  int? firmId;
  String? eDate;
  int? yarnId;
  int? machineId;
  String? machineType;
  String? wagesType;
  String? deckType;
  String? windingType;
  int? spendile;
  num? hours;
  num? weight;
  num? meter;
  int? lots;
  num? wages;
  num? grossQuantity;
  String? details;
  String? entry;
  String? emptyType;
  String? updatedAt;
  String? createdAt;
  int? createdBy;
  int? updatedBy;
  String? firmName;
  String? yarnName;
  String? machineName;
  String? createrName;
  String? updaterName;
  List<TwistingDeliveryDetails>? twistingDeliveryDetails;

  YarnDeliveryToTwisterModel({
    this.id,
    this.firmId,
    this.eDate,
    this.yarnId,
    this.machineId,
    this.machineType,
    this.wagesType,
    this.deckType,
    this.windingType,
    this.spendile,
    this.hours,
    this.weight,
    this.meter,
    this.lots,
    this.wages,
    this.grossQuantity,
    this.details,
    this.entry,
    this.emptyType,
    this.updatedAt,
    this.createdAt,
    this.createdBy,
    this.updatedBy,
    this.firmName,
    this.yarnName,
    this.machineName,
    this.createrName,
    this.updaterName,
    this.twistingDeliveryDetails,
  });

  YarnDeliveryToTwisterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    eDate = json['e_date'];
    yarnId = json['yarn_id'];
    machineId = json['machine_id'];
    machineType = json['machine_type'];
    wagesType = json['wages_type'];
    deckType = json['deck_type'];
    windingType = json['winding_type'];
    spendile = json['spendile'];
    hours = json['hours'];
    weight = json['weight'];
    meter = json['meter'];
    lots = json['lots'];
    wages = json['wages'];
    grossQuantity = json['gross_quantity'];
    details = json['details'];
    entry = json['entry'];
    emptyType = json['empty_type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    firmName = json['firm_name'];
    yarnName = json['yarn_name'];
    machineName = json['machine_name'];
    createrName = json['creater_name'];
    updaterName = json['updater_name'];
    if (json['twisting_delivery_details'] != null) {
      twistingDeliveryDetails = <TwistingDeliveryDetails>[];
      json['twisting_delivery_details'].forEach((v) {
        twistingDeliveryDetails!.add(TwistingDeliveryDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firm_id'] = firmId;
    data['e_date'] = eDate;
    data['yarn_id'] = yarnId;
    data['machine_id'] = machineId;
    data['machine_type'] = machineType;
    data['wages_type'] = wagesType;
    data['deck_type'] = deckType;
    data['winding_type'] = windingType;
    data['spendile'] = spendile;
    data['hours'] = hours;
    data['weight'] = weight;
    data['meter'] = meter;
    data['lots'] = lots;
    data['wages'] = wages;
    data['gross_quantity'] = grossQuantity;
    data['details'] = details;
    data['entry'] = entry;
    data['empty_type'] = emptyType;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['firm_name'] = firmName;
    data['yarn_name'] = yarnName;
    data['machine_name'] = machineName;
    data['creater_name'] = createrName;
    data['updater_name'] = updaterName;
    if (twistingDeliveryDetails != null) {
      data['twisting_delivery_details'] =
          twistingDeliveryDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TwistingDeliveryDetails {
  int? id;
  int? twistingYarnDeliveryId;
  int? yarnId;
  int? colorId;
  String? bagBoxNo;
  String? stockIn;
  int? pack;
  num? quantity;
  String? details;
  String? yarnName;
  String? colorName;

  TwistingDeliveryDetails({
    this.id,
    this.twistingYarnDeliveryId,
    this.yarnId,
    this.colorId,
    this.bagBoxNo,
    this.stockIn,
    this.pack,
    this.quantity,
    this.details,
    this.yarnName,
    this.colorName,
  });

  TwistingDeliveryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    twistingYarnDeliveryId = json['twisting_yarn_delivery_id'];
    yarnId = json['yarn_id'];
    colorId = json['color_id'];
    bagBoxNo = json['bag_box_no'];
    stockIn = json['stock_in'];
    pack = json['pack'];
    quantity = json['quantity'];
    details = json['details'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['twisting_yarn_delivery_id'] = twistingYarnDeliveryId;
    data['yarn_id'] = yarnId;
    data['color_id'] = colorId;
    data['bag_box_no'] = bagBoxNo;
    data['stock_in'] = stockIn;
    data['pack'] = pack;
    data['quantity'] = quantity;
    data['details'] = details;
    data['yarn_name'] = yarnName;
    data['color_name'] = colorName;
    return data;
  }
}
