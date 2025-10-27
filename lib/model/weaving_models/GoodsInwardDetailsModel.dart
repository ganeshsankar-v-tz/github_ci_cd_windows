class GoodsInwardDetailsModel {
  int? weaverId;
  String? eDate;
  int? challanNo;
  List<ItemDetails>? itemDetails;

  GoodsInwardDetailsModel(
      {this.weaverId, this.eDate, this.challanNo, this.itemDetails});

  GoodsInwardDetailsModel.fromJson(Map<String, dynamic> json) {
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
  int? warpDesignId;
  String? warpDesignName;
  String? warpType;
  String? warpId;
  int? inwardQty;
  num? inwardMeter;
  num? wages;
  num? credit;
  String? damaged;
  String? productDetails;
  String? pending;
  int? pendingQty;
  num? pendingMeter;
  num? productWidth;
  num? pick;
  String? eDate;
  num? sareeWeight;
  String? sareeCheckerName;
  String? usedOtherWarp;

  ItemDetails({
    this.id,
    this.weavingAcId,
    this.loom,
    this.currentStatus,
    this.entryType,
    this.productId,
    this.productName,
    this.warpDesignId,
    this.warpDesignName,
    this.warpType,
    this.warpId,
    this.inwardQty,
    this.inwardMeter,
    this.wages,
    this.credit,
    this.damaged,
    this.productDetails,
    this.pending,
    this.pendingQty,
    this.pendingMeter,
    this.productWidth,
    this.pick,
    this.eDate,
    this.sareeWeight,
    this.sareeCheckerName,
    this.usedOtherWarp,
  });

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weavingAcId = json['weaving_ac_id'];
    loom = json['loom'];
    currentStatus = json['current_status'];
    entryType = json['entry_type'];
    productId = json['product_id'];
    productName = json['product_name'];
    warpDesignId = json['warp_design_id'];
    warpDesignName = json['warp_design_name'];
    warpType = json['warp_type'];
    warpId = json['warp_id'];
    inwardQty = json['inward_qty'];
    inwardMeter = json['inward_meter'];
    wages = json['wages'];
    credit = json['credit'];
    damaged = json['damaged'];
    productDetails = json['product_details'];
    pending = json['pending'];
    pendingQty = json['pending_qty'];
    pendingMeter = json['pending_meter'];
    productWidth = json['product_width'];
    pick = json['pick'];
    eDate = json['e_date'];
    sareeWeight = json['saree_weight'];
    sareeCheckerName = json['saree_checker_name'];
    usedOtherWarp = json['used_other_warp'];
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
    data['warp_design_id'] = warpDesignId;
    data['warp_design_name'] = warpDesignName;
    data['warp_type'] = warpType;
    data['warp_id'] = warpId;
    data['inward_qty'] = inwardQty;
    data['inward_meter'] = inwardMeter;
    data['wages'] = wages;
    data['credit'] = credit;
    data['damaged'] = damaged;
    data['product_details'] = productDetails;
    data['pending'] = pending;
    data['pending_qty'] = pendingQty;
    data['pending_meter'] = pendingMeter;
    data['product_width'] = productWidth;
    data['pick'] = pick;
    data['e_date'] = eDate;
    data['saree_weight'] = sareeWeight;
    data['saree_checker_name'] = sareeCheckerName;
    data['used_other_warp'] = usedOtherWarp;
    return data;
  }
}
