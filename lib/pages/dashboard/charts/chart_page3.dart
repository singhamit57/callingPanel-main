import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/pages/dashboard/dashboardpages/dashboard_controller.dart';
import 'package:callingpanel/widgets/responsive/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Todo {
  String name;
  bool enable;
  Todo({this.enable = true, required this.name});
}

// ignore: unused_element
List<Todo> _todos = [
  Todo(name: "Purchase Paper", enable: true),
  Todo(name: "Refill the inventory of speakers", enable: true),
  Todo(name: "Hire someone", enable: true),
  Todo(name: "Maketing Strategy", enable: true),
  Todo(name: "Selling furniture", enable: true),
  Todo(name: "Finish the disclosure", enable: true),
];

class PanelLeftPage extends StatefulWidget {
  const PanelLeftPage({Key? key}) : super(key: key);

  @override
  _PanelLeftPageState createState() => _PanelLeftPageState();
}

DashBoardCtrl? dashBoardCtrl;

class _PanelLeftPageState extends State<PanelLeftPage> {
  @override
  void initState() {
    dashBoardCtrl = Get.find<DashBoardCtrl>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (ResponsiveLayout.isComputer(context))
            Container(
              color: Get.theme.primaryColor,
              width: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.primaryColorDark,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                  ),
                ),
              ),
            ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: Constants.kdPadding / 2,
                      top: Constants.kdPadding / 2,
                      right: Constants.kdPadding / 2),
                  child: Card(
                    color: Get.theme.primaryColor,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ListTile(
                        //leading: Icon(Icons.shopping_basket),
                        title: const Text(
                          "Products Sold",
                          style: TextStyle(color: Colors.white),
                        ),

                        trailing: Chip(
                          label: Obx(() => Text(
                                dashBoardCtrl!.productsold.value,
                                style: const TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                // LineChartSample2(),
                // buildPieChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/*
Padding(
                  padding: const EdgeInsets.only(
                      right: Constants.kdPadding / 2,
                      bottom: Constants.kdPadding,
                      top: Constants.kdPadding,
                      left: Constants.kdPadding / 2),
                  child: Card(
                    color: Get.theme.primaryColor,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: List.generate(
                        _todos.length,
                        (index) => CheckboxListTile(
                          title: Text(
                            _todos[index].name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          value: _todos[index].enable,
                          onChanged: (newValue) {
                            setState(() {
                              _todos[index].enable = newValue ?? true;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),

*/