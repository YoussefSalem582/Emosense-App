import 'package:equatable/equatable.dart';
import 'package:emosense_mobile/features/auth/auth_choice/domain/entities/auth_choice_destination.dart';

class AuthChoiceState extends Equatable {
  const AuthChoiceState({this.pending});

  final AuthChoiceDestination? pending;

  @override
  List<Object?> get props => [pending];
}
