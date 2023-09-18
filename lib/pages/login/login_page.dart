import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/get_location.dart';
import 'package:callingpanel/functions/make_call.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/functions/storage/storagekeys.dart';
import 'package:callingpanel/widgets/responsive/responsive_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import 'loginpage_controll.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

final LoginPageCtrl logctrl = Get.put(LoginPageCtrl());
LogeduserControll? logeduserctrl;
var saveddata = "";

class _LoginPageState extends State<LoginPage> {
  var downloadhover = "".obs;
  bool _havepermissions = true;

  @override
  void initState() {
    logeduserctrl = Get.find<LogeduserControll>();

    // logctrl.useridctrl.text = 'SuperAdmin';
    // logctrl.passwordctrl.text = '1234';
    // logctrl.makelogin(id: 'agadmin210834', pw: '7914');
    // logctrl.makelogin(id: 'adminkartik', pw: '9957');
    // logctrl.makelogin(id: 'agcaller1059', pw: '11111');
    // logctrl.makelogin(id: 'admin210848', pw: '971286');
    // logctrl.makelogin(id: 'agcaller1058', pw: '12345');
    logeduserctrl!.islogedin = false;
    logeduserctrl!.isloopworking = false;
    logeduserctrl!.havelocationdata = false;
    logctrl.showpassword.value = false;
    logeduserctrl!.currnetworkname = "";

    if (logeduserctrl!.timer == null ? false : logeduserctrl!.timer!.isActive) {
      logeduserctrl!.timer!.cancel();
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      logctrl.buttonstate.value = ButtonState.idle;
      getcurrentlocation();
      logctrl.initialsetup();
      getuseridwp();
      checkpermissions();
    });

    super.initState();
  }

  @override
  void dispose() {
    logctrl.updatebuttonstatus(0);
    super.dispose();
  }

  checkpermissions() async {
    if (kIsWeb) return;
    bool _phone = await Permission.phone.isGranted;
    if (!_phone) {
      await Permission.phone.request();
    }

    _havepermissions = _phone;
  }

  checkfordemoinput() {
    String urlpath = "user";
    if (kIsWeb) {
      urlpath = html.window.location.href.toLowerCase();
    }

    String inputvalue = Get.parameters['user'] ?? "";
    if (inputvalue.toLowerCase() == "demo" || urlpath.contains('demo')) {
      logctrl.remberpassword.value = true;
      if (Get.width < 752) {
        logctrl.useridctrl.text = "agtel210852";
        logctrl.passwordctrl.text = "1234";
      } else {
        logctrl.useridctrl.text = "agadmin210851";
        logctrl.passwordctrl.text = "1234";
      }
    }
  }

  getuseridwp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    iscalledanyone = preferences.getBool(StorageKeys.wascalled) ?? false;
    logctrl.useridctrl.text = preferences.getString(StorageKeys.userId) ?? '';
    logctrl.passwordctrl.text =
        preferences.getString(StorageKeys.userName) ?? '';
    if (logctrl.useridctrl.value.text == '') {
      logctrl.remberpassword.value = false;
    } else {
      logctrl.remberpassword.value = true;
    }
    checkfordemoinput();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: backgrounsColor,
        body: Stack(
          children: [
            Visibility(
              visible: ResponsiveLayout.isComputer(context),
              child: Positioned(
                  top: 20,
                  right: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      builddownloadapps(
                        "Mobile App",
                        Icon(
                          Icons.android,
                          color: Get.theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      builddownloadapps(
                        "Web App",
                        Icon(
                          Icons.language,
                          color: Get.theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      builddownloadapps(
                        "Window App",
                        Icon(
                          Icons.desktop_windows,
                          color: Get.theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ResponsiveLayout(
                computer: Row(
                  children: [
                    Expanded(flex: 3, child: buildlottie()),
                    Expanded(
                        flex: 2,
                        child:
                            buildlogincard(context: context, logctrl: logctrl))
                  ],
                ),
                phone: Padding(
                  padding: const EdgeInsets.all(Constants.kdPadding * 2),
                  child: buildlogincard(context: context, logctrl: logctrl),
                ),
              ),
            ),
            Positioned(right: 20, top: 20, child: builddownloadapk())
          ],
        ),
      ),
    );
  }

//logctrl.downloadapp(value);
  Widget builddownloadapps(String value, Icon icon) {
    return Obx(() {
      bool ishovering = downloadhover.value == value;
      return InkWell(
        onTap: () {
          logctrl.downloadapp(value);
        },
        splashColor: Get.theme.colorScheme.surface,
        onHover: (hover) {
          if (hover) {
            downloadhover.value = value;
          } else {
            downloadhover.value = "";
          }
        },
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: kdwhitecolor,
              border: Border.all(
                  color: Get.theme.colorScheme.onSecondary, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              5.widthBox,
              (value)
                  .text
                  .color(ishovering
                      ? Get.theme.colorScheme.primary
                      : Get.theme.colorScheme.onSecondary)
                  .size(14)
                  .fontWeight(ishovering ? FontWeight.bold : FontWeight.w500)
                  .overflow(TextOverflow.ellipsis)
                  .align(TextAlign.center)
                  .make(),
            ],
          ),
        ),
      );
    });
  }

  Widget buildtextfield({
    required String hinttext,
    required IconData preicon,
    required LoginPageCtrl pagecontroll,
    IconButton? suffbutton,
    bool ispassword = false,
    TextEditingController? textEditingController,
    Function(String)? onsubmit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextFormField(
        cursorColor: Get.theme.primaryColorDark,
        obscureText: ispassword,
        onFieldSubmitted: onsubmit,
        onChanged: (value) {
          pagecontroll.buttonstate.value = ButtonState.idle;
        },
        style: const TextStyle(color: kdbluecolor, fontWeight: FontWeight.w500),
        controller: textEditingController,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Get.theme.colorScheme.primary, width: 1),
            ),
            prefixIcon: Icon(
              preicon,
              color: Get.theme.colorScheme.primary,
            ),
            suffixIcon: suffbutton,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Get.theme.colorScheme.primary,
                width: 2.5,
              ),
            ),
            focusColor: Get.theme.primaryColorDark,
            hintText: hinttext),
      ),
    );
  }

  Widget builduserid({
    required LoginPageCtrl pagecontroll,
  }) {
    return buildtextfield(
        hinttext: "Enter User Id",
        preicon: Icons.person,
        pagecontroll: pagecontroll,
        textEditingController: pagecontroll.useridctrl);
  }

  Widget buildpassword({
    required LoginPageCtrl pagecontroll,
  }) {
    return Obx(() => buildtextfield(
        hinttext: "Enter Password",
        preicon: Icons.security,
        pagecontroll: pagecontroll,
        textEditingController: pagecontroll.passwordctrl,
        ispassword: !pagecontroll.showpassword.value,
        onsubmit: (value) {
          if (pagecontroll.useridctrl.text.isNotEmpty &&
              pagecontroll.passwordctrl.text.isNotEmpty) {
            if (pagecontroll.buttonstate.value == ButtonState.idle) {
              FocusScope.of(context).unfocus();
              pagecontroll.validate();
            }
          }
        },
        suffbutton: IconButton(
            onPressed: () {
              pagecontroll.showpassword.value =
                  !pagecontroll.showpassword.value;
            },
            icon: Icon(
              pagecontroll.showpassword.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: pagecontroll.showpassword.value
                  ? Get.theme.colorScheme.onSecondary
                  : Get.theme.colorScheme.onSecondary,
            ))));
  }

  Widget buildrememver({required LoginPageCtrl controller}) {
    return Obx(() => Container(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          children: [
            Checkbox(
                value: controller.remberpassword.value,
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => kdfbblue),
                checkColor: kdwhitecolor,
                onChanged: (value) {
                  controller.remberpassword.value = value!;
                }),
            Expanded(
                child: "Remember password ?"
                    .text
                    .color(kdfbblue)
                    .size(14)
                    .fontWeight(FontWeight.w600)
                    .make())
          ],
        )));
  }

  Widget buildloginbutton({
    required LoginPageCtrl pagecontroll,
    required context,
  }) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (_havepermissions) {
          pagecontroll.validate();
        } else {
          showsnackbar(titel: "Alert", detail: "Please allow permissions !");
        }
      },
      child: Container(
        // height: 35,
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              colors: [
                Constants.kdred,
                Constants.kdorange.withOpacity(.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        child: "Log In"
            .text
            .xl2
            .color(Get.theme.colorScheme.primary)
            .fontFamily('PoppinsSemiBold')
            .makeCentered(),
      ),
    );
  }

  Widget buildanimatedbtn({
    required LoginPageCtrl pagecontroll,
    required context,
  }) {
    return Obx(() => ProgressButton.icon(
          textStyle: const TextStyle(
              fontFamily: 'PoppinsSemiBold', color: kdwhitecolor),
          iconedButtons: {
            ButtonState.idle: IconedButton(
              text: 'Login',
              icon: const Icon(
                Icons.login,
                color: kdwhitecolor,
              ),
              color: Get.theme.colorScheme.primary,
            ),
            ButtonState.loading: const IconedButton(
              text: 'Varifing',
              // icon: Icon(Icons.login),
              color: kdwhitecolor,
            ),
            ButtonState.fail: IconedButton(
              text: 'Failed',
              icon: const Icon(
                Icons.cancel,
                color: kdwhitecolor,
              ),
              color: Get.theme.colorScheme.primary,
            ),
            ButtonState.success: IconedButton(
              text: 'Success',
              icon: const Icon(
                Icons.check_circle,
                color: kdwhitecolor,
              ),
              color: Get.theme.colorScheme.primary,
            ),
          },
          onPressed: () {
            if (pagecontroll.buttonstate.value == ButtonState.idle) {
              FocusScope.of(context).unfocus();
              pagecontroll.validate();
            }
          },
          state: pagecontroll.buttonstate.value,
        ));
  }

  Widget buildlogincard({required context, required LoginPageCtrl logctrl}) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: 400,
        height: 500,
        // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(8.0),
        //     color: kdwhitecolor,
        //     border:
        //         Border.all(width: 1, color: Get.theme.colorScheme.onSecondary)),
        child: Card(
          elevation: 5,
          color: kdwhitecolor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  'AG'
                      .text
                      .xl5
                      .color(Get.theme.colorScheme.primary)
                      .fontFamily('PoppinsExtraBold')
                      .make(),
                  ' Caller'
                      .text
                      .xl5
                      .color(Get.theme.colorScheme.onSecondary)
                      .fontFamily('PoppinsSemiBold')
                      .make(),
                  // 'AG Caller'.text.xl2.white.make()
                ],
              ),
              // SizedBox(
              //   height: 50,
              // ),
              Column(
                children: [
                  builduserid(
                    pagecontroll: logctrl,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buildpassword(
                    pagecontroll: logctrl,
                  ),
                  buildrememver(controller: logctrl),
                ],
              ),

              buildanimatedbtn(
                pagecontroll: logctrl,
                context: context,
              ),
              const SizedBox(
                height: 20,
              ),
              ("Version : ${Constants.appversion.toString()} v")
                  .text
                  .color(kdfbblue)
                  .size(12)
                  .fontWeight(FontWeight.w600)
                  .makeCentered(),
              1.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildlottie() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/loginpage_animation.json',
            repeat: true,
          ),
          // "Sinox Fx"
          //     .text
          //     .bold
          //     .size(45)
          //     .color(Constants.kdorange)
          //     .makeCentered(),
        ],
      ),
    );
  }

  Widget builddownloadapk() {
    return Visibility(
        visible: (kIsWeb && ResponsiveLayout.isPhone(context)),
        child: GestureDetector(
          onTap: () {
            launchUrl(Uri.parse("https://agcaller.com/products/agcaller.apk"));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border:
                  Border.all(width: 1, color: Get.theme.colorScheme.surface),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.android,
                  size: 20,
                  color: Get.theme.colorScheme.primary,
                ),
                8.widthBox,
                "Get App".text.white.size(12).make(),
              ],
            ),
          ),
        ));
  }
}
