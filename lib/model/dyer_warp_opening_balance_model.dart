class DyerWarpOpeningBalanceModel {
  int? id;
  int? dyerId;
  String? dyerName;
  String? recordNo;
  String? details;
  int? totalProductQty;
  dynamic? totalMeter;
  String? createdAt;
  List<ItemDetails>? itemDetails;

  DyerWarpOpeningBalanceModel(
      {this.id,
        this.dyerId,
        this.dyerName,
        this.recordNo,
        this.details,
        this.totalProductQty,
        this.totalMeter,
        this.createdAt,
        this.itemDetails});

  DyerWarpOpeningBalanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dyerId = json['dyer_id'];
    dyerName = json['dyer_name'];
    recordNo = json['record_no'];
    details = json['details'];
    totalProductQty = json['total_product_qty'];
    totalMeter = json['total_meter'];
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
    data['dyer_id'] = this.dyerId;
    data['dyer_name'] = this.dyerName;
    data['record_no'] = this.recordNo;
    data['details'] = this.details;
    data['total_product_qty'] = this.totalProductQty;
    data['total_meter'] = this.totalMeter;
    data['created_at'] = this.createdAt;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? dyarWarpOpeningStockId;
  int? warpDesignId;
  String? warpType;
  int? productQty;
  dynamic? meter;
  String? colourToDye;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? warpDesignName;

  ItemDetails(
      {this.id,
        this.dyarWarpOpeningStockId,
        this.warpDesignId,
        this.warpType,
        this.productQty,
        this.meter,
        this.colourToDye,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.warpDesignName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dyarWarpOpeningStockId = json['dyar_warp_opening_stock_id'];
    warpDesignId = json['warp_design_id'];
    warpType = json['warp_type'];
    productQty = json['product_qty'];
    meter = json['meter'];
    colourToDye = json['colour_to_dye'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    warpDesignName = json['warp_design_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dyar_warp_opening_stock_id'] = this.dyarWarpOpeningStockId;
    data['warp_design_id'] = this.warpDesignId;
    data['warp_type'] = this.warpType;
    data['product_qty'] = this.productQty;
    data['meter'] = this.meter;
    data['colour_to_dye'] = this.colourToDye;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['warp_design_name'] = this.warpDesignName;
    return data;
  }
}