import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LoomAccountDetailsModel {
  int? id;
  int? weaverId;
  String? createdAt;
  String? updatedAt;
  String? weaverName;
  String? subWeaverNo;
  String? branch;
  String? ifscNo;
  String? accountNo;
  String? panNo;
  int? tdsPerc;
  String? acHolder;
  String? aatharNo;
  String? bankName;
  String? benifAcTyp;

  LoomAccountDetailsModel(
      {this.id,
      this.weaverId,
      this.createdAt,
      this.updatedAt,
      this.weaverName,
      this.subWeaverNo,
      this.branch,
      this.ifscNo,
      this.accountNo,
      this.panNo,
      this.tdsPerc,
      this.acHolder,
      this.aatharNo,
      this.bankName,
      this.benifAcTyp});

  LoomAccountDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weaverId = json['weaver_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    weaverName = json['weaver_name'];
    subWeaverNo = json['sub_weaver_no'];
    branch = json['branch'];
    ifscNo = json['ifsc_no'];
    accountNo = json['account_no'];
    panNo = json['pan_no'];
    tdsPerc = json['tds_perc'];
    acHolder = json['ac_holder'];
    aatharNo = json['aathar_no'];
    bankName = json['bank_name'];
    benifAcTyp = json['benif_ac_typ'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['weaver_id'] = weaverId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['weaver_name'] = weaverName;
    data['sub_weaver_no'] = subWeaverNo;
    data['branch'] = branch;
    data['ifsc_no'] = ifscNo;
    data['account_no'] = accountNo;
    data['pan_no'] = panNo;
    data['tds_perc'] = tdsPerc;
    data['ac_holder'] = acHolder;
    data['aathar_no'] = aatharNo;
    data['bank_name'] = bankName;
    data['benif_ac_typ'] = benifAcTyp;
    return data;
  }

  DataGridRow getDataGridRow() {
    return DataGridRow(cells: [
      const DataGridCell<dynamic>(columnName: 's_no', value: 1),
      DataGridCell<dynamic>(columnName: 'weaver_name', value: weaverName),
      DataGridCell<dynamic>(columnName: 'sub_weaver_no', value: subWeaverNo),
      DataGridCell<dynamic>(columnName: 'ac_holder', value: acHolder),
      DataGridCell<dynamic>(columnName: 'ifsc_no', value: ifscNo),
      DataGridCell<dynamic>(columnName: 'bank_name', value: bankName),
      DataGridCell<dynamic>(columnName: 'branch', value: branch),
      DataGridCell<dynamic>(columnName: 'account_no', value: accountNo),
      DataGridCell<dynamic>(columnName: 'tds', value: tdsPerc),
      DataGridCell<dynamic>(columnName: 'pan', value: panNo),
      DataGridCell<dynamic>(columnName: 'aathar_no', value: aatharNo),
      DataGridCell<dynamic>(columnName: 'benif_ac_typ', value: benifAcTyp),
    ]);
  }
}
