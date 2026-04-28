/// Public API for the tickets feature (attendance-style feature module).
library;

export 'shared/data/datasources/ticket_local_data_source.dart';
export 'shared/data/models/ticket_model.dart';
export 'shared/data/repositories/ticket_repository_impl.dart';
export 'shared/domain/entities/ticket.dart';
export 'shared/domain/repositories/ticket_repository.dart';
export 'shared/presentation/bloc/tickets_bloc.dart';
export 'admin/presentation/pages/admin_tickets_page.dart';
export 'employee/presentation/pages/employee_tickets_page.dart';
