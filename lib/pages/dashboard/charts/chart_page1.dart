import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/pages/dashboard/dashboardpages/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Person {
  String name;
  Color color;
  Person({required this.name, required this.color});
}

List<Person> _persons = [
  Person(name: "Theia Bowen", color: const Color(0xfff8b250)),
  Person(name: "Fariha Odling", color: const Color(0xffff5182)),
  Person(name: "Viola Willis", color: const Color(0xff0293ee)),
  Person(name: "Emmett Forrest", color: const Color(0xfff8b250)),
  Person(name: "Nick Jarvis", color: const Color(0xff13d38e)),
  Person(name: "ThAmit Clayeia", color: const Color(0xfff8b250)),
  Person(name: "ThAmalie Howardeia", color: const Color(0xffff5182)),
  Person(name: "Campbell Britton", color: const Color(0xff0293ee)),
  Person(name: "Haley Mellor", color: const Color(0xffff5182)),
  Person(name: "Harlen Higgins", color: const Color(0xff13d38e)),
];

// ignore: use_key_in_widget_constructors
class PanelCenterPage extends StatefulWidget {
  @override
  State<PanelCenterPage> createState() => _PanelCenterPageState();
}

DashBoardCtrl? dashBoardCtrl;

class _PanelCenterPageState extends State<PanelCenterPage> {
  @override
  void initState() {
    dashBoardCtrl = Get.find<DashBoardCtrl>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: Constants.kdPadding / 2,
                right: Constants.kdPadding / 2,
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
                  //leading: Icon(Icons.sell),
                  title: const Text(
                    "Total Users",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Chip(
                    label: Obx(() => Text(
                          dashBoardCtrl!.totaluser.value,
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ),
            ),
          ),
          // BarChartSample2(),
          Padding(
            padding: const EdgeInsets.only(
                top: Constants.kdPadding,
                left: Constants.kdPadding / 2,
                right: Constants.kdPadding / 2,
                bottom: Constants.kdPadding),
            child: Card(
              color: Get.theme.primaryColor,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: List.generate(
                  _persons.length,
                  (index) => ListTile(
                    leading: CircleAvatar(
                      radius: 15,
                      child: Text(
                        _persons[index].name.substring(0, 1),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _persons[index].color,
                    ),
                    title: Text(
                      _persons[index].name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.message,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
