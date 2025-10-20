import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../model/doctor_model.dart';
import '../service/IDoctorSearchService.dart';

part 'doctor_search_state.dart';

class DoctorSearchCubit extends BaseCubit<DoctorSearchState> {
  final IDoctorSearchService service;
  final int sectionId;

  DoctorSearchCubit({required this.service, required this.sectionId})
    : super(const DoctorSearchState());

  Future<void> fetchDoctors() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    try {
      final res = await service.getListDoctor(sectionId);
      if (res.success == true && res.data is List<DoctorItems>) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.success,
            data: res.data,
          ),
        );
      } else {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: res.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: e.message,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: ConstantString().errorOccurred,
        ),
      );
    }
  }
}
