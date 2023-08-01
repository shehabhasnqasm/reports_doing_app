// ignore_for_file: must_be_immutable

part of 'get_admin_emails_cubit.dart';

abstract class GetAdminEmailsState extends Equatable {
  const GetAdminEmailsState();

  @override
  List<Object> get props => [];
}

class GetAdminEmailsInitial extends GetAdminEmailsState {}

class LoadingState extends GetAdminEmailsState {}

class SuccessGetAdminEmailsState extends GetAdminEmailsState {
  List<EmailUserModel> emails = [];
  SuccessGetAdminEmailsState({required this.emails});

  @override
  List<Object> get props => [emails];
}

class FailureGetAdminEmailsState extends GetAdminEmailsState {
  final String errorMsg;
  const FailureGetAdminEmailsState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
