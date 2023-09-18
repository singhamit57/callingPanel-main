import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/pages/dashboard/dashboardpages/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chart_page2.dart';

class Product {
  String name;
  bool enable;
  Product({this.enable = true, required this.name});
}

List<Product> _products = [
  Product(name: "LED Submersible Lights", enable: true),
  Product(name: "Portable Projector", enable: true),
  Product(name: "Bluetooth Speaker", enable: true),
  Product(name: "Smart Watch", enable: true),
  Product(name: "Temporary Tattoos", enable: true),
  Product(name: "Bookends", enable: true),
  Product(name: "Vegetable Chopper", enable: true),
  Product(name: "Neck Massager", enable: true),
  Product(name: "Facial Cleanser", enable: true),
  Product(name: "Back Cushion", enable: true),
];

class PanelRightPage extends StatefulWidget {
  const PanelRightPage({Key? key}) : super(key: key);

  @override
  _PanelRightPageState createState() => _PanelRightPageState();
}

DashBoardCtrl? dashBoardCtrl;

class _PanelRightPageState extends State<PanelRightPage> {
  @override
  void initState() {
    dashBoardCtrl = Get.find<DashBoardCtrl>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: Constants.kdPadding / 2,
                  top: Constants.kdPadding / 2,
                  left: Constants.kdPadding / 2),
              child: Card(
                color: Get.theme.primaryColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ListTile(
                    //leading: Icon(Icons.monetization_on),
                    title: const Text(
                      "Lead Length",
                      style: TextStyle(color: Colors.white),
                    ),

                    trailing: Chip(
                      label: Obx(() => Text(
                            dashBoardCtrl!.leadlength.value,
                            style: const TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            const LineChartSample1(),
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
                    _products.length,
                    (index) => SwitchListTile.adaptive(
                      title: Text(
                        _products[index].name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      value: _products[index].enable,
                      onChanged: (newValue) {
                        setState(() {
                          _products[index].enable = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
