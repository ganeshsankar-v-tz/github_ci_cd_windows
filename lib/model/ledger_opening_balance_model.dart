class LedgerOpeningBalanceModel {
  int? id;
  int? firmId;
  String? firmName;
  int? roleId;
  String? ledgerRoleName;
  int? ledgerId;
  String? ledgerName;
  String? accountType;
  String? accountTypeName;
  String? place;
  String? date;
  int? totalAmount;
  String? createdAt;
  String? updatedAt;
  List<LedgerOpenDetails>? ledgerOpenDetails;

  LedgerOpeningBalanceModel(
      {this.id,
        this.firmId,
        this.firmName,
        this.roleId,
        this.ledgerRoleName,
        this.ledgerId,
        this.ledgerName,
        this.accountType,
        this.accountTypeName,
        this.place,
        this.date,
        this.totalAmount,
        this.createdAt,
        this.updatedAt,
        this.ledgerOpenDetails});

  LedgerOpeningBalanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    roleId = json['role_id'];
    ledgerRoleName = json['ledger_role_name'];
    ledgerId = json['ledger_id'];
    ledgerName = json['ledger_name'];
    accountType = json['account_type'];
    accountTypeName = json['account_type_name'];
    place = json['place'];
    date = json['date'];
    totalAmount = json['total_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['ledger_open_details'] != null) {
      ledgerOpenDetails = <LedgerOpenDetails>[];
      json['ledger_open_details'].forEach((v) {
        ledgerOpenDetails!.add(new LedgerOpenDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['role_id'] = this.roleId;
    data['ledger_role_name'] = this.ledgerRoleName;
    data['ledger_id'] = this.ledgerId;
    data['ledger_name'] = this.ledgerName;
    data['account_type'] = this.accountType;
    data['account_type_name'] = this.accountTypeName;
    data['place'] = this.place;
    data['date'] = this.date;
    data['total_amount'] = this.totalAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.ledgerOpenDetails != null) {
      data['ledger_open_details'] =
          this.ledgerOpenDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LedgerOpenDetails {
  int? id;
  int? ledgerOpeningBalanceId;
  dynamic amount;
  String? amountType;
  String? type;
  String? details;
  int? status;
  String? createdAt;
  String? updatedAt;

  LedgerOpenDetails(
      {this.id,
        this.ledgerOpeningBalanceId,
        this.amount,
        this.amountType,
        this.type,
        this.details,
        this.status,
        this.createdAt,
        this.updatedAt});

  LedgerOpenDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ledgerOpeningBalanceId = json['ledger_opening_balance_id'];
    amount = json['amount'];
    amountType = json['amount_type'];
    type = json['type'];
    details = json['details'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ledger_opening_balance_id'] = this.ledgerOpeningBalanceId;
    data['amount'] = this.amount;
    data['amount_type'] = this.amountType;
    data['type'] = this.type;
    data['details'] = this.details;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}