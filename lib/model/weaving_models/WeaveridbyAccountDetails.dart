class WeaverIdByAccountDetails {
  String? acHolder;
  String? accountNo;
  String? ifscNo;
  String? bankName;
  String? branch;
  int? tdsPerc;
  String? acType;
  String? panNo;
  String? aatharNo;

  WeaverIdByAccountDetails(
      {this.acHolder,
        this.accountNo,
        this.ifscNo,
        this.bankName,
        this.branch,
        this.tdsPerc,
        this.acType,
        this.panNo,
        this.aatharNo});

  WeaverIdByAccountDetails.fromJson(Map<String, dynamic> json) {
    acHolder = json['ac_holder'];
    accountNo = json['account_no'];
    ifscNo = json['ifsc_no'];
    bankName = json['bank_name'];
    branch = json['branch'];
    tdsPerc = json['tds_perc'];
    acType = json['ac_type'];
    panNo = json['pan_no'];
    aatharNo = json['aathar_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ac_holder'] = this.acHolder;
    data['account_no'] = this.accountNo;
    data['ifsc_no'] = this.ifscNo;
    data['bank_name'] = this.bankName;
    data['branch'] = this.branch;
    data['tds_perc'] = this.tdsPerc;
    data['ac_type'] = this.acType;
    data['pan_no'] = this.panNo;
    data['aathar_no'] = this.aatharNo;
    return data;
  }
}
