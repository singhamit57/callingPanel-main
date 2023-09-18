import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:callingpanel/constants/circle_avtar.dart';
import 'package:callingpanel/constants/connection_url.dart';
import 'package:callingpanel/constants/const_colors.dart';
import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/functions/donload_file.dart';
import 'package:callingpanel/functions/make_call.dart';
import 'package:callingpanel/functions/show_getsnack.dart';
import 'package:callingpanel/functions/storage/storagefiles/savenewlead.dart';
import 'package:callingpanel/functions/storage/storagekeys.dart';
import 'package:callingpanel/mini_widgets.dart/linearloding_widget.dart';
import 'package:callingpanel/mini_widgets.dart/nodatafound_lottie.dart';
import 'package:callingpanel/mobileapp/appscreens/callhistory/fullcallhistory.dart';
import 'package:callingpanel/mobileapp/appscreens/helperpages/leaddepartment/changeleaddepart_page.dart';
import 'package:callingpanel/mobileapp/appscreens/helperpages/leadlocation/leadlocationchange_page.dart';
import 'package:callingpanel/mobileapp/mobilewidgets/callresponsepage.dart/callresponse_page.dart';
import 'package:callingpanel/models/leads/leadfulldetail_model.dart';
import 'package:callingpanel/pages/uploaddata/uploaddata_model.dart';
import 'package:callingpanel/widgets/reuseable/search_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'newdata_controll.dart';
import 'package:http/http.dart' as http;

class MobileNewDataPage extends StatefulWidget {
  final String? frompage;
  const MobileNewDataPage({Key? key, this.frompage}) : super(key: key);

  @override
  _MobileNewDataPageState createState() => _MobileNewDataPageState();
}

int tablecount = 0;
int rowcount = 0;
List<bool> validfields = [];
int roundcount = 0;
int onetimelimit = 20;
bool lastuploadStatus = false;

MobileNewDataCtrl? newDataCtrl;
LogeduserControll? logeduserControll;

class _MobileNewDataPageState extends State<MobileNewDataPage> {
  bool isrecording = false;
  FilePickerResult? pickedFile;
  int randindex = 0;
  int randavtar = 0;

  @override
  void initState() {
    newDataCtrl = Get.find<MobileNewDataCtrl>();
    logeduserControll = Get.find<LogeduserControll>();
    newDataCtrl!.searchtextctrl.text = "";
    newDataCtrl!.getsearchresult("", false);
    randindex = Random().nextInt(cardgradiList.length);
    randavtar = Random().nextInt(avtarlist.length);
    super.initState();
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

  onpopmenuselection(int value) {
    if (value == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MobileCallResponsePage(
                    datatype: 'newdata',
                    leaddata: LeadFullDetail(),
                  )));
    }
    if (value == 1) {
      pickexcelfile(context: context);
    }
    if (value == 2) {
      var url = mainurl + "leadfile.xlsx";
      downloadFileByUrl(url: url);
    }
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

  pickexcelfile({required context}) async {
    pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );

    /// file might be picked

    if (pickedFile != null) {
      readfiledata(context: context);
    }
  }

  readfiledata({required context}) async {
    // controll!.changebtnstate(1);
    newDataCtrl!.issearching.value = true;
    newDataCtrl!.uploadedpercent.value = 0.0;
    newDataCtrl!.uploadeddata = 0;
    newDataCtrl!.totaldata = 0;
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
          // controll!.changebtnstate(3);
          newDataCtrl!.issearching.value = false;
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
            // controll!.changebtnstate(3);
            // controll!.issearching.value = false;
            return;
          }
          roundcount++;
        }
      }

      roundcount = 0;
      tablecount = 0;
      // controll!.loadingbtnlable.value = 'Uploading...';
      for (var table in excel.tables.keys) {
        if (tablecount == 1) return;
        tablecount = 1;
        //print(table); //sheet Name
        // print(excel.tables[table]!.maxCols);

        /// controll
        newDataCtrl!.totaldata = excel.tables[table]!.maxRows;

        for (var row in excel.tables[table]!.rows) {
          //Row Loop here

          if (rowcount == 0) {
            if (row.length != 8) {
              newDataCtrl!.issearching.value = false;
              // controll!.changebtnstate(3);
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
              newDataCtrl!.issearching.value = false;
              // controll!.changebtnstate(3);
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
            _onedata.department = logeduserControll!
                .logeduserdetail.value.logeduserDepartment![0];
            _onedata.compId = logeduserControll!.logeduserdetail.value.compId;
            _onedata.compName =
                logeduserControll!.logeduserdetail.value.compName;
            _onedata.logedId =
                logeduserControll!.logeduserdetail.value.logeduserId;
            _onedata.logedName =
                logeduserControll!.logeduserdetail.value.logeduserName;
            _onedata.datacode =
                logeduserControll!.logeduserdetail.value.logeduserId;
            newDataCtrl!.updatalist.add(_onedata);
            roundcount++;
            if (roundcount == onetimelimit) {
              lastuploadStatus =
                  await uploadonedata(data: newDataCtrl!.updatalist);

              if (lastuploadStatus) {
                newDataCtrl!.updateupload(onetimelimit);
                roundcount = 0;
                newDataCtrl!.updatalist.clear();
              } else {
                showsnackbar(titel: 'Error !!!', detail: 'Data not saved...');
                break;
              }
            }
          }
          rowcount = rowcount + 1;
        }
      }

      if (newDataCtrl!.updatalist.isNotEmpty) {
        lastuploadStatus = await uploadonedata(data: newDataCtrl!.updatalist);

        if (lastuploadStatus) {
          newDataCtrl!.updateupload(onetimelimit);
          roundcount = 0;
          newDataCtrl!.updatalist.clear();
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
    newDataCtrl!.issearching.value = false;
    // controll!.changebtnstate(2);
  }

  makenewresponse({
    required MobileNewDataCtrl mdatactrl,
  }) async {
    logeduserControll!.isuseroncall.value = false;
    if (mdatactrl.shownewdta.value.tableId != '') {
      mdatactrl.issearching.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      bool _iscalled = pref.getBool(StorageKeys.iscalledtolead +
              logeduserControll!.logeduserdetail.value.logeduserId) ??
          false;

      if (pref.getString(StorageKeys.callendtime) == 'NA' && _iscalled) {
        saveleadlocally(callendtime: DateTime.now().toString());
      }

      if (_iscalled) {
        mdatactrl.issearching.value = false;
        var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MobileCallResponsePage(
                herotag: "New-Data",
                leaddata: mdatactrl.shownewdta.value,
                havedata: true,
                datatype: 'leaddata',
              ),
            ));
        if (result == true) {
          mdatactrl.shownewdta.value = LeadFullDetail();
          saveleadlocally(
            havedata: false,
            iscalled: false,
            callstarttime: 'NA',
            callendtime: 'NA',
            onedata: mdatactrl.shownewdta.value,
          );
          mdatactrl.iscalledtolead.value = false;
          mdatactrl.getnewdata();
        }
      } else {
        showsnackbar(titel: 'Alert !!!', detail: 'Please make call first...');
      }
      mdatactrl.issearching.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgrounsColor,
        appBar: AppBar(
          // centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              'AG'
                  .text
                  .xl2
                  .color(kdwhitecolor)
                  .fontFamily('PoppinsExtraBold')
                  .make(),
              ' Caller'
                  .text
                  .xl2
                  .color(kdwhitecolor)
                  .fontFamily('PoppinsSemiBold')
                  .make(),
              // 'AG Caller'.text.xl2.white.make()
            ],
          ),
          actions: [
            PopupMenuButton(
                color: Get.theme.scaffoldBackgroundColor,
                onSelected: (int value) {
                  onpopmenuselection(value);
                },
                icon: Image.asset(
                  'assets/icons/uploadicon.png',
                  // height: 40,
                  // width: 40,
                  fit: BoxFit.cover,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      height: 50,
                      child: popupRowitem(
                        icon: Icons.add,
                        titel: "Add Lead",
                      ),
                      value: 0,
                    ),
                    PopupMenuItem(
                      height: 50,
                      child: popupRowitem(
                        icon: Icons.upload,
                        titel: "Upload File",
                      ),
                      value: 1,
                    ),
                    PopupMenuItem(
                      height: 50,
                      child: popupRowitem(
                        icon: Icons.download,
                        titel: "Sample",
                      ),
                      value: 2,
                    ),
                  ];
                }),
            const SizedBox(
              width: 5,
            ),
            // IconButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => MobileCallResponsePage(
            //                     datatype: 'newdata',
            //                     leaddata: LeadFullDetail(),
            //                   )));
            //     },
            //     icon: const Icon(
            //       Icons.add,
            //       color: kdwhitecolor,
            //     )),
          ],
        ),
        // bottomSheet:
        //     buildnewdatacard(context: context, mdatactrl: newDataCtrl!),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            shownewdatacard(context: context, mdatactrl: newDataCtrl!);
          },
          backgroundColor: kdwhitecolor,
          child: Image.asset(
            'assets/icons/newleadicon.png',
            // height: 50,
            fit: BoxFit.cover,
          ),
        ),

        body: Column(children: [
          Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: Obx(() => Column(
                      children: [
                        if (newDataCtrl!.issearching.value) buildLinerloading(),
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            buildserchbar(),
                            Container(
                              height: 100,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  overalldetailcard(
                                      count: newDataCtrl!.allfollowlist.length
                                          .toString(),
                                      lable: "Total Follow up"),
                                  overalldetailcard(
                                      count: newDataCtrl!
                                          .getfollowcount('Hot Lead'),
                                      lable: "Hot Lead"),
                                  overalldetailcard(
                                      count: newDataCtrl!
                                          .getfollowcount('Medium Lead'),
                                      lable: "Medium Lead"),
                                  overalldetailcard(
                                      count: newDataCtrl!
                                          .getfollowcount('Cold Lead'),
                                      lable: "Cold Lead"),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: .9,
                              color: Get.theme.colorScheme.onSecondary,
                              indent: 10,
                              endIndent: 2,
                              height: 10,
                            ),
                          ],
                        ),
                        ListView.builder(
                            itemCount: newDataCtrl!.followlistshow.length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return buildrecentdatacard(
                                onedata: newDataCtrl!.followlistshow[index],
                                avtar: avtarlist[index],
                              );
                            }),
                        // if (newDataCtrl!.followlistshow.isNotEmpty)
                        //   Column(
                        //     children:
                        //         newDataCtrl!.followlistshow.map((element) {
                        //       return buildrecentdatacard(onedata: element);
                        //     }).toList(),
                        //   ),
                        Visibility(
                            visible: (newDataCtrl!.followlistshow.isEmpty &&
                                !newDataCtrl!.issearching.value),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                buildnodatlottie(height: 300, repeat: false),
                                Positioned(
                                  bottom: 45,
                                  child: ("No Followup pending")
                                      .text
                                      .size(14)
                                      .color(Get.theme.colorScheme.onSecondary)
                                      .fontFamily('PoppinsSemiBold')
                                      .makeCentered(),
                                ),
                              ],
                            )),
                        80.heightBox,
                      ],
                    )),
              )),
        ]),
      ),
    );
  }

  Widget buildrecentdatacard({
    required LeadFullDetail onedata,
    required String avtar,
  }) {
    Color _bg = kdhotlead;
    if (onedata.lastPriority == 'Medium Lead') {
      _bg = kdmediumlead;
    } else if (onedata.lastPriority == 'Cold Lead') {
      _bg = kdcoldlead;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MobileFullCallHistory(
                      herotag: 'FollowUp ${onedata.tableId}',
                      tableid: onedata.tableId!,
                      name: onedata.fullName!,
                      leadid: onedata.tableId ?? '',
                      mobile: onedata.mobile!,
                      altmobile: onedata.altMobile,
                      newDataCtrl: newDataCtrl,
                      loaction:
                          "${onedata.country} > ${onedata.state} > ${onedata.city}",
                      frompage: 'newdata',
                    )));
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(top: 4, right: 3, left: 3),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(8),
          // gradient: cardgradiList[_gradindex],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 35,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(onedata.avtarpath!)),
            ),
            5.widthBox,
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${onedata.fullName}")
                    .text
                    .color(kdblackcolor)
                    .size(18)
                    .fontWeight(FontWeight.w600)
                    .make(),
                Text("${onedata.lastResponse} (${onedata.lastDepartment})")
                    .text
                    .color(kdblackcolor)
                    .size(14)
                    .fontWeight(FontWeight.w500)
                    .make(),
                (onedata.lastRemark ?? "")
                    .text
                    .softWrap(true)
                    .overflow(TextOverflow.ellipsis)
                    .color(kdblackcolor)
                    .maxLines(2)
                    .size(12)
                    .fontWeight(FontWeight.w500)
                    .make(),
              ],
            )),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        makemycall(
                            context: context,
                            imagepath: onedata.avtarpath,
                            frompagename: "NewDataPage",
                            lable: onedata.fullName ?? "",
                            leadid: onedata.tableId ?? '',
                            mobile: "${onedata.mobile}",
                            altmobile: "${onedata.altMobile}");
                      },
                      icon: const Icon(
                        Icons.call,
                        color: kdblackcolor,
                      )),
                  Text("${onedata.lastIntDate}")
                      .text
                      .size(12)
                      .align(TextAlign.right)
                      .color(kdblackcolor)
                      .fontWeight(FontWeight.w600)
                      .make(),
                ],
              ),
            ),
            5.widthBox,
          ],
        ),
      ),
    );
  }

  Widget popupRowitem({
    required IconData icon,
    required String titel,
  }) {
    return Container(
      // height: 35,
      width: 95,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Get.theme.colorScheme.primary,
          ),
          const SizedBox(
            width: 3,
          ),
          (titel)
              .text
              .color(Get.theme.colorScheme.primary)
              .size(14)
              .fontWeight(FontWeight.w400)
              .make(),
        ],
      ),
    );
  }

  shownewdatacard({required context, required MobileNewDataCtrl mdatactrl}) {
    Get.bottomSheet(
      buildnewdatacard(
        context: context,
        mdatactrl: mdatactrl,
      ),
      elevation: 5,
    );
  }

  Widget buildnewdatacard(
      {required context, required MobileNewDataCtrl mdatactrl}) {
    return Obx(() {
      String showlocation = "No Location";
      var _data = mdatactrl.shownewdta.value;
      if (mdatactrl.shownewdta.value.city != null) {
        showlocation = "${_data.country} > ${_data.state} > ${_data.city} ";
      }
      if (mdatactrl.donthavedata.value) {
        _data.fullName = 'No Name';
        _data.departments = 'No Department';
        _data.profile = 'No Profile';
        _data.country = 'Country';
        _data.state = 'State';
        _data.city = 'City';
        showlocation = 'No Location';
      }

      return InkWell(
        onDoubleTap: () async {
          await makenewresponse(mdatactrl: mdatactrl);
        },
        child: Container(
            height: 180,
            padding: const EdgeInsets.fromLTRB(4, 0, 5, 3),
            decoration: const BoxDecoration(
                color: kdwhitecolor,
                // gradient: LinearGradient(colors: [
                //   Get.theme.colorScheme.surface,
                //   Get.theme.colorScheme.surface.withOpacity(.8),
                // ]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                )),
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                10.heightBox,
                "New Lead"
                    .text
                    .color(Get.theme.colorScheme.secondary)
                    .xl2
                    .underline
                    .fontFamily('PoppinsSemiBold')
                    .makeCentered(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 3, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
//Heading Row

                            ///Name Row
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 22,
                                ),
                                const VerticalDivider(
                                  width: 5,
                                  thickness: .9,
                                  color: kdskyblue,
                                ),
                                (_data.fullName ?? 'No Name')
                                    .text
                                    .color(Get.theme.colorScheme.primary)
                                    .fontFamily('PoppinsSemiBold')
                                    .size(17)
                                    .make(),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),

                            ///Department row
                            GestureDetector(
                              onTap: () {
                                // endlastcall();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LeadDepartsMobile()));
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.playlist_add_check,
                                    size: 22,
                                  ),
                                  const VerticalDivider(
                                    width: 5,
                                    thickness: .9,
                                    color: kdskyblue,
                                  ),
                                  (mdatactrl.shownewdta.value.departments ??
                                          'No Department')
                                      .text
                                      .color(Get.theme.colorScheme.onSecondary)
                                      .fontFamily('PoppinsSemiBold')
                                      .overflow(TextOverflow.ellipsis)
                                      .size(14)
                                      .make(),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  if (newDataCtrl!.selecteddepartment.value !=
                                      'Any Department')
                                    const Icon(
                                      Icons.filter_list,
                                      size: 18,
                                    ),
                                ],
                              ),
                            ),

                            ///profile row
                            Row(
                              children: [
                                const Icon(
                                  Icons.engineering,
                                  size: 22,
                                ),
                                const VerticalDivider(
                                  width: 5,
                                  thickness: .9,
                                  color: kdskyblue,
                                ),
                                (mdatactrl.shownewdta.value.profile ??
                                        'No profile')
                                    .text
                                    .color(Get.theme.colorScheme.primary)
                                    .fontFamily('PoppinsSemiBold')
                                    .overflow(TextOverflow.ellipsis)
                                    .size(14)
                                    .make(),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            GestureDetector(
                              onTap: () {
                                // endlastcall();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LeadLocationsMobile(
                                              mobileNewDataCtrl: mdatactrl,
                                            )));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.place,
                                    size: 22,
                                  ),
                                  const VerticalDivider(
                                    width: 5,
                                    thickness: .9,
                                    color: kdskyblue,
                                  ),
                                  Container(
                                    // width: Get.width * .7,
                                    child: (showlocation)
                                        .text
                                        .color(
                                            Get.theme.colorScheme.onSecondary)
                                        .fontFamily('PoppinsSemiBold')
                                        .overflow(TextOverflow.ellipsis)
                                        .size(12)
                                        .make(),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (newDataCtrl!.selectedlocation.value !=
                                          'Any Location')
                                        const Icon(
                                          Icons.filter_list,
                                          color: kdwhitecolor,
                                          size: 18,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Spacer(),
                    Center(
                      child: Row(
                        children: [
                          Visibility(
                            visible: !mdatactrl.issearching.value,
                            child: IconButton(
                              onPressed: () async {
                                if (_data.mobile != null) {
                                  if (_data.mobile.toString().length >= 4) {
                                    await saveleadlocally(
                                      havedata: true,
                                      onedata: mdatactrl.shownewdta.value,
                                      iscalled: true,
                                      callstarttime: DateTime.now().toString(),
                                      callendtime: 'NA',
                                    );
                                    mdatactrl.iscalledtolead.value = true;
                                    Get.find<LogeduserControll>()
                                        .isuseroncall
                                        .value = true;
                                  }
                                  makemycall(
                                      context: context,
                                      lable: _data.fullName ?? "",
                                      frompagename: "NewDataPage",
                                      leadid: _data.tableId ?? '',
                                      mobile: _data.mobile.toString());
                                } else {
                                  showsnackbar(
                                      titel: 'Alert !!!',
                                      detail: 'No mobile number available...',
                                      duration: 3);
                                }
                              },
                              icon: Icon(
                                Icons.call,
                                color: Get.theme.colorScheme.secondary,
                                size: 28,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (!mdatactrl.issearching.value &&
                                !mdatactrl.iscalledtolead.value),
                            child: IconButton(
                              onPressed: () async {
                                // showloading(
                                //   context: context,
                                //   titel: 'Processing...',
                                // );
                                await mdatactrl.getnewdata();
                                // Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.refresh,
                                color: Get.theme.colorScheme.onSecondary,
                                size: 28,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (mdatactrl.iscalledtolead.value),
                            child: IconButton(
                              onPressed: () async {
                                // endlastcall();
                                await makenewresponse(mdatactrl: mdatactrl);
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Get.theme.colorScheme.onSecondary,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )),
      );
    });
  }

  Widget buildserchbar() {
    return SearchWidget(
      hintText: 'Search',
      controller: newDataCtrl!.searchtextctrl,
      onChanged: (value) {
        EasyDebounce.debounce('folloup', const Duration(milliseconds: 800),
            () => newDataCtrl!.getsearchresult(value.toLowerCase(), false));
      },
      text: "",
    );
  }

  Widget overalldetailcard({
    required String count,
    required String lable,
  }) {
    bool _selected =
        newDataCtrl!.searchtextctrl.text.toString().contains(lable);
    if (lable == 'Total Follow up' && newDataCtrl!.searchtextctrl.text == '') {
      _selected = true;
    }
    Color _bg = kdfollow;
    if (lable == 'Hot Lead') {
      _bg = kdhotlead;
    } else if (lable == 'Medium Lead') {
      _bg = kdmediumlead;
    } else if (lable == 'Cold Lead') {
      _bg = kdcoldlead;
    }

    Color _color = _selected ? kdfbblue : kdblackcolor;
    double _width = _selected ? 1.5 : 0;
    return GestureDetector(
      onTap: () {
        newDataCtrl!.searchtextctrl.text =
            lable == 'Total Follow up' ? '' : lable;
        newDataCtrl!.getsearchresult(newDataCtrl!.searchtextctrl.text, true);
        EasyDebounce.cancelAll();
      },
      child: Container(
        height: 80,
        width: 100,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(8),
          // gradient: cardgradiList[_gradindex],
          border: Border.all(
              width: _width, color: _selected ? _color : Colors.transparent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            count.text.bold
                .size(24)
                .color(_color)
                .fontWeight(FontWeight.w500)
                .makeCentered(),
            const SizedBox(
              height: 2,
            ),
            AutoSizeText(
              (lable.replaceAll(" ", "\n")),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: _color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*

Widget buildrecentdatacard({required LeadFullDetail onedata}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MobileFullCallHistory(
                    // herotag: 'FollowUp ${onedata.tableId}',
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: .5, color: Constants.kdorange)),
        child: Row(
          children: [
            Container(
              width: 3,
              height: 70,
              color: kdaccentcolor,
              // child: SelectableText('Hot Lead'),
            ),
            SizedBox(
              width: 2,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: kdwhitecolor,
                        size: 16,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      "{onedata.fullName}".text.white.size(16).bold.make(),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: kdwhitecolor,
                        size: 16,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      "{onedata.mobile}".text.white.size(12).bold.make(),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.list,
                        color: kdwhitecolor,
                        size: 16,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      "{onedata.lastResponse} ({onedata.lastDepartment})"
                          .text
                          .white
                          .size(12)
                          .bold
                          .make(),
                    ],
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.place,
                        color: kdwhitecolor,
                        size: 16,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      ("{onedata.lastRemark}".substring(0, 32) + ' ...')
                          .text
                          .softWrap(true)
                          .overflow(TextOverflow.fade)
                          .white
                          .size(12)
                          .bold
                          .make(),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        makemycall(
                            context: context,
                            mobile: "{onedata.mobile}",
                            altmobile: "{onedata.altMobile}");
                      },
                      icon: Icon(
                        Icons.call,
                        color: kdwhitecolor,
                      )),
                  "{onedata.respStamp}"
                      .text
                      .size(12)
                      .align(TextAlign.right)
                      .color(kdskyblue)
                      .make(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
*/