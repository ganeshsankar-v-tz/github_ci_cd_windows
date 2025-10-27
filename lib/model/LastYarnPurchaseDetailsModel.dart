class LastYarnPurchaseDetailsModel {
  List<LastYarnPurchase>? lastYarnPurchase;
  List<LastRate>? lastRate;

  LastYarnPurchaseDetailsModel({this.lastYarnPurchase, this.lastRate});

  LastYarnPurchaseDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['last_yarn_purchase'] != null) {
      lastYarnPurchase = <LastYarnPurchase>[];
      json['last_yarn_purchase'].forEach((v) {
        lastYarnPurchase!.add(LastYarnPurchase.fromJson(v));
      });
    }
    if (json['last_rate'] != null) {
      lastRate = <LastRate>[];
      json['last_rate'].forEach((v) {
        lastRate!.add(LastRate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lastYarnPurchase != null) {
      data['last_yarn_purchase'] =
          lastYarnPurchase!.map((v) => v.toJson()).toList();
    }
    if (lastRate != null) {
      data['last_rate'] = lastRate!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LastYarnPurchase {
  String? invoiceNo;
  String? purchaseDate;
  num? rate;

  LastYarnPurchase({this.invoiceNo, this.purchaseDate, this.rate});

  LastYarnPurchase.fromJson(Map<String, dynamic> json) {
    invoiceNo = json['invoice_no'];
    purchaseDate = json['purchase_date'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoice_no'] = invoiceNo;
    data['purchase_date'] = purchaseDate;
    data['rate'] = rate;
    return data;
  }
}

class LastRate {
  int? supplierId;
  String? invoiceNo;
  String? purchaseDate;
  int? yarnId;
  int? colorId;
  num? rate;

  LastRate(
      {this.supplierId,
      this.invoiceNo,
      this.purchaseDate,
      this.yarnId,
      this.colorId,
      this.rate});

  LastRate.fromJson(Map<String, dynamic> json) {
    supplierId = json['supplier_id'];
    invoiceNo = json['invoice_no'];
    purchaseDate = json['purchase_date'];
    yarnId = json['yarn_id'];
    colorId = json['color_id'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supplier_id'] = supplierId;
    data['invoice_no'] = invoiceNo;
    data['purchase_date'] = purchaseDate;
    data['yarn_id'] = yarnId;
    data['color_id'] = colorId;
    data['rate'] = rate;
    return data;
  }
}
