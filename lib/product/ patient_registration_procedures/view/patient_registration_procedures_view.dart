import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/enum/enum_patient_registration_procedures.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/navigation_service.dart';
import '../../../features/widget/loading_show_dialog.dart';
import '../cubit/patient_registration_procedures_cubit.dart';

class PatientRegistrationProceduresView extends StatelessWidget {
  final EnumPatientRegistrationProcedures startStep;
  final bool showBack;
  const PatientRegistrationProceduresView({
    super.key,
    required this.startStep,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final aColor = Theme.of(context).colorScheme.primary;
    final iColor = Colors.grey.shade300;
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) =>
          PatientRegistrationProceduresCubit(startStep: startStep),
      child:
          BlocConsumer<
            PatientRegistrationProceduresCubit,
            PatientRegistrationProceduresState
          >(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              switch (state.status) {
                case EnumGeneralStateStatus.loading:
                  AppDialog(context).loadingDialog();
                  break;
                case EnumGeneralStateStatus.success:
                  NavigationService.ns.goBack();
                  break;
                case EnumGeneralStateStatus.failure:
                  NavigationService.ns.goBack();
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: 100,
                              child: FixedTimeline.tileBuilder(
                                theme: TimelineThemeData(
                                  direction: Axis.horizontal,
                                  nodePosition: 0.25,
                                  connectorTheme: ConnectorThemeData(
                                    thickness: 5,
                                    color: iColor,
                                  ),
                                  indicatorTheme: IndicatorThemeData(
                                    size: 18,
                                    color: aColor,
                                  ),
                                ),
                                builder: TimelineTileBuilder.connected(
                                  connectionDirection:
                                      ConnectionDirection.before,
                                  itemCount: EnumPatientRegistrationProcedures
                                      .values
                                      .length,
                                  indicatorBuilder: (_, index) {
                                    final reached =
                                        index <= state.currentStep.index;
                                    final reachedDone =
                                        index <= state.currentStep.index - 1;
                                    return DotIndicator(
                                      size: 25,
                                      color: reached ? aColor : iColor,
                                      child: Icon(
                                        reachedDone
                                            ? Icons.check
                                            : Icons.circle,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                  connectorBuilder: (_, index, __) {
                                    final filled =
                                        index <= state.currentStep.index;
                                    return SolidLineConnector(
                                      color: filled ? aColor : iColor,
                                    );
                                  },
                                  contentsBuilder: (context, index) {
                                    final reached =
                                        index <= state.currentStep.index;
                                    final color = reached
                                        ? aColor
                                        : Colors.grey;
                                    final label =
                                        EnumPatientRegistrationProcedures
                                            .values[index]
                                            .label
                                            .tr();

                                    final content = Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 12),
                                        Text(
                                          label,
                                          textAlign: TextAlign.center,
                                          style: textTheme.labelMedium
                                              ?.copyWith(
                                                fontWeight: reached
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                                color: color,
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
                                  indicatorPositionBuilder: (_, __) => 0.0,
                                  contentsAlign: ContentsAlign.basic,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            infoWidget("Bölüm", state.model.departmentName),
                            infoWidget("Doktor", state.model.doctorName),
                            infoWidget("Sigorta", state.model.associationName),
                            Expanded(
                              child: state.currentStep.widget(state.model),
                            ),
                          ],
                        ),
                      ),
                      if (showBack)
                        Positioned(
                          top: 90,
                          left: 8,
                          child: _BackButton(
                            color: aColor,
                            onPressed: () {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }
                            },
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

  infoWidget(String title, String? text) {
    return Visibility(
      visible: text != null && text.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("$title: ${text ?? ""}", textAlign: TextAlign.center),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed, required this.color});
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.arrow_back, size: 22, color: color),
        ),
      ),
    );
  }
}
