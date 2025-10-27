// class ProductOrderModel {
//   int? id;
//   int? customerId;
//   String? customerName;
//   String? orderNo;
//   String? through;
//   String? agent;
//   String? discount;
//   String? transport;
//   String? productStatus;
//   int? totalQty;
//   String? createdAt;
//   List<ItemDetails>? itemDetails;
//
//   ProductOrderModel(
//       {this.id,
//       this.customerId,
//       this.customerName,
//       this.orderNo,
//       this.through,
//       this.agent,
//       this.discount,
//       this.transport,
//       this.productStatus,
//       this.totalQty,
//       this.createdAt,
//       this.itemDetails});
//
//   ProductOrderModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     customerId = json['customer_id'];
//     customerName = json['customer_name'];
//     orderNo = json['order_no'];
//     through = json['through'];
//     agent = json['agent'];
//     discount = json['discount'];
//     transport = json['transport'];
//     productStatus = json['product_status'];
//     totalQty = json['total_qty'];
//     createdAt = json['created_at'];
//     if (json['item_details'] != null) {
//       itemDetails = <ItemDetails>[];
//       json['item_details'].forEach((v) {
//         itemDetails!.add(new ItemDetails.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['customer_id'] = this.customerId;
//     data['customer_name'] = this.customerName;
//     data['order_no'] = this.orderNo;
//     data['through'] = this.through;
//     data['agent'] = this.agent;
//     data['discount'] = this.discount;
//     data['transport'] = this.transport;
//     data['product_status'] = this.productStatus;
//     data['total_qty'] = this.totalQty;
//     data['created_at'] = this.createdAt;
//     if (this.itemDetails != null) {
//       data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ItemDetails {
//   int? id;
//   int? productOrderId;
//   int? productId;
//   String? designNo;
//   String? work;
//   String? workDetails;
//   int? quantity;
//   double? rate;
//   String? details;
//   int? status;
//   String? createdAt;
//   String? updatedAt;
//   String? productName;
//
//   ItemDetails(
//       {this.id,
//       this.productOrderId,
//       this.productId,
//       this.designNo,
//       this.work,
//       this.workDetails,
//       this.quantity,
//       this.rate,
//       this.details,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.productName});
//
//   ItemDetails.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productOrderId = json['product_order_id'];
//     productId = json['product_id'];
//     designNo = json['design_no'];
//     work = json['work'];
//     workDetails = json['work_details'];
//     quantity = json['quantity'];
//     rate = json['rate'];
//     details = json['details'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     productName = json['product_name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['product_order_id'] = this.productOrderId;
//     data['product_id'] = this.productId;
//     data['design_no'] = this.designNo;
//     data['work'] = this.work;
//     data['work_details'] = this.workDetails;
//     data['quantity'] = this.quantity;
//     data['rate'] = this.rate;
//     data['details'] = this.details;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['product_name'] = this.productName;
//     return data;
//   }
// }

class ProductOrderModel {
  int? id;
  int? customerId;
  String? customerName;
  String? orderNo;
  String? eDate;
  String? orderThrough;
  String? agent;
  String? discountInfo;
  String? transport;
  String? orderStatus;
  List<ItemDetails>? itemDetails;

  ProductOrderModel(
      {this.id,
      this.customerId,
      this.customerName,
      this.orderNo,
      this.eDate,
      this.orderThrough,
      this.agent,
      this.discountInfo,
      this.transport,
      this.orderStatus,
      this.itemDetails});

  ProductOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    orderNo = json['order_no'];
    eDate = json['e_date'];
    orderThrough = json['order_through'];
    agent = json['agent'];
    discountInfo = json['discount_info'];
    transport = json['transport'];
    orderStatus = json['order_status'];
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
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['order_no'] = this.orderNo;
    data['e_date'] = this.eDate;
    data['order_through'] = this.orderThrough;
    data['agent'] = this.agent;
    data['discount_info'] = this.discountInfo;
    data['transport'] = this.transport;
    data['order_status'] = this.orderStatus;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? productOrderId;
  int? productId;
  int? workNo;
  int? quantity;
  int? rowNo;
  Null? det;
  int? rate;
  int? weftGiven;
  String? createdAt;
  String? updatedAt;
  String? productName;

  ItemDetails(
      {this.id,
      this.productOrderId,
      this.productId,
      this.workNo,
      this.quantity,
      this.rowNo,
      this.det,
      this.rate,
      this.weftGiven,
      this.createdAt,
      this.updatedAt,
      this.productName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productOrderId = json['product_order_id'];
    productId = json['product_id'];
    workNo = json['work_no'];
    quantity = json['quantity'];
    rowNo = json['row_no'];
    det = json['det'];
    rate = json['rate'];
    weftGiven = json['weft_given'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_order_id'] = this.productOrderId;
    data['product_id'] = this.productId;
    data['work_no'] = this.workNo;
    data['quantity'] = this.quantity;
    data['row_no'] = this.rowNo;
    data['det'] = this.det;
    data['rate'] = this.rate;
    data['weft_given'] = this.weftGiven;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product_name'] = this.productName;
    return data;
  }
}
