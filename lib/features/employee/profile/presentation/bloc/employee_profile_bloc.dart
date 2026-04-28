import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'employee_profile_event.dart';
part 'employee_profile_state.dart';

/// Profile UI state for the employee profile tab (demo/mock data until wired to backend).
class EmployeeProfileBloc
    extends Bloc<EmployeeProfileEvent, EmployeeProfileState> {
  EmployeeProfileBloc() : super(const EmployeeProfileInitial()) {
    on<EmployeeProfileLoadRequested>(_onLoad);
    on<EmployeeProfileRefreshRequested>(_onRefresh);
    on<EmployeeProfileNotificationsChanged>(_onNotificationsChanged);
    on<EmployeeProfileEmailAlertsChanged>(_onEmailAlertsChanged);
    on<EmployeeProfileLanguageChanged>(_onLanguageChanged);
  }

  EmployeeProfileData get _seed => const EmployeeProfileData(
    name: 'Youssef Hassan',
    position: 'Customer Service Representative',
    status: 'Active',
    email: 'youssef.hassan@company.com',
    phone: '+20 1026855881',
    department: 'Customer Support',
    employeeId: '211000582',
    startDate: 'January 15, 2025',
    location: 'Giza',
    manager: 'Dr Walaa',
    team: 'Customer Experience',
    notificationsEnabled: true,
    emailAlerts: false,
    selectedLanguage: 'English',
  );

  Future<void> _onLoad(
    EmployeeProfileLoadRequested event,
    Emitter<EmployeeProfileState> emit,
  ) async {
    emit(const EmployeeProfileLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      emit(EmployeeProfileSuccess(_seed));
    } catch (e) {
      emit(EmployeeProfileError(e.toString()));
    }
  }

  Future<void> _onRefresh(
    EmployeeProfileRefreshRequested event,
    Emitter<EmployeeProfileState> emit,
  ) async {
    await _reloadFromSuccess(emit);
  }

  Future<void> _reloadFromSuccess(Emitter<EmployeeProfileState> emit) async {
    final current = state;
    if (current is! EmployeeProfileSuccess) {
      await _onLoad(const EmployeeProfileLoadRequested(), emit);
      return;
    }
    emit(const EmployeeProfileLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      emit(EmployeeProfileSuccess(current.data));
    } catch (e) {
      emit(EmployeeProfileError(e.toString()));
    }
  }

  void _onNotificationsChanged(
    EmployeeProfileNotificationsChanged event,
    Emitter<EmployeeProfileState> emit,
  ) {
    final current = state;
    if (current is! EmployeeProfileSuccess) return;
    emit(
      EmployeeProfileSuccess(
        current.data.copyWith(notificationsEnabled: event.value),
      ),
    );
  }

  void _onEmailAlertsChanged(
    EmployeeProfileEmailAlertsChanged event,
    Emitter<EmployeeProfileState> emit,
  ) {
    final current = state;
    if (current is! EmployeeProfileSuccess) return;
    emit(
      EmployeeProfileSuccess(current.data.copyWith(emailAlerts: event.value)),
    );
  }

  void _onLanguageChanged(
    EmployeeProfileLanguageChanged event,
    Emitter<EmployeeProfileState> emit,
  ) {
    final current = state;
    if (current is! EmployeeProfileSuccess) return;
    emit(
      EmployeeProfileSuccess(
        current.data.copyWith(selectedLanguage: event.language),
      ),
    );
  }
}
