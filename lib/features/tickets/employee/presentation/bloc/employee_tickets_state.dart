part of 'employee_tickets_bloc.dart';

abstract class EmployeeTicketsState extends Equatable {
  const EmployeeTicketsState();

  @override
  List<Object?> get props => [];
}

class EmployeeTicketsInitial extends EmployeeTicketsState {
  const EmployeeTicketsInitial();
}

class EmployeeTicketsLoading extends EmployeeTicketsState {
  const EmployeeTicketsLoading();
}

class EmployeeTicketsSuccess extends EmployeeTicketsState {
  final EmployeeTicketsData data;

  const EmployeeTicketsSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class EmployeeTicketsError extends EmployeeTicketsState {
  final String message;

  const EmployeeTicketsError(this.message);

  @override
  List<Object?> get props => [message];
}
