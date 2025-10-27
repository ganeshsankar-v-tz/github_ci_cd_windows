class PrivateWeftRequirementListModel {
  int? weaverId;
  String? weaverName;
  int? weavingAcId;
  String? loom;
  int? productId;
  String? productName;
  String? reqFor;
  int? noOfUnit;
  List<ItemDetails>? itemDetails;

  PrivateWeftRequirementListModel(
      {this.weaverId,
      this.weaverName,
      this.weavingAcId,
      this.loom,
      this.productId,
      this.productName,
      this.reqFor,
      this.noOfUnit,
      this.itemDetails});

  PrivateWeftRequirementListModel.fromJson(Map<String, dynamic> json) {
    weaverId = json['weaver_id'];
    weaverName = json['weaver_name'];
    weavingAcId = json['weaving_ac_id'];
    loom = json['loom'];
    productId = json['product_id'];
    productName = json['product_name'];
    reqFor = json['req_for'];
    noOfUnit = json['no_of_unit'];
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
    data['weaver_name'] = weaverName;
    data['weaving_ac_id'] = weavingAcId;
    data['loom'] = loom;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['req_for'] = reqFor;
    data['no_of_unit'] = noOfUnit;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? yarnId;
  String? yarnName;
  String? weftType;
  num? quantity;
  String? unitName;

  ItemDetails(
      {this.yarnId,
      this.yarnName,
      this.weftType,
      this.quantity,
      this.unitName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    weftType = json['weft_type'];
    quantity = json['quantity'];
    unitName = json['unit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['yarn_id'] = yarnId;
    data['yarn_name'] = yarnName;
    data['weft_type'] = weftType;
    data['quantity'] = quantity;
    data['unit_name'] = unitName;
    return data;
  }
}
