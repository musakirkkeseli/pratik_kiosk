import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/core/widget/loading_widget.dart';
import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';
import 'package:kiosk/features/utility/user_http_service.dart';

import '../../../features/utility/const/constant_string.dart';
import '../cubit/section_search_cubit.dart';
import '../service/section_search_service.dart';
import 'widget/section_search_list_view_widget.dart';

class SectionSearchView extends StatefulWidget {
  final bool isAppointment;
  const SectionSearchView({super.key, this.isAppointment = false});

  @override
  State<SectionSearchView> createState() => _SectionSearchViewState();
}

class _SectionSearchViewState extends State<SectionSearchView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SectionSearchCubit>(
      create: (context) => SectionSearchCubit(
        service: SectionSearchService(UserHttpService()),
        isAppointment: widget.isAppointment,
      )..fetchSections(),
      child: BlocBuilder<SectionSearchCubit, SectionSearchState>(
        builder: (context, state) {
          if (widget.isAppointment) {
            return Scaffold(
              appBar: AppBar(title: Text(ConstantString().sectionSelection)),
              body: Padding(
                padding: EdgeInsets.all(20),
                child: _bodyFunc(state, context),
              ),
            );
          }
          return _bodyFunc(state, context);
        },
      ),
    );
  }

  _bodyFunc(SectionSearchState state, BuildContext context) {
    switch (state.status) {
      case EnumGeneralStateStatus.loading:
        return LoadingWidget();
      case EnumGeneralStateStatus.success:
        return SectionSearchListViewWidget(
          sectionItemList: state.data,
          isAppointment: widget.isAppointment,
        );
      default:
        return Center(
          child: Text(state.message ?? ConstantString().errorOccurred),
        );
    }
  }
}
