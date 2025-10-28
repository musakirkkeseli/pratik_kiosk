import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../features/utility/const/constant_color.dart';
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
      width: MediaQuery.of(context).size.width * .25,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        //Bir sırada kaç buton bulunacağı ve aralarındaki mesafeyi belirler
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
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
                  case PageType.register:
                    context.read<PatientLoginCubit>().deleteBirthDate();
                    break;
                  case PageType.verifySms:
                    context.read<PatientLoginCubit>().deleteOtpCode();
                    break;
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: ConstColor.grey, width: 1),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              child: Icon(
                Icons.backspace_outlined,
                color: Colors.red,
                size: 28,
              ),
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
          case PageType.register:
            context.read<PatientLoginCubit>().onChangeBirthDate(index.toString());
            break;
          case PageType.verifySms:
            context.read<PatientLoginCubit>().onChangeOtpCode(index.toString());
            break;
        }
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: ConstColor.white,
        side: const BorderSide(color: ConstColor.grey, width: 1),
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Center(
        child: Text(
          (index).toString(),
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300,
            color: ConstColor.black,
          ),
        ),
      ),
    );
  }
}
