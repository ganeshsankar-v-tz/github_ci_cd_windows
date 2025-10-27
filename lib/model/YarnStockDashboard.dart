class YarnStockDashboard {
  int? id;
  String? name;
  int? stockIn;
  String? status;

  YarnStockDashboard({this.id, this.name, this.stockIn, this.status});

  YarnStockDashboard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stockIn = json['stock_in'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['stock_in'] = this.stockIn;
    data['status'] = this.status;
    return data;
  }
}