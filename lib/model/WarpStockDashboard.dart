class WarpStockDashboard {
  int? id;
  String? design_name;
  int? total_ends;

  WarpStockDashboard({this.id, this.design_name, this.total_ends});

  WarpStockDashboard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    design_name = json['design_name'];
    total_ends = json['total_ends'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['design_name'] = this.design_name;
    data['total_ends'] = this.total_ends;
    return data;
  }
}