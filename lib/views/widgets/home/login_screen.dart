import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/auth/auth_bloc.dart';
import 'package:frontend_appflowershop/bloc/auth/auth_event.dart';
import 'package:frontend_appflowershop/bloc/auth/auth_state.dart';
import 'package:frontend_appflowershop/views/screens/home_screen.dart';
import 'package:frontend_appflowershop/views/widgets/login/login_form.dart';
import 'package:frontend_appflowershop/views/widgets/login/register_link.dart';
import 'package:frontend_appflowershop/views/widgets/login/login_button.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _preferenceService = PreferenceService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Builder(
        builder: (BuildContext context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is AuthSuccess) {
                    // Lưu token vào SharedPreferences
                    await PreferenceService.saveToken(state.user.token);

                    // Hiển thị thông báo
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Đăng nhập thành công: ${state.user.name}')),
                    );

                    // Điều hướng sang HomeScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
              ),
            ],
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline,
                        size: 100, color: Colors.deepPurple),
                    const SizedBox(height: 30),
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    LoginForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return LoginButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (_formKey.currentState != null &&
                                        _formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(
                                            LoginEvent(
                                              _emailController.text,
                                              _passwordController.text,
                                            ),
                                          );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Biểu mẫu chưa sẵn sàng')),
                                      );
                                    }
                                  });
                                },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const RegisterLink(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
