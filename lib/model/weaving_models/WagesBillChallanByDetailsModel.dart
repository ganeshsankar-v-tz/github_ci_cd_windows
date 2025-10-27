class WagesBillChallanByDetailsModel {
  int? weaverId;
  String? eDate;
  int? challanNo;
  List<WagesBillDetails>? wagesBillDetails;
  List<GoodInwardDetails>? goodInwardDetails;

  WagesBillChallanByDetailsModel(
      {this.weaverId,
      this.eDate,
      this.challanNo,
      this.wagesBillDetails,
      this.goodInwardDetails});

  WagesBillChallanByDetailsModel.fromJson(Map<String, dynamic> json) {
    weaverId = json['weaver_id'];
    eDate = json['e_date'];
    challanNo = json['challan_no'];
    if (json['wages_bill_details'] != null) {
      wagesBillDetails = <WagesBillDetails>[];
      json['wages_bill_details'].forEach((v) {
        wagesBillDetails!.add(WagesBillDetails.fromJson(v));
      });
    }
    if (json['good_inward_details'] != null) {
      goodInwardDetails = <GoodInwardDetails>[];
      json['good_inward_details'].forEach((v) {
        goodInwardDetails!.add(GoodInwardDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weaver_id'] = weaverId;
    data['e_date'] = eDate;
    data['challan_no'] = challanNo;
    if (wagesBillDetails != null) {
      data['wages_bill_details'] =
          wagesBillDetails!.map((v) => v.toJson()).toList();
    }
    if (goodInwardDetails != null) {
      data['good_inward_details'] =
          goodInwardDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WagesBillDetails {
  int? id;
  int? weavingAcId;
  String? loom;
  String? currentStatus;
  String? entryType;
  String? eDate;
  int? productId;
  String? productName;
  int? prLedgerId;
  num? debit;
  String? paymentType;
  String? prLedgerName;

  WagesBillDetails(
      {this.id,
      this.weavingAcId,
      this.loom,
      this.currentStatus,
      this.entryType,
      this.eDate,
      this.productId,
      this.productName,
      this.prLedgerId,
      this.debit,
      this.paymentType,
      this.prLedgerName});

  WagesBillDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weavingAcId = json['weaving_ac_id'];
    loom = json['loom'];
    currentStatus = json['current_status'];
    entryType = json['entry_type'];
    eDate = json['e_date'];
    productId = json['product_id'];
    productName = json['product_name'];
    prLedgerId = json['pr_ledger_id'];
    debit = json['debit'];
    paymentType = json['payment_type'];
    prLedgerName = json['pr_ledger_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['weaving_ac_id'] = weavingAcId;
    data['loom'] = loom;
    data['current_status'] = currentStatus;
    data['entry_type'] = entryType;
    data['e_date'] = eDate;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['pr_ledger_id'] = prLedgerId;
    data['debit'] = debit;
    data['payment_type'] = paymentType;
    data['pr_ledger_name'] = prLedgerName;
    return data;
  }
}

class GoodInwardDetails {
  int? id;
  int? weavingAcId;
  String? loom;
  String? currentStatus;
  String? entryType;
  String? eDate;
  int? challanNo;
  int? inwardQty;
  num? inwardMeter;
  num? credit;

  GoodInwardDetails(
      {this.id,
      this.weavingAcId,
      this.loom,
      this.currentStatus,
      this.entryType,
      this.eDate,
      this.challanNo,
      this.inwardQty,
      this.inwardMeter,
      this.credit});

  GoodInwardDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weavingAcId = json['weaving_ac_id'];
    loom = json['loom'];
    currentStatus = json['current_status'];
    entryType = json['entry_type'];
    eDate = json['e_date'];
    challanNo = json['challan_no'];
    inwardQty = json['inward_qty'];
    inwardMeter = json['inward_meter'];
    credit = json['credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['weaving_ac_id'] = weavingAcId;
    data['loom'] = loom;
    data['current_status'] = currentStatus;
    data['entry_type'] = entryType;
    data['e_date'] = eDate;
    data['challan_no'] = challanNo;
    data['inward_qty'] = inwardQty;
    data['inward_meter'] = inwardMeter;
    data['credit'] = credit;
    return data;
  }
}
