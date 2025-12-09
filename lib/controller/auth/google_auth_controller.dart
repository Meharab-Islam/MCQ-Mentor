import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mcq_mentor/screens/home/CustomBottomNavBar.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class GoogleAuthController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxBool isLoading = false.obs;
  final box = GetStorage();
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool isInitialize = false;
  static Future<void> initSignIn() async {
    if (!isInitialize) {
      await _googleSignIn.initialize(
        serverClientId:
            '692082661577-qmdj8u1eojvmk9o9nhfacc5t447343lq.apps.googleusercontent.com',
      );
    }
    isInitialize = true;
  }

  // Sign in with Google
  Future signInWithGoogle() async {
    try {
      await _googleSignIn.signOut(); // Force clear session
      await initSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final authorizationClient = googleUser.authorizationClient;
      GoogleSignInClientAuthorization? authorization = await authorizationClient
          .authorizationForScopes(['email', 'profile']);
      final accessToken = authorization?.accessToken;
      print(accessToken);

      try {
        isLoading.value = true;

        final data = {'provider': 'google', 'token': accessToken};

        final response = await _apiService.post(
          ApiEndpoint.loginWithGoogle,
          data,
        );

        if (response.statusCode == 200) {
          final token = response.data['access_token'];

          if (token != null) {
            await box.write('access_token', token);
          }

          // Navigate to home
          Get.offAll(() => CustomBottomNavBarScreen());
        }
        return false;
      } catch (e) {
        // ApiService will already show error messages
        return false;
      } finally {
        isLoading.value = false;
      }
      // return userCredential;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw e;
    }
  }
}
