class WeavingAccount {
  int? id;
  String? cbal;
  int? weaverId;
  int? printed;
  String? currentStatus;
  String? finishedDate;
  String? messageText;
  int? subWeaverNo;
  String? loomNo;
  int? productId;
  num? wages;
  int? firmId;
  String? transactionType;
  String? copsReels;
  String? widthPick;
  int? width;
  int? pick;
  String? pinning;
  String? compCheck;
  int? wagesAno;
  num? deduction;
  String? lockId;
  String? linePrint;
  int? cardNo;
  String? privateWeft;
  String? contractWeav;
  String? cardChar;
  String? weaverName;
  String? productName;
  String? firmName;
  num? unitLength;
  String? designNo;
  String? color;
  String? designImage;
  String? createdAt;
  String? updatedAt;
  String? createdName;
  String? updatedName;
  List<EntryTypes>? entryTypes;

  WeavingAccount({
    this.id,
    this.cbal,
    this.weaverId,
    this.printed,
    this.currentStatus,
    this.finishedDate,
    this.messageText,
    this.subWeaverNo,
    this.loomNo,
    this.productId,
    this.wages,
    this.firmId,
    this.transactionType,
    this.copsReels,
    this.widthPick,
    this.width,
    this.pick,
    this.pinning,
    this.compCheck,
    this.wagesAno,
    this.deduction,
    this.lockId,
    this.linePrint,
    this.cardNo,
    this.privateWeft,
    this.contractWeav,
    this.cardChar,
    this.weaverName,
    this.productName,
    this.firmName,
    this.unitLength,
    this.designNo,
    this.color,
    this.entryTypes,
    this.designImage,
    this.createdAt,
    this.updatedAt,
    this.createdName,
    this.updatedName,
  });

  WeavingAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cbal = json['cbal'];
    weaverId = json['weaver_id'];
    printed = json['printed'];
    currentStatus = json['current_status'];
    finishedDate = json['finished_date'];
    messageText = json['message_text'];
    subWeaverNo = json['sub_weaver_no'];
    loomNo = json['loom_no'];
    productId = json['product_id'];
    wages = json['wages'];
    firmId = json['firm_id'];
    transactionType = json['transaction_type'];
    copsReels = json['cops_reels'];
    widthPick = json['width_pick'];
    width = json['width'];
    pick = json['pick'];
    pinning = json['pinning'];
    compCheck = json['comp_check'];
    wagesAno = json['wages_ano'];
    deduction = json['deduction'];
    lockId = json['lock_id'];
    linePrint = json['line_print'];
    cardNo = json['card_no'];
    privateWeft = json['private_weft'];
    contractWeav = json['contract_weav'];
    cardChar = json['card_char'];
    weaverName = json['weaver_name'];
    productName = json['product_name'];
    firmName = json['firm_name'];
    unitLength = json['unit_length'];
    designNo = json['design_no'];
    color = json['color'];
    designImage = json['design_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdName = json['created_name'];
    updatedName = json['updated_name'];
    if (json['entry_types'] != null) {
      entryTypes = <EntryTypes>[];
      json['entry_types'].forEach((v) {
        entryTypes!.add(EntryTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cbal'] = cbal;
    data['weaver_id'] = weaverId;
    data['printed'] = printed;
    data['current_status'] = currentStatus;
    data['finished_date'] = finishedDate;
    data['message_text'] = messageText;
    data['sub_weaver_no'] = subWeaverNo;
    data['loom_no'] = loomNo;
    data['product_id'] = productId;
    data['wages'] = wages;
    data['firm_id'] = firmId;
    data['transaction_type'] = transactionType;
    data['cops_reels'] = copsReels;
    data['width_pick'] = widthPick;
    data['width'] = width;
    data['pick'] = pick;
    data['pinning'] = pinning;
    data['comp_check'] = compCheck;
    data['wages_ano'] = wagesAno;
    data['deduction'] = deduction;
    data['lock_id'] = lockId;
    data['line_print'] = linePrint;
    data['card_no'] = cardNo;
    data['private_weft'] = privateWeft;
    data['contract_weav'] = contractWeav;
    data['card_char'] = cardChar;
    data['weaver_name'] = weaverName;
    data['product_name'] = productName;
    data['firm_name'] = firmName;
    data['unit_length'] = unitLength;
    data['design_no'] = designNo;
    data['color'] = color;
    data['design_image'] = designImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_name'] = createdName;
    data['updated_name'] = updatedName;
    if (entryTypes != null) {
      data['entry_types'] = entryTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EntryTypes {
  int? id;
  int? weavingAcId;
  String? entryType;
  int? status;
  String? createdAt;
  String? updatedAt;

  EntryTypes({
    this.id,
    this.weavingAcId,
    this.entryType,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  EntryTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weavingAcId = json['weaving_ac_id'];
    entryType = json['entry_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['weaving_ac_id'] = weavingAcId;
    data['entry_type'] = entryType;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
