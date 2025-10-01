import 'package:flutter/material.dart';

import '../../../../features/utility/const/constant_color.dart';
import '../../../section/view/section_view.dart';

class SectionButtonWidget extends StatefulWidget {
  const SectionButtonWidget({super.key});

  @override
  State<SectionButtonWidget> createState() => _SectionButtonWidgetState();
}

class _SectionButtonWidgetState extends State<SectionButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SectionSearchView()),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(color: ConstColor.primaryColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(child: Text("Bölümler")),
        ),
      ),
    );
  }
}
