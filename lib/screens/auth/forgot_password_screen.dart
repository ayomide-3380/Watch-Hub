import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    if (_emailController.text.trim().isNotEmpty && _emailController.text.contains('@')) {
      setState(() => _isSent = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(title: const Text('RECOVER ACCESS')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isSent
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mark_email_read_outlined, color: AppTheme.goldAccent, size: 72),
                  const SizedBox(height: 24),
                  Text(
                    'Reset Link Dispatched',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We have sent a secure password reset link to ${_emailController.text}. Please check your inbox.',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('RETURN TO SIGN IN'),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forgot Your Password?',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter your registered email address and we will send instructions to reset your password.',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 28),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Registered Email Address',
                      prefixIcon: Icon(Icons.email_outlined, color: AppTheme.goldAccent),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _sendResetLink,
                      child: const Text('DISPATCH RESET LINK'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
