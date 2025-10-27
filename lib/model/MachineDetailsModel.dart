class MachineDetailsModel {
  int? id;
  String? machineName;
  String? machineType;
  String? wagesType;
  num? wages;
  String? windingType;
  String? deckType;
  int? spendile;
  num? hours;
  num? weight;
  num? meter;
  int? lots;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;

  MachineDetailsModel({
    this.id,
    this.machineName,
    this.machineType,
    this.wagesType,
    this.wages,
    this.windingType,
    this.deckType,
    this.spendile,
    this.hours,
    this.weight,
    this.meter,
    this.lots,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  MachineDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    machineName = json['machine_name'];
    machineType = json['machine_type'];
    wagesType = json['wages_type'];
    wages = json['wages'];
    windingType = json['winding_type'];
    deckType = json['deck_type'];
    spendile = json['spendile'];
    hours = json['hours'];
    weight = json['weight'];
    meter = json['meter'];
    lots = json['lots'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['machine_name'] = machineName;
    data['machine_type'] = machineType;
    data['wages_type'] = wagesType;
    data['wages'] = wages;
    data['winding_type'] = windingType;
    data['deck_type'] = deckType;
    data['spendile'] = spendile;
    data['hours'] = hours;
    data['weight'] = weight;
    data['meter'] = meter;
    data['lots'] = lots;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    return data;
  }

  @override
  String toString() {
    return "$machineName";
  }
}
