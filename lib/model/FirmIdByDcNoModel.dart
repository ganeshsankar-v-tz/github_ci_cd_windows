class FirmIdByDcNoModel {
  int? firmId;
  int? dcNo;
  int? dcRecNo;
  int? customerId;
  String? ledgerName;

  FirmIdByDcNoModel({this.firmId, this.dcNo, this.customerId, this.ledgerName});

  FirmIdByDcNoModel.fromJson(Map<String, dynamic> json) {
    firmId = json['firm_id'];
    dcNo = json['dc_no'];
    dcRecNo = json['dc_rec_no'];
    customerId = json['customer_id'];
    ledgerName = json['ledger_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firm_id'] = firmId;
    data['dc_no'] = dcNo;
    data['dc_rec_no'] = dcRecNo;
    data['customer_id'] = customerId;
    data['ledger_name'] = ledgerName;
    return data;
  }

  @override
  String toString() {
    return "$dcNo";
  }
}
