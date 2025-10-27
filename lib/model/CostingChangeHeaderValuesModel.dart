class CostingChangeHeaderValuesModel {
  int? productId;
  String? productName;
  int? noOfUnits;
  String? costingDate;
  String? designNo;
  dynamic quantity;
  dynamic rateWages;
  dynamic sglUnitCost;
  dynamic amount;
  dynamic netTotal;
  dynamic newRate;
  dynamic diffrent;

  CostingChangeHeaderValuesModel(
      {this.productId,
      this.productName,
      this.noOfUnits,
      this.costingDate,
      this.designNo,
      this.quantity,
      this.rateWages,
      this.sglUnitCost,
      this.amount,
      this.netTotal,
      this.newRate,
      this.diffrent});

  CostingChangeHeaderValuesModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    noOfUnits = json['no_of_units'];
    costingDate = json['costing_date'];
    designNo = json['design_no'];
    quantity = json['quantity'];
    rateWages = json['rate_wages'];
    sglUnitCost = json['sgl_unit_cost'];
    amount = json['amount'];
    netTotal = json['net_total'];
    newRate = json['new_rate'];
    diffrent = json['diffrent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['no_of_units'] = this.noOfUnits;
    data['costing_date'] = this.costingDate;
    data['design_no'] = this.designNo;
    data['quantity'] = this.quantity;
    data['rate_wages'] = this.rateWages;
    data['sgl_unit_cost'] = this.sglUnitCost;
    data['amount'] = this.amount;
    data['net_total'] = this.netTotal;
    data['new_rate'] = this.newRate;
    data['diffrent'] = this.diffrent;
    return data;
  }
}
