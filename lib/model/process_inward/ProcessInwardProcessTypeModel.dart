class ProcessInwardProcessTypeModel {
  String? processType;

  ProcessInwardProcessTypeModel({this.processType});

  ProcessInwardProcessTypeModel.fromJson(Map<String, dynamic> json) {
    processType = json['process_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_type'] = processType;
    return data;
  }

  @override
  String toString() {
    return "$processType";
  }
}
