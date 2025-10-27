class TwisterWarpingModel {
  int? id;
  int? warperId;
  String? warperName;
  String? lot;
  String? recoredNo;
  int? firm;
  int? totalDeliverdWeight;
  dynamic totalReceivedWeight;
  int? totalWages;
  int? toatlCopsOut;
  int? totalCopsIn;
  int? totalReelOut;
  dynamic balanceDeliverdWeight;
  dynamic balanceReceivedWeight;
  int? balanceCopsIn;
  int? balanceReelIn;
  String? createdAt;
  List<ItemDetails>? itemDetails;

  TwisterWarpingModel(
      {this.id,
      this.warperId,
      this.warperName,
      this.lot,
      this.recoredNo,
      this.firm,
      this.totalDeliverdWeight,
      this.totalReceivedWeight,
      this.totalWages,
      this.toatlCopsOut,
      this.totalCopsIn,
      this.totalReelOut,
      this.balanceDeliverdWeight,
      this.balanceReceivedWeight,
      this.balanceCopsIn,
      this.balanceReelIn,
      this.createdAt,
      this.itemDetails});

  TwisterWarpingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warperId = json['warper_id'];
    warperName = json['warper_name'];
    lot = json['lot'];
    recoredNo = json['recored_no'];
    firm = json['firm'];
    totalDeliverdWeight = json['total_deliverd_weight'];
    totalReceivedWeight = json['total_received_weight'];
    totalWages = json['total_wages'];
    toatlCopsOut = json['toatl_cops_out'];
    totalCopsIn = json['total_cops_in'];
    totalReelOut = json['total_reel_out'];
    balanceDeliverdWeight = json['balance_deliverd_weight'];
    balanceReceivedWeight = json['balance_received_weight'];
    balanceCopsIn = json['balance_cops_in'];
    balanceReelIn = json['balance_reel_in'];
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
    data['warper_id'] = this.warperId;
    data['warper_name'] = this.warperName;
    data['lot'] = this.lot;
    data['recored_no'] = this.recoredNo;
    data['firm'] = this.firm;
    data['total_deliverd_weight'] = this.totalDeliverdWeight;
    data['total_received_weight'] = this.totalReceivedWeight;
    data['total_wages'] = this.totalWages;
    data['toatl_cops_out'] = this.toatlCopsOut;
    data['total_cops_in'] = this.totalCopsIn;
    data['total_reel_out'] = this.totalReelOut;
    data['balance_deliverd_weight'] = this.balanceDeliverdWeight;
    data['balance_received_weight'] = this.balanceReceivedWeight;
    data['balance_cops_in'] = this.balanceCopsIn;
    data['balance_reel_in'] = this.balanceReelIn;
    data['created_at'] = this.createdAt;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  String? date;
  String? entryType;
  String? particulers;
  dynamic deliverdWeight;
  dynamic receivedWeight;
  dynamic wages;
  int? copsOut;
  int? copsIn;
  int? reelOut;
  int? reelIn;
  int? twistingWarpingAddonsId;
  int? twistingWarpingId;
  String? createdAt;
  String? updatedAt;

  ItemDetails(
      {this.id,
      this.date,
      this.entryType,
      this.particulers,
      this.deliverdWeight,
      this.receivedWeight,
      this.wages,
      this.copsOut,
      this.copsIn,
      this.reelOut,
      this.reelIn,
      this.twistingWarpingAddonsId,
      this.twistingWarpingId,
      this.createdAt,
      this.updatedAt});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    entryType = json['entry_type'];
    particulers = json['particulers'];
    deliverdWeight = json['deliverd_weight'];
    receivedWeight = json['received_weight'];
    wages = json['wages'];
    copsOut = json['cops_out'];
    copsIn = json['cops_in'];
    reelOut = json['reel_out'];
    reelIn = json['reel_in'];
    twistingWarpingAddonsId = json['twisting_warping_addons_id'];
    twistingWarpingId = json['twisting_warping_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['entry_type'] = this.entryType;
    data['particulers'] = this.particulers;
    data['deliverd_weight'] = this.deliverdWeight;
    data['received_weight'] = this.receivedWeight;
    data['wages'] = this.wages;
    data['cops_out'] = this.copsOut;
    data['cops_in'] = this.copsIn;
    data['reel_out'] = this.reelOut;
    data['reel_in'] = this.reelIn;
    data['twisting_warping_addons_id'] = this.twistingWarpingAddonsId;
    data['twisting_warping_id'] = this.twistingWarpingId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
