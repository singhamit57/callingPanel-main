import 'package:callingpanel/constants/const_colors.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';

class CustumPaginateDataTable extends StatelessWidget {
  final DataTableSource dataTableSource;
  final List<DataColumn2> datacolumnlist;
  final bool? isloading;
  final int? rowsPerPage;
  const CustumPaginateDataTable(
      {Key? key,
      required this.datacolumnlist,
      required this.dataTableSource,
      this.rowsPerPage = 10,
      this.isloading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: kdyellowcolor.withOpacity(.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(3, 5)),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
            cardColor: Get.theme.primaryColorDark,
            dataTableTheme: DataTableThemeData(
              dataRowHeight: 35,
              dataTextStyle: const TextStyle(
                  color: kdwhitecolor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
              headingTextStyle: TextStyle(
                  color: Get.theme.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => kdskyblue),
              dataRowColor: MaterialStateColor.resolveWith(
                  (states) => Get.theme.primaryColorDark),
            )),
        child: PaginatedDataTable2(
            columnSpacing: 0,
            headingRowHeight: 30,
            rowsPerPage: rowsPerPage!,
            horizontalMargin: 5,
            fit: FlexFit.tight,
            showCheckboxColumn: false,
            empty: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                isloading == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "No Data Found",
                          style: TextStyle(
                              color: kdwhitecolor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      )
              ],
            ),
            columns: datacolumnlist,
            source: dataTableSource),
      ),
    );
  }
}

DataCell buildtextdatacell({required String text}) {
  return DataCell(
    AutoSizeText(
      text,
      maxLines: 1,
    ),
  );
}

DataCell buildactioncell(
    {required Widget left, required Widget center, required Widget right}) {
  return DataCell(Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        left,
        const SizedBox(
          width: 10,
        ),
        center,
        const SizedBox(
          width: 10,
        ),
        right
      ],
    ),
  ));
}
