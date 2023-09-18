List<String> avtarlist = [
  'assets/icons/avtar0.jpeg',
  'assets/icons/avtar1.jpeg',
  'assets/icons/avtar2.jpeg',
  'assets/icons/avtar3.jpeg',
  'assets/icons/avtar4.jpeg',
  'assets/icons/avtar5.jpeg',
];


/*

          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Get.theme.colorScheme.onSurface,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text("${onedata.fullName}")
                          .text
                          .color(kdblackcolor)
                          .size(16)
                          .fontWeight(FontWeight.w600)
                          .make(),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Get.theme.colorScheme.onSurface,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text("${onedata.mobile}")
                          .text
                          .color(kdblackcolor)
                          .size(14)
                          .fontWeight(FontWeight.w600)
                          .make(),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.list,
                        color: Get.theme.colorScheme.onSurface,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text("${onedata.lastResponse} (${onedata.lastDepartment})")
                          .text
                          .color(Get.theme.colorScheme.secondary)
                          .size(14)
                          .fontWeight(FontWeight.w600)
                          .make(),
                    ],
                  ),
                  Visibility(
                    visible: (onedata.lastRemark != 'NA'),
                    maintainSize: true,
                    maintainState: true,
                    maintainAnimation: true,
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Get.theme.colorScheme.onSurface,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Expanded(
                          child: (onedata.lastRemark ?? "")
                              .text
                              .softWrap(true)
                              .overflow(TextOverflow.ellipsis)
                              .color(Get.theme.colorScheme.onSecondary)
                              .maxLines(2)
                              .size(12)
                              .fontWeight(FontWeight.w600)
                              .make(),
                        ),
                      ],
                    ),
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
                            frompagename: "NewDataPage",
                            lable: onedata.fullName ?? "",
                            leadid: onedata.tableId ?? '',
                            mobile: "${onedata.mobile}",
                            altmobile: "${onedata.altMobile}");
                      },
                      icon: Icon(
                        Icons.call,
                        color: Get.theme.colorScheme.onSurface,
                      )),
                  Text("${onedata.lastIntDate}")
                      .text
                      .size(12)
                      .align(TextAlign.right)
                      .color(Get.theme.colorScheme.secondary)
                      .fontWeight(FontWeight.w600)
                      .make(),
                ],
              ),
            )
          ],
        

 */