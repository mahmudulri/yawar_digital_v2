import 'package:arzan_digital/bindings/add_sub_reseller_binding.dart';
import 'package:arzan_digital/bindings/baseview_binding.dart';
import 'package:arzan_digital/bindings/custom_recharge_binding.dart';
import 'package:arzan_digital/bindings/myprofile_binding.dart';
import 'package:arzan_digital/bindings/recharge_binding.dart';
import 'package:arzan_digital/bindings/newservice_binding.dart';
import 'package:arzan_digital/bindings/sign_in_binding.dart';
import 'package:arzan_digital/bindings/splash_binding.dart';
import 'package:arzan_digital/bottom_nav.dart';
import 'package:arzan_digital/screens/add_card_screen.dart';
import 'package:arzan_digital/screens/add_sub_reseller_screen.dart';
import 'package:arzan_digital/screens/change_balance_screen.dart';
import 'package:arzan_digital/screens/change_pin.dart';
import 'package:arzan_digital/screens/change_sub_pass_screen.dart';
import 'package:arzan_digital/screens/confirm_pin.dart';
import 'package:arzan_digital/screens/custom_recharge_screen.dart';
import 'package:arzan_digital/screens/edit_profile_screen.dart';
import 'package:arzan_digital/screens/myprofile_screen.dart';
import 'package:arzan_digital/screens/onboarding.dart';
import 'package:arzan_digital/screens/new_service_screen.dart';

import 'package:arzan_digital/screens/order_details.dart';
import 'package:arzan_digital/screens/recharge_screen.dart';
import 'package:arzan_digital/screens/result_screen.dart';
import 'package:arzan_digital/screens/sign_up_screen.dart';
import 'package:arzan_digital/screens/social_recharge.dart';

import 'package:get/get.dart';
import 'package:arzan_digital/splash_screen.dart';

const String splash = '/splash-screen';
// const String newsigninscreen = '/newsign-in-screen';
const String onboardingscreen = '/onboardin-screen';
const String basescreen = '/base-screen';
const String bottomnavscreen = '/bottomnav-screen';

const String addcardScreen = '/addcard-screen';
const String addsubresellerscreen = '/addsubreseller-screen';
const String changebalancescreen = '/changebalance-screen';
const String changepinscreen = '/changepin-screen';
const String changesubpassscreen = '/changesubpass-screen';
const String confirmpinscreen = '/confirmpin-screen';
const String editprofilescreen = '/editprofile-screen';
const String customrechargescreen = '/customrecharge-screen';
const String myprofilescreen = '/myprofile-screen';
const String orderdetailsscreen = '/orderdetails-screen';
const String rechargescreen = '/recharge-screen';
const String resultscreen = '/result-screen';
const String servicescreen = '/service-screen';
const String newservicescreen = '/newservice-screen';

const String socialrechargescreen = '/socialrecharge-screen';

List<GetPage> myroutes = [
  GetPage(name: splash, page: () => SplashScreen(), binding: SplashBinding()),
  GetPage(
    name: onboardingscreen,
    page: () => Onboarding(),
    binding: SignInBinding(),
  ),
  // GetPage(
  //   name: basescreen,
  //   page: () => BaseView(),
  //   binding: BaseViewBinding(),
  // ),
  GetPage(
    name: bottomnavscreen,
    page: () => BottomNavScreen(),
    binding: BaseViewBinding(),
  ),
  GetPage(name: addcardScreen, page: () => AddCardScreen()),
  GetPage(
    name: addsubresellerscreen,
    page: () => AddSubResellerScreen(),
    binding: AddSubResellerBinding(),
  ),
  GetPage(name: changebalancescreen, page: () => ChangeBalanceScreen()),
  GetPage(name: changepinscreen, page: () => ChangePin()),
  GetPage(name: changesubpassscreen, page: () => ChangeSubPasswordScreen()),

  GetPage(name: editprofilescreen, page: () => EditProfileScreen()),
  GetPage(
    name: myprofilescreen,
    page: () => MyprofileScreen(),
    binding: MyProfileBinding(),
  ),
  GetPage(name: orderdetailsscreen, page: () => OrderDetailsScreen()),
  GetPage(
    name: rechargescreen,
    page: () => RechargeScreen(),
    binding: RechargeBinding(),
  ),
  GetPage(
    name: customrechargescreen,
    page: () => CustomRechargeScreen(),
    binding: CustomRechargeBinding(),
  ),
  GetPage(name: resultscreen, page: () => ResultScreen()),
  GetPage(
    name: newservicescreen,
    page: () => NewServiceScreen(),
    binding: NewServiceBinding(),
  ),
  GetPage(
    name: socialrechargescreen,
    page: () => SocialRechargeScreen(),
    binding: RechargeBinding(),
  ),
];
