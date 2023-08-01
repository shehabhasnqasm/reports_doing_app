import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/email_user_model.dart';
import 'package:reports_doing_app/features/reports/domin_layer/usecases/get_admin_emails_for_crnt_usr_uc.dart';

part 'get_admin_emails_state.dart';

class GetAdminEmailsCubit extends Cubit<GetAdminEmailsState> {
  final GetAdminEmailsForCurrentUserUseCase getAdminEmailsForCurrentUserUseCase;
  GetAdminEmailsCubit({required this.getAdminEmailsForCurrentUserUseCase})
      : super(GetAdminEmailsInitial());

  Future<void> getAdminEmailsforCurntUser() async {
    emit(LoadingState());
    final success = await getAdminEmailsForCurrentUserUseCase.call();

    success.fold((failure) {
      emit(FailureGetAdminEmailsState(errorMsg: errorMsgState(failure)));
    }, (emails) async {
      if (emails.isNotEmpty) {
        emit(SuccessGetAdminEmailsState(emails: emails));
      } else if (emails.isEmpty) {
        emit(GetAdminEmailsInitial());
      }
    });
    //emit(const UnAuthenticatedState(errorMsg: ""));
  }

  String errorMsgState(ReportFailure failure) {
    switch (failure.runtimeType) {
      case OfflineReportFailure:
        return OfflineReportFailure().message;
      case PublicErrorFailure:
        return PublicErrorFailure().message;

      default:
        return "unknown error when getting reports from firebase ";
    }
  }
}
