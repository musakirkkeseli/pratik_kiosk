import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../model/book_appointment_request_model.dart';
import '../model/empty_slots_request_model.dart';
import '../model/empty_slots_response_model.dart';
import '../service/IMakeAppointment_service.dart';

part 'appointment_slot_state.dart';

class AppointmentSlotCubit extends BaseCubit<AppointmentSlotState> {
  final IMakeAppointmentService service;
  final int doctorId;
  final int departmentId;
  final String doctorName;
  final String departmentName;

  AppointmentSlotCubit({
    required this.service,
    required this.doctorId,
    required this.departmentId,
    required this.doctorName,
    required this.departmentName,
  }) : super(const AppointmentSlotState());


  String? selectedSlotId;
  String? selectedDate;
  String? selectedTime;

  Future<void> fetchEmptySlots() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));

    try {
      final request = EmptySlotsRequestModel(
        doctorId: doctorId,
        departmentId: departmentId,
      );

      final response = await service.getEmptySlots(request);

      if (response.data?.slots != null) {
        final groupedSlots = _groupSlotsByDate(response.data!.slots!);

        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.success,
            slots: response.data!.slots,
            groupedSlots: groupedSlots,
          ),
        );
      } else {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            errorMessage: response.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          errorMessage: ConstantString().errorOccurred,
        ),
      );
    }
  }

  Map<String, List<SlotItem>> _groupSlotsByDate(List<SlotItem> slots) {
    final Map<String, List<SlotItem>> grouped = {};

    for (var slot in slots) {
      final date = slot.getFormattedDate();
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(slot);
    }

    return grouped;
  }

  void selectSlot(String slotId, String date, String time) {
    if (selectedSlotId == slotId) {
      selectedSlotId = null;
      selectedDate = null;
      selectedTime = null;
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.success,
          selectedSlotId: '',
        ),
      );
    } else {
      selectedSlotId = slotId;
      selectedDate = date;
      selectedTime = time;
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.success,
          selectedSlotId: slotId,
        ),
      );
    }
  }

  void confirmAppointment() {
    if (selectedSlotId == null) return;
    // Direkt randevu almaya geç
    makeAppointment();
  }

  void makeAppointment() async {
    if (selectedSlotId == null) {
      return;
    }

    safeEmit(
      state.copyWith(
        status: EnumGeneralStateStatus.loading,
        appointmentBooked: false,
      ),
    );

    try {
      final request = BookAppointmentRequestModel(slotId: selectedSlotId);

      final response = await service.bookAppointment(request);

      if (response.data?.appointmentID != null) {
        final appointmentId = response.data!.appointmentID!;

        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.success,
            appointmentId: appointmentId,
            appointmentBooked: true,
          ),
        );

      } else {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            errorMessage: response.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          errorMessage: ConstantString().errorOccurred,
        ),
      );
    }
  }
}
