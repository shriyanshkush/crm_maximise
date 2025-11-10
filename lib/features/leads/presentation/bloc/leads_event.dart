import 'package:equatable/equatable.dart';

abstract class LeadsEvent extends Equatable {
  const LeadsEvent();
  @override
  List<Object?> get props => [];
}

class LoadLeadsEvent extends LeadsEvent {
  final int page;
  final int limit;
  final String? status;
  final String? source;
  final String? startDate;
  final String? endDate;

  const LoadLeadsEvent({
    this.page = 1,
    this.limit = 20,
    this.status,
    this.source,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [page, limit, status, source, startDate, endDate];
}

class CreateLeadEvent extends LeadsEvent {
  final String name;
  final String email;
  final String phone;
  final String source;

  const CreateLeadEvent({required this.name, required this.email, required this.phone, required this.source});
  @override
  List<Object?> get props => [name, email, phone, source];
}

class RefreshLeadsEvent extends LeadsEvent {}
class ExportCsvEvent extends LeadsEvent {
  final String? startDate;
  final String? endDate;
  final String? status;
  final String? source;
  const ExportCsvEvent({this.startDate, this.endDate, this.status, this.source});
  @override
  List<Object?> get props => [startDate, endDate, status, source];
}
