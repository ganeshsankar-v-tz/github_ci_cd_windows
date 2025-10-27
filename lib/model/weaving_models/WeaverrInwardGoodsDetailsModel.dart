class WeaverInwardGoodsDetailsModel {
  int? giSlipRecNo;
  String? eDate;
  int? challanNo;
  int? inwardQty;
  num? inwardMeter;
  int? credit;
  bool selected = false;

  WeaverInwardGoodsDetailsModel(
      {this.giSlipRecNo,
      this.eDate,
      this.challanNo,
      this.inwardQty,
      this.inwardMeter,
      this.credit});

  WeaverInwardGoodsDetailsModel.fromJson(Map<String, dynamic> json) {
    giSlipRecNo = json['gi_slip_rec_no'];
    eDate = json['e_date'];
    challanNo = json['challan_no'];
    inwardQty = json['inward_qty'];
    inwardMeter = json['inward_meter'];
    credit = json['credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gi_slip_rec_no'] = giSlipRecNo;
    data['challan_no'] = challanNo;
    data['inward_qty'] = inwardQty;
    data['inward_meter'] = inwardMeter;
    data['credit'] = credit;
    return data;
  }
}
