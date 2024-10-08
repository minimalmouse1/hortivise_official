// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:horti_vige/data/services/notification_service.dart';
import 'package:horti_vige/firebase_options.dart';
import 'package:horti_vige/providers/availability_provider.dart';
import 'package:horti_vige/providers/blogs_provider.dart';
import 'package:horti_vige/providers/chat_provider.dart';
import 'package:horti_vige/providers/consultation_pricing_provider.dart';
import 'package:horti_vige/providers/consultations_provider.dart';
import 'package:horti_vige/providers/notifications_provider.dart';
import 'package:horti_vige/providers/packages_provider.dart';
import 'package:horti_vige/providers/user_provider.dart';
import 'package:horti_vige/providers/wallet_provider.dart';
import 'package:horti_vige/ui/screens/auth/become_consultant_screen.dart';
import 'package:horti_vige/ui/screens/auth/change_password_screen.dart';
import 'package:horti_vige/ui/screens/auth/login_screen.dart';
import 'package:horti_vige/ui/screens/auth/signup_screen.dart';
import 'package:horti_vige/ui/screens/common/blog_detail_screen.dart';
import 'package:horti_vige/ui/screens/common/conversation_screen.dart';
import 'package:horti_vige/ui/screens/common/landing_screen.dart';
import 'package:horti_vige/ui/screens/common/profile_screen.dart';
import 'package:horti_vige/ui/screens/consultant/consultation_details_screen.dart';
import 'package:horti_vige/ui/screens/consultant/consultation_pricing/add_pricing_screen.dart';
import 'package:horti_vige/ui/screens/consultant/consultation_pricing/consultation_pricing_screen.dart';
import 'package:horti_vige/ui/screens/consultant/consultation_request_screen.dart';
import 'package:horti_vige/ui/screens/consultant/edit_availability_screen.dart';
import 'package:horti_vige/ui/screens/consultant/main/consultant_main_screen.dart';
import 'package:horti_vige/ui/screens/greetings/booking_success_screen.dart';
import 'package:horti_vige/ui/screens/greetings/congrats_screen.dart';
import 'package:horti_vige/ui/screens/greetings/thank_you_screen.dart';
import 'package:horti_vige/ui/screens/payment/card/custom_card_payment_screen.dart';
import 'package:horti_vige/ui/screens/user/appointment/book_appointment_screen.dart';
import 'package:horti_vige/ui/screens/user/calendar_screen.dart';
import 'package:horti_vige/ui/screens/user/consultant_details_screen.dart';
import 'package:horti_vige/ui/screens/video_call_screen.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_nav_drawer.dart';
import 'package:horti_vige/core/utils/app_consts.dart';
import 'package:horti_vige/core/utils/helpers/preference_manager.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferenceManager.getInstance().initSharedPreferences();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseAppCheck.instance.activate();
  Stripe.publishableKey = Constants.kStripePublishKey;
  // await dotenv.load(fileName: 'assets/.env');

  NotificationService.setupNotifications();
  // VideoService.instance.init();
  // final isGranted = await VideoService.instance.isPermissionsGranted();
  // if (isGranted) {
  //   await VideoService.instance.initAgora();
  // }

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ConsultationProvider()),
        ChangeNotifierProvider(create: (_) => PackagesProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => BlogsProvider()),
        ChangeNotifierProvider(
          create: (_) => AvailabilityProvider(
            userProvider: UserProvider(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ConsultationPricingProvider(
            userProvider: UserProvider(),
          ),
        ),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.noScaling,
        ),
        child: MaterialApp(
          title: 'Hortivise',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.colorGreen),
            snackBarTheme: const SnackBarThemeData(
              contentTextStyle: AppTextStyles.bodyStyleMedium,
            ),
            useMaterial3: false,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.colorWhite,
              foregroundColor: AppColors.colorBlack,
              elevation: 1,
            ),
            fontFamily: 'Poppins',
          ),
          initialRoute: LandingScreen.routeName,

          routes: {
            LandingScreen.routeName: (ctx) =>  const LandingScreen(),
            LoginScreen.routeName: (ctx) => const LoginScreen(),
            SignUpScreen.routeName: (ctx) => const SignUpScreen(),
            ZoomDrawerScreen.routeName: (ctx) => const ZoomDrawerScreen(),
            BecomeConsultantScreen.routeName: (ctx) =>
                const BecomeConsultantScreen(),
            ThankYouScreen.routeName: (ctx) => const ThankYouScreen(),
            CongratsScreen.routeName: (ctx) => const CongratsScreen(),
            ConsultantDetailsScreen.routeName: (ctx) =>
                const ConsultantDetailsScreen(),
            BookAppointmentScreen.routeName: (ctx) =>
                const BookAppointmentScreen(),
            CalendarScreen.routeName: (ctx) => const CalendarScreen(),
            BookingSuccessScreen.routeName: (ctx) =>
                const BookingSuccessScreen(),
            ConsultantMainScreen.routeName: (ctx) =>
                const ConsultantMainScreen(),
            ConsultationDetailsScreen.routeName: (ctx) =>
                const ConsultationDetailsScreen(),
            ConversationScreen.routeName: (ctx) => const ConversationScreen(),
            EditAvailabilityScreen.routeName: (ctx) =>
                const EditAvailabilityScreen(),
            ConsultationRequestScreen.routeName: (ctx) =>
                const ConsultationRequestScreen(),
            ProfileScreen.routeName: (ctx) => const ProfileScreen(),
            BlogDetailScreen.routeName: (ctx) => const BlogDetailScreen(),
            CustomCardPaymentScreen.routeName: (ctx) =>
                const CustomCardPaymentScreen(),
            ChangePasswordScreen.routeName: (ctx) =>
                const ChangePasswordScreen(),
            DemoAppHome.routeName: (ctx) => const DemoAppHome(),
            ConsultationPricingScreen.routeName: (ctx) =>
                const ConsultationPricingScreen(),
            AddPricingScreen.routeName: (ctx) => const AddPricingScreen(),
          },
        ),
      ),
    );
  }
}
