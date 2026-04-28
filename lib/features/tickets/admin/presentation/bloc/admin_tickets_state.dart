part of 'admin_tickets_bloc.dart';

abstract class AdminTicketsState extends Equatable {
  const AdminTicketsState();

  @override
  List<Object?> get props => [];
}

class AdminTicketsInitial extends AdminTicketsState {
  const AdminTicketsInitial();
}

class AdminTicketsLoading extends AdminTicketsState {
  const AdminTicketsLoading();
}

class AdminTicketsSuccess extends AdminTicketsState {
  final AdminTicketsData data;

  const AdminTicketsSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class AdminTicketsError extends AdminTicketsState {
  final String message;

  const AdminTicketsError(this.message);

  @override
  List<Object?> get props => [message];
}
