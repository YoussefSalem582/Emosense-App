import 'package:equatable/equatable.dart';

enum AuthChoiceDestination { login, signup, onboarding }

class AuthChoiceState extends Equatable {
  const AuthChoiceState({this.pending});

  final AuthChoiceDestination? pending;

  @override
  List<Object?> get props => [pending];
}
