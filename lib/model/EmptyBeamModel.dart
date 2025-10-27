class EmptyBeamModel {
  int? id;
  int? ledgerId;
  String? recordNo;
  int? bobbin;
  int? beam;
  int? sheet;
  String? details;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? ledgerName;

  EmptyBeamModel(
      {this.id,
        this.ledgerId,
        this.recordNo,
        this.bobbin,
        this.beam,
        this.sheet,
        this.details,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.ledgerName});

  EmptyBeamModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ledgerId = json['ledger_id'];
    recordNo = json['record_no'];
    bobbin = json['bobbin'];
    beam = json['beam'];
    sheet = json['sheet'];
    details = json['details'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    ledgerName = json['ledger_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ledger_id'] = this.ledgerId;
    data['record_no'] = this.recordNo;
    data['bobbin'] = this.bobbin;
    data['beam'] = this.beam;
    data['sheet'] = this.sheet;
    data['details'] = this.details;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['ledger_name'] = this.ledgerName;
    return data;
  }
}