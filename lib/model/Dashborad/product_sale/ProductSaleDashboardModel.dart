class ProductSaleDashboardModel {
  int? totalSale;
  num? totalRevenu;
  int? totalCustomer;
  int? totalProduct;
  List<SalesReport>? salesReport;
  List<ProductStock>? productStock;
  List<TopSellingProduct>? topSellingProduct;
  List<RecentSale>? recentSale;

  ProductSaleDashboardModel({
    this.totalSale,
    this.totalRevenu,
    this.totalCustomer,
    this.totalProduct,
    this.salesReport,
    this.productStock,
    this.topSellingProduct,
    this.recentSale,
  });

  ProductSaleDashboardModel.fromJson(Map<String, dynamic> json) {
    totalSale = json['total_sale'];
    totalRevenu = json['total_revenu'];
    totalCustomer = json['total_customer'];
    totalProduct = json['total_product'];
    if (json['sales_report'] != null) {
      salesReport = <SalesReport>[];
      json['sales_report'].forEach((v) {
        salesReport!.add(SalesReport.fromJson(v));
      });
    }
    if (json['product_stock'] != null) {
      productStock = <ProductStock>[];
      json['product_stock'].forEach((v) {
        productStock!.add(ProductStock.fromJson(v));
      });
    }
    if (json['top_selling_product'] != null) {
      topSellingProduct = <TopSellingProduct>[];
      json['top_selling_product'].forEach((v) {
        topSellingProduct!.add(TopSellingProduct.fromJson(v));
      });
    }
    if (json['recent_sale'] != null) {
      recentSale = <RecentSale>[];
      json['recent_sale'].forEach((v) {
        recentSale!.add(RecentSale.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_sale'] = totalSale;
    data['total_revenu'] = totalRevenu;
    data['total_customer'] = totalCustomer;
    data['total_product'] = totalProduct;
    if (salesReport != null) {
      data['sales_report'] = salesReport!.map((v) => v.toJson()).toList();
    }
    if (productStock != null) {
      data['product_stock'] = productStock!.map((v) => v.toJson()).toList();
    }
    if (topSellingProduct != null) {
      data['top_selling_product'] =
          topSellingProduct!.map((v) => v.toJson()).toList();
    }
    if (recentSale != null) {
      data['recent_sale'] = recentSale!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesReport {
  int? saleYear;
  int? saleMonth;
  int? totalQty;

  SalesReport({
    this.saleYear,
    this.saleMonth,
    this.totalQty,
  });

  SalesReport.fromJson(Map<String, dynamic> json) {
    saleYear = json['sale_year'];
    saleMonth = json['sale_month'];
    totalQty = json['total_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sale_year'] = saleYear;
    data['sale_month'] = saleMonth;
    data['total_qty'] = totalQty;
    return data;
  }
}

class ProductStock {
  int? productId;
  String? productName;
  int? inwardQty;
  int? outwardQty;
  int? balanceQty;

  ProductStock({
    this.productId,
    this.productName,
    this.inwardQty,
    this.outwardQty,
    this.balanceQty,
  });

  ProductStock.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    inwardQty = json['inward_qty'];
    outwardQty = json['outward_qty'];
    balanceQty = json['balance_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['inward_qty'] = inwardQty;
    data['outward_qty'] = outwardQty;
    data['balance_qty'] = balanceQty;
    return data;
  }
}

class TopSellingProduct {
  int? productId;
  String? productName;
  int? totalQty;

  TopSellingProduct({
    this.productId,
    this.productName,
    this.totalQty,
  });

  TopSellingProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    totalQty = json['total_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['total_qty'] = totalQty;
    return data;
  }
}

class RecentSale {
  String? eDate;
  int? customerId;
  String? customerName;
  int? totalQty;

  RecentSale({
    this.eDate,
    this.customerId,
    this.customerName,
    this.totalQty,
  });

  RecentSale.fromJson(Map<String, dynamic> json) {
    eDate = json['e_date'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    totalQty = json['total_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['e_date'] = eDate;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['total_qty'] = totalQty;
    return data;
  }
}
