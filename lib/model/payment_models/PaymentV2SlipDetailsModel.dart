class PaymentV2SlipDetailsModel {
  int? id;
  String? eDate;
  num? creditAmount;
  num? qty;

  PaymentV2SlipDetailsModel({this.id, this.eDate, this.creditAmount, this.qty});

  PaymentV2SlipDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eDate = json['e_date'];
    creditAmount = json['credit_amount'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['e_date'] = eDate;
    data['credit_amount'] = creditAmount;
    data['qty'] = qty;
    return data;
  }
}
