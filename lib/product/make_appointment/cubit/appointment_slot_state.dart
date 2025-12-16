part of 'appointment_slot_cubit.dart';



class AppointmentSlotState {
  final EnumGeneralStateStatus status;
  final List<SlotItem>? slots;
  final Map<String, List<SlotItem>>? groupedSlots;
  final String? selectedSlotId;
  final String? selectedDate;
  final String? selectedTime;
  final String? errorMessage;
  final String? appointmentId;
  final bool appointmentBooked;

  const AppointmentSlotState({
    this.status = EnumGeneralStateStatus.initial,
    this.slots,
    this.groupedSlots,
    this.selectedSlotId,
    this.selectedDate,
    this.selectedTime,
    this.errorMessage,
    this.appointmentId,
    this.appointmentBooked = false,
  });

  AppointmentSlotState copyWith({
    EnumGeneralStateStatus? status,
    List<SlotItem>? slots,
    Map<String, List<SlotItem>>? groupedSlots,
    String? selectedSlotId,
    String? selectedDate,
    String? selectedTime,
    String? errorMessage,
    String? appointmentId,
    bool? appointmentBooked,
  }) {
    return AppointmentSlotState(
      status: status ?? this.status,
      slots: slots ?? this.slots,
      groupedSlots: groupedSlots ?? this.groupedSlots,
      selectedSlotId: selectedSlotId ?? this.selectedSlotId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      errorMessage: errorMessage ?? this.errorMessage,
      appointmentId: appointmentId ?? this.appointmentId,
      appointmentBooked: appointmentBooked ?? this.appointmentBooked,
    );
  }
}
