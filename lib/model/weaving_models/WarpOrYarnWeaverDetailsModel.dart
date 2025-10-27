class WarpOrYarnWeaverDetailsModel {
  int? weaverId;
  String? eDate;
  int? challanNo;
  List<ItemDetails>? itemDetails;

  WarpOrYarnWeaverDetailsModel(
      {this.weaverId, this.eDate, this.challanNo, this.itemDetails});

  WarpOrYarnWeaverDetailsModel.fromJson(Map<String, dynamic> json) {
    weaverId = json['weaver_id'];
    eDate = json['e_date'];
    challanNo = json['challan_no'];
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weaver_id'] = weaverId;
    data['e_date'] = eDate;
    data['challan_no'] = challanNo;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? weavingAcId;
  String? loom;
  String? currentStatus;
  String? entryType;
  int? productId;
  String? productName;
  int? yarnId;
  String? yarnName;
  int? yarnColorId;
  String? yarnColorName;
  String? stockIn;
  String? boxSerialNo;
  int? yarnPack;
  num? yarnGrossQty;
  num? yarnSingleEmptyWt;
  int? copsOut;
  int? reelOut;
  String? yarnEmptyType;
  num? yarnLessWt;
  String? productDetails;
  num? yarnQty;
  int? warpDesignId;
  String? warpDesignName;
  String? warpType;
  String? warpId;
  num? warpQty;
  num? meter;
  int? bmOut;
  int? bbnOut;
  int? shtOut;
  int? bmIn;
  int? bbnIn;
  int? shtIn;
  String? eDate;
  String? emptyWarpDesingName;

  ItemDetails({
    this.id,
    this.weavingAcId,
    this.loom,
    this.currentStatus,
    this.entryType,
    this.productId,
    this.productName,
    this.yarnId,
    this.yarnName,
    this.yarnColorId,
    this.yarnColorName,
    this.stockIn,
    this.boxSerialNo,
    this.yarnPack,
    this.yarnGrossQty,
    this.yarnSingleEmptyWt,
    this.copsOut,
    this.reelOut,
    this.yarnEmptyType,
    this.yarnLessWt,
    this.productDetails,
    this.yarnQty,
    this.warpDesignId,
    this.warpDesignName,
    this.warpType,
    this.warpId,
    this.warpQty,
    this.meter,
    this.bmOut,
    this.bbnOut,
    this.shtOut,
    this.bmIn,
    this.bbnIn,
    this.shtIn,
    this.eDate,
    this.emptyWarpDesingName,
  });

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weavingAcId = json['weaving_ac_id'];
    loom = json['loom'];
    currentStatus = json['current_status'];
    entryType = json['entry_type'];
    productId = json['product_id'];
    productName = json['product_name'];
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    yarnColorId = json['yarn_color_id'];
    yarnColorName = json['yarn_color_name'];
    stockIn = json['stock_in'];
    boxSerialNo = json['box_serial_no'];
    yarnPack = json['yarn_pack'];
    yarnGrossQty = json['yarn_gross_qty'];
    yarnSingleEmptyWt = json['yarn_single_empty_wt'];
    copsOut = json['cops_out'];
    reelOut = json['reel_out'];
    yarnEmptyType = json['yarn_empty_type'];
    yarnLessWt = json['yarn_less_wt'];
    productDetails = json['product_details'];
    yarnQty = json['yarn_qty'];
    warpDesignId = json['warp_design_id'];
    warpDesignName = json['warp_design_name'];
    warpType = json['warp_type'];
    warpId = json['warp_id'];
    warpQty = json['warp_qty'];
    meter = json['meter'];
    bmOut = json['bm_out'];
    bbnOut = json['bbn_out'];
    shtOut = json['sht_out'];
    bmIn = json['bm_in'];
    bbnIn = json['bbn_in'];
    shtIn = json['sht_in'];
    eDate = json['e_date'];
    emptyWarpDesingName = json['empty_warp_desing_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['weaving_ac_id'] = weavingAcId;
    data['loom'] = loom;
    data['current_status'] = currentStatus;
    data['entry_type'] = entryType;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['yarn_id'] = yarnId;
    data['yarn_name'] = yarnName;
    data['yarn_color_id'] = yarnColorId;
    data['yarn_color_name'] = yarnColorName;
    data['stock_in'] = stockIn;
    data['box_serial_no'] = boxSerialNo;
    data['yarn_pack'] = yarnPack;
    data['yarn_gross_qty'] = yarnGrossQty;
    data['yarn_single_empty_wt'] = yarnSingleEmptyWt;
    data['cops_out'] = copsOut;
    data['reel_out'] = reelOut;
    data['yarn_empty_type'] = yarnEmptyType;
    data['yarn_less_wt'] = yarnLessWt;
    data['product_details'] = productDetails;
    data['yarn_qty'] = yarnQty;
    data['warp_design_id'] = warpDesignId;
    data['warp_design_name'] = warpDesignName;
    data['warp_type'] = warpType;
    data['warp_id'] = warpId;
    data['warp_qty'] = warpQty;
    data['meter'] = meter;
    data['bm_out'] = bmOut;
    data['bbn_out'] = bbnOut;
    data['sht_out'] = shtOut;
    data['bm_in'] = bmIn;
    data['bbn_in'] = bbnIn;
    data['sht_in'] = shtIn;
    data['e_date'] = eDate;
    data['empty_warp_desing_name'] = emptyWarpDesingName;
    return data;
  }
}
