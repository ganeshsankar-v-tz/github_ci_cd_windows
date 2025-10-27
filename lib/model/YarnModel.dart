class YarnModel {
  int? id;
  String? name;
  int? unitId;
  String? details;
  String? llName;
  String? holder;
  dynamic netWeight;
  String? isActive;
  int? holderUnit;
  dynamic dftLength;
  dynamic sycons;
  String? hsnCode;
  String? yarnTyp;
  String? codetyp;
  String? ynTaxTyp;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  String? updatedBy;
  String? unitName;
  String? creatorName;

  YarnModel(
      {this.id,
      this.name,
      this.unitId,
      this.details,
      this.llName,
      this.holder,
      this.netWeight,
      this.isActive,
      this.holderUnit,
      this.dftLength,
      this.sycons,
      this.hsnCode,
      this.yarnTyp,
      this.codetyp,
      this.ynTaxTyp,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.unitName,
      this.creatorName});

  YarnModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unitId = json['unit_id'];
    details = json['details'];
    llName = json['ll_name'];
    holder = json['holder'];
    netWeight = json['net_weight'];
    isActive = json['is_active'];
    holderUnit = json['holder_unit'];
    dftLength = json['dft_length'];
    sycons = json['sycons'];
    hsnCode = json['hsn_code'];
    yarnTyp = json['yarn_typ'];
    codetyp = json['codetyp'];
    ynTaxTyp = json['yn_tax_typ'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    unitName = json['unit_name'];
    creatorName = json['creator_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['unit_id'] = this.unitId;
    data['details'] = this.details;
    data['ll_name'] = this.llName;
    data['holder'] = this.holder;
    data['net_weight'] = this.netWeight;
    data['is_active'] = this.isActive;
    data['holder_unit'] = this.holderUnit;
    data['dft_length'] = this.dftLength;
    data['sycons'] = this.sycons;
    data['hsn_code'] = this.hsnCode;
    data['yarn_typ'] = this.yarnTyp;
    data['codetyp'] = this.codetyp;
    data['yn_tax_typ'] = this.ynTaxTyp;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['unit_name'] = this.unitName;
    data['creator_name'] = this.creatorName;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$name";
  }
}
