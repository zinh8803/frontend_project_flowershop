import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/views/widgets/home/register_screen.dart';

class RegisterLink extends StatelessWidget {
  const RegisterLink({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
      },
      child: const Text(
        "Chưa có tài khoản? Đăng ký ngay",
        style: TextStyle(
          fontSize: 16,
          color: Colors.deepPurple,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
