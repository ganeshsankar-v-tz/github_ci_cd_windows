class WagesBillListModel {
  int? id;
  String? eDate;
  int? challanNo;
  int? weaverId;
  String? weaverName;
  num? amount;

  WagesBillListModel(
      {this.id,
      this.eDate,
      this.challanNo,
      this.weaverId,
      this.weaverName,
      this.amount});

  WagesBillListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eDate = json['e_date'];
    challanNo = json['challan_no'];
    weaverId = json['weaver_id'];
    weaverName = json['weaver_name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['e_date'] = eDate;
    data['challan_no'] = challanNo;
    data['weaver_id'] = weaverId;
    data['weaver_name'] = weaverName;
    data['amount'] = amount;
    return data;
  }
}
