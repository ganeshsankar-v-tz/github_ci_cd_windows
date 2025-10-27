class ProductJobWork {
  int? id;
  String? workName;
  String? details;
  String? unitName;
  int? labourWages;
  String? workTyp;
  String? abvr;
  String? isActive;
  String? llName;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;
  int? status;
  String? creatorName;

  ProductJobWork(
      {this.id,
      this.workName,
      this.details,
      this.unitName,
      this.labourWages,
      this.workTyp,
      this.abvr,
      this.isActive,
      this.llName,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.status,
      this.creatorName});

  ProductJobWork.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workName = json['work_name'];
    details = json['details'];
    unitName = json['unit_name'];
    labourWages = json['labour_wages'];
    workTyp = json['work_typ'];
    abvr = json['abvr'];
    isActive = json['is_active'];
    llName = json['ll_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    status = json['status'];
    creatorName = json['creator_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['work_name'] = this.workName;
    data['details'] = this.details;
    data['unit_name'] = this.unitName;
    data['labour_wages'] = this.labourWages;
    data['work_typ'] = this.workTyp;
    data['abvr'] = this.abvr;
    data['is_active'] = this.isActive;
    data['ll_name'] = this.llName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['status'] = this.status;
    data['creator_name'] = this.creatorName;
    return data;
  }

  @override
  String toString() {
    return "$workName";
  }
}
