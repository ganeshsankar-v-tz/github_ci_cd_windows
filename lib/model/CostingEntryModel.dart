class CostingEntryModel {
  int? id;
  int? productId;
  String? productName;
  String? designNo;
  int? noofunits;
  String? date;
  int? groupId;
  String? groupName;
  dynamic sglUnitCost;
  int? recordNo;
  int? totalQty;
  dynamic totalAmount;
  int? profit;
  dynamic netTotal;
  List<ProductDetails>? productDetails;

  CostingEntryModel(
      {this.id,
      this.productId,
      this.productName,
      this.designNo,
      this.noofunits,
      this.date,
      this.groupId,
      this.groupName,
      this.sglUnitCost,
      this.recordNo,
      this.totalQty,
      this.totalAmount,
      this.profit,
      this.netTotal,
      this.productDetails});

  CostingEntryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    productName = json['product_name'];
    designNo = json['design_no'];
    noofunits = json['noofunits'];
    date = json['date'];
    groupId = json['group_id'];
    groupName = json['group_name'];
    sglUnitCost = json['sgl_unit_cost'];
    recordNo = json['record_no'];
    totalQty = json['total_qty'];
    totalAmount = json['total_amount'];
    profit = json['profit'];
    netTotal = json['net_total'];
    if (json['product_details'] != null) {
      productDetails = <ProductDetails>[];
      json['product_details'].forEach((v) {
        productDetails!.add(new ProductDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['design_no'] = this.designNo;
    data['noofunits'] = this.noofunits;
    data['date'] = this.date;
    data['group_id'] = this.groupId;
    data['group_name'] = this.groupName;
    data['sgl_unit_cost'] = this.sglUnitCost;
    data['record_no'] = this.recordNo;
    data['total_qty'] = this.totalQty;
    data['total_amount'] = this.totalAmount;
    data['profit'] = this.profit;
    data['net_total'] = this.netTotal;
    if (this.productDetails != null) {
      data['product_details'] =
          this.productDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductDetails {
  int? id;
  String? header;
  String? details;
  dynamic quantity;
  int? unitId;
  dynamic rate;
  dynamic amount;
  dynamic runningTotal;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? costingEntryId;
  String? unitName;

  ProductDetails(
      {this.id,
      this.header,
      this.details,
      this.quantity,
      this.unitId,
      this.rate,
      this.amount,
      this.runningTotal,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.costingEntryId,
      this.unitName});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    header = json['header'];
    details = json['details'];
    quantity = json['quantity'];
    unitId = json['unit_id'];
    rate = json['rate'];
    amount = json['amount'];
    runningTotal = json['running_total'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    costingEntryId = json['costing_entry_id'];
    unitName = json['unit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['header'] = this.header;
    data['details'] = this.details;
    data['quantity'] = this.quantity;
    data['unit_id'] = this.unitId;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['running_total'] = this.runningTotal;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['costing_entry_id'] = this.costingEntryId;
    data['unit_name'] = this.unitName;
    return data;
  }
}
