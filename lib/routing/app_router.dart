import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/auth/phone_entry_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/permission_explainer_screen.dart';
import '../screens/citizen/citizen_home_feed_screen.dart';
import '../screens/citizen/report_issue_form_screen.dart';
import '../screens/citizen/report_success_xp_screen.dart';
import '../screens/citizen/issue_detail_active_screen.dart';
import '../screens/citizen/issue_detail_resolved_screen.dart';
import '../screens/citizen/my_reports_screen.dart';
import '../screens/citizen/safety_map_screen.dart';
import '../screens/citizen/citizen_profile_screen.dart';
import '../screens/volunteer/volunteer_dispatch_feed_screen.dart';
import '../screens/volunteer/task_detail_pre_accept_screen.dart';
import '../screens/volunteer/task_detail_claimed_screen.dart';
import '../screens/volunteer/taken_snackbar_screen.dart';
import '../screens/volunteer/resolve_confirmation_sheet_screen.dart';
import '../screens/volunteer/volunteer_history_screen.dart';
import '../screens/volunteer/volunteer_profile_screen.dart';
import '../screens/kyc/kyc_intro_screen.dart';
import '../screens/kyc/selfie_capture_screen.dart';
import '../screens/kyc/id_front_capture_screen.dart';
import '../screens/kyc/id_back_capture_screen.dart';
import '../screens/kyc/kyc_pending_screen.dart';
import '../screens/shared/settings_screen.dart';
import '../screens/shared/help_faq_screen.dart';
import '../screens/shared/about_sudarshan_screen.dart';
import '../screens/shared/sudarshan_vision_screen.dart';
import '../screens/shared/role_menu_bottom_sheet_screen.dart';
import '../screens/shared/zone_detail_sheet_screen.dart';
import '../screens/shared/badge_unlock_screen.dart';
import '../screens/shared/achievement_unlocked_screen.dart';
import '../screens/shared/location_permission_request_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/welcome',
    debugLogDiagnostics: true,
    onException: (context, state, router) {
      // Gracefully handle navigation failures (e.g., pop on root route)
      debugPrint('GoRouter exception: ${state.error}');
    },
    routes: [
      // Auth Flow
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/phone-entry',
        name: 'phoneEntry',
        builder: (context, state) => const PhoneEntryScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        name: 'otpVerification',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        name: 'roleSelection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/permission-explainer',
        name: 'permissionExplainer',
        builder: (context, state) => const PermissionExplainerScreen(),
      ),
      GoRoute(
        path: '/location-permission',
        name: 'locationPermission',
        builder: (context, state) => const LocationPermissionRequestScreen(),
      ),

      // Citizen Flow
      GoRoute(
        path: '/citizen-home',
        name: 'citizenHome',
        builder: (context, state) => const CitizenHomeFeedScreen(),
      ),
      GoRoute(
        path: '/report-issue',
        name: 'reportIssue',
        builder: (context, state) => const ReportIssueFormScreen(),
      ),
      GoRoute(
        path: '/report-success',
        name: 'reportSuccess',
        builder: (context, state) => const ReportSuccessXpScreen(),
      ),
      GoRoute(
        path: '/issue-detail-active',
        name: 'issueDetailActive',
        builder: (context, state) => const IssueDetailActiveScreen(),
      ),
      GoRoute(
        path: '/issue-detail-resolved',
        name: 'issueDetailResolved',
        builder: (context, state) => const IssueDetailResolvedScreen(),
      ),
      GoRoute(
        path: '/my-reports',
        name: 'myReports',
        builder: (context, state) => const MyReportsScreen(),
      ),
      GoRoute(
        path: '/safety-map',
        name: 'safetyMap',
        builder: (context, state) => const SafetyMapScreen(),
      ),
      GoRoute(
        path: '/citizen-profile',
        name: 'citizenProfile',
        builder: (context, state) => const CitizenProfileScreen(),
      ),

      // Volunteer Flow
      GoRoute(
        path: '/volunteer-feed',
        name: 'volunteerFeed',
        builder: (context, state) => const VolunteerDispatchFeedScreen(),
      ),
      GoRoute(
        path: '/task-detail-pre-accept',
        name: 'taskDetailPreAccept',
        builder: (context, state) => const TaskDetailPreAcceptScreen(),
      ),
      GoRoute(
        path: '/task-detail-claimed',
        name: 'taskDetailClaimed',
        builder: (context, state) => const TaskDetailClaimedScreen(),
      ),
      GoRoute(
        path: '/taken-snackbar',
        name: 'takenSnackbar',
        builder: (context, state) => const TakenSnackbarScreen(),
      ),
      GoRoute(
        path: '/resolve-confirmation',
        name: 'resolveConfirmation',
        builder: (context, state) => const ResolveConfirmationSheetScreen(),
      ),
      GoRoute(
        path: '/volunteer-history',
        name: 'volunteerHistory',
        builder: (context, state) => const VolunteerHistoryScreen(),
      ),
      GoRoute(
        path: '/volunteer-profile',
        name: 'volunteerProfile',
        builder: (context, state) => const VolunteerProfileScreen(),
      ),

      // KYC Flow
      GoRoute(
        path: '/kyc-intro',
        name: 'kycIntro',
        builder: (context, state) => const KycIntroScreen(),
      ),
      GoRoute(
        path: '/selfie-capture',
        name: 'selfieCapture',
        builder: (context, state) => const SelfieCaptureScreen(),
      ),
      GoRoute(
        path: '/id-front-capture',
        name: 'idFrontCapture',
        builder: (context, state) => const IdFrontCaptureScreen(),
      ),
      GoRoute(
        path: '/id-back-capture',
        name: 'idBackCapture',
        builder: (context, state) => const IdBackCaptureScreen(),
      ),
      GoRoute(
        path: '/kyc-pending',
        name: 'kycPending',
        builder: (context, state) => const KycPendingScreen(),
      ),

      // Shared / Settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/help-faq',
        name: 'helpFaq',
        builder: (context, state) => const HelpFaqScreen(),
      ),
      GoRoute(
        path: '/about-sudarshan',
        name: 'aboutSudarshan',
        builder: (context, state) => const AboutSudarshanScreen(),
      ),
      GoRoute(
        path: '/sudarshan-vision',
        name: 'sudarshanVision',
        builder: (context, state) => const SudarshanVisionScreen(),
      ),
      GoRoute(
        path: '/role-menu',
        name: 'roleMenu',
        builder: (context, state) => const RoleMenuBottomSheetScreen(),
      ),
      GoRoute(
        path: '/zone-detail',
        name: 'zoneDetail',
        builder: (context, state) => const ZoneDetailSheetScreen(),
      ),
      GoRoute(
        path: '/badge-unlock',
        name: 'badgeUnlock',
        builder: (context, state) => const BadgeUnlockScreen(),
      ),
      GoRoute(
        path: '/achievement-unlocked',
        name: 'achievementUnlocked',
        builder: (context, state) => const AchievementUnlockedScreen(),
      ),
    ],
  );
}
