import 'package:equatable/equatable.dart';

enum RoleSelectionDestination { authChoice, splash }

class RoleSelectionState extends Equatable {
  const RoleSelectionState({this.pending});

  final RoleSelectionDestination? pending;

  @override
  List<Object?> get props => [pending];
}
