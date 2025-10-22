import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/enum/enum_patient_registration_procedures.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../features/utility/enum/enum_general_state_status.dart';

import '../../../features/utility/user_http_service.dart';
import '../cubit/patient_registration_procedures_cubit.dart';
import '../../../core/utility/user_login_status_service.dart';
import '../../../features/utility/const/constant_string.dart';
import '../model/patient_registration_procedures_request_model.dart';
import '../service/patient_registration_procedures_service.dart';
import 'widget/info_container_widget.dart';

class PatientRegistrationProceduresView extends StatelessWidget {
  final EnumPatientRegistrationProcedures startStep;
  final PatientRegistrationProceduresModel? model;
  const PatientRegistrationProceduresView({
    super.key,
    required this.startStep,
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    final aColor = Theme.of(context).colorScheme.primary;
    final iColor = Colors.grey.shade300;
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => PatientRegistrationProceduresCubit(
        service: PatientRegistrationProceduresService(UserHttpService()),
        startStep: startStep,
        model: model,
      ),
      child:
          BlocConsumer<
            PatientRegistrationProceduresCubit,
            PatientRegistrationProceduresState
          >(
            listener: (context, state) {
              switch (state.status) {
                case EnumGeneralStateStatus.loading:
                  // AppDialog(context).loadingDialog();
                  break;
                case EnumGeneralStateStatus.success:
                  // NavigationService.ns.goBack();
                  break;
                case EnumGeneralStateStatus.failure:
                  // NavigationService.ns.goBack();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message ?? 'Error')),
                  );
                  break;
                default:
              }
            },
            builder: (context, state) {
              return Scaffold(
                body: SafeArea(
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final count =
                                        EnumPatientRegistrationProcedures
                                            .values
                                            .length;
                                    final tileWidth =
                                        constraints.maxWidth / count;
                                    return FixedTimeline.tileBuilder(
                                      theme: TimelineThemeData(
                                        direction: Axis.horizontal,
                                        nodePosition: 0.5,
                                        connectorTheme: ConnectorThemeData(
                                          thickness: 8,
                                          color: iColor,
                                        ),
                                        indicatorTheme: IndicatorThemeData(
                                          size: 26,
                                          color: aColor,
                                        ),
                                      ),
                                      builder: TimelineTileBuilder.connected(
                                        connectionDirection:
                                            ConnectionDirection.before,
                                        itemCount: count,
                                        itemExtent: tileWidth,
                                        indicatorBuilder: (_, index) {
                                          final reached =
                                              index <= state.currentStep.index;
                                          final reachedDone =
                                              index <=
                                              state.currentStep.index - 1;
                                          return AnimatedScale(
                                            scale: reached ? 1.0 : 0.95,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.easeInOutCubic,
                                            child: DotIndicator(
                                              size: reached ? 34 : 30,
                                              color: reached ? aColor : iColor,
                                              child: AnimatedSwitcher(
                                                duration: const Duration(
                                                  milliseconds: 350,
                                                ),
                                                transitionBuilder:
                                                    (child, anim) =>
                                                        FadeTransition(
                                                          opacity: anim,
                                                          child: child,
                                                        ),
                                                child: Icon(
                                                  reachedDone
                                                      ? Icons.check
                                                      : Icons.circle,
                                                  key: ValueKey<bool>(
                                                    reachedDone,
                                                  ),
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        connectorBuilder: (_, index, __) {
                                          final filled =
                                              index <= state.currentStep.index;
                                          return TweenAnimationBuilder<Color?>(
                                            duration: const Duration(
                                              milliseconds: 600,
                                            ),
                                            curve: Curves.easeInOutCubic,
                                            tween: ColorTween(
                                              begin: iColor,
                                              end: filled ? aColor : iColor,
                                            ),
                                            builder: (context, color, _) =>
                                                SolidLineConnector(
                                                  color: color,
                                                ),
                                          );
                                        },
                                        contentsBuilder: (context, index) {
                                          final reached =
                                              index <= state.currentStep.index;
                                          final label =
                                              EnumPatientRegistrationProcedures
                                                  .values[index]
                                                  .label;
                                          final baseStyle =
                                              textTheme.labelMedium ??
                                              const TextStyle(fontSize: 12);
                                          final targetStyle = baseStyle
                                              .copyWith(
                                                fontWeight: reached
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                                color: reached
                                                    ? aColor
                                                    : Colors.grey,
                                              );
                                          final content = Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(height: 12),
                                              AnimatedOpacity(
                                                duration: const Duration(
                                                  milliseconds: 450,
                                                ),
                                                opacity: reached ? 1.0 : 0.7,
                                                child: AnimatedDefaultTextStyle(
                                                  duration: const Duration(
                                                    milliseconds: 450,
                                                  ),
                                                  style: targetStyle,
                                                  child: Text(
                                                    label,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            child: content,
                                          );
                                        },
                                        indicatorPositionBuilder: (_, __) =>
                                            0.5,
                                        contentsAlign: ContentsAlign.basic,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              _ButtonBar(
                                currentStep: state.currentStep,
                                startStep: startStep,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                child: InfoContainerWidget(model: state.model),
                              ),
                              Expanded(
                                child: state.currentStep.widget(state.model),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}

class _ButtonBar extends StatelessWidget {
  final EnumPatientRegistrationProcedures startStep;
  final EnumPatientRegistrationProcedures currentStep;
  const _ButtonBar({required this.currentStep, required this.startStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        currentStep.isGoBack
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (currentStep == startStep) {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    } else {
                      context
                          .read<PatientRegistrationProceduresCubit>()
                          .previousStep();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey[800],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: Colors.grey[800],
                  ),
                  label: Text(
                    currentStep == startStep
                        ? ConstantString().homePageTitle
                        : currentStep.index > 0
                        ? EnumPatientRegistrationProcedures
                              .values[currentStep.index - 1]
                              .label
                        : '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        if (!(currentStep.isGoBack))
          ElevatedButton.icon(
            onPressed: () => UserLoginStatusService().logout(),
            icon: const Icon(Icons.logout, size: 18),
            label: Text(ConstantString().logout),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
      ],
    );
  }
}
