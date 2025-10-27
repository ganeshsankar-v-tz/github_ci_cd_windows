class LastPurchase {
  String? purchaseDate;
  num? quantity;
  num? netTotal;

  LastPurchase({
    this.purchaseDate,
    this.quantity,
    this.netTotal,
  });

  LastPurchase.fromJson(Map<String, dynamic> json) {
    purchaseDate = json['purchase_date'];
    quantity = json['quantity'];
    netTotal = json['net_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['purchase_date'] = purchaseDate;
    data['quantity'] = quantity;
    data['netTotal'] = netTotal;
    return data;
  }
}
