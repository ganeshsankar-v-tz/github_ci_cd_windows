class WarpOpeningStockModel {
  int? id;
  int? warpDesignId;
  String? warpDesignName;
  String? date;
  String? warpType;
  int? totalProductQty;
  dynamic totalMeter;
  List<ItemDetails>? itemDetails;

  WarpOpeningStockModel(
      {this.id,
        this.warpDesignId,
        this.warpDesignName,
        this.date,
        this.warpType,
        this.totalProductQty,
        this.totalMeter,
        this.itemDetails});

  WarpOpeningStockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warpDesignId = json['warp_design_id'];
    warpDesignName = json['warp_design_name'];
    date = json['date'];
    warpType = json['warp_type'];
    totalProductQty = json['total_product_qty'];
    totalMeter = json['total_meter'];
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
    data['warp_design_id'] = this.warpDesignId;
    data['warp_design_name'] = this.warpDesignName;
    data['date'] = this.date;
    data['warp_type'] = this.warpType;
    data['total_product_qty'] = this.totalProductQty;
    data['total_meter'] = this.totalMeter;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? warpOpeningStockId;
  String? warpIdNo;
  int? productQuantity;
  dynamic? meter;
  String? warpCondition;
  String? emptyType;
  int? emptyQuantity;
  int? sheet;
  String? warpColour;
  String? status;
  String? createdAt;
  String? updatedAt;

  ItemDetails(
      {this.id,
        this.warpOpeningStockId,
        this.warpIdNo,
        this.productQuantity,
        this.meter,
        this.warpCondition,
        this.emptyType,
        this.emptyQuantity,
        this.sheet,
        this.warpColour,
        this.status,
        this.createdAt,
        this.updatedAt});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warpOpeningStockId = json['warp_opening_stock_id'];
    warpIdNo = json['warp_id_no'];
    productQuantity = json['product_quantity'];
    meter = json['meter'];
    warpCondition = json['warp_condition'];
    emptyType = json['empty_type'];
    emptyQuantity = json['empty_quantity'];
    sheet = json['sheet'];
    warpColour = json['warp_colour'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warp_opening_stock_id'] = this.warpOpeningStockId;
    data['warp_id_no'] = this.warpIdNo;
    data['product_quantity'] = this.productQuantity;
    data['meter'] = this.meter;
    data['warp_condition'] = this.warpCondition;
    data['empty_type'] = this.emptyType;
    data['empty_quantity'] = this.emptyQuantity;
    data['sheet'] = this.sheet;
    data['warp_colour'] = this.warpColour;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}