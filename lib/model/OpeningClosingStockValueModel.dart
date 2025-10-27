class OpeningClosingStockValueModel {
  int? id;
  String? acSession;
  int? firmId;
  String? firmName;
  String? openingDate;
  String? closingDate;
  dynamic? debit;
  dynamic? credit;
  dynamic? difference;
  dynamic? totalOpeningStock;
  dynamic? totalClosingStock;
  String? createdAt;
  List<ItemDetails>? itemDetails;

  OpeningClosingStockValueModel(
      {this.id,
      this.acSession,
      this.firmId,
      this.firmName,
      this.openingDate,
      this.closingDate,
      this.debit,
      this.credit,
      this.difference,
      this.totalOpeningStock,
      this.totalClosingStock,
      this.createdAt,
      this.itemDetails});

  OpeningClosingStockValueModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    acSession = json['ac_session'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    openingDate = json['opening_date'];
    closingDate = json['closing_date'];
    debit = json['debit'];
    credit = json['credit'];
    difference = json['difference'];
    totalOpeningStock = json['total_opening_stock'];
    totalClosingStock = json['total_closing_stock'];
    createdAt = json['created_at'];
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
    data['ac_session'] = this.acSession;
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['opening_date'] = this.openingDate;
    data['closing_date'] = this.closingDate;
    data['debit'] = this.debit;
    data['credit'] = this.credit;
    data['difference'] = this.difference;
    data['total_opening_stock'] = this.totalOpeningStock;
    data['total_closing_stock'] = this.totalClosingStock;
    data['created_at'] = this.createdAt;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? openingClosingStockId;
  String? ledgerAc;
  dynamic? openingStock;
  dynamic? closingStock;
  int? status;
  String? createdAt;
  String? updatedAt;

  ItemDetails(
      {this.id,
      this.openingClosingStockId,
      this.ledgerAc,
      this.openingStock,
      this.closingStock,
      this.status,
      this.createdAt,
      this.updatedAt});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    openingClosingStockId = json['opening_closing_stock_id'];
    ledgerAc = json['ledger_ac'];
    openingStock = json['opening_stock'];
    closingStock = json['closing_stock'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['opening_closing_stock_id'] = this.openingClosingStockId;
    data['ledger_ac'] = this.ledgerAc;
    data['opening_stock'] = this.openingStock;
    data['closing_stock'] = this.closingStock;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
