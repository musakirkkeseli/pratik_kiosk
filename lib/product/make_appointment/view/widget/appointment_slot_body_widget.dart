import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';
import '../../cubit/appointment_slot_cubit.dart';
import 'slot_time_grid_widget.dart';

class AppointmentSlotBodyWidget extends StatelessWidget {
  final String doctorName;
  final String departmentName;
  final AppointmentSlotState state;

  const AppointmentSlotBodyWidget({
    super.key,
    required this.doctorName,
    required this.departmentName,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelectedSlot =
        state.selectedSlotId != null && state.selectedSlotId!.isNotEmpty;

    return Column(
      children: [
        // Geri Butonu
        // Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: Align(
        //     alignment: Alignment.centerLeft,
        //     child: IconButton(
        //       onPressed: () => Navigator.of(context).pop(),
        //       icon: const Icon(Icons.arrow_back, size: 32),
        //       style: IconButton.styleFrom(
        //         backgroundColor: ConstColor.grey200,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Container(
          padding: const EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(vertical: 20),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${ConstantString().sectionName}: $departmentName',
                style: context.cardTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                '${ConstantString().doctorName}: $doctorName',
                style: context.bodyPrimary.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
        Expanded(child: _buildSlotsList(context)),
        if (state.slots != null && state.slots!.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: hasSelectedSlot
                  ? () => _showConfirmDialog(context)
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: hasSelectedSlot
                    ? Theme.of(context).primaryColor
                    : ConstColor.grey300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                ConstantString().takeAppointment,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: hasSelectedSlot
                      ? ConstColor.white
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSlotsList(BuildContext context) {
    if (state.status == EnumGeneralStateStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.slots == null || state.slots!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_busy, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              ConstantString().noAvailableAppointmentsForDoctor,
              style: context.notFoundText,
            ),
          ],
        ),
      );
    }

    // Slotları tarihe göre grupla
    final groupedSlots = <String, List<dynamic>>{};
    for (var slot in state.slots!) {
      final date = slot.getFormattedDate();
      if (!groupedSlots.containsKey(date)) {
        groupedSlots[date] = [];
      }
      groupedSlots[date]!.add(slot);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: groupedSlots.length,
      itemBuilder: (context, index) {
        final date = groupedSlots.keys.elementAt(index);
        final slots = groupedSlots[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarih başlığı
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                date,
                style: context.cardTitle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SlotTimeGridWidget(
              slots: slots.cast(),
              selectedSlotId: state.selectedSlotId ?? '',
              doctorName: doctorName,
              departmentName: departmentName,
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  void _showConfirmDialog(BuildContext context) {
    final cubit = context.read<AppointmentSlotCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          ConstantString().confirm,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(ConstantString().doctorName, doctorName),
            const SizedBox(height: 12),
            _buildInfoRow(ConstantString().sectionName, departmentName),
            const SizedBox(height: 12),
            _buildInfoRow(ConstantString().date, cubit.selectedDate ?? ''),
            const SizedBox(height: 12),
            _buildInfoRow(ConstantString().time, cubit.selectedTime ?? ''),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              ConstantString().cancel,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.confirmAppointment();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              ConstantString().confirm,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
