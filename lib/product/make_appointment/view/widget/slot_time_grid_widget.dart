import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/utility/const/constant_color.dart';
import '../../cubit/appointment_slot_cubit.dart';
import '../../model/empty_slots_response_model.dart';

class SlotTimeGridWidget extends StatelessWidget {
  final List<SlotItem> slots;
  final String selectedSlotId;
  final String doctorName;
  final String departmentName;

  const SlotTimeGridWidget({
    super.key,
    required this.slots,
    required this.selectedSlotId,
    required this.doctorName,
    required this.departmentName,
  });

  @override
  Widget build(BuildContext context) {
    final rowCount = (slots.length / 4).ceil();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rowCount,
      itemBuilder: (context, rowIndex) {
        final startIndex = rowIndex * 4;
        final endIndex = (startIndex + 4).clamp(0, slots.length);
        final rowSlots = slots.sublist(startIndex, endIndex);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < 4; i++)
                if (i < rowSlots.length)
                  _buildSlotItem(context, rowSlots[i])
                else
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: Container(),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlotItem(BuildContext context, SlotItem slot) {
    final isSelected = slot.slotID == selectedSlotId;
    final isAvailable = slot.isAvailable;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: isAvailable
              ? () {
                  context.read<AppointmentSlotCubit>().selectSlot(
                    slot.slotID ?? '',
                    slot.getFormattedDate(),
                    slot.getFormattedTime(),
                  );
                }
              : null,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : isAvailable
                      ? ConstColor.white
                      : ConstColor.grey200,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : isAvailable
                        ? ConstColor.grey400
                        : ConstColor.grey300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                slot.getFormattedTime(),
                style: TextStyle(
                  color: isSelected
                      ? ConstColor.white
                      : isAvailable
                          ? ConstColor.black
                          : ConstColor.grey600,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
