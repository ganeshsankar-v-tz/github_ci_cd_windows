class LedgerAccountDetailsModel {
  int? id;
  int? ledgerId;
  String? ledgerName;
  String? bankName;
  String? accontNo;
  String? branch;
  String? ifscNo;
  String? panNo;
  String? panName;
  String? aatharNo;
  int? tdsPerc;
  String? acHolder;
  String? loomNo;

  LedgerAccountDetailsModel({
    this.id,
    this.ledgerId,
    this.ledgerName,
    this.bankName,
    this.accontNo,
    this.branch,
    this.ifscNo,
    this.panNo,
    this.panName,
    this.aatharNo,
    this.tdsPerc,
    this.acHolder,
    this.loomNo,
  });

  LedgerAccountDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ledgerId = json['ledger_id'];
    ledgerName = json['ledger_name'];
    bankName = json['bank_name'];
    accontNo = json['accont_no'];
    branch = json['branch'];
    ifscNo = json['ifsc_no'];
    panNo = json['pan_no'];
    panName = json['pan_name'];
    aatharNo = json['aathar_no'];
    tdsPerc = json['tds_perc'];
    acHolder = json['ac_holder'];
    loomNo = json['loom_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ledger_id'] = ledgerId;
    data['ledger_name'] = ledgerName;
    data['bank_name'] = bankName;
    data['accont_no'] = accontNo;
    data['branch'] = branch;
    data['ifsc_no'] = ifscNo;
    data['pan_no'] = panNo;
    data['pan_name'] = panName;
    data['aathar_no'] = aatharNo;
    data['tds_perc'] = tdsPerc;
    data['ac_holder'] = acHolder;
    data['loom_no'] = loomNo;
    return data;
  }
}
