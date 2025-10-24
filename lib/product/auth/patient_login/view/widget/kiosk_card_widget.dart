import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/line_md.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../../../features/utility/const/constant_string.dart';
import '../../../../../features/utility/extension/text_theme_extension.dart';
import '../../../../../features/utility/extension/color_extension.dart';

class KioskCardWidget extends StatelessWidget {
  const KioskCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: context.primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            "Kiosk İşlemleri",
            style: context.sectionTitle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildKioskItem(
                context,
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedAppointment02,
                  size: 40,
                  color: Colors.white,
                ),
                label: ConstantString().appointmentRegistration,
              ),

              // 2) line-md:account-add  (Iconify)
              _buildKioskItem(
                context,
                icon: const Iconify(
                  LineMd.account_add,
                  size: 40,
                  color: Colors.white,
                ),
                label: ConstantString().patientRegistration,
              ),

              // 3) material-symbols:list-rounded (Iconify)
              _buildKioskItem(
                context,
                icon: const Iconify(
                  MaterialSymbols.list_rounded,
                  size: 40,
                  color: Colors.white,
                ),
                label: ConstantString().testQueue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildKioskItem(
  BuildContext context, {
  required Widget icon,
  required String label,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.08,
        height: MediaQuery.of(context).size.height * 0.06,
        decoration: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: icon),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.15,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: context.cardTitle.copyWith(
            fontSize: 14,
          ),
        ),
      ),
    ],
  );
}
