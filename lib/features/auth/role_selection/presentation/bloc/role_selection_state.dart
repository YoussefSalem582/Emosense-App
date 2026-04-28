import 'package:equatable/equatable.dart';
import 'package:emosense_mobile/features/auth/role_selection/domain/entities/role_selection_destination.dart';

class RoleSelectionState extends Equatable {
  const RoleSelectionState({this.pending});

  final RoleSelectionDestination? pending;

  @override
  List<Object?> get props => [pending];
}
