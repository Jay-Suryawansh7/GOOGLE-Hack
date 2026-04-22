import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';
import '../../core/navigation_extensions.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;
  String? _phone;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is String) {
      _phone = extra;
    }
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6 || _phone == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        phone: _phone!,
        token: otp,
        type: OtpType.sms,
      );

      if (response.session != null) {
        // Check if user already has a profile/role
        final user = response.session!.user;
        final profile = await Supabase.instance.client
            .from('profiles')
            .select('role')
            .eq('id', user.id)
            .maybeSingle();

        if (mounted) {
          if (profile != null && profile['role'] != null) {
            // Existing user with role
            final role = profile['role'] as String;
            if (role == 'citizen') {
              context.go('/citizen-home');
            } else if (role == 'volunteer') {
              context.go('/volunteer-feed');
            } else {
              context.go('/role-selection');
            }
          } else {
            // New user
            context.go('/role-selection');
          }
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOTP() async {
    if (_phone == null) return;
    try {
      await Supabase.instance.client.auth.signInWithOtp(phone: _phone!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent')),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.safePop('/phone-entry'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify Number',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  children: [
                    const TextSpan(text: 'Enter code sent to \n'),
                    TextSpan(
                      text: _phone ?? '+91 XXXXX XXXXX',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    height: 56,
                    child: TextField(
                      controller: _otpControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.surfaceContainerLowest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          borderSide: const BorderSide(color: AppColors.secondaryContainer, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextButton(
                onPressed: _resendOTP,
                child: const Text('Resend OTP'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyOTP,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Verify & Continue'),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
