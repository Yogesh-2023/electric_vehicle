part of '../main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isMailSent = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          titleSpacing: 0,
          title: Text(
            _isMailSent ? 'Reset Password' : 'Forgot Password',
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.maxContentWidth(context),
                ),
                child: Padding(
                  padding: Responsive.pagePadding(context).copyWith(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isMailSent) ...[
                        Center(
                          child: SizedBox(
                            height: 80,
                            child: OverflowBox(
                              minHeight: 125,
                              maxHeight: 125,
                              child: Image.asset(
                                'assets/images/new-ev-care-logo.png',
                                width: 300,
                                height: 125,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      Text(
                        _isMailSent
                            ? 'Enter the token received in your email and your new password.'
                            : 'Enter your registered email to receive a reset token.',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: isTablet ? 40 : 25),
                      if (!_isMailSent) ...[
                        const FieldLabel('Email Address'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                      ] else ...[
                        const FieldLabel('Token'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _tokenController,
                          decoration: const InputDecoration(
                            hintText: 'Enter Token',
                          ),
                        ),
                        const SizedBox(height: 18),
                        const FieldLabel('New Password'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'New Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(
                                  () => _obscurePassword = !_obscurePassword,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const FieldLabel('Confirm Password'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: _obscurePassword,
                          decoration: const InputDecoration(
                            hintText: 'Confirm Password',
                          ),
                        ),
                      ],
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (!_isMailSent) {
                              setState(() => _isMailSent = true);
                              _showScreenSnack(context, 'Reset token sent');
                            } else {
                              _showScreenSnack(
                                context,
                                'Password reset successful',
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            _isMailSent ? 'Reset Password' : 'Submit',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
