part of 'section_search_cubit.dart';

class SectionSearchState {
  final EnumGeneralStateStatus status;
  final List<SectionItems> data;
  final String? message;

  const SectionSearchState({
    this.status = EnumGeneralStateStatus.initial,
    this.data = const [],
    this.message,
  });

  SectionSearchState copyWith({
    EnumGeneralStateStatus? status,
    List<SectionItems>? data,
    String? message,
  }) {
    return SectionSearchState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message,
    );
  }
}
