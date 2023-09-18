import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/controllers/pageswitch_controller.dart';
import 'package:callingpanel/extensions/string_ext.dart';
import 'package:callingpanel/functions/hide_keyboard.dart';
import 'package:callingpanel/mini_widgets.dart/tool_tips.dart';
import 'package:callingpanel/pages/adduser/adduser_controller.dart';
import 'package:callingpanel/widgets/workarea/workarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'appbar_controller.dart';

final WorkPageController workPageController = Get.find();

final Appbarcontroller _appbarcontroller = Get.find<Appbarcontroller>();
DateTime _now = DateTime.now();

class SerchInputWidget extends StatelessWidget {
  const SerchInputWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        height: 50,
        width: 300,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.kdPadding * 1.5, vertical: 0),
        decoration: BoxDecoration(
            color: kdwhitecolor,
            // border: Border.all(color: Constants.kdorange, width: .5),
            borderRadius: BorderRadius.circular(30.0)),
        child: TextField(
          cursorColor: kdblackcolor,
          maxLines: 1,
          keyboardType: TextInputType.name,
          controller: _appbarcontroller.searchbarctrl,
          cursorWidth: .8,
          onSubmitted: (value) {
            _appbarcontroller.changeinsearch(value);
          },
          onChanged: (value) {
            if (value.length >= 2) return;
            _appbarcontroller.changeinsearch(value);
          },
          style: const TextStyle(fontSize: 16, color: kdblackcolor),
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: kdwhitecolor,
            hintText: "Search",
            // prefixIcon: const Icon(
            //   Icons.search,
            //   size: 30,
            //   color: kdblackcolor,
            // ),
            suffixIcon: InkWell(
              onTap: () {
                _appbarcontroller
                    .changeinsearch(_appbarcontroller.searchbarctrl.text);
              },
              child: const Icon(
                Icons.search,
                size: 30,
                color: kdblackcolor,
              ),
            ),
            hintStyle: TextStyle(
              fontSize: 16,
              color: kdblackcolor.withOpacity(.2),
            ),
          ),
        ),
      ),
    );
  }
}

class AddUserbutton extends StatelessWidget {
  const AddUserbutton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // bool _hover = _appbarcontroller.hovericonname.value == 'addnewUser';
      // Color _color =
      //     _hover ? Get.theme.colorScheme.secondary : Constants.kdorange;
      Color _color = kdwhitecolor;
      return Visibility(
        visible:
            Get.find<LogeduserControll>().userpermissions.value.addEditUser,
        child: InkWell(
          onTap: () {
            _appbarcontroller.appbarheading.value = "New User";
            final preslecttab =
                Get.find<WorkPageController>().workwidgetname.value;
            if (preslecttab == PageSwitch.admins) {
              Get.find<AddEditUserController>().operation = "Addnewadmin";
            }
            if (preslecttab == PageSwitch.manager) {
              Get.find<AddEditUserController>().operation = "Addnewmanager";
            }
            if (preslecttab == PageSwitch.caller) {
              Get.find<AddEditUserController>().operation = "Addnewtelecaller";
            }
            Get.find<AddEditUserController>().onnewuser();
            Get.find<WorkPageController>().setworkpage('AddEditUser');
          },
          onHover: (value) {
            if (value) {
              _appbarcontroller.hovericonname.value = 'addnewUser';
            } else {
              _appbarcontroller.hovericonname.value = '';
            }
          },
          child: buildtooptip(
            message: 'Add new user.',
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: Constants.kdPadding),
              child: Column(
                children: [
                  Icon(
                    Icons.person_add,
                    size: _appbarcontroller.iconsize.value,
                    color: _color,
                  ),
                  "New User"
                      .text
                      .color(
                        _color,
                      )
                      .size(_appbarcontroller.textsize.value)
                      .makeCentered()
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class AddLeadbutton extends StatelessWidget {
  const AddLeadbutton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // bool _hover = _appbarcontroller.hovericonname.value == 'addnewUser';
      // Color _color =
      //     _hover ? Get.theme.colorScheme.secondary : Constants.kdorange;
      Color _color = kdwhitecolor;
      return Visibility(
        visible:
            Get.find<LogeduserControll>().userpermissions.value.addEditLead,
        child: InkWell(
          onTap: () {
            Get.find<WorkPageController>().setworkpage(PageSwitch.newlead);
          },
          onHover: (value) {
            if (value) {
              _appbarcontroller.hovericonname.value = 'addnewlead';
            } else {
              _appbarcontroller.hovericonname.value = '';
            }
          },
          child: buildtooptip(
            message: 'Add new leads.',
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: Constants.kdPadding),
              child: Column(
                children: [
                  Icon(
                    Icons.contacts,
                    size: _appbarcontroller.iconsize.value,
                    color: _color,
                  ),
                  "Upload Data"
                      .text
                      .color(
                        _color,
                      )
                      .size(_appbarcontroller.textsize.value)
                      .makeCentered()
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class DaterangepicWidget extends StatelessWidget {
  const DaterangepicWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // bool _hover = _appbarcontroller.hovericonname.value == 'DateRange';
      // bool _hover = _appbarcontroller.hovericonname.value == 'addnewUser';
      // Color _color =
      //     _hover ? Get.theme.colorScheme.secondary : Constants.kdorange;
      Color _color = kdwhitecolor;
      return InkWell(
        onHover: (value) {
          if (value) {
            _appbarcontroller.hovericonname.value = 'DateRange';
          } else {
            _appbarcontroller.hovericonname.value = '';
          }
        },
        onTap: () {
          hidekeyboard(context: context);
          showDateRangePicker(
            context: context,
            initialDateRange: DateTimeRange(
                start: _appbarcontroller.getfromdate(),
                end: _appbarcontroller.gettodate()),
            firstDate: DateTime(_now.year - 1),
            lastDate: DateTime(_now.year + 1),
            saveText: "Find",
            cancelText: "Close",
            confirmText: "Find",
            initialEntryMode: DatePickerEntryMode.input,
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData(
                  primaryColor: Get.theme.colorScheme.primary,
                  cardColor: Get.theme.colorScheme.primary,
                  brightness: Brightness.dark,
                  // dialogBackgroundColor: Get.theme.colorScheme.onSecondary,
                ),
                child: child!,
              );
            },
          ).then((value) {
            if (value != null) {
              _appbarcontroller.onchangedaterange(
                  setfromdate: value.start, settodate: value.end);
            }
          });
        },
        child: buildtooptip(
          message: 'Select date range.',
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: Constants.kdPadding),
            child: Column(
              children: [
                Icon(
                  Icons.date_range,
                  size: _appbarcontroller.iconsize.value,
                  color: _color,
                ),
                "Date"
                    .text
                    .color(_color)
                    .size(_appbarcontroller.textsize.value)
                    .makeCentered()
              ],
            ),
          ),
        ),
      );
    });
  }
}

class DatePicWidget extends StatelessWidget {
  const DatePicWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // bool _hover = _appbarcontroller.hovericonname.value == 'DatePic';
      // bool _hover = _appbarcontroller.hovericonname.value == 'addnewUser';
      // Color _color =
      //     _hover ? Get.theme.colorScheme.secondary : Constants.kdorange;
      Color _color = kdwhitecolor;
      return InkWell(
        onTap: () {
          hidekeyboard(context: context);
          showDatePicker(
            context: context,
            initialDate: _now,
            firstDate: DateTime(_now.year - 1),
            lastDate: DateTime(_now.year + 1),
          ).then((value) {
            if (value != null) {
              _appbarcontroller.selecteddate.value = value;
            }
          });
        },
        onHover: (value) {
          if (value) {
            _appbarcontroller.hovericonname.value = 'DatePic';
          } else {
            _appbarcontroller.hovericonname.value = '';
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: Constants.kdPadding),
          child: Column(
            children: [
              Icon(
                Icons.today,
                size: _appbarcontroller.iconsize.value,
                color: _color,
              ),
              "Date"
                  .text
                  .color(_color)
                  .size(_appbarcontroller.textsize.value)
                  .makeCentered()
            ],
          ),
        ),
      );
    });
  }
}

class UploadWidget extends StatelessWidget {
  const UploadWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // bool _hover = _appbarcontroller.hovericonname.value == 'Uploadfile';
      // Color _color =
      //     _hover ? Get.theme.colorScheme.secondary : Constants.kdorange;
      Color _color = kdwhitecolor;
      return Visibility(
        visible:
            Get.find<LogeduserControll>().userpermissions.value.addEditLead,
        child: InkWell(
          onTap: () {
            hidekeyboard(context: context);
          },
          onHover: (value) {
            if (value) {
              _appbarcontroller.hovericonname.value = 'Uploadfile';
            } else {
              _appbarcontroller.hovericonname.value = '';
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: Constants.kdPadding),
            child: Column(
              children: [
                Icon(
                  Icons.file_upload,
                  size: _appbarcontroller.iconsize.value,
                  color: _color,
                ),
                "Upload"
                    .text
                    .color(_color)
                    .size(_appbarcontroller.textsize.value)
                    .makeCentered()
              ],
            ),
          ),
        ),
      );
    });
  }
}

class DownloadWidget extends StatelessWidget {
  const DownloadWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // bool _hover = _appbarcontroller.hovericonname.value == 'Downloadfile';
      // Color _color =
      //     _hover ? Get.theme.colorScheme.secondary : Constants.kdorange;
      Color _color = kdwhitecolor;
      return InkWell(
        onTap: () {
          hidekeyboard(context: context);
          _appbarcontroller.downloadbuttonclick();
        },
        onHover: (value) {
          if (value) {
            _appbarcontroller.hovericonname.value = 'Downloadfile';
          } else {
            _appbarcontroller.hovericonname.value = '';
          }
        },
        child: buildtooptip(
          message: _appbarcontroller.downloadTip.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: Constants.kdPadding),
            child: Column(
              children: [
                Icon(
                  Icons.file_download,
                  size: _appbarcontroller.iconsize.value,
                  color: _color,
                ),
                "Download"
                    .text
                    .color(_color)
                    .size(_appbarcontroller.textsize.value)
                    .makeCentered()
              ],
            ),
          ),
        ),
      );
    });
  }
}

class AddCompBtn extends StatelessWidget {
  const AddCompBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: Get.find<WorkPageController>().workwidgetname.value ==
              PageSwitch.companies,
          child: InkWell(
            onTap: () {
              Get.find<WorkPageController>()
                  .setworkpage(PageSwitch.addeditcompanies);
            },
            onHover: (value) {
              if (value) {
                _appbarcontroller.hovericonname.value = 'addcompany';
              } else {
                _appbarcontroller.hovericonname.value = '';
              }
            },
            child: buildtooptip(
              message: 'Add new company.',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: const [
                    Icon(
                      Icons.add,
                      color: kdwhitecolor,
                      size: 24,
                    ),
                    Text(
                      "Company",
                      style: TextStyle(
                          color: kdwhitecolor, overflow: TextOverflow.ellipsis),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class ProfileWid extends StatelessWidget {
  const ProfileWid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _logeduser = Get.find<LogeduserControll>().logeduserdetail.value;

    String _post = (_logeduser.logeduserPost);
    if (_post.isNotEmpty) {
      _post = "( $_post )";
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 5, 10, 2),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (_logeduser.logeduserName).toTextWid(
            size: 17,
            color: kdblackcolor,
            weight: FontWeight.bold,
          ),
          _post.toTextWid(color: kdblackcolor),
        ],
      ),
    );
  }
}
