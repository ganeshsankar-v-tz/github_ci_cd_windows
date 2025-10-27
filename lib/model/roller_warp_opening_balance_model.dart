class RollerWarpOpeningBalanceModel {
  int? id;
  int? rollerId;
  String? rollerName;
  String? recordNo;
  String? details;
  String? createdAt;
  List<ItemDetails>? itemDetails;

  RollerWarpOpeningBalanceModel(
      {this.id,
        this.rollerId,
        this.rollerName,
        this.recordNo,
        this.details,
        this.createdAt,
        this.itemDetails});

  RollerWarpOpeningBalanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rollerId = json['roller_id'];
    rollerName = json['roller_name'];
    recordNo = json['record_no'];
    details = json['details'];
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
    data['roller_id'] = this.rollerId;
    data['roller_name'] = this.rollerName;
    data['record_no'] = this.recordNo;
    data['details'] = this.details;
    data['created_at'] = this.createdAt;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? rollerWarpOpeningStockId;
  int? warpDesignId;
  String? warpIdNo;
  int? productQty;
  int? meter;
  String? deliveredEmpty;
  int? emptyQty;
  int? sheet;
  String? warpColour;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? warpDesignName;

  ItemDetails(
      {this.id,
        this.rollerWarpOpeningStockId,
        this.warpDesignId,
        this.warpIdNo,
        this.productQty,
        this.meter,
        this.deliveredEmpty,
        this.emptyQty,
        this.sheet,
        this.warpColour,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.warpDesignName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rollerWarpOpeningStockId = json['roller_warp_opening_stock_id'];
    warpDesignId = json['warp_design_id'];
    warpIdNo = json['warp_id_no'];
    productQty = json['product_qty'];
    meter = json['meter'];
    deliveredEmpty = json['delivered_empty'];
    emptyQty = json['empty_qty'];
    sheet = json['sheet'];
    warpColour = json['warp_colour'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    warpDesignName = json['warp_design_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roller_warp_opening_stock_id'] = this.rollerWarpOpeningStockId;
    data['warp_design_id'] = this.warpDesignId;
    data['warp_id_no'] = this.warpIdNo;
    data['product_qty'] = this.productQty;
    data['meter'] = this.meter;
    data['delivered_empty'] = this.deliveredEmpty;
    data['empty_qty'] = this.emptyQty;
    data['sheet'] = this.sheet;
    data['warp_colour'] = this.warpColour;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['warp_design_name'] = this.warpDesignName;
    return data;
  }
}