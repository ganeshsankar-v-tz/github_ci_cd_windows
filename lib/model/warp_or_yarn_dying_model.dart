class WarpOrYarnDyingModel {
  int? id;
  int? dyerId;
  String? dyerName;
  String? lot;
  int? recoredNo;
  int? firmId;
  String? firmName;
  int? accountTypeId;
  String? accountTypeName;
  int? transactionTypeId;
  String? details;
  String? yarnDeliveryWages;
  String? tokesDeleivery;
  String? warpDyingWages;
  int? totalDeliveryWeight;
  int? totalRecivedWeight;
  int? totalWastageWeight;
  int? totalWages;
  List<ItemDetails>? itemDetails;

  WarpOrYarnDyingModel(
      {this.id,
        this.dyerId,
        this.dyerName,
        this.lot,
        this.recoredNo,
        this.firmId,
        this.firmName,
        this.accountTypeId,
        this.accountTypeName,
        this.transactionTypeId,
        this.details,
        this.yarnDeliveryWages,
        this.tokesDeleivery,
        this.warpDyingWages,
        this.totalDeliveryWeight,
        this.totalRecivedWeight,
        this.totalWastageWeight,
        this.totalWages,
        this.itemDetails});

  WarpOrYarnDyingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dyerId = json['dyer_id'];
    dyerName = json['dyer_name'];
    lot = json['lot'];
    recoredNo = json['recored_no'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    accountTypeId = json['account_type_id'];
    accountTypeName = json['account_type_name'];
    transactionTypeId = json['transaction_type_id'];
    details = json['details'];
    yarnDeliveryWages = json['yarn_delivery_wages'];
    tokesDeleivery = json['tokes_deleivery'];
    warpDyingWages = json['warp_dying_wages'];
    totalDeliveryWeight = json['total_delivery_weight'];
    totalRecivedWeight = json['total_recived_weight'];
    totalWastageWeight = json['total_wastage_weight'];
    totalWages = json['total_wages'];
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
    data['lot'] = this.lot;
    data['recored_no'] = this.recoredNo;
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['account_type_id'] = this.accountTypeId;
    data['account_type_name'] = this.accountTypeName;
    data['transaction_type_id'] = this.transactionTypeId;
    data['details'] = this.details;
    data['yarn_delivery_wages'] = this.yarnDeliveryWages;
    data['tokes_deleivery'] = this.tokesDeleivery;
    data['warp_dying_wages'] = this.warpDyingWages;
    data['total_delivery_weight'] = this.totalDeliveryWeight;
    data['total_recived_weight'] = this.totalRecivedWeight;
    data['total_wastage_weight'] = this.totalWastageWeight;
    data['total_wages'] = this.totalWages;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? warpYarnDyeingId;
  int? warpYarnDyeingAddonsId;
  String? date;
  String? entryType;
  int? particulers;
  int? tks;
  int? deliverdWeight;
  int? recivedWeight;
  int? wastageWeight;
  int? waste;
  int? wages;
  int? status;
  String? createdAt;
  String? updatedAt;

  ItemDetails(
      {this.id,
        this.warpYarnDyeingId,
        this.warpYarnDyeingAddonsId,
        this.date,
        this.entryType,
        this.particulers,
        this.tks,
        this.deliverdWeight,
        this.recivedWeight,
        this.wastageWeight,
        this.waste,
        this.wages,
        this.status,
        this.createdAt,
        this.updatedAt});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warpYarnDyeingId = json['warp_yarn_dyeing_id'];
    warpYarnDyeingAddonsId = json['warp_yarn_dyeing_addons_id'];
    date = json['date'];
    entryType = json['entry_type'];
    particulers = json['particulers'];
    tks = json['tks'];
    deliverdWeight = json['deliverd_weight'];
    recivedWeight = json['recived_weight'];
    wastageWeight = json['wastage_weight'];
    waste = json['waste'];
    wages = json['wages'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warp_yarn_dyeing_id'] = this.warpYarnDyeingId;
    data['warp_yarn_dyeing_addons_id'] = this.warpYarnDyeingAddonsId;
    data['date'] = this.date;
    data['entry_type'] = this.entryType;
    data['particulers'] = this.particulers;
    data['tks'] = this.tks;
    data['deliverd_weight'] = this.deliverdWeight;
    data['recived_weight'] = this.recivedWeight;
    data['wastage_weight'] = this.wastageWeight;
    data['waste'] = this.waste;
    data['wages'] = this.wages;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
