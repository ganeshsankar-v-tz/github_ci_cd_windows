class TransportCopyModel {
  int? id;
  int? firmId;
  String? firmName;
  String? date;
  int? roleId;
  String? ledgerRoleName;
  String? to;
  String? toLedgerName;
  String? place;
  String? invoiceNo;
  String? productSaleBill;
  int? noOfQuantity;
  String? invoiceDate;
  int? bundle;
  dynamic totalAmount;
  String? throughLorry;
  String? freight;
  String? from;
  String? exportTo;
  String? toPlace;

  TransportCopyModel(
      {this.id,
      this.firmId,
      this.firmName,
      this.date,
      this.roleId,
      this.ledgerRoleName,
      this.to,
      this.toLedgerName,
      this.place,
      this.invoiceNo,
      this.productSaleBill,
      this.noOfQuantity,
      this.invoiceDate,
      this.bundle,
      this.totalAmount,
      this.throughLorry,
      this.freight,
      this.from,
      this.exportTo,
      this.toPlace});

  TransportCopyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    date = json['date'];
    roleId = json['role_id'];
    ledgerRoleName = json['ledger_role_name'];
    to = json['to'];
    toLedgerName = json['to_ledger_name'];
    place = json['place'];
    invoiceNo = json['invoice_no'];
    productSaleBill = json['product_sale_bill'];
    noOfQuantity = json['no_of_quantity'];
    invoiceDate = json['invoice_date'];
    bundle = json['bundle'];
    totalAmount = json['total_amount'];
    throughLorry = json['through_lorry'];
    freight = json['freight'];
    from = json['from'];
    exportTo = json['export_to'];
    toPlace = json['to_place'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['date'] = this.date;
    data['role_id'] = this.roleId;
    data['ledger_role_name'] = this.ledgerRoleName;
    data['to'] = this.to;
    data['to_ledger_name'] = this.toLedgerName;
    data['place'] = this.place;
    data['invoice_no'] = this.invoiceNo;
    data['product_sale_bill'] = this.productSaleBill;
    data['no_of_quantity'] = this.noOfQuantity;
    data['invoice_date'] = this.invoiceDate;
    data['bundle'] = this.bundle;
    data['total_amount'] = this.totalAmount;
    data['through_lorry'] = this.throughLorry;
    data['freight'] = this.freight;
    data['from'] = this.from;
    data['export_to'] = this.exportTo;
    data['to_place'] = this.toPlace;
    return data;
  }
}
