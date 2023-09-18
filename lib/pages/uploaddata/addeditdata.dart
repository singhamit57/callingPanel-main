import 'dart:io';

import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/constants/validate_exp.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/functions/showdilogue.dart';
import 'package:callingpanel/mini_widgets.dart/animated_button.dart';
import 'package:callingpanel/widgets/appbar/appbar_controller.dart';
import 'package:callingpanel/widgets/responsive/responsive_widget.dart';
import 'package:callingpanel/widgets/reuseable/csc_pickerwidget.dart';
import 'package:callingpanel/widgets/reuseable/mytext_field.dart';
import 'package:callingpanel/widgets/reuseable/str_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'adddata_controller.dart';
import 'uploaddata_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddEditDataPage extends StatefulWidget {
  const AddEditDataPage({Key? key}) : super(key: key);

  @override
  _AddEditDataPageState createState() => _AddEditDataPageState();
}

int tablecount = 0;
int rowcount = 0;
List<bool> validfields = [];
int roundcount = 0;
int onetimelimit = 20;
bool lastuploadStatus = false;
AddDataControll? controll;
LogeduserControll? logeduserctrl;
Appbarcontroller? appbarcontroller;

class _AddEditDataPageState extends State<AddEditDataPage> {
  FilePickerResult? pickedFile;
  pickexcelfile({required context}) async {
    controll!.datacode = 'NA';
    pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );

    /// file might be picked

    if (pickedFile != null) {
      selectdepartforupload(context: context);
    }
  }

  bool formulacheck(Data? onedata) {
    try {
      if (onedata!.value == null) {
        return false;
      } else {
        return onedata.isFormula;
      }
    } catch (e) {
      return false;
    }
  }

  singledatavalidate() {
    if (controll!.namectrl.text.length < 3) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter full name');
      return;
    }
    if (controll!.emailctrl.text.isNotEmpty &&
        !controll!.emailctrl.text.isEmail) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter valid email id');
      return;
    }
    if (controll!.mobilectrl.text.length < 4) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter mobile number');
      return;
    }
    if (controll!.profilectrl.text.length < 4) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter profile');
      return;
    }
    if (controll!.countryctrl.text.length < 3) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter country name');
      return;
    }
    if (controll!.statectrl.text.length < 2) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter state name');
      return;
    }
    if (controll!.cityctrl.text.length < 3) {
      showsnackbar(titel: 'Alert !!!', detail: 'Please enter city name');
      return;
    }

    controll!.updatalist.clear();
    controll!.addeditonedata.fullName = controll!.namectrl.text;
    controll!.addeditonedata.emailId = controll!.emailctrl.text;
    controll!.addeditonedata.mobile = controll!.mobilectrl.text;
    controll!.addeditonedata.altMobile = controll!.altmobilectrl.text;
    controll!.addeditonedata.profile = controll!.profilectrl.text;
    controll!.addeditonedata.country = controll!.countryctrl.text;
    controll!.addeditonedata.state = controll!.statectrl.text;
    controll!.addeditonedata.city = controll!.cityctrl.text;
    controll!.addeditonedata.datacode = controll!.datacodectrl.text;
    controll!.addeditonedata.department = controll!.selectedDepart.value;
    controll!.addeditonedata.fullName = controll!.namectrl.text;
    controll!.addeditonedata.compId =
        logeduserctrl!.logeduserdetail.value.compId;
    controll!.addeditonedata.compName =
        logeduserctrl!.logeduserdetail.value.compName;
    controll!.addeditonedata.logedId =
        logeduserctrl!.logeduserdetail.value.logeduserId;
    controll!.addeditonedata.logedName =
        logeduserctrl!.logeduserdetail.value.logeduserName;
    controll!.updatalist.add(controll!.addeditonedata);
    uploadsingledata(
      data: controll!.updatalist,
    );
  }

  uploadsingledata({
    required List<UploaddataModel> data,
  }) async {
    String _url = mainurl + '/leaddatabase/savemultilead.php';
    var _body = uploaddataModelToJson(data);

    controll!.issearching.value = true;
    controll!.changebtnstate(1);
    try {
      http.Response response = await http.post(Uri.parse(_url), body: _body);
      if (response.statusCode == 200) {
        if (response.body.contains('successfully ')) {
          controll!.changebtnstate(2);
          controll!.onpageload();
        }

        controll!.issearching.value = false;
      } else {
        controll!.issearching.value = false;
        controll!.changebtnstate(3);
      }
    } catch (e) {
      controll!.issearching.value = false;
      controll!.changebtnstate(3);
    }
    controll!.issearching.value = false;
    controll!.changebtnstate(2);
  }

  Future<bool> uploadonedata({required List<UploaddataModel> data}) async {
    String fullurl = mainurl + '/leaddatabase/savemultilead.php';
    var _body = uploaddataModelToJson(data);
    try {
      http.Response response = await http.post(Uri.parse(fullurl), body: _body);
      if (response.statusCode == 200) {
        if (response.body.toString().contains('successfully')) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      debugPrint('uploadsingledata :$e');
      return false;
    }
    return false;
  }

  String nullcheckvalue(Data? data) {
    try {
      if (data!.value == null) {
        return '';
      } else {
        return data.value.toString();
      }
    } catch (e) {
      return '';
    }
  }

  readfiledata({required context}) async {
    // controll!.changebtnstate(1);
    controll!.issearching.value = true;
    controll!.uploadedpercent.value = 0.0;
    controll!.uploadeddata = 0;
    controll!.totaldata = 0;

    // controll!.loadingbtnlable.value = 'Please wait...';

    if (pickedFile != null) {
      // controll!.loadingbtnlable.value = 'Reading...'; kIsWeb
      Excel? excel;
      if (!kIsWeb) {
        var bytes = File(pickedFile!.files.first.path!).readAsBytesSync();
        excel = Excel.decodeBytes(List.from(bytes));
      } else {
        var bytes = pickedFile!.files.first.bytes;
        excel = Excel.decodeBytes(List.from(bytes!));
      }
      tablecount = 0;
      rowcount = 0;
      validfields.clear();
      validfields = [];
      roundcount = 0;
      excel.tables.length;

      for (var tables in excel.tables.keys) {
        if (tablecount == 1) {
          showsnackbar(
              titel: 'Alert !!!',
              detail: 'Excel file have more than 1 sheet...');
          controll!.changebtnstate(3);
          controll!.issearching.value = false;
          return;
        }
        tablecount = 1;
        List<bool> haveformula = [];

        for (var rows in excel.tables[tables]!.rows) {
          haveformula.add(formulacheck(rows[0]));
          haveformula.add(formulacheck(rows[1]));
          haveformula.add(formulacheck(rows[2]));
          haveformula.add(formulacheck(rows[3]));
          haveformula.add(formulacheck(rows[4]));
          haveformula.add(formulacheck(rows[5]));
          haveformula.add(formulacheck(rows[6]));
          haveformula.add(formulacheck(rows[7]));
          if (haveformula.contains(true)) {
            showsnackbar(
                titel: 'Alert !!!',
                detail:
                    'Excel file contains formula at row number ${roundcount + 1}...');
            controll!.changebtnstate(3);
            controll!.issearching.value = false;
            return;
          }
          roundcount++;
        }
      }

      roundcount = 0;
      tablecount = 0;
      controll!.loadingbtnlable.value = 'Uploading...';
      for (var table in excel.tables.keys) {
        if (tablecount == 1) return;
        tablecount = 1;
        //print(table); //sheet Name
        // print(excel.tables[table]!.maxCols);

        /// controll
        controll!.totaldata = excel.tables[table]!.maxRows;

        for (var row in excel.tables[table]!.rows) {
          //Row Loop here

          if (rowcount == 0) {
            if (row.length != 8) {
              controll!.issearching.value = false;
              controll!.changebtnstate(3);
              showsnackbar(
                  titel: 'Failed', detail: 'Please upload valid file....');

              return;
            }

            bool _name = nullcheckvalue(row[0]).toLowerCase() == 'full name';
            validfields.add(_name);
            bool _mail = nullcheckvalue(row[1]).toLowerCase() == 'emailid';
            validfields.add(_mail);
            bool _mobile = nullcheckvalue(row[2]).toLowerCase() == 'mobile';
            validfields.add(_mobile);
            bool _altmobile =
                nullcheckvalue(row[3]).toLowerCase() == 'altmobile';
            validfields.add(_altmobile);
            bool _profile = nullcheckvalue(row[4]).toLowerCase() == 'profile';
            validfields.add(_profile);
            bool _country = nullcheckvalue(row[5]).toLowerCase() == 'country';
            validfields.add(_country);
            bool lastuploadStatus =
                nullcheckvalue(row[6]).toLowerCase() == 'state';
            validfields.add(lastuploadStatus);
            bool _city = nullcheckvalue(row[7]).toLowerCase() == 'city';
            validfields.add(_city);
            if (validfields.contains(false)) {
              controll!.issearching.value = false;
              controll!.changebtnstate(3);
              showsnackbar(
                  titel: 'Failed', detail: 'Please upload valid file....');
              return;
            }
          }

          if (rowcount >= 1) {
            UploaddataModel _onedata = UploaddataModel();
            _onedata.fullName = nullcheckvalue(row[0]);
            _onedata.emailId = nullcheckvalue(row[1]);
            _onedata.mobile = nullcheckvalue(row[2]);
            _onedata.altMobile = nullcheckvalue(row[3]);
            _onedata.profile = nullcheckvalue(row[4]);
            _onedata.expirence = '';
            _onedata.country = nullcheckvalue(row[5]);
            _onedata.state = nullcheckvalue(row[6]);
            _onedata.city = nullcheckvalue(row[7]);
            _onedata.department = controll!.selectedDepart.value;
            _onedata.datacode = controll!.datacode;
            _onedata.compId = logeduserctrl!.logeduserdetail.value.compId;
            _onedata.compName = logeduserctrl!.logeduserdetail.value.compName;
            _onedata.logedId = logeduserctrl!.logeduserdetail.value.logeduserId;
            _onedata.logedName =
                logeduserctrl!.logeduserdetail.value.logeduserName;
            controll!.updatalist.add(_onedata);
            roundcount++;
            if (roundcount == onetimelimit) {
              lastuploadStatus =
                  await uploadonedata(data: controll!.updatalist);

              if (lastuploadStatus) {
                controll!.updateupload(onetimelimit);
                roundcount = 0;
                controll!.updatalist.clear();
              } else {
                showsnackbar(titel: 'Error !!!', detail: 'Data not saved...');
                break;
              }
            }
          }
          rowcount = rowcount + 1;
        }
      }

      if (controll!.updatalist.isNotEmpty) {
        lastuploadStatus = await uploadonedata(data: controll!.updatalist);

        if (lastuploadStatus) {
          controll!.updateupload(onetimelimit);
          roundcount = 0;
          controll!.updatalist.clear();
          // controll!.up.value = controll!.uploadeddata.value + 1;
        } else {
          showsnackbar(titel: 'Error !!!', detail: 'Data not saved...');
        }
        //print(lastuploadStatus);

      }
      if (lastuploadStatus) {
        showsnackbar(
            titel: 'Data Uploaded', detail: 'Data Uploaded Sucessfully....');
      }

      // Navigator.pop(context);
      // Get.back();
    }
    controll!.issearching.value = false;
    controll!.changebtnstate(2);
  }

  selectdepartforupload({required context}) {
    return showmydilogue(
        context: context,
        titel: const Text(
          "Please select department",
          style: TextStyle(color: kdyellowcolor, fontWeight: FontWeight.bold),
        ),
        details: builddepartment(context: context),
        action: [
          ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                datacodeforupload(context: context);
              },
              child: const Text("Proceed"))
        ]);
  }

  datacodeforupload({required context}) {
    controll!.datacode = '';
    return showmydilogue(
        context: context,
        titel: const Text(
          "Please Enter Data Code",
          style: TextStyle(color: kdyellowcolor, fontWeight: FontWeight.bold),
        ),
        details: MyTextField(
          lable: '',
          hint: 'Enter Data Code(Max 8 Char.)',
          keyboardtype: TextInputType.text,
          autofocus: true,
          onchange: (value) {
            controll!.datacode = value;
          },
        ),
        action: [
          ElevatedButton(
              onPressed: () async {
                if (controll!.datacode.isEmpty) {
                  controll!.datacode = 'NA';
                }
                if (controll!.datacode.length > 8) {
                  showsnackbar(
                      titel: 'Alert !!!',
                      detail: 'Please enter 8 charactor data code only...');
                  return;
                }
                Navigator.pop(context);
                controll!.issearching.value = true;
                await Future.delayed(const Duration(milliseconds: 800));
                readfiledata(context: context);
              },
              child: const Text("Upload"))
        ]);
  }

  @override
  void initState() {
    controll = Get.find<AddDataControll>();
    logeduserctrl = Get.find<LogeduserControll>();
    appbarcontroller = Get.find<Appbarcontroller>();
    controll!.loadingbtnlable.value = 'Please wait...';
    controll!.insertdepartment();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      appbarcontroller!.downloadTip.value = 'Download sample file';
      appbarcontroller!.downloadvisible.value = true;
    });

    // controll!.onpageload();
    super.initState();
  }

  @override
  void dispose() {
    controll!.onpageload();
    controll!.loadingbtnlable.value = 'Please wait...';
    appbarcontroller!.downloadvisible.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() => Visibility(
              visible: controll!.issearching.value,
              child: buillinearprogess(controll: controll!))),
          Row(
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 25),
                    child: (controll!.leadPageTitel.value)
                        .text
                        .xl4
                        .color(Get.theme.colorScheme.onSecondary)
                        .fontFamily('PoppinsSemiBold')
                        .make()),
              ),
              pickfile(context: context),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          ResponsiveLayout(
            computer: Column(
              children: [
                buildonerow(
                    widget1: buildcompanyid(), widget2: buildcompanyname()),
                buildonerow(widget1: buildfullname(), widget2: buildemailid()),
                buildonerow(widget1: buildmobile(), widget2: buildaltmobile()),
                buildonerow(
                    widget1: buildprofile(), widget2: buildexperience()),
                buildonerow(widget1: buildcountry(), widget2: buildstate()),
                buildonerow(
                    widget1: buildcity(),
                    widget2: builddepartment(context: context)),
                const SizedBox(
                  height: 20,
                ),
                buildbutton(context: context, controll: controll!),
              ],
            ),
            phone: Column(
              children: [
                buildcompanyid(),
                buildcompanyname(),
                buildfullname(),
                buildemailid(),
                buildmobile(),
                buildaltmobile(),
                buildprofile(),
                buildexperience(),
                buildcountry(),
                buildstate(),
                buildcity(),
                builddepartment(context: context),
                const SizedBox(
                  height: 20,
                ),
                buildbutton(context: context, controll: controll!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildbutton({
    required AddDataControll controll,
    required context,
  }) {
    return Obx(() => buildanimatebtntext(
          ontap: () async {
            // ignore: unrelated_type_equality_checks
            if (controll.buttonstate == ButtonState.idle) {
              singledatavalidate();
            }
          },
          key: 'Upload',
          success: "Lead Uploaded",
          idel: "Upload Lead",
          fail: "Failed",
          loading: controll.loadingbtnlable.value,
          state: controll.buttonstate.value,
        ));
  }

  Widget buillinearprogess({
    required AddDataControll controll,
  }) {
    return Obx(() => Center(
          child: LinearProgressIndicator(
            color: kdskyblue,
            minHeight: 5,
            backgroundColor: kdwhitecolor,
            value: controll.uploadedpercent.value,
          ),
        ));
  }

  Widget pickfile({required context}) {
    return TextButton.icon(
        onPressed: () {
          if (!controll!.issearching.value) {
            pickexcelfile(context: context);
          }
        },
        icon: const Icon(Icons.upload),
        label: 'Upload File'.text.bold.make());
  }

  Widget buildonerow({
    required Widget widget1,
    required Widget widget2,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: widget1,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          flex: 3,
          child: widget2,
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  Widget buildcompanyid() {
    return Obx(() => Visibility(
          visible: Get.find<LogeduserControll>().showcompoption.value,
          child: const MyTextField(
            hint: "Enter Company Id",
            lable: "Company Id",
            keyboardtype: TextInputType.name,
            // controller: companyidctrl,
            maxlength: 20,
          ),
        ));
  }

  Widget buildcompanyname() {
    return Obx(() => Visibility(
          visible: Get.find<LogeduserControll>().showcompoption.value,
          child: const MyTextField(
            hint: "Enter Company Name",
            lable: "Company Name",
            keyboardtype: TextInputType.name,
            // controller: companynamectrl,
          ),
        ));
  }

  Widget buildfullname() {
    return MyTextField(
      hint: "Enter Full Name",
      lable: "Name*",
      controller: controll!.namectrl,
      keyboardtype: TextInputType.name,
      // controller: companynamectrl,
      maxlength: 50,
    );
  }

  Widget buildprofile() {
    return MyTextField(
      hint: "Enter Profile Name",
      lable: "Profile*",
      controller: controll!.profilectrl,
      keyboardtype: TextInputType.name,
      // controller: companynamectrl,
      maxlength: 20,
    );
  }

  Widget buildmobile() {
    return MyTextField(
      hint: "Enter Mobile Number",
      lable: "Mobile*",
      controller: controll!.mobilectrl,
      keyboardtype: TextInputType.number,
      // controller: companynamectrl,
      formatter: [
        FilteringTextInputFormatter.allow(expallowmobile),
      ],
      maxlength: 15,
    );
  }

  Widget buildaltmobile() {
    return MyTextField(
      hint: "Enter Alt. Mobile Number",
      lable: "Alt. Mobile",
      controller: controll!.altmobilectrl,
      keyboardtype: TextInputType.number,
      // controller: companynamectrl,
      formatter: [
        FilteringTextInputFormatter.allow(expallowmobile),
      ],
      maxlength: 15,
    );
  }

  Widget buildemailid() {
    return MyTextField(
      hint: "Enter Email Id",
      lable: "Email Id",
      controller: controll!.emailctrl,
      keyboardtype: TextInputType.emailAddress,
      // controller: companynamectrl,
      maxlength: 50,
    );
  }

  Widget buildexperience() {
    return MyTextField(
      hint: "Enter Data Code",
      lable: "Data Code",
      controller: controll!.datacodectrl,
      keyboardtype: TextInputType.name,
      // controller: companynamectrl,
      maxlength: 20,
    );
  }

  Widget buildcountry() {
    return MyTextField(
      hint: "Enter Country Name",
      lable: "Country*",
      controller: controll!.countryctrl,
      keyboardtype: TextInputType.name,
      maxlength: 30,
      sufix: IconButton(
          onPressed: () {
            showCSCPikcer(
                onCountychange: (value) {
                  controll!.countryctrl.text = value;
                },
                onStatechange: (value) {
                  controll!.statectrl.text = value;
                },
                onCitychange: (value) {
                  controll!.cityctrl.text = value;
                },
                context: context);
          },
          icon: Icon(
            Icons.place,
            color: Get.theme.colorScheme.secondary,
          )),
      // controller: companynamectrl,
    );
  }

  Widget buildstate() {
    return MyTextField(
      hint: "Enter State Name",
      lable: "State*",
      maxlength: 30,
      controller: controll!.statectrl,
      keyboardtype: TextInputType.name,
      // controller: companynamectrl,
    );
  }

  Widget buildcity() {
    return MyTextField(
      hint: "Enter City Name",
      lable: "City*",
      maxlength: 30,
      controller: controll!.cityctrl,
      keyboardtype: TextInputType.name,
      // controller: companynamectrl,
    );
  }

  Widget buildqualificaion() {
    return const MyTextField(
      hint: "Enter Qualification",
      lable: "Qualification",
      keyboardtype: TextInputType.name,
      // controller: companynamectrl,
    );
  }

  Widget builddepartment({
    required context,
  }) {
    return Obx(() => Container(
          padding: const EdgeInsets.only(
            top: 10,
            left: 20,
          ),
          child: buidldropdown(
            onchange: (value) {
              controll!.selectedDepart.value = value;
            },
            itemslist: controll!.departmetns,
            initvalue:
                controll!.departmetns.contains(controll!.selectedDepart.value)
                    ? controll!.selectedDepart.value
                    : controll!.departmetns[0],
            hinttext: controll!.departmetns[0],
            context: context,
          ),
        ));
  }
}
