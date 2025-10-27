import 'package:abtxt/view/production/production_controller.dart';
import 'package:abtxt/view/production/wages_bill/wages_bill_list.dart';
import 'package:abtxt/view/production/weaving/add_weaving.dart';
import 'package:abtxt/view/production/weaving/weaving_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'loom_declaration/loom_declaration_list.dart';

class production extends StatefulWidget {
  const production({Key? key}) : super(key: key);

  @override
  State<production> createState() => _State();
}

class _State extends State<production> {
  production_controller controller = Get.put(production_controller());
  @override
  void initState() {
    controller.searchFilter("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<production_controller>(builder: (controller) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9F3FF),
        appBar: AppBar(
          title: TextField(
            onChanged: (search) => controller.searchFilter(search),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search...',
              border: InputBorder.none,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: controller.filterList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount:
                  (MediaQuery.of(context).size.width ~/ 250).toInt(),
            ),
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> map = controller.filterList[index];
              var item = map['title'];
              var icon = map['icon'];
              var color = map['color'];
              return Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                ),
                child: InkWell(
                  onTap: () => itemClicked('$item'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: ShapeDecoration(
                                color: color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            Center(
                              child:
                                  Image.asset(height: 50, width: 50, '$icon'),
                            ),
                          ],
                        ),
                        Text(
                          '$item',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  itemClicked(String item) {
    switch (item) {
      case 'Loom Declaration':
        Get.toNamed(LoomDeclarationList.routeName);
        break;
      case 'Weaving':
        Get.toNamed(AddWeaving.routeName);
        // Get.snackbar("Alert", "Working in progress");
        break;

      case 'Wages Bill':
        Get.toNamed(WagesBillList.routeName);
        break;
    }
  }
}
