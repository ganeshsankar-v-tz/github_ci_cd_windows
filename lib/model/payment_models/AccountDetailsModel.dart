class AccountDetailsModel {
  String? acHolder;
  String? accountNo;
  String? ifscNo;
  String? bankName;

  AccountDetailsModel({
    this.acHolder,
    this.accountNo,
    this.ifscNo,
    this.bankName,
  });

  AccountDetailsModel.fromJson(Map<String, dynamic> json) {
    acHolder = json['ac_holder'];
    accountNo = json['account_no'];
    ifscNo = json['ifsc_no'];
    bankName = json['bank_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ac_holder'] = acHolder;
    data['account_no'] = accountNo;
    data['ifsc_no'] = ifscNo;
    data['bank_name'] = bankName;
    return data;
  }

  @override
  String toString() {
    return "$accountNo".replaceAll(" ", "");
  }
}
