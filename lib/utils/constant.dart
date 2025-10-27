import 'dart:ui';

class Constants {
  static const inrCurrencySynmbol = '₹';

  static const placeHolderPath = 'assets/images/Select Image.png';

  static List<int> PAGING = [10, 25, 50, 100];

  static List<String> STATES = [
    'Tamil Nadu',
    'Kerala',
  ];
  static List<String> chartDropdown = [
    "This Week",
    "This Month",
    "Last Month",
  ];

  static List<String> ROLES = [
    'Supplier',
    'Customer',
    'Cleaner',
    'Weaver',
    'Warper',
    'Roller',
    'Dyer',
    'Job Worker',
  ];

  static List<String> LINK_THROUGH = [
    'Self',
    'Agent',
  ];
  static List<String> Wages_Type = ['Winder', 'TFO', 'Jari'];

  static List<String> WI_USEDEMPTY = [
    'Beam',
    'Bobbin',
    'Nothing',
  ];
  static List<String> Freight = [
    'To Pay',
    'Paid',
  ];
  static List<String> ThroughLorry = [
    'VRL Transport',
    'VR Transport',
  ];
  static List<String> InvoiceNo = [
    'None',
    'Product Sale',
  ];
  static List<String> To = [
    'Kalyan Silks & Saree',
    'Kalyan Silks',
  ];

  static List<String> REGISTRAION = [
    'Registered',
    'Non-Registered',
  ];

  static List<String> ISACTIVE = [
    "Yes",
    "No",
  ];
  static List<String> Ledger_Registration = [
    "R",
    "U",
  ];
  static List<String> Stock_ACTIVE = [
    "Yes",
    "No",
  ];
  static List<String> Intergrated = [
    "No",
    "Yes",
  ];
  static List<String> newUnitActiveStatus = [
    "No",
    "Yes",
  ];

  static List<String> WARP_CONDITION = [
    "Dyed",
    "Undyed",
  ];
  static List<String> Used_Empty = [
    "Bobbin",
    "Sheet",
    "Beam",
    "Nothing",
  ];
  static List<String> AGAINST = [
    "on Account",
    "Bill/Ref Nos",
  ];
  static List<String> TRANSACTION_TYPE = [
    "Old",
    "Fresh",
  ];

  static List<String> REFRENCENO = [
    "1",
    "2",
    "3",
    "4",
  ];

  static List<String> STOCK_TO = [
    "Office",
    "Godown",
    "Warehouse",
  ];

  static List<String> WORK = [
    "Yes",
    "No",
  ];

  static List<String> YARNNAMECONTROLLER = [
    '110 Karishma',
    'Cotton',
    'Silk',
  ];
  static List<String> STOCKIN = [
    '110 Karishma',
    'Cotton',
    'Silk',
  ];
  static List<String> COLLER_NAME = [
    'White',
    'Green',
    'Blue',
  ];
  static List<String> BOXNO = [
    'A-1234',
    'B-012',
    'C-321',
  ];

  static List<String> ACTIVE = [
    "ACTIVE",
    "INACTIVE",
  ];
  static List<String> ACOUNTNAME = [
    'TEST',
    'ACOUNT',
    'BANK',
  ];
  static List<String> TYPE = [
    "Cops",
    "Cops_Reel",
  ];
  static List<String> decimalTypes = [
    "0",
    "0.0",
    "0.00",
    "0.000",
    "0.0000",
  ];
  static List<String> Decimal = [
    "000",
    "111",
    "1001",
  ];
  static List<String> WorkType = [
    "Job Work",
    "Process Work",
  ];
  static List<String> GroupName = [
    "Embose Silk Saree",
    "Embose Saree",
  ];
  static List<String> ENTRY_TYPES = [
    "Inward",
    "Return",
    "Wastage",
    "Excess",
  ];
  static List<String> ENTRY_TYPES_PROCESS = [
    "Delivery",
    "Inward",
  ];
  static List<String> ENTRY_TYPES_PRODUCTION = [
    "Yarn Delivery",
    "Warp Delivery",
    // "Empty - (In / Out)",
    "Rtrn-Yarn",
    // "Inward - Cops, Reel",
  ];
  static List<String> TWISTING_ENTRY_TYPES = [
    "Opening Balance",
    "Delivery",
    "Yarn Inward",
    "Warp Inward",
    "Order-Warp",
    "Wastage",
    "Transfer-Weight",
  ];
  static List<String> WEAVING_REPORTS = [
    "Finished Warp List",
    "Weaver - Yarn Stock Report",
    "Weaver Yarn Stock - Cross Check",
    "Yarn Delivery Balance Report",
    "Weaver - (Other) Warp Stock Report",
    "Product or MainWarp Balance Report",
    "Yarn Delivery Report",
    "Goods Inward Report",
    "Goods Inward - Last Wages Report",
    "Message Report",
    "Last Entry Report",
    "Weaver Absent Report",
    "Advance Issued Report",
    "Wages Deducted Report",
    "Day Book Report",
    "Weaver List",
    "Loom List",
    "Weight, Amount Balance Report",
    "( Datewise ) Wages Report",
    "WeaverWise A/C Balance Report",
    "Beam / Bobbin Token Report",
    "Delivered - Weft Colours",
    "Weaver Balance ( Pure Silk )",
    "Manual Warp Notification",
    "Warp Notification Report",
    "Weft Colour Report",
  ];

  static List<String> WARP_COLOR = [
    "Green",
    "Red",
    "White",
    "Blue",
  ];
  static List<String> WEFT_COLOR = [
    "Green",
    "Red",
    "White",
    "Blue",
    "white",
  ];

  static List<String> Header = [
    "Warp 80s",
    "Warp 90s",
    "Warp 70s",
  ];
  static List<String> Unit = [
    "Saree",
    "Set",
    "Sudi",
  ];

  //Adjustment
  static List<String> ADJUSTMENT_IN = [
    "Office",
    "OutSide",
    "Work",
  ];
  static List<String> Pattern = [
    "Nothing",
    "Design Sheet",
  ];
  static List<String> Group = [
    "Embose warp",
    "Embose warp-2",
    "Embose warp-3",
  ];
  static List<String> WarpType = [
    "Main Warp",
    "Other",
  ];
  static List<String> UsedEmpty = [
    "All",
    "Weaving",
    "Sales",
  ];
  static List<String> WarpCondition = [
    "Dyed",
    "UnDyed",
  ];
  static List<String> WarpID = [
    "W05-01",
    "W05-02",
  ];
  static List<String> WarperName = [
    "Dhamu",
    "Sami",
  ];
  static List<String> RollerName = [
    "Rangasami",
    "Sami",
  ];
  static List<String> WarpDesign = [
    "400+4000+400",
    "1200+4000+800",
  ];
  static List<String> AccountType = [
    "Dyeing Wages",
    "Dyeing ",
    "Product Purchase",
  ];
  static List<String> YarnName = [
    "80s Cotton",
    "90s Cotton",
    "100s Cotton",
  ];
  static List<String> SupplierName = [
    "Karmegam",
    "RAja",
  ];
  static List<String> WeavingStatus = [
    "New",
    "Running",
  ];
  static List<String> LengthType = [
    "Metre",
    "Yards",
  ];
  static List<String> chargesPer = [
    "Length",
    "Yarn Usage",
  ];
  static List<String> WeaverName = [
    "Unit",
    "Length",
  ];
  static List<String> GH = [
    "Unit",
    "Length",
  ];
  static List<String> WarpStatu = [
    "New",
    "Running",
    "Finished",
  ];
  static List<String> FromNotification = [
    "No",
    "Yes",
  ];
  static List<String> WarpDeliveryto = [
    "Weaver",
    "Role",
  ];
  static List<String> LedgerName = [
    "Senthil-Warp",
    "Senthil-Warp-2",
  ];
  static List<String> Orderfor = [
    "Purchase",
    "Sale",
  ];
  static List<String> WarpOrderType = [
    "Use Warp ID",
    "Use Warp Name",
  ];
  static List<String> Firm = [
    "AB Textile Pvt Ltd",
    "bB Textile Pvt Ltd",
  ];
  static List<String> ProductName = [
    "Embose Silk Saree",
    "Embose Silk Saree_2",
    "Embose Silk Saree_3",
  ];
  static List<String> Wagesbill_Entrytype = [
    "Payment",
    "Debit",
  ];
  static List<String> CalculateType = [
    "Qty x Rate",
    "Pack x Rate",
  ];
  static List<String> Calculate_Adj = [
    "Stoc + Qty",
    "Stoc - Qty",
  ];
  static List<String> ENTRYTYPE = [
    "Delivery+Order",
    "Delivery",
    "Order",
  ];
  static List<String> DELIVERY_FROM = [
    "Shop",
    "Office",
  ];
  static List<String> YARNNAME = [
    "110 Karishma",
    "130 Karishma",
    "120 Karishma",
  ];
  static List<String> COLOURS = [
    "White",
    "BLACK",
    "WHITE",
  ];
  static List<String> DyerName = [
    "White-1",
    "BLACK-2",
    "WHITE=3",
  ];
  static List<String> ColorName = [
    "Orange",
    "BLACK-2",
    "WHITE=3",
  ];
  static List<String> PackName = [
    "Purple",
    "BLACK-2",
    "WHITE=3",
  ];
  static List<String> Red = [
    "Color",
    "BLACK-2",
    "WHITE=3",
  ];
  static List<String> FirmNo = [
    "Ganapathy",
    "Krishna",
    "Rama",
  ];
  static List<String> AccountName = [
    "Home",
    "Tamil",
    "English",
  ];
  static List<String> Colorname = [
    "2",
    "Tamil",
    "English",
  ];
  static List<String> Stock = [
    "Godown",
    "Office",
  ];
  static List<String> Calculate = [
    "4",
    "House",
    "Fort",
  ];
  static List<String> BagBox = [
    "18",
    "Tamil",
    "English",
  ];
  static List<String> Yarn = [
    "17",
    "Tamil",
    "English",
  ];
  static List<String> color = [
    "18",
    "Tamil",
    "English",
  ];
  static List<String> Delivered = [
    "30",
    "Tamil",
    "English",
  ];
  static List<String> type = [
    "on Account",
    "Yarn Sales",
    "Warp Sales",
    "Product Sales",
  ];
  static List<String> firm = [
    "1",
    "Tamil",
    "English",
  ];
  static List<String> customer = [
    "2",
    "Tamil",
    "English",
  ];
  static List<String> invoice = [
    "1",
    "2",
    "3",
  ];
  static List<String> account = [
    "4",
    "Tamil",
    "English",
  ];
  static List<String> to = [
    "Cash",
    "Bank",
  ];
  static List<String> freight = [
    "To Pay",
    "Paid",
  ];
  static List<String> transport = [
    "VRL Transport",
    "Tamil",
    "English",
  ];
  static List<String> WarpStatusController = [
    "Yes",
    "No",
  ];
  static List<String> LOOMNO = [
    "22",
    "Tamil",
    "English",
  ];
  static List<String> EF = [
    "33",
    "Tamil",
    "English",
  ];
  static List<String> LOOM = [
    "1",
    "2",
    "3",
    "4",
  ];

  static List<String> Processor = [
    "01",
    "Tamil",
    "English",
  ];
  static List<String> Account = [
    "02",
    "Tamil",
    "English",
  ];
  static List<String> Trasaction = [
    "03",
    "Tamil",
    "English",
  ];
  static List<String> TrasactionType = ["Old, Fresh", "Fresh"];
  static List<String> WagesBill_Type = [
    "Wages",
    "WagesAmount",
  ];
  static List<String> AGENT = [
    "Main Agent",
    "Worker",
    "Agent",
  ];
  static List<String> Wages = [
    "03",
    "Tamil",
    "English",
  ];
  static List<String> WagesBill_To = [
    "Cash",
    "Indian bank",
    "State bank",
    "TMB bank",
  ];
  static List<String> THROUGH = [
    "Phone",
    "Mobile",
    "LandLine",
  ];
  static List<String> Warper = [
    "A",
    "Tamil",
    "English",
  ];
  static List<String> YarnDelivery = [
    "B",
    "Tamil",
    "English",
  ];
  static List<String> Tokes = [
    "Wages",
    "Amount",
  ];
  static List<String> WarpDying = [
    "D",
    "Tamil",
    "English",
  ];
  static List<String> Holder = [
    "Cops",
    "Reel",
    "Nothing",
  ];
  static List<String> Active = [
    "1",
    "Tamil",
    "English",
  ];

  //Twisting or warping
  static List<String> WAGESACCOUNT = [
    "1",
    "2",
    "3",
  ];
  static List<String> WARPERNAME = [
    "1",
    "2",
    "3",
  ];
  static List<String> TRANSACTIONTYPE = [
    'Test',
    'Account',
    'Bank',
    'Merchant',
  ];

  static List<String> TWISTER_ENTRY_TYPES = [
    "one",
    "two",
    "three",
  ];

//Twisting _delivery

  static List<String> DELIVERY = [
    "one",
    "two",
    "three",
  ];
  static List<String> COLORNAME = [
    "one",
    "two",
    "three",
  ];
  static List<String> DELIVERYFROM = [
    "one",
    "two",
    "three",
  ];
  static List<String> FOLDER = [
    "one",
    "two",
    "three",
  ];

  //Twister_Yarn Inward

  static List<String> YI_YARNNAME = [
    "one",
    "two",
    "three",
  ];
  static List<String> YI_COLORNAME = [
    "Red",
    "Blue",
    "White",
  ];
  static List<String> YI_STOCKTO = [
    "one",
    "two",
    "three",
  ];
  static List<String> YI_STOCK = [
    "one",
    "two",
    "three",
  ];

  static List<String> NatureofGroups = [
    "Liabilities",
    "Liabilities-2",
  ];
  static List<String> City = [
    "Salem",
    "Chennai",
  ];
  static List<String> Country = [
    "India",
    "Usa",
  ];
  static List<String> Hint = [
    "0",
    "1",
  ];
  static List<String> WinderName = [
    "Kannan",
    "RAja",
  ];
  static List<String> Against = [
    "Sales No / Ref No",
    "On Account",
  ];
  static List<String> ReferenceNo = [
    "12",
    "13",
  ];
  static List<String> Weight = [
    "No",
    "Yes",
  ];
  static List<String> productInfoUnits = <String>[
    "Saree",
    "Meters",
    "Pavada",
    "Set",
    "Pieces",
    "Nos",
    "Yards",
  ];
  static List<String> Recuirments = [
    "Unit",
    "Length",
  ];
  static List<String> by = [
    "Cash",
    "Checque",
    "Online Transaction",
  ];

  static List<String> Transaction_type = [
    "yes",
    "no",
  ];

  static List<String> In = [
    "KG",
    "Pound",
  ];

  static List<String> messageType = [
    "Normal",
    "Complaint",
  ];
  static List<String> Language = [
    "English",
    "தமிழ்",
    "हिंदी",
  ];
  static List<String> Credit = [
    "Completed",
    "Pending",
    "Process",
  ];
  static List<String> Debit = [
    "Completed",
    "Pending",
    "Process",
  ];
  static List<String> ENTRY_TYPE = [
    "Inward",
    "Return",
    "Wastage",
    "Excess",
  ];
  static List<String> Warp_Or_Yarn = [
    "Warp Delivery",
    "Yarn Delivery",
    "Yarn Inward",
    "Warp Inward",
  ];
  static List<String> WarpYarndying = [
    "Warp Delivery",
    "Yarn Delivery",
    "Yarn Inward",
    "Warp Inward",
  ];
  static List<String> language = [
    "English",
    "Local",
  ];
  static List<String> PRODUCTION_ENTRY_TYPE = [
    "Warp Delivery",
    "Yarn Delivery",
    "Goods Inward",
    "Payment",
    "Empty - (In / Out)",
    "Receipt",
    "Rtrn - Yarn",
    "Credit",
    "Debit",
    "Yarn Wastage",
    "Warp Excess",
    "Warp Shortage",
    "Message",
    "Trsfr - Amount",
    "Trsfr - Cops,Reel",
    "Trsfr - Empty",
    "Trsfr - Warp",
    "Trsfr - Yarn",
    "Adjustment Wt",
    "O.Bal - Empty",
    "Inward - Cops, Reel",
  ];
  static List<String> amountType = [
    "Credit",
    "Debit",
  ];
  static List<String> emptyType = [
    "Beam",
    "Bobbin",
    "Nothing",
  ];
  static List<String> WeftType = [
    "Main Weft",
    "Other Weft",
  ];
  static List<String> Hints = [
    "Left",
    "Right",
  ];
  static List<String> Destination_to = [
    "Salem",
    "Chennai",
    "Kanchipuram",
    "Arni",
    "Other State",
  ];

  static List<String> Delivered_from = [
    "Godown",
    "Office",
  ];

  static List<String> Calculate_type = [
    "Pack x Wages",
    "Qty x Wages",
  ];

  static List<String> stockTo = [
    "Office",
    "Godown",
  ];

  static List<String> deliveredFrom = [
    "Office",
    "Godown",
  ];

  static List<String> yarnDeliverCalculateType = [
    "Qty x Wages",
    "Pack x Wages",
  ];
  static List<String> Wages_Account = [
    "Dying Wages",
    "Warping Wages",
  ];

  static List<String> deliveredEmpty = [
    "Beam",
    "Bobbin",
  ];

  static List<String> entry = [
    "Delivery",
    "Inward",
    "Return",
  ];

  static List<String> WeavingBreak = [
    "Left",
    "Right",
  ];

  static List<String> order = [
    "Yes",
    "No",
  ];

  static List<String> usedEmpty = [
    "Beam",
    "Bobbin",
    "Nothing",
  ];
  static List<String> Entrytype = [
    "Beam",
    "Bobbin",
  ];

  static List<String> Entry = [
    "Delivery",
    "Return",
  ];
  static List<String> Through = [
    "Phone",
    "E_Mail",
    "Fax",
    "Direct",
  ];
  static List<String> Warp_Type = [
    "Dyed",
    "Not Dyed",
  ];
  static List<String> cashBank = [
    "Cash",
    "Bank Account",
  ];
  static List<String> YarnDeliverWages = [
    "Weight * Wages",
    "Work * Wages",
  ];
  static List<String> TokesDelivery = [
    "Single",
    "Multiple",
  ];
  static List<String> WarpDyingWages = [
    "ProductQyt*Wages",
    "ProductWgt*Wages",
  ];

  static List<String> FromOrder = [
    "No",
    "Yes",
  ];
  static List<String> OrderSNo = [
    "No",
    "Yes",
  ];
  static List<String> status = [
    "Balance",
    "Completed",
  ];

  static List<String> WARP_TYPE = [
    "Main Warp",
    "Other Warp",
  ];

  static List<String> WeeklyIwardDay = [
    "None",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  static List<String> Theme = [
    "Light",
    "Dark",
  ];
  static List<String> DisplaySize = [
    "100%",
    "125%",
    "150%",
    "175%",
    "200%",
    "225%",
  ];

  static List<String> YEARS = [
    "2023",
    "2022",
    "2021",
  ];
  static List<String> WeavingType = [
    "Qty",
    "Qty, Metre",
  ];
  static List<String> WidthPick = [
    "Active",
    "In Active",
  ];
  static List<String> Pinning = [
    "Active",
    "In Active",
  ];
  static List<String> PrivateWeftRecuirment = [
    "Active",
    "In Active",
  ];

  static List<Map<String, dynamic>> BASIC_MENUS = [
    {
      'title': 'Firm',
      'icon': 'assets/Basics Modules Icons/firm.png',
      'color': Color(0xFFFFF1F1),
    },
    {
      'title': 'Account',
      'icon': 'assets/Basics Modules Icons/account.png',
      'color': Color(0xFFFFF2FC),
    },
    {
      'title': 'Ledger',
      'icon': 'assets/Basics Modules Icons/ledger.png',
      'color': Color(0xFFF5ECFF),
    },
    //4
    {
      'title': 'New Colour',
      'icon': 'assets/Basics Modules Icons/new_color.png',
      'color': Color(0xFFFFF6EB),
    },
    //5
    {
      'title': 'New Unit',
      'icon': 'assets/Basics Modules Icons/new_unit.png',
      'color': Color(0xFFE7FAFF),
    },
    //6
    {
      'title': 'Cops-Reel',
      'icon': 'assets/Basics Modules Icons/cops_reel.png',
      'color': Color(0xFFE5FFF8),
    },
    //7
    {
      'title': 'New Yarn',
      'icon': 'assets/Basics Modules Icons/new_yarn.png',
      'color': Color(0xFFF3F3FF),
    },
    //8
    {
      'title': 'Winding Yarn Conversions',
      'icon': 'assets/Basics Modules Icons/winding_yarn_conversion.png',
      'color': Color(0xFFFFEEEE),
    },
    //9
    {
      'title': 'Warp Design Sheet',
      'icon': 'assets/Basics Modules Icons/warp_design sheet.png',
      'color': Color(0xFFF8F2FF),
    },
    //10
    {
      'title': 'Warp Group',
      'icon': 'assets/Basics Modules Icons/warp_group.png',
      'color': Color(0xFFE7FAFF),
    },
    //11
    {
      'title': 'New Warp',
      'icon': 'assets/Basics Modules Icons/new_warp.png',
      'color': Color(0xFFFFFEE3),
    },
    //12
    {
      'title': 'Warping Wages Config',
      'icon': 'assets/Basics Modules Icons/warping_wages_config.png',
      'color': Color(0xFFFFEEEE),
    },
    //warping_design_charges_config.png
    //13_1
    {
      'title': 'Warping Design Charges Config',
      'icon': 'assets/Basics Modules Icons/warping_design_charges_config.png',
      'color': Color(0xFFFFF6EB),
    },
    //13
    {
      'title': 'Warp Supplier Single yarn Rate',
      'icon': 'assets/Basics Modules Icons/warp_supplier_single_yarn_rate.png',
      'color': Color(0xFFF8F2FF),
    },
    //14
    {
      'title': 'Product Group',
      'icon': 'assets/Basics Modules Icons/product_group.png',
      'color': Color(0xFFDBFFF6),
    },
    //15
    {
      'title': 'Product Info',
      'icon': 'assets/Basics Modules Icons/product_info.png',
      'color': Color(0xFFFFF6EB),
    },
    //16
    {
      'title': 'Product Image',
      'icon': 'assets/Basics Modules Icons/product_image.png',
      'color': Color(0xFFF5EDFF),
    },
    //17
    {
      'title': 'Product Weft Requirement',
      'icon': 'assets/Basics Modules Icons/product_weft_requirement.png',
      'color': Color(0xFFE8FBFF),
    },
    //18
    {
      'title': 'Product Job Work',
      'icon': 'assets/Basics Modules Icons/product_jobwork.png',
      'color': Color(0xFFF4EBFF),
    },
    //19

    {
      'title': 'Color Matching',
      'icon': 'assets/Basics Modules Icons/color_matching.png',
      'color': Color(0xFFF3FFDA),
    },
    //20
    {
      'title': 'Costing Entry',
      'icon': 'assets/Basics Modules Icons/costing_entry.png',
      'color': Color(0xFFE1F9FF),
    },
    //21
    {
      'title': 'Costing Change',
      'icon': 'assets/Basics Modules Icons/costing_change.png',
      'color': Color(0xFFFFF2FC),
    },
    //22
    {
      'title': 'Yarn Opening Stock',
      'icon': 'assets/Basics Modules Icons/yarn_opening_stock.png',
      'color': Color(0xFFFFF6EB),
    },
    //23
    {
      'title': 'Warp Opening Stock',
      'icon': 'assets/Basics Modules Icons/warp_opening_stock.png',
      'color': Color(0xFFDBFFF6),
    },
    //24
    {
      'title': 'Product Opening Stock',
      'icon': 'assets/Basics Modules Icons/product_opening_stock.png',
      'color': Color(0xFFF7E8FF),
    },
    //25

    {
      'title': 'Empty Opening Stock',
      'icon': 'assets/Basics Modules Icons/product_opening_stock.png',
      'color': Color(0xFFFFEEEE),
    },
    //26
    {
      'title': 'Ledger Opening Balance',
      'icon': 'assets/Basics Modules Icons/ledger_opening_balance.png',
      'color': Color(0xFFF3F3FF),
    },
    //27
    {
      'title': 'Opening Closing Stock Value',
      'icon': 'assets/Basics Modules Icons/opning_closing_stockvalue.png',
      'color': Color(0xFFE6E6F6),
    },
    //28
    {
      'title': 'Dyer Order Opening Balance',
      'icon': 'assets/Basics Modules Icons/dyer_order_opening_balance.png',
      'color': Color(0xFFE1FAFB),
    },

    //29
    {
      'title': 'Dyer Yarn Opening Balance',
      'icon': 'assets/Basics Modules Icons/dyer_yarn_opening_balance.png',
      'color': Color(0xFFF4F3FF),
    },
    //30

    {
      'title': 'Dyer Warp Opening Balance',
      'icon': 'assets/Basics Modules Icons/dyer_warp_opening_balance.png',
      'color': Color(0xFFF3FFDB),
    },
    //31
    {
      'title': 'Warp Yarn Opening Balance',
      'icon': 'assets/Basics Modules Icons/warper_yarn_opening_balance.png',
      'color': Color(0xFFF3FFDB),
    },
    //32
    {
      'title': 'Roller Warp Opening Balance',
      'icon': 'assets/Basics Modules Icons/roller_warp_opening_balance.png',
      'color': Color(0xFFE5FFF9),
    },
    //33
    {
      'title': 'Winding Yarn Opening Balance',
      'icon': 'assets/Basics Modules Icons/warper_yarn_opening_balance.png',
      'color': Color(0xFFE8FBFF),
    },
    //34
    {
      'title': 'Empty Beam',
      'icon': 'assets/Basics Modules Icons/yarn_opening_stock.png',
      'color': Color(0xFFFFF6EB),
    },
    //35
    {
      'title': 'Process Product Opening Balance',
      'icon': 'assets/Basics Modules Icons/process_product_opening_balance.png',
      'color': Color(0xFFFFFEE3),
    },
    //36
    {
      'title': 'Job Work Product Opening Balance',
      'icon': 'assets/Basics Modules Icons/jobwork_product_opening_balance.png',
      'color': Color(0xFFF3F3FF),
    },
  ];
}
