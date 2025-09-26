import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  PatientCubit() : super(PatientInitial());
}
