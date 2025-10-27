class WarpORYarnDeliveryModel {
  int? id;
  int? weaverId;
  String? currentStatus;
  String? weaverName;
  String? creatorName;
  int? challanNo;
  String? eDate;
  String? entryType;
  int? loom;
  List<ItemDetails>? itemDetails;

  WarpORYarnDeliveryModel(
      {this.id,
        this.weaverId,
        this.currentStatus,
        this.weaverName,
        this.creatorName,
        this.challanNo,
        this.eDate,
        this.entryType,
        this.loom,
        this.itemDetails});

  WarpORYarnDeliveryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weaverId = json['weaver_id'];
    currentStatus = json['current_status'];
    weaverName = json['weaver_name'];
    creatorName = json['creator_name'];
    challanNo = json['challan_no'];
    eDate = json['e_date'];
    entryType = json['entry_type'];
    loom = json['loom'];
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(new ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['weaver_id'] = this.weaverId;
    data['current_status'] = this.currentStatus;
    data['weaver_name'] = this.weaverName;
    data['creator_name'] = this.creatorName;
    data['challan_no'] = this.challanNo;
    data['e_date'] = this.eDate;
    data['entry_type'] = this.entryType;
    data['loom'] = this.loom;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? weavingAcId;
  int? challanNo;
  String? transactionType;
  String? eDate;
  String? entryType;
  Null? warpDesignId;
  Null? debit;
  Null? credit;
  Null? warpId;
  Null? warpQty;
  Null? qty;
  Null? meter;
  Null? warpType;
  int? bmOut;
  int? bmIn;
  int? bbnOut;
  int? bbnIn;
  int? shtIn;
  int? shtOut;
  int? copsIn;
  int? copsOut;
  int? reelOut;
  int? reelIn;
  int? yarnId;
  int? yarnColorId;
  String? yarnEmptyType;
  int? yarnPack;
  double? yarnGrossQty;
  int? yarnSingleEmptyWt;
  int? yarnLessWt;
  double? yarnQty;
  Null? productId;
  Null? productWidth;
  Null? pick;
  Null? inwardMeter;
  Null? inwardQty;
  Null? unitMeter;
  int? rowNo;
  Null? pinning;
  Null? wages;
  Null? damaged;
  String? productDetails;
  Null? pending;
  Null? pendingQty;
  Null? pendingMeter;
  Null? weDetails;
  Null? woDetails;
  Null? msgFont;
  Null? msgType;
  Null? prLedgerId;
  Null? transToNo;
  Null? confirmNo;
  String? stockIn;
  String? boxNo;
  String? boxSerialNo;
  String? transNo;
  String? acNo;
  Null? deduction;
  int? deliveryWeight;
  int? receivedWeight;
  Null? paymentType;
  Null? acConfirmNo;
  Null? giAlipRecNo;
  Null? wbRecNo;
  int? deliRecNo;
  Null? emptyToken;
  Null? workNo;
  int? copsNo;
  int? reelNo;
  Null? msgText;
  int? coneIn;
  int? coneOut;
  int? coneNo;
  Null? cgstPerc;
  Null? sgstPerc;
  Null? igstPerc;
  Null? cessPerc;
  Null? sacNo;
  String? challanChar;
  int? prodOrderRecNo;
  int? prodOrderRowNo;
  int? prodOrderExpQty;
  int? prodOrderExpPno;
  int? prodOrderExpWno;
  Null? actDeliWt;
  Null? actReceWt;
  Null? fillingStatus;
  Null? fillingInfo;
  int? printed;
  int? sNo;
  int? status;
  Null? createdBy;
  Null? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? yarnName;
  String? colorName;

  ItemDetails(
      {this.id,
        this.weavingAcId,
        this.challanNo,
        this.transactionType,
        this.eDate,
        this.entryType,
        this.warpDesignId,
        this.debit,
        this.credit,
        this.warpId,
        this.warpQty,
        this.qty,
        this.meter,
        this.warpType,
        this.bmOut,
        this.bmIn,
        this.bbnOut,
        this.bbnIn,
        this.shtIn,
        this.shtOut,
        this.copsIn,
        this.copsOut,
        this.reelOut,
        this.reelIn,
        this.yarnId,
        this.yarnColorId,
        this.yarnEmptyType,
        this.yarnPack,
        this.yarnGrossQty,
        this.yarnSingleEmptyWt,
        this.yarnLessWt,
        this.yarnQty,
        this.productId,
        this.productWidth,
        this.pick,
        this.inwardMeter,
        this.inwardQty,
        this.unitMeter,
        this.rowNo,
        this.pinning,
        this.wages,
        this.damaged,
        this.productDetails,
        this.pending,
        this.pendingQty,
        this.pendingMeter,
        this.weDetails,
        this.woDetails,
        this.msgFont,
        this.msgType,
        this.prLedgerId,
        this.transToNo,
        this.confirmNo,
        this.stockIn,
        this.boxNo,
        this.boxSerialNo,
        this.transNo,
        this.acNo,
        this.deduction,
        this.deliveryWeight,
        this.receivedWeight,
        this.paymentType,
        this.acConfirmNo,
        this.giAlipRecNo,
        this.wbRecNo,
        this.deliRecNo,
        this.emptyToken,
        this.workNo,
        this.copsNo,
        this.reelNo,
        this.msgText,
        this.coneIn,
        this.coneOut,
        this.coneNo,
        this.cgstPerc,
        this.sgstPerc,
        this.igstPerc,
        this.cessPerc,
        this.sacNo,
        this.challanChar,
        this.prodOrderRecNo,
        this.prodOrderRowNo,
        this.prodOrderExpQty,
        this.prodOrderExpPno,
        this.prodOrderExpWno,
        this.actDeliWt,
        this.actReceWt,
        this.fillingStatus,
        this.fillingInfo,
        this.printed,
        this.sNo,
        this.status,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.yarnName,
        this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weavingAcId = json['weaving_ac_id'];
    challanNo = json['challan_no'];
    transactionType = json['transaction_type'];
    eDate = json['e_date'];
    entryType = json['entry_type'];
    warpDesignId = json['warp_design_id'];
    debit = json['debit'];
    credit = json['credit'];
    warpId = json['warp_id'];
    warpQty = json['warp_qty'];
    qty = json['qty'];
    meter = json['meter'];
    warpType = json['warp_type'];
    bmOut = json['bm_out'];
    bmIn = json['bm_in'];
    bbnOut = json['bbn_out'];
    bbnIn = json['bbn_in'];
    shtIn = json['sht_in'];
    shtOut = json['sht_out'];
    copsIn = json['cops_in'];
    copsOut = json['cops_out'];
    reelOut = json['reel_out'];
    reelIn = json['reel_in'];
    yarnId = json['yarn_id'];
    yarnColorId = json['yarn_color_id'];
    yarnEmptyType = json['yarn_empty_type'];
    yarnPack = json['yarn_pack'];
    yarnGrossQty = json['yarn_gross_qty'];
    yarnSingleEmptyWt = json['yarn_single_empty_wt'];
    yarnLessWt = json['yarn_less_wt'];
    yarnQty = json['yarn_qty'];
    productId = json['product_id'];
    productWidth = json['product_width'];
    pick = json['pick'];
    inwardMeter = json['inward_meter'];
    inwardQty = json['inward_qty'];
    unitMeter = json['unit_meter'];
    rowNo = json['row_no'];
    pinning = json['pinning'];
    wages = json['wages'];
    damaged = json['damaged'];
    productDetails = json['product_details'];
    pending = json['pending'];
    pendingQty = json['pending_qty'];
    pendingMeter = json['pending_meter'];
    weDetails = json['we_details'];
    woDetails = json['wo_details'];
    msgFont = json['msg_font'];
    msgType = json['msg_type'];
    prLedgerId = json['pr_ledger_id'];
    transToNo = json['trans_to_no'];
    confirmNo = json['confirm_no'];
    stockIn = json['stock_in'];
    boxNo = json['box_no'];
    boxSerialNo = json['box_serial_no'];
    transNo = json['trans_no'];
    acNo = json['ac_no'];
    deduction = json['deduction'];
    deliveryWeight = json['delivery_weight'];
    receivedWeight = json['received_weight'];
    paymentType = json['payment_type'];
    acConfirmNo = json['ac_confirm_no'];
    giAlipRecNo = json['gi_alip_rec_no'];
    wbRecNo = json['wb_rec_no'];
    deliRecNo = json['deli_rec_no'];
    emptyToken = json['empty_token'];
    workNo = json['work_no'];
    copsNo = json['cops_no'];
    reelNo = json['reel_no'];
    msgText = json['msg_text'];
    coneIn = json['cone_in'];
    coneOut = json['cone_out'];
    coneNo = json['cone_no'];
    cgstPerc = json['cgst_perc'];
    sgstPerc = json['sgst_perc'];
    igstPerc = json['igst_perc'];
    cessPerc = json['cess_perc'];
    sacNo = json['sac_no'];
    challanChar = json['challan_char'];
    prodOrderRecNo = json['prod_order_rec_no'];
    prodOrderRowNo = json['prod_order_row_no'];
    prodOrderExpQty = json['prod_order_exp_qty'];
    prodOrderExpPno = json['prod_order_exp_pno'];
    prodOrderExpWno = json['prod_order_exp_wno'];
    actDeliWt = json['act_deli_wt'];
    actReceWt = json['act_rece_wt'];
    fillingStatus = json['filling_status'];
    fillingInfo = json['filling_info'];
    printed = json['printed'];
    sNo = json['s_no'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['weaving_ac_id'] = this.weavingAcId;
    data['challan_no'] = this.challanNo;
    data['transaction_type'] = this.transactionType;
    data['e_date'] = this.eDate;
    data['entry_type'] = this.entryType;
    data['warp_design_id'] = this.warpDesignId;
    data['debit'] = this.debit;
    data['credit'] = this.credit;
    data['warp_id'] = this.warpId;
    data['warp_qty'] = this.warpQty;
    data['qty'] = this.qty;
    data['meter'] = this.meter;
    data['warp_type'] = this.warpType;
    data['bm_out'] = this.bmOut;
    data['bm_in'] = this.bmIn;
    data['bbn_out'] = this.bbnOut;
    data['bbn_in'] = this.bbnIn;
    data['sht_in'] = this.shtIn;
    data['sht_out'] = this.shtOut;
    data['cops_in'] = this.copsIn;
    data['cops_out'] = this.copsOut;
    data['reel_out'] = this.reelOut;
    data['reel_in'] = this.reelIn;
    data['yarn_id'] = this.yarnId;
    data['yarn_color_id'] = this.yarnColorId;
    data['yarn_empty_type'] = this.yarnEmptyType;
    data['yarn_pack'] = this.yarnPack;
    data['yarn_gross_qty'] = this.yarnGrossQty;
    data['yarn_single_empty_wt'] = this.yarnSingleEmptyWt;
    data['yarn_less_wt'] = this.yarnLessWt;
    data['yarn_qty'] = this.yarnQty;
    data['product_id'] = this.productId;
    data['product_width'] = this.productWidth;
    data['pick'] = this.pick;
    data['inward_meter'] = this.inwardMeter;
    data['inward_qty'] = this.inwardQty;
    data['unit_meter'] = this.unitMeter;
    data['row_no'] = this.rowNo;
    data['pinning'] = this.pinning;
    data['wages'] = this.wages;
    data['damaged'] = this.damaged;
    data['product_details'] = this.productDetails;
    data['pending'] = this.pending;
    data['pending_qty'] = this.pendingQty;
    data['pending_meter'] = this.pendingMeter;
    data['we_details'] = this.weDetails;
    data['wo_details'] = this.woDetails;
    data['msg_font'] = this.msgFont;
    data['msg_type'] = this.msgType;
    data['pr_ledger_id'] = this.prLedgerId;
    data['trans_to_no'] = this.transToNo;
    data['confirm_no'] = this.confirmNo;
    data['stock_in'] = this.stockIn;
    data['box_no'] = this.boxNo;
    data['box_serial_no'] = this.boxSerialNo;
    data['trans_no'] = this.transNo;
    data['ac_no'] = this.acNo;
    data['deduction'] = this.deduction;
    data['delivery_weight'] = this.deliveryWeight;
    data['received_weight'] = this.receivedWeight;
    data['payment_type'] = this.paymentType;
    data['ac_confirm_no'] = this.acConfirmNo;
    data['gi_alip_rec_no'] = this.giAlipRecNo;
    data['wb_rec_no'] = this.wbRecNo;
    data['deli_rec_no'] = this.deliRecNo;
    data['empty_token'] = this.emptyToken;
    data['work_no'] = this.workNo;
    data['cops_no'] = this.copsNo;
    data['reel_no'] = this.reelNo;
    data['msg_text'] = this.msgText;
    data['cone_in'] = this.coneIn;
    data['cone_out'] = this.coneOut;
    data['cone_no'] = this.coneNo;
    data['cgst_perc'] = this.cgstPerc;
    data['sgst_perc'] = this.sgstPerc;
    data['igst_perc'] = this.igstPerc;
    data['cess_perc'] = this.cessPerc;
    data['sac_no'] = this.sacNo;
    data['challan_char'] = this.challanChar;
    data['prod_order_rec_no'] = this.prodOrderRecNo;
    data['prod_order_row_no'] = this.prodOrderRowNo;
    data['prod_order_exp_qty'] = this.prodOrderExpQty;
    data['prod_order_exp_pno'] = this.prodOrderExpPno;
    data['prod_order_exp_wno'] = this.prodOrderExpWno;
    data['act_deli_wt'] = this.actDeliWt;
    data['act_rece_wt'] = this.actReceWt;
    data['filling_status'] = this.fillingStatus;
    data['filling_info'] = this.fillingInfo;
    data['printed'] = this.printed;
    data['s_no'] = this.sNo;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['yarn_name'] = this.yarnName;
    data['color_name'] = this.colorName;
    return data;
  }
}
