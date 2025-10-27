class JobWorkInwardOrderedWork {
  int? orderWorkId;
  String? orderWorkName;

  JobWorkInwardOrderedWork({this.orderWorkId, this.orderWorkName});

  JobWorkInwardOrderedWork.fromJson(Map<String, dynamic> json) {
    orderWorkId = json['order_work_id'];
    orderWorkName = json['order_work_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_work_id'] = orderWorkId;
    data['order_work_name'] = orderWorkName;
    return data;
  }

  @override
  String toString() {
    return "$orderWorkName";
  }
}
