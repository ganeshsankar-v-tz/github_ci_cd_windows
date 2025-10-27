import 'package:abtxt/model/LoomModel.dart';

class LoomGroup {
  String? loomNo;
  late List<LoomModel> looms;

  LoomGroup({this.loomNo, this.looms = const []});

  LoomGroup.fromJson(Map<String, dynamic> json) {
    loomNo = json['loom_no'];
    if (json['looms'] != null) {
      looms = <LoomModel>[];
      json['looms'].forEach((v) {
        looms.add(LoomModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loom_no'] = loomNo;
    data['looms'] = looms.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    // var dd = looms.map((e) => e.currentStatus).toString();

    return '$loomNo';
  }
}
