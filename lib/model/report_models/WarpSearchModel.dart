class WarpSearchModel {
  String? warpFrom;
  int? warpDesignId;
  String? warpName;
  String? warpType;
  String? details;
  String? emptyType;
  int? emptyQty;
  int? ledgerId;
  String? ledgerName;
  int? sheet;
  String? eDate;
  num? weight;
  int? qty;
  num? metre;
  String? warpColor;
  String? warpLable;
  List<WarpTracking>? warpTracking;

  WarpSearchModel(
      {this.warpFrom,
      this.warpDesignId,
      this.warpName,
      this.warpType,
      this.details,
      this.emptyType,
      this.emptyQty,
      this.ledgerId,
      this.ledgerName,
      this.sheet,
      this.eDate,
      this.weight,
      this.qty,
      this.metre,
      this.warpColor,
      this.warpLable,
      this.warpTracking});

  WarpSearchModel.fromJson(Map<String, dynamic> json) {
    warpFrom = json['warp_from'];
    warpDesignId = json['warp_design_id'];
    warpName = json['warp_name'];
    warpType = json['warp_type'];
    details = json['details'];
    emptyType = json['empty_type'];
    emptyQty = json['empty_qty'];
    ledgerId = json['ledger_id'];
    ledgerName = json['ledger_name'];
    sheet = json['sheet'];
    eDate = json['e_date'];
    weight = json['weight'];
    qty = json['qty'];
    metre = json['metre'];
    warpColor = json['warp_color'];
    warpLable = json['warp_lable'];
    if (json['warp_tracking'] != null) {
      warpTracking = <WarpTracking>[];
      json['warp_tracking'].forEach((v) {
        warpTracking!.add(WarpTracking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warp_from'] = warpFrom;
    data['warp_design_id'] = warpDesignId;
    data['warp_name'] = warpName;
    data['warp_type'] = warpType;
    data['details'] = details;
    data['empty_type'] = emptyType;
    data['empty_qty'] = emptyQty;
    data['ledger_id'] = ledgerId;
    data['ledger_name'] = ledgerName;
    data['sheet'] = sheet;
    data['e_date'] = eDate;
    data['weight'] = weight;
    data['qty'] = qty;
    data['metre'] = metre;
    data['warp_color'] = warpColor;
    data['warp_lable'] = warpLable;
    if (warpTracking != null) {
      data['warp_tracking'] = warpTracking!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WarpTracking {
  String? entryType;
  String? eDate;
  String? newWarpId;
  int? ledgerId;
  String? ledgerName;
  int? warpDesignId;
  String? warpName;
  String? warpCondition;
  String? oldWarpId;
  String? loom;
  String? currentStatus;
  String? productName;
  String? rollerName;

  WarpTracking(
      {this.entryType,
      this.eDate,
      this.newWarpId,
      this.ledgerId,
      this.ledgerName,
      this.warpDesignId,
      this.warpName,
      this.warpCondition,
      this.oldWarpId,
      this.loom,
      this.currentStatus,
      this.productName,
      this.rollerName});

  WarpTracking.fromJson(Map<String, dynamic> json) {
    entryType = json['entry_type'];
    eDate = json['e_date'];
    newWarpId = json['new_warp_id'];
    ledgerId = json['ledger_id'];
    ledgerName = json['ledger_name'];
    warpDesignId = json['warp_design_id'];
    warpName = json['warp_name'];
    warpCondition = json['warp_condition'];
    oldWarpId = json['old_warp_id'];
    loom = json['loom'];
    currentStatus = json['current_status'];
    productName = json['product_name'];
    rollerName = json['roller_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entry_type'] = entryType;
    data['e_date'] = eDate;
    data['new_warp_id'] = newWarpId;
    data['ledger_id'] = ledgerId;
    data['ledger_name'] = ledgerName;
    data['warp_design_id'] = warpDesignId;
    data['warp_name'] = warpName;
    data['warp_condition'] = warpCondition;
    data['old_warp_id'] = oldWarpId;
    data['loom'] = loom;
    data['current_status'] = currentStatus;
    data['product_name'] = productName;
    data['roller_name'] = rollerName;
    return data;
  }
}
