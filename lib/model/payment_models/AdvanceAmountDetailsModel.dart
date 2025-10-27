class AdvanceAmountDetailsModel {
  num? balance;
  String? perticulars;

  AdvanceAmountDetailsModel({this.balance, this.perticulars});

  AdvanceAmountDetailsModel.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    perticulars = json['perticulars'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    data['perticulars'] = perticulars;
    return data;
  }
}
