class TaxFixingModel {
  int? id;
  String? taxTitle;
  String? entryType;
  String? state;
  String? isActive;
  String? al1Typ;
  int? al1Ano;
  num? al1Perc;
  String? cf1;
  String? al2Typ;
  int? al2Ano;
  num? al2Perc;
  String? cf2;
  String? al3Typ;
  int? al3Ano;
  num? al3Perc;
  String? cf3;
  String? al4Typ;
  int? al4Ano;
  num? al4Perc;
  String? cf4;
  String? taxStyle;
  String? entryBy;
  String? createdAt;
  String? updatedAt;
  String? al1AnoName;
  String? al2AnoName;
  String? al3AnoName;
  String? al4AnoName;

  TaxFixingModel(
      {this.id,
      this.taxTitle,
      this.entryType,
      this.state,
      this.isActive,
      this.al1Typ,
      this.al1Ano,
      this.al1Perc,
      this.cf1,
      this.al2Typ,
      this.al2Ano,
      this.al2Perc,
      this.cf2,
      this.al3Typ,
      this.al3Ano,
      this.al3Perc,
      this.cf3,
      this.al4Typ,
      this.al4Ano,
      this.al4Perc,
      this.cf4,
      this.taxStyle,
      this.entryBy,
      this.al1AnoName,
      this.al2AnoName,
      this.al3AnoName,
      this.al4AnoName,
      this.createdAt,
      this.updatedAt});

  TaxFixingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taxTitle = json['tax_title'];
    entryType = json['entry_type'];
    state = json['state'];
    isActive = json['is_active'];
    al1Typ = json['al1_typ'];
    al1Ano = json['al1_ano'];
    al1Perc = json['al1_perc'];
    cf1 = json['cf1'];
    al2Typ = json['al2_typ'];
    al2Ano = json['al2_ano'];
    al2Perc = json['al2_perc'];
    cf2 = json['cf2'];
    al3Typ = json['al3_typ'];
    al3Ano = json['al3_ano'];
    al3Perc = json['al3_perc'];
    cf3 = json['cf3'];
    al4Typ = json['al4_typ'];
    al4Ano = json['al4_ano'];
    al4Perc = json['al4_perc'];
    cf4 = json['cf4'];
    taxStyle = json['tax_style'];
    al1AnoName = json['al1_ano_name'];
    al2AnoName = json['al2_ano_name'];
    al3AnoName = json['al3_ano_name'];
    al4AnoName = json['al4_ano_name'];
    entryBy = json['entry_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tax_title'] = this.taxTitle;
    data['entry_type'] = this.entryType;
    data['state'] = this.state;
    data['is_active'] = this.isActive;
    data['al1_typ'] = this.al1Typ;
    data['al1_ano'] = this.al1Ano;
    data['al1_perc'] = this.al1Perc;
    data['cf1'] = this.cf1;
    data['al2_typ'] = this.al2Typ;
    data['al2_ano'] = this.al2Ano;
    data['al2_perc'] = this.al2Perc;
    data['cf2'] = this.cf2;
    data['al3_typ'] = this.al3Typ;
    data['al3_ano'] = this.al3Ano;
    data['al3_perc'] = this.al3Perc;
    data['cf3'] = this.cf3;
    data['al4_typ'] = this.al4Typ;
    data['al4_ano'] = this.al4Ano;
    data['al4_perc'] = this.al4Perc;
    data['cf4'] = this.cf4;
    data['al1_ano_name'] = this.al1AnoName;
    data['al2_ano_name'] = this.al2AnoName;
    data['al3_ano_name'] = this.al3AnoName;
    data['al4_ano_name'] = this.al4AnoName;
    data['tax_style'] = this.taxStyle;
    data['entry_by'] = this.entryBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  @override
  String toString() {
    return '$taxTitle';
  }
}
