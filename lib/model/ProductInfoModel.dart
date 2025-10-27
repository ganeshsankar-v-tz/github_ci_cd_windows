class ProductInfoModel {
  int? id;
  String? productName;
  String? designNo;
  String? integrated;
  String? llName;
  int? groupId;
  String? groupName;
  String? productUnit;
  dynamic unitMeter;
  String? lengthType;
  int? width;
  int? pick;
  int? reed;
  String? details;
  String? weaverWagesPer;
  dynamic wages;
  String? usedFor;
  String? isActive;
  String? weightBasedTxn;
  String? createdAt;
  List<WrapDetails>? wrapDetails;
  List<ProductDetails>? productDetails;

  ProductInfoModel(
      {this.id,
      this.productName,
      this.designNo,
      this.integrated,
      this.llName,
      this.groupId,
      this.groupName,
      this.productUnit,
      this.unitMeter,
      this.lengthType,
      this.width,
      this.pick,
      this.reed,
      this.details,
      this.weaverWagesPer,
      this.wages,
      this.usedFor,
      this.isActive,
      this.weightBasedTxn,
      this.createdAt,
      this.wrapDetails,
      this.productDetails});

  ProductInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    designNo = json['design_no'];
    integrated = json['integrated'];
    llName = json['ll_name'];
    groupId = json['group_id'];
    groupName = json['group_name'];
    productUnit = json['product_unit'];
    unitMeter = json['unit_meter'];
    lengthType = json['length_type'];
    width = json['width'];
    pick = json['pick'];
    reed = json['reed'];
    details = json['details'];
    weaverWagesPer = json['weaver_wages_per'];
    wages = json['wages'];
    usedFor = json['used_for'];
    isActive = json['is_active'];
    weightBasedTxn = json['weight_based_txn'];
    createdAt = json['created_at'];
    if (json['warp_details'] != null) {
      wrapDetails = <WrapDetails>[];
      json['warp_details'].forEach((v) {
        wrapDetails!.add(new WrapDetails.fromJson(v));
      });
    }
    if (json['product_details'] != null) {
      productDetails = <ProductDetails>[];
      json['product_details'].forEach((v) {
        productDetails!.add(new ProductDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['design_no'] = this.designNo;
    data['integrated'] = this.integrated;
    data['ll_name'] = this.llName;
    data['group_id'] = this.groupId;
    data['group_name'] = this.groupName;
    data['product_unit'] = this.productUnit;
    data['unit_meter'] = this.unitMeter;
    data['length_type'] = this.lengthType;
    data['width'] = this.width;
    data['pick'] = this.pick;
    data['reed'] = this.reed;
    data['details'] = this.details;
    data['weaver_wages_per'] = this.weaverWagesPer;
    data['wages'] = this.wages;
    data['used_for'] = this.usedFor;
    data['is_active'] = this.isActive;
    data['weight_based_txn'] = this.weightBasedTxn;
    data['created_at'] = this.createdAt;
    if (this.wrapDetails != null) {
      data['warp_details'] = this.wrapDetails!.map((v) => v.toJson()).toList();
    }
    if (this.productDetails != null) {
      data['product_details'] =
          this.productDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return "$productName";
  }
}

class WrapDetails {
  String? wrapType;
  String? wrapDesign;
  int? wrapDesignId;

  WrapDetails({this.wrapType, this.wrapDesign,this.wrapDesignId});

  WrapDetails.fromJson(Map<String, dynamic> json) {
    wrapType = json['warp_type'];
    wrapDesign = json['warp_design'];
    wrapDesignId = json['warp_design_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warp_type'] = this.wrapType;
    data['warp_design'] = this.wrapDesign;
    data['warp_design_id'] = this.wrapDesignId;
    return data;
  }
}

class ProductDetails {
  String? pUnit;
  String? wrapType;
  String? pQuantity;
  String? pDesignNo;
  String? pWorkName;
  String? wrapDesign;
  String? pProductName;

  ProductDetails(
      {this.pUnit,
      this.wrapType,
      this.pQuantity,
      this.pDesignNo,
      this.pWorkName,
      this.wrapDesign,
      this.pProductName});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    pUnit = json['p_unit'];
    wrapType = json['wrap_type'];
    pQuantity = json['p_quantity'];
    pDesignNo = json['p_design_no'];
    pWorkName = json['p_work_name'];
    wrapDesign = json['wrap_design'];
    pProductName = json['p_product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['p_unit'] = this.pUnit;
    data['wrap_type'] = this.wrapType;
    data['p_quantity'] = this.pQuantity;
    data['p_design_no'] = this.pDesignNo;
    data['p_work_name'] = this.pWorkName;
    data['wrap_design'] = this.wrapDesign;
    data['p_product_name'] = this.pProductName;
    return data;
  }
}
