part of '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _termsAccepted = false;
  bool _obscurePassword = true;

  bool get _canLogin => _termsAccepted;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_canLogin) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const AppShell()));
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.maxContentWidth(context),
                ),
                child: Padding(
                  padding: Responsive.pagePadding(
                    context,
                  ).copyWith(top: 0, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          height: 98,
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
                      const SizedBox(height: 12),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: isTablet ? 26 : 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your credentials to access your EV service dashboard.',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: isTablet ? 40 : 25),
                      Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Enter email address',
                          hintStyle: TextStyle(
                            color: Color(0xFFB8C2CF),
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      SizedBox(height: isTablet ? 24 : 18),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB8C2CF),
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _termsAccepted,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() => _termsAccepted = value ?? false);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'By clicking continue, you agree to our ',
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: isTablet ? 16 : 13,
                                  height: 1.35,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: const TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const TermsOfServiceScreen(),
                                          ),
                                        );
                                      },
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: const TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const PrivacyPolicyScreen(),
                                          ),
                                        );
                                      },
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _canLogin ? _login : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            disabledBackgroundColor: const Color(0xFFD7DEE8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: isTablet ? 15 : 13,
                              fontWeight: FontWeight.w500,
                            ),
                            children: const [
                              TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
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
