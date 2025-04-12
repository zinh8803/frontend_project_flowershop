abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String name;

  RegisterSubmitted(this.email, this.password, this.name);
}
