import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../model/section_model.dart';
import '../service/ISectionSearchService.dart';

part 'section_search_state.dart';

class SectionSearchCubit extends BaseCubit<SectionSearchState> {
  final ISectionSearchService service;

  SectionSearchCubit({required this.service})
    : super(const SectionSearchState());

  Future<void> fetchSections() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    try {
      final res = await service.getBranchAndDeptListRequest();
      if (res.success == true && res.data is List<SectionItems>) {
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
