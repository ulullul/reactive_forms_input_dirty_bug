import 'package:reactive_forms_annotations/reactive_forms_annotations.dart';

part 'login_model_form.gform.dart';

@Rf()
class LoginModel {
  final String email;
  final String password;

  LoginModel({
    @RfControl(
      validators: [RequiredValidator(), EmailValidator()],
    )
    this.email = '',
    @RfControl(
      validators: [RequiredValidator()],
    )
    this.password = '',
  });
}
