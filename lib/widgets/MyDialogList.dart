import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDialogList extends StatefulWidget {
  final Function onCreateNew;
  final TextEditingController controller;
  final Function onItemSelected;
  List<dynamic> list;
  final String labelText;
  final bool showCreateNew;
  final bool isValidate;

  MyDialogList({
    Key? key,
    required this.onCreateNew,
    required this.controller,
    required this.onItemSelected,
    this.list = const [],
    required this.labelText,
    this.showCreateNew = false,
    this.isValidate = true,
  }) : super(key: key);

  @override
  State<MyDialogList> createState() => _MyDialogListState();
}

class _MyDialogListState extends State<MyDialogList> {
  RxList<dynamic> filterList = RxList([]);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        onTap: () async {
          var item = await initList(context, widget.labelText);
          if (item != null) {
            widget.onItemSelected(item);
          }
        },
        readOnly: true,
        style: const TextStyle(
          color: Color(0xFF141414),
          fontSize: 14,
          fontFamily: 'Poppins',
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: const TextStyle(fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          border: const OutlineInputBorder(),
          labelText: '${widget.labelText}',
          suffixIcon: widget.showCreateNew == true
              ? IconButton(
                  onPressed: () {
                    widget.onCreateNew('');
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.orange,
                  ),
                )
              : null,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF939393),
              width: 0.4,
            ),
          ),
        ),
        validator: (value) {
          if (widget.isValidate == true) {
            if (GetUtils.isNullOrBlank('$value') == true) {
              return 'Required';
            }
          }

          return null;
        },
      ),
    );
  }

  initList(BuildContext context, String labelText) {
    filterList.value = widget.list;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search ${labelText}...',
              border: InputBorder.none,
            ),
            onChanged: (search) => searchFilter(search),
          ),
          content: SizedBox(
            width: 300,
            child: Obx(() => ListView.builder(
                  shrinkWrap: false,
                  itemCount: filterList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = filterList[index];
                    return ListTile(
                      onTap: () => Get.back(result: item),
                      title: Text(
                        '${item}',
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  },
                )),
          ),
        );
      },
    );
  }

  searchFilter(String search) {
    print(search);
    if (search.isNotEmpty) {
      filterList.value = widget.list
          .where((element) =>
              element.toString().toLowerCase().contains(search.toLowerCase()))
          .toList();
    } else {
      filterList.value = widget.list;
    }
  }
}
