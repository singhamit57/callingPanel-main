import 'package:callingpanel/controllers/logedusercontroller.dart';
import 'package:callingpanel/models/location_model.dart';
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

Future<LocationModel> getcurrentlocation() async {
  LocationModel data = LocationModel();
  if (Platform.isWindows) return data;

  try {
    Location location = Location();
    LocationData _locationData = await location.getLocation();
    data = LocationModel(
      latitude: _locationData.latitude.toString(),
      longitude: _locationData.longitude.toString(),
      accuracy: _locationData.accuracy.toString(),
      speed: _locationData.speed.toString(),
    );
    Get.find<LogeduserControll>().currentlocation = data;
  } catch (e) {
    debugPrint('Location $e');
  }

  return data;
}

locationpermissions() async {
  Location location = Location();
  bool permission = false;
  bool _serviceEnabled = await location.serviceEnabled();
  var _serviceEnabled2 = await location.hasPermission();
  if (_serviceEnabled2.toString() == 'PermissionStatus.granted') {
    permission = true;
  }
  Get.find<LogeduserControll>().locationpermiisonallowed.value =
      _serviceEnabled;
  if (!_serviceEnabled || !permission) {
    _serviceEnabled = await location.requestService();
    Get.find<LogeduserControll>().locationpermiisonallowed.value =
        (_serviceEnabled && permission);
  }
}
