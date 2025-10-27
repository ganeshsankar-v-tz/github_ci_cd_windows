class ProductGroupModel {
  int? id;
  String? unit;
  String? groupName;
  dynamic purchaseRate;
  String? date;
  String? isActive;
  String? createdAt;
  List<ProductList>? productList;
  List<SupplierList>? supplierList;

  ProductGroupModel(
      {this.id,
      this.unit,
      this.groupName,
      this.purchaseRate,
      this.date,
      this.isActive,
      this.createdAt,
      this.productList,
      this.supplierList});

  ProductGroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unit = json['unit'];
    groupName = json['group_name'];
    purchaseRate = json['purchase_rate'];
    date = json['date'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    if (json['Product_list'] != null) {
      productList = <ProductList>[];
      json['Product_list'].forEach((v) {
        productList!.add(ProductList.fromJson(v));
      });
    }
    if (json['Suplier_list'] != null) {
      supplierList = <SupplierList>[];
      json['Suplier_list'].forEach((v) {
        supplierList!.add(SupplierList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unit'] = unit;
    data['group_name'] = groupName;
    data['purchase_rate'] = purchaseRate;
    data['date'] = date;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    if (productList != null) {
      data['Product_list'] = productList!.map((v) => v.toJson()).toList();
    }
    if (supplierList != null) {
      data['Suplier_list'] = supplierList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return "$groupName";
  }
}

class ProductList {
  int? id;
  String? productName;
  String? designNo;
  String? group;
  int? productGroupId;
  int? status;
  String? createdAt;
  String? updatedAt;

  ProductList(
      {this.id,
      this.productName,
      this.designNo,
      this.group,
      this.productGroupId,
      this.status,
      this.createdAt,
      this.updatedAt});

  ProductList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    designNo = json['design_no'];
    group = json['group'];
    productGroupId = json['product_group_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productName;
    data['design_no'] = designNo;
    data['group'] = group;
    data['product_group_id'] = productGroupId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SupplierList {
  int? id;
  String? suplier;
  String? area;
  int? productGroupId;
  dynamic lastPurRate;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? supplierDate;

  SupplierList(
      {this.id,
      this.suplier,
      this.area,
      this.productGroupId,
      this.lastPurRate,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.supplierDate});

  SupplierList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    suplier = json['suplier'];
    area = json['area'];
    productGroupId = json['product_group_id'];
    lastPurRate = json['last_pur_rate'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    supplierDate = json['supplier_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['suplier'] = suplier;
    data['area'] = area;
    data['product_group_id'] = productGroupId;
    data['last_pur_rate'] = lastPurRate;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['supplier_date'] = supplierDate;
    return data;
  }
}
