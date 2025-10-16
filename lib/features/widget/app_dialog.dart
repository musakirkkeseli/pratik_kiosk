import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utility/const/constant_color.dart';
import '../utility/const/constant_string.dart';

class AppDialog {
  late BuildContext context;
  AppDialog(this.context);

  Future<dynamic> loadingDialog() {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        child: WillPopScope(
          child: Center(
            child: Lottie.asset(ConstantString.healthGif, width: 150, ),
          ),
          onWillPop: () async => false,
        ),
      ),
    );
  }

  infoDialog(
    String title,
    String descript, {
    void Function()? firstOnPressed,
    void Function()? secondOnPressed,
    String? firstActionText,
    String? secondActionText,
  }) {
    return showDialog(
      context: context,
      builder: (context) => defaultAlertDialog(
        title,
        descript,
        firstOnPressed: firstOnPressed,
        secondOnPressed: secondOnPressed,
        firstActionText: firstActionText,
        secondActionText: secondActionText,
      ),
    );
  }

  defaultAlertDialog(
    String title,
    String descript, {
    void Function()? firstOnPressed,
    void Function()? secondOnPressed,
    String? firstActionText,
    String? secondActionText,
  }) {
    return AlertDialog(
      title: Text(title),
      content: Text(descript),
      actions: [
        secondActionText is String
            ? TextButton(
                onPressed: secondOnPressed is Function()
                    ? secondOnPressed
                    : null,
                child: Text(
                  secondActionText,
                  style: const TextStyle(color: ConstColor.white),
                ),
              )
            : Container(),
        TextButton(
          onPressed: firstOnPressed is Function()
              ? firstOnPressed
              : () {
                  Navigator.pop(context);
                },
          child: Text(
            firstActionText ?? "ConstantString().close",
            style: const TextStyle(color: ConstColor.white),
          ),
        ),
      ],
    );
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      backgroundColor: ConstColor.primaryColor,
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // phoneVerificationSheet(Function(String)? onChanged, Function()? onPressed) {
  //   showModalBottomSheet(
  //       context: context,
  //       useRootNavigator: true,
  //       isScrollControlled: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(
  //           top: Radius.circular(20),
  //         ),
  //       ),
  //       builder: (context) {
  //         return FractionallySizedBox(
  //             heightFactor: 0.8,
  //             child: SafeArea(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(24),
  //                 child: Column(
  //                   children: [
  //                     CustomTextField(
  //                       onChanged: onChanged,
  //                       title: ConstantString().smsCode,
  //                       icon: const Icon(Icons.phone),
  //                     ),
  //                     ElevatedButton(
  //                         onPressed: onPressed,
  //                         child: Text(ConstantString().send))
  //                   ],
  //                 ),
  //               ),
  //             ));
  //       });
  // }

  // Future<dynamic> messsageDialog(
  //     String imageUrl, String title, String message, String url) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) => Dialog(
  //             backgroundColor: ConstColor.white,
  //             child: InkWell(
  //               onTap: () {
  //                 LaunchService.makeWebUrl(url);
  //               },
  //               child: Container(
  //                 height: MediaQuery.sizeOf(context).height * .8,
  //                 width: MediaQuery.sizeOf(context).width * .9,
  //                 decoration: BoxDecoration(
  //                     image: DecorationImage(
  //                         image: NetworkImage(imageUrl),
  //                         fit: BoxFit.fill,
  //                         opacity: .1)),
  //                 padding: const EdgeInsets.all(12),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     SingleChildScrollView(
  //                       child: Column(
  //                         children: [
  //                           Row(
  //                             children: [
  //                               const Expanded(
  //                                 child: SizedBox(),
  //                               ),
  //                               IconButton(
  //                                   onPressed: () {
  //                                     Navigator.pop(context);
  //                                   },
  //                                   icon: const Icon(
  //                                     Icons.cancel,
  //                                     color: ConstColor.error,
  //                                     size: 40,
  //                                   )),
  //                             ],
  //                           ),
  //                           Container(
  //                               height: 70,
  //                               width: MediaQuery.sizeOf(context).width,
  //                               alignment: Alignment.center,
  //                               child: Text(
  //                                 title,
  //                                 style: const TextStyle(fontSize: 20),
  //                               )),
  //                           Text(message),
  //                         ],
  //                       ),
  //                     ),
  //                     ElevatedButton(
  //                         onPressed: () {
  //                           LaunchService.makeWebUrl(url);
  //                         },
  //                         child: const Text("İncele"))
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ));
  // }
}
