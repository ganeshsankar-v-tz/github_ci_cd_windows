class EmptyOpeningStockModel {
  int? id;
  int? beam;
  int? babbin;
  int? sheet;
  int? status;
  String? createdAt;
  String? updatedAt;

  EmptyOpeningStockModel(
      {this.id,
      this.beam,
      this.babbin,
      this.sheet,
      this.status,
      this.createdAt,
      this.updatedAt});

  EmptyOpeningStockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    beam = json['beam'];
    babbin = json['babbin'];
    sheet = json['sheet'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['beam'] = this.beam;
    data['babbin'] = this.babbin;
    data['sheet'] = this.sheet;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
