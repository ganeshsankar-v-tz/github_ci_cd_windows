class WeavingFinishListModel {
  int? balanceProQty;
  int? beam;
  int? bobbin;
  int? sheet;
  int? cops;
  int? reel;
  int? amount;
  bool? otherWarp;
  bool? yarnBalance;

  WeavingFinishListModel(
      {this.balanceProQty,
      this.beam,
      this.bobbin,
      this.sheet,
      this.cops,
      this.reel,
      this.amount,
      this.otherWarp,
      this.yarnBalance});

  WeavingFinishListModel.fromJson(Map<String, dynamic> json) {
    balanceProQty = json['balance_pro_qty'];
    beam = json['beam'];
    bobbin = json['bobbin'];
    sheet = json['sheet'];
    cops = json['cops'];
    reel = json['reel'];
    amount = json['amount'];
    otherWarp = json['other_warp'];
    yarnBalance = json['yarn_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance_pro_qty'] = balanceProQty;
    data['beam'] = beam;
    data['bobbin'] = bobbin;
    data['sheet'] = sheet;
    data['cops'] = cops;
    data['reel'] = reel;
    data['amount'] = amount;
    data['other_warp'] = otherWarp;
    data['yarn_balance'] = yarnBalance;
    return data;
  }
}
