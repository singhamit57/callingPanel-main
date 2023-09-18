// import 'dart:convert';

// import 'package:callingpanel/functions/string_toobject.dart';
// import 'package:callingpanel/models/department_model.dart';
// import 'package:callingpanel/models/logeduserdetail_model.dart';
// import 'package:callingpanel/models/permission_model.dart';
// import 'package:callingpanel/models/responserequrement_model.dart';

// //LogedUserDetails logeduserdetails = LogedUserDetails();
// List<DepartmentsModel> companydepartemtns = [];
// AllowedPermission logeduserpermissions = AllowedPermission();
// ResponseRequrements responseRequrements = ResponseRequrements();

// userdetailssetup({required dynamic response}) {
//   logeduserdetails.compId = response['CompId'];
//   logeduserdetails.compName = response['CompName'];
//   logeduserdetails.compStatus = response['CompStatus'];
//   logeduserdetails.logeduserId = response['UserId'];
//   logeduserdetails.logeduserName = response['UserName'];
//   logeduserdetails.logeduserPost = response['UserDesignation'];
//   logeduserdetails.logeduserDepartment =
//       strtosttlist(jsonEncode(response['UserDepartment']));
//   logeduserpermissions =
//       allowedPermissionFromJson(jsonEncode(response['PemissionDetails']));
//   // int i = 0;
//   // Map<String, dynamic> _data = response['Departments'] as Map<String, dynamic>;
//   // _data.keys.forEach((key) {
//   //   print(key);
//   // });

//   // for (final _key in _data.keys) {
//   //   print(_key);
//   // }
//   // while (i < _data.length) {
//   //   var _data1 = _data[i];
//   //   print(_data1);
//   //   i++;
//   // }
// }


// /*
// // To parse this JSON data, do
// //
// //     final responseRequrements = responseRequrementsFromJson(jsonString);

// import 'dart:convert';

// List<ResponseRequrements> responseRequrementsFromJson(String str) => List<ResponseRequrements>.from(json.decode(str).map((x) => ResponseRequrements.fromJson(x)));

// String responseRequrementsToJson(List<ResponseRequrements> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class ResponseRequrements {
//     ResponseRequrements({
//         this.technology,
//         this.properties,
//     });

//     List<String> technology;
//     List<String> properties;

//     factory ResponseRequrements.fromJson(Map<String, dynamic> json) => ResponseRequrements(
//         technology: json["Technology"] == null ? null : List<String>.from(json["Technology"].map((x) => x)),
//         properties: json["Properties"] == null ? null : List<String>.from(json["Properties"].map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "Technology": technology == null ? null : List<dynamic>.from(technology.map((x) => x)),
//         "Properties": properties == null ? null : List<dynamic>.from(properties.map((x) => x)),
//     };
// }

// */