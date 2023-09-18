// ignore_for_file: non_constant_identifier_names

import 'package:date_format/date_format.dart';

String date_dMyy(DateTime date) {
  return formatDate(date, [d, '-', M, '-', yy]);
}

String date_dM(DateTime date) {
  return formatDate(date, [d, '-', M]);
}
