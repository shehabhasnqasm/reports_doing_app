part of 'add_admin_email_cubit.dart';

abstract class AddAdminEmailState extends Equatable {
  const AddAdminEmailState();

  @override
  List<Object> get props => [];
}

class AddAdminEmailInitial extends AddAdminEmailState {}

class LoadingAddAdminEmailState extends AddAdminEmailState {}

class SuccessAddAdminEmailStatee extends AddAdminEmailState {
  const SuccessAddAdminEmailStatee();
}

class FailurAddAdminEmailState extends AddAdminEmailState {
  final String errorMsg;
  const FailurAddAdminEmailState({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
