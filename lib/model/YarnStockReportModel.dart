class YarnStockReportModel {
  int? yarnId;
  String? yarnName;
  dynamic purchaseDetails;
  dynamic salesDetails;
  dynamic progroessDetails;
  dynamic inwardTotal;
  dynamic deliveryTotal;
  dynamic stockTotal;

  YarnStockReportModel(
      {this.yarnId,
      this.yarnName,
      this.purchaseDetails,
      this.salesDetails,
      this.progroessDetails,
      this.inwardTotal,
      this.deliveryTotal,
      this.stockTotal});

  YarnStockReportModel.fromJson(Map<String, dynamic> json) {
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    purchaseDetails = json['purchase_details'];
    salesDetails = json['sales_details'];
    progroessDetails = json['progroess_details'];
    inwardTotal = json['inward_total'];
    deliveryTotal = json['delivery_total'];
    stockTotal = json['stock_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['yarn_id'] = this.yarnId;
    data['yarn_name'] = this.yarnName;
    data['purchase_details'] = this.purchaseDetails;
    data['sales_details'] = this.salesDetails;
    data['progroess_details'] = this.progroessDetails;
    data['inward_total'] = this.inwardTotal;
    data['delivery_total'] = this.deliveryTotal;
    data['stock_total'] = this.stockTotal;
    return data;
  }
}
