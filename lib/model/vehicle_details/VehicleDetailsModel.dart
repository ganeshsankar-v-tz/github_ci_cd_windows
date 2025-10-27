class VehicleDetailsModel {
  int? id;
  String? transportName;
  String? vehicleNo;
  String? vehicleGst;
  int? createdBy;
  int? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? creatorName;
  String? updatorName;

  VehicleDetailsModel({
    this.id,
    this.transportName,
    this.vehicleNo,
    this.vehicleGst,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.creatorName,
    this.updatorName,
  });

  VehicleDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transportName = json['transport_name'];
    vehicleNo = json['vehicle_no'];
    vehicleGst = json['vehicle_gst'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    creatorName = json['creator_name'];
    updatorName = json['updator_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transport_name'] = transportName;
    data['vehicle_no'] = vehicleNo;
    data['vehicle_gst'] = vehicleGst;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['creator_name'] = creatorName;
    data['updator_name'] = updatorName;
    return data;
  }

  @override
  String toString() {
    return "$transportName";
  }
}
