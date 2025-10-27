class WeaverByWeftBalanceModel {
  List<RequiredYarn>? requiredYarn;
  List<DeliveryYarn>? deliveryYarn;
  List<DeliveryBalance>? deliveryBalance;
  List<UsedYarn>? usedYarn;
  List<WeaverYarnStock>? weaverYarnStock;

  WeaverByWeftBalanceModel(
      {this.requiredYarn,
      this.deliveryYarn,
      this.deliveryBalance,
      this.usedYarn,
      this.weaverYarnStock});

  WeaverByWeftBalanceModel.fromJson(Map<String, dynamic> json) {
    if (json['required_yarn'] != null) {
      requiredYarn = <RequiredYarn>[];
      json['required_yarn'].forEach((v) {
        requiredYarn!.add(RequiredYarn.fromJson(v));
      });
    }
    if (json['delivery_yarn'] != null) {
      deliveryYarn = <DeliveryYarn>[];
      json['delivery_yarn'].forEach((v) {
        deliveryYarn!.add(DeliveryYarn.fromJson(v));
      });
    }
    if (json['delivery_balance'] != null) {
      deliveryBalance = <DeliveryBalance>[];
      json['delivery_balance'].forEach((v) {
        deliveryBalance!.add(DeliveryBalance.fromJson(v));
      });
    }
    if (json['used_yarn'] != null) {
      usedYarn = <UsedYarn>[];
      json['used_yarn'].forEach((v) {
        usedYarn!.add(UsedYarn.fromJson(v));
      });
    }
    if (json['weaver_yarn_stock'] != null) {
      weaverYarnStock = <WeaverYarnStock>[];
      json['weaver_yarn_stock'].forEach((v) {
        weaverYarnStock!.add(WeaverYarnStock.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (requiredYarn != null) {
      data['required_yarn'] = requiredYarn!.map((v) => v.toJson()).toList();
    }
    if (deliveryYarn != null) {
      data['delivery_yarn'] = deliveryYarn!.map((v) => v.toJson()).toList();
    }
    if (deliveryBalance != null) {
      data['delivery_balance'] =
          deliveryBalance!.map((v) => v.toJson()).toList();
    }
    if (usedYarn != null) {
      data['used_yarn'] = usedYarn!.map((v) => v.toJson()).toList();
    }
    if (weaverYarnStock != null) {
      data['weaver_yarn_stock'] =
          weaverYarnStock!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RequiredYarn {
  int? yarnId;
  String? yarnName;
  String? weftType;
  num? reqYarn;
  String? unit;

  RequiredYarn(
      {this.yarnId, this.yarnName, this.weftType, this.reqYarn, this.unit});

  RequiredYarn.fromJson(Map<String, dynamic> json) {
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    weftType = json['weft_type'];
    reqYarn = json['req_yarn'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['yarn_id'] = yarnId;
    data['yarn_name'] = yarnName;
    data['weft_type'] = weftType;
    data['req_yarn'] = reqYarn;
    data['unit'] = unit;
    return data;
  }
}

class DeliveryYarn {
  int? yarnId;
  String? yarnName;
  num? yarnQty;
  String? unit;
  String? pck;

  DeliveryYarn({this.yarnId, this.yarnName, this.yarnQty, this.unit, this.pck});

  DeliveryYarn.fromJson(Map<String, dynamic> json) {
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    yarnQty = json['yarn_qty'];
    unit = json['unit'];
    pck = json['pck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['yarn_id'] = yarnId;
    data['yarn_name'] = yarnName;
    data['yarn_qty'] = yarnQty;
    data['unit'] = unit;
    data['pck'] = pck;
    return data;
  }
}

class DeliveryBalance {
  int? yarnId;
  String? yarnName;
  String? weftType;
  num? balanceYarn;
  String? unit;

  DeliveryBalance(
      {this.yarnId, this.yarnName, this.weftType, this.balanceYarn, this.unit});

  DeliveryBalance.fromJson(Map<String, dynamic> json) {
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    weftType = json['weft_type'];
    balanceYarn = json['balance_yarn'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['yarn_id'] = yarnId;
    data['yarn_name'] = yarnName;
    data['weft_type'] = weftType;
    data['balance_yarn'] = balanceYarn;
    data['unit'] = unit;
    return data;
  }
}

class UsedYarn {
  int? yarnId;
  String? yarnName;
  String? weftType;
  num? usedYarn;
  String? unit;

  UsedYarn(
      {this.yarnId, this.yarnName, this.weftType, this.usedYarn, this.unit});

  UsedYarn.fromJson(Map<String, dynamic> json) {
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    weftType = json['weft_type'];
    usedYarn = json['used_yarn'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['yarn_id'] = yarnId;
    data['yarn_name'] = yarnName;
    data['weft_type'] = weftType;
    data['used_yarn'] = usedYarn;
    data['unit'] = unit;
    return data;
  }
}

class WeaverYarnStock {
  int? yarnId;
  String? yarnName;
  String? weftType;
  num? balStockYarn;
  String? unit;

  WeaverYarnStock(
      {this.yarnId,
      this.yarnName,
      this.weftType,
      this.balStockYarn,
      this.unit});

  WeaverYarnStock.fromJson(Map<String, dynamic> json) {
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    weftType = json['weft_type'];
    balStockYarn = json['bal_stock_yarn'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['yarn_id'] = yarnId;
    data['yarn_name'] = yarnName;
    data['weft_type'] = weftType;
    data['bal_stock_yarn'] = balStockYarn;
    data['unit'] = unit;
    return data;
  }
}
