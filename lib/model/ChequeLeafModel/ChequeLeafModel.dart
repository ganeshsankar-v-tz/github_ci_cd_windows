class ChequeLeafModel {
  int? id;
  String? name;
  String? isOpen;
  String? eDate;
  num? amount;
  int? createdBy;
  int? updatedBy;
  String? template;
  String? chequeNo;
  String? createdAt;
  String? createdName;
  String? updatedName;
  String? updatedAt;
  String? entryFrom;
  String? details;

  ChequeLeafModel({
    this.id,
    this.name,
    this.isOpen,
    this.eDate,
    this.amount,
    this.createdBy,
    this.updatedBy,
    this.template,
    this.chequeNo,
    this.createdAt,
    this.createdName,
    this.updatedName,
    this.updatedAt,
    this.entryFrom,
    this.details,
  });

  ChequeLeafModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isOpen = json['is_open'];
    eDate = json['e_date'];
    amount = json['amount'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    template = json['template'];
    chequeNo = json['cheque_no'];
    createdAt = json['created_at'];
    createdName = json['created_name'];
    updatedName = json['updated_name'];
    updatedAt = json['updated_at'];
    entryFrom = json['entry_from'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_open'] = isOpen;
    data['e_date'] = eDate;
    data['amount'] = amount;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['template'] = template;
    data['cheque_no'] = chequeNo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_name'] = createdName;
    data['updated_name'] = updatedName;
    data['entry_from'] = entryFrom;
    data['details'] = details;
    return data;
  }
}
