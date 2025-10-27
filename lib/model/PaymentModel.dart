class PaymentModel {
  int? id;
  int? firmId;
  String? firmName;
  int? slipNo;
  String? eDate;
  String? refNo;
  String? details;
  int? ledgerId;
  String? ledgerName;
  num? debitAmount;
  String? against;
  String? city;
  List<ItemDetails>? itemDetails;

  PaymentModel(
      {this.id,
      this.firmId,
      this.firmName,
      this.slipNo,
      this.eDate,
      this.refNo,
      this.details,
      this.ledgerId,
      this.ledgerName,
      this.debitAmount,
      this.against,
      this.city,
      this.itemDetails});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    slipNo = json['slip_no'];
    eDate = json['e_date'];
    refNo = json['ref_no'];
    details = json['details'];
    ledgerId = json['ledger_id'];
    ledgerName = json['ledger_name'];
    debitAmount = json['debit_amount'];
    against = json['against'];
    city = json['city'];
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(new ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['slip_no'] = this.slipNo;
    data['e_date'] = this.eDate;
    data['ref_no'] = this.refNo;
    data['details'] = this.details;
    data['ledger_id'] = this.ledgerId;
    data['ledger_name'] = this.ledgerName;
    data['debit_amount'] = this.debitAmount;
    data['against'] = this.against;
    data['city'] = this.city;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? paymentId;
  int? firmId;
  int? slipNo;
  int? acNo;
  int? rowNo;
  int? toLedgerNo;
  int? creditAmount;
  int? toLedgerCno;
  String? chNo;
  String? chDt;
  String? isComChq;
  String? createdBy;
  String? updatedBy;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? firmName;
  String? ledgerName;

  ItemDetails(
      {this.id,
      this.paymentId,
      this.firmId,
      this.slipNo,
      this.acNo,
      this.rowNo,
      this.toLedgerNo,
      this.creditAmount,
      this.toLedgerCno,
      this.chNo,
      this.chDt,
      this.isComChq,
      this.createdBy,
      this.updatedBy,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.firmName,
      this.ledgerName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentId = json['payment_id'];
    firmId = json['firm_id'];
    slipNo = json['slip_no'];
    acNo = json['ac_no'];
    rowNo = json['row_no'];
    toLedgerNo = json['to_ledger_no'];
    creditAmount = json['credit_amount'];
    toLedgerCno = json['to_ledger_cno'];
    chNo = json['ch_no'];
    chDt = json['ch_dt'];
    isComChq = json['is_com_chq'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    firmName = json['firm_name'];
    ledgerName = json['ledger_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['payment_id'] = this.paymentId;
    data['firm_id'] = this.firmId;
    data['slip_no'] = this.slipNo;
    data['ac_no'] = this.acNo;
    data['row_no'] = this.rowNo;
    data['to_ledger_no'] = this.toLedgerNo;
    data['credit_amount'] = this.creditAmount;
    data['to_ledger_cno'] = this.toLedgerCno;
    data['ch_no'] = this.chNo;
    data['ch_dt'] = this.chDt;
    data['is_com_chq'] = this.isComChq;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['firm_name'] = this.firmName;
    data['ledger_name'] = this.ledgerName;
    return data;
  }
}
