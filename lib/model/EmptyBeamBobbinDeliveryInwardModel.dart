class EmptyBeamBobbinDeliveryInwardModel {
  int? id;
  String? recordNo;
  String? entryType;
  String? transactionType;
  String? date;
  String? from;
  int? beam;
  int? bobbin;
  int? sheet;
  String? details;
  int? copReelQty;
  List<ItemDetails>? itemDetails;

  EmptyBeamBobbinDeliveryInwardModel(
      {this.id,
      this.recordNo,
      this.entryType,
      this.transactionType,
      this.date,
      this.from,
      this.beam,
      this.bobbin,
      this.sheet,
      this.details,
      this.copReelQty,
      this.itemDetails});

  EmptyBeamBobbinDeliveryInwardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recordNo = json['record_no'];
    entryType = json['entry_type'];
    transactionType = json['transaction_type'];
    date = json['date'];
    from = json['from'];
    beam = json['beam'];
    bobbin = json['bobbin'];
    sheet = json['sheet'];
    details = json['details'];
    copReelQty = json['cop_reel_qty'];
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
    data['record_no'] = this.recordNo;
    data['entry_type'] = this.entryType;
    data['transaction_type'] = this.transactionType;
    data['date'] = this.date;
    data['from'] = this.from;
    data['beam'] = this.beam;
    data['bobbin'] = this.bobbin;
    data['sheet'] = this.sheet;
    data['details'] = this.details;
    data['cop_reel_qty'] = this.copReelQty;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? emptyBeamBobbinDeliveryId;
  String? type;
  String? copsReel;
  int? quantity;
  int? status;
  String? createdAt;
  String? updatedAt;

  ItemDetails(
      {this.id,
      this.emptyBeamBobbinDeliveryId,
      this.type,
      this.copsReel,
      this.quantity,
      this.status,
      this.createdAt,
      this.updatedAt});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    emptyBeamBobbinDeliveryId = json['empty_beam_bobbin_delivery_id'];
    type = json['type'];
    copsReel = json['cops_reel'];
    quantity = json['quantity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['empty_beam_bobbin_delivery_id'] = this.emptyBeamBobbinDeliveryId;
    data['type'] = this.type;
    data['cops_reel'] = this.copsReel;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
