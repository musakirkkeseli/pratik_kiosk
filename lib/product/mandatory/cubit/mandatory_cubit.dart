import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../core/utility/logger_service.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../model/mandatory_request_model.dart';
import '../model/mandatory_response_model.dart';
import '../../../features/model/patient_mandatory_model.dart';
import '../service/IMandatoryService.dart';

part 'mandatory_state.dart';

class MandatoryCubit extends BaseCubit<MandatoryState> {
  final IMandatoryService service;
  final MandatoryRequestModel mandatoryRequestModel;
  MandatoryCubit({required this.service, required this.mandatoryRequestModel})
    : super(MandatoryState());

  final MyLog _log = MyLog('MandatoryCubit');

  Future<void> fetchMandatory() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    try {
      final res = await service.postMandatory(mandatoryRequestModel);
      if (res.success == true && res.data is List<MandatoryResponseModel>) {
        _log.d("MandatoryCubit: $res");
        List<PatientMandatoryModel> patientMandatoryList = [];
        for (var item in res.data!) {
          _log.d("Mandatory Item: ${item.toJson()}");
          patientMandatoryList.add(
            PatientMandatoryModel(
              id: item.id ?? "",
              targetFieldName: item.targetFieldName ?? "",
            ),
          );
        }
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.success,
            data: res.data,
            patientMandatoryData: patientMandatoryList,
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

  mandatoryRequiredWarningSave(String warning, String message) {
    List<String> requiredWarning = state.requiredWarning;
    requiredWarning.add("$warning $message");
    safeEmit(state.copyWith(requiredWarning: requiredWarning));
  }

  mandatoryRequiredWarningClear() {
    safeEmit(state.copyWith(requiredWarning: []));
  }

  void mandatoryValueSave(String id, String value) {
    List<PatientMandatoryModel> patientMandatoryList =
        state.patientMandatoryData;
    final index = patientMandatoryList.indexWhere(
      (element) => element.id == id,
    );
    if (index >= 0) {
      patientMandatoryList[index].value = value;
      safeEmit(state.copyWith(patientMandatoryData: patientMandatoryList));
    }
  }
}
