import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
import 'package:reports_doing_app/features/reports/domin_layer/usecases/add_email_to_crnt_usr_usecase.dart';

part 'add_admin_email_state.dart';

class AddAdminEmailCubit extends Cubit<AddAdminEmailState> {
  final AddAdminEmailToCurrentUserUseCase addAdminEmailToCurrentUserUseCase;
  AddAdminEmailCubit({required this.addAdminEmailToCurrentUserUseCase})
      : super(AddAdminEmailInitial());

  Future<void> addAdminEmail(String name, String email) async {
    emit(LoadingAddAdminEmailState());
    var addedEmail = await addAdminEmailToCurrentUserUseCase.call(email, name);
    addedEmail.fold((failure) {
      emit(FailurAddAdminEmailState(errorMsg: errorMsgState(failure)));
    }, (unit) {
      emit(const SuccessAddAdminEmailStatee());
    });
  }
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
