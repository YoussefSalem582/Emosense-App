/// Public API for the tickets feature (attendance-style feature module).
library;

export 'shared/data/datasources/ticket_local_data_source.dart';
export 'shared/data/models/ticket_model.dart';
export 'shared/data/repositories/ticket_repository_impl.dart';
export 'shared/domain/entities/ticket.dart';
export 'shared/domain/repositories/ticket_ports.dart';
export 'shared/domain/repositories/ticket_repository.dart';
export 'shared/presentation/models/ticket_ui_models.dart';

export 'admin/domain/repositories/admin_tickets_repository.dart';
export 'admin/data/repositories/admin_tickets_repository_impl.dart';
export 'employee/domain/repositories/employee_tickets_repository.dart';
export 'employee/data/repositories/employee_tickets_repository_impl.dart';

export 'admin/presentation/bloc/admin_tickets_bloc.dart';
export 'employee/presentation/bloc/employee_tickets_bloc.dart';
export 'admin/presentation/pages/admin_tickets_page.dart';
export 'employee/presentation/pages/employee_tickets_page.dart';
