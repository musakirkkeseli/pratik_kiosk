import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/extension/color_extension.dart';

import '../../cubit/patient_login_cubit.dart';

class VirtualKeypad extends StatefulWidget {
  final PageType pageType;
  const VirtualKeypad({super.key, required this.pageType});

  @override
  State<VirtualKeypad> createState() => _VirtualKeypadState();
}

class _VirtualKeypadState extends State<VirtualKeypad> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .17,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        //Bir sırada kaç buton bulunacağı ve aralarındaki mesafeyi belirler
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          //1'den 9'a kadar sayıları buton olarak ekrana yazdırır
          if (index < 9) {
            return keybordButton(index + 1, context);
          } else if (index == 9) {
            //eğer index==9 ise boş geçer
            return Container();
          } else if (index == 10) {
            //eğer index==10 ise 0 yazılı butonu gösterir
            return keybordButton(0, context);
          } else {
            return OutlinedButton(
              onPressed: () {
                switch (widget.pageType) {
                  case PageType.auth:
                    context.read<PatientLoginCubit>().deleteTcNo();
                    break;
                  case PageType.verifySms:
                    context.read<PatientLoginCubit>().deleteOtpCode();
                    break;
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: context.primaryColor,
                shape: const CircleBorder(),
              ),
              child: Icon(Icons.delete, color: context.errorColor),
            );
          }
        },
      ),
    );
  }

  //tuş takımının sayı değerli butonlarını oluşturan widget ve içerisine butonun içerine yazılacak olan sayıyı alır
  OutlinedButton keybordButton(int index, BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        //tuşa basıldığında içerisinde yazan sayıyı LoginCubit'in onChangePhoneNumber fonksiyonuna bildirir.
        switch (widget.pageType) {
          case PageType.auth:
            context.read<PatientLoginCubit>().onChangeTcNo(index.toString());
            break;
          case PageType.verifySms:
            context.read<PatientLoginCubit>().onChangeOtpCode(index.toString());
            break;
        }
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: context.primaryColor,
        shape: const CircleBorder(),
      ),
      child: Text(
        (index).toString(),
        style: TextStyle(fontSize: 20, color: context.secondaryColor),
      ),
    );
  }
}
