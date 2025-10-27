class ProcessPureSilkModel {
  int? id;
  int? processorId;
  String? processerName;
  String? lot;
  int? recoredNo;
  int? firmId;
  String? firmName;
  String? details;
  int? deliveredQty;
  int? recivedQty;
  int? wages;
  List<ProcessItem>? processItem;

  ProcessPureSilkModel(
      {this.id,
      this.processorId,
      this.processerName,
      this.lot,
      this.recoredNo,
      this.firmId,
      this.firmName,
      this.details,
      this.deliveredQty,
      this.recivedQty,
      this.wages,
      this.processItem});

  ProcessPureSilkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    processorId = json['processor_id'];
    processerName = json['processer_name'];
    lot = json['lot'];
    recoredNo = json['recored_no'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    details = json['details'];
    deliveredQty = json['delivered_qty'];
    recivedQty = json['recived_qty'];
    wages = json['wages'];
    if (json['process_item'] != null) {
      processItem = <ProcessItem>[];
      json['process_item'].forEach((v) {
        processItem!.add(new ProcessItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['processor_id'] = this.processorId;
    data['processer_name'] = this.processerName;
    data['lot'] = this.lot;
    data['recored_no'] = this.recoredNo;
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['details'] = this.details;
    data['delivered_qty'] = this.deliveredQty;
    data['recived_qty'] = this.recivedQty;
    data['wages'] = this.wages;
    if (this.processItem != null) {
      data['process_item'] = this.processItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProcessItem {
  int? id;
  String? date;
  String? entryType;
  int? deliveredQty;
  int? recivedQty;
  int? wages;
  int? processId;
  String? processAddonsId;
  int? status;
  String? createdAt;
  String? updatedAt;

  ProcessItem(
      {this.id,
      this.date,
      this.entryType,
      this.deliveredQty,
      this.recivedQty,
      this.wages,
      this.processId,
      this.processAddonsId,
      this.status,
      this.createdAt,
      this.updatedAt});

  ProcessItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    entryType = json['entry_type'];
    deliveredQty = json['delivered_qty'];
    recivedQty = json['recived_qty'];
    wages = json['wages'];
    processId = json['process_id'];
    processAddonsId = json['process_Addons_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['entry_type'] = this.entryType;
    data['delivered_qty'] = this.deliveredQty;
    data['recived_qty'] = this.recivedQty;
    data['wages'] = this.wages;
    data['process_id'] = this.processId;
    data['process_Addons_id'] = this.processAddonsId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
