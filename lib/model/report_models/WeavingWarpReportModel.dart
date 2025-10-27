class WeavingWarpReportModel {
  String? date;
  int? warpDesignId;
  String? warpName;
  int? productId;
  String? productName;
  String? weaverName;
  int? loom;
  int? productQuantity;
  int? inwardQty;
  int? remainingQty;

  WeavingWarpReportModel(
      {this.date,
      this.warpDesignId,
      this.warpName,
      this.productId,
      this.productName,
      this.weaverName,
      this.loom,
      this.productQuantity,
      this.inwardQty,
      this.remainingQty});

  WeavingWarpReportModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    warpDesignId = json['warp_design_id'];
    warpName = json['warp_name'];
    productId = json['product_id'];
    productName = json['product_name'];
    weaverName = json['weaver_name'];
    loom = json['loom'];
    productQuantity = json['product_quantity'];
    inwardQty = json['inward_qty'];
    remainingQty = json['remaining_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['warp_design_id'] = this.warpDesignId;
    data['warp_name'] = this.warpName;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['weaver_name'] = this.weaverName;
    data['loom'] = this.loom;
    data['product_quantity'] = this.productQuantity;
    data['inward_qty'] = this.inwardQty;
    data['remaining_qty'] = this.remainingQty;
    return data;
  }
}
