/// Custom exceptoin class to handle various Firebase authentication-related errors
class GFirebaseAuthException implements Exception {
  /// The error code associated with the exception
  final String code;
  
  /// Constructor that takes an error code
  GFirebaseAuthException(this.code);

  /// Get the corresponding error message based on the error code
  String get message {
    switch (code) {
      case 'invalid-password':
        return 'The password is invalid. Please use a different password';
      case 'email-already-in-use':
        return 'The email address is already registered. Please use a different email.';
      case 'invalid-email':
        return 'The email address provided is invalid. Please enter a valid email.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'user-disabled':
        return 'This user account has been disabled. Please contact support for assistance.';
      case 'user-not-found':
        return 'Invalid login details. User not found.';
      case 'wrong-password':
        return 'Incorrect password. Please check your password and try again.';
      case 'invalid-verification-code':
        return 'Invalid verification code. Please enter a valid code.';
      case 'invalid-verification-id':
        return 'Invalid verification ID. Please request a new verification code.';
      case 'quota-exceeded':
        return 'Quota exceeded. Please try again later.';
      case 'email-already-exists':
        return 'The email address already exists. Please use a different email.';
      case 'provider-already-linked':
        return 'The account is already linked with another provider.';
      case 'requires-recent-login':
        return 'This operation is sensitive and requires recent authentication. Please log in again.';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different user account.';
      case 'user-mismatch':
        return 'The supplied credentials do not correspond to the previously signed in user.';
      case 'account-exists-with-a-different-credential':
        return 'An account already exists with the same email but different sign-in credentials.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Contact support for assistance.';
      case 'expired-action-code':
        return 'The action code is invalid. Please request a new action code.';
      case 'invalid-action-code':
        return 'The action code is invalid. Please check the code and try again.';
      case 'missing-action-code':
        return 'The action code is missing. Please provide a valid action code.';
      case 'invalid-phone-number':
        return 'The phone number is invalid. Please enter a valid phone number.';
      case 'invalid-recipient-email':
        return 'The recipient email is invalid. Please enter a valid email.';
      case 'invalid-message-payload':
        return 'The message payload is invalid. Please check the payload and try again.';
      case 'invalid-sender':
        return 'The sender is invalid. Please check the sender and try again.';
      case 'multi-factor-info-not-found':
        return 'Multi-factor information not found. Please try again.';
      case 'multi-factor-auth-required':
        return 'Multi-factor authentication is required. Please provide the second factor.';
      case 'unauthorized-continue-uri':
        return 'The continue URL is not authorized. Please use a different URL.';
      case 'web-storage-unsupported':
        return 'Web storage is not supported. Please use a different device or browser.';
      case 'tenant-id-mismatch':
        return 'The tenant ID does not match. Please check the tenant ID and try again.';
      case 'permission-denied':
        return 'Permission denied. Please check your permissions and try again.';
      case 'popup-blocked':
        return 'The popup was blocked. Please enable popups for this site.';
      case 'popup-closed-by-user':
        return 'The popup was closed by the user.';
      case 'unverified-email':
        return 'The email address is not verified. Please verify your email address.';
      case 'captcha-check-failed':
        return 'The reCAPTCHA check failed. Please try again.';
      case 'invalid-app-credential':
        return 'The app credential is invalid. Please check your app credentials.';
      case 'invalid-app':
        return 'The app is invalid. Please check your app configuration.';
      case 'app-not-authorized':
        return 'The app is not authorized. Please check your app authorization.';
      case 'app-not-installed':
        return 'The app is not installed. Please install the app.';
      case 'internal-error':
        return 'An internal error occurred. Please try again later.';
      case 'invalid-custom-token':
        return 'The custom token is invalid. Please check your custom token.';
      case 'network-request-failed':
        return 'A network request failed. Please check your internet connection and try again.';
      case 'invalid-api-key':
        return 'The API key is invalid. Please check your API key.';
      case 'api-key-not-found':
        return 'The API key was not found. Please check your API key.';
      case 'auth-domain-config-required':
        return 'The Auth domain configuration is required. Please check your Auth domain configuration.';
      case 'credential-used-in-different-auth-flow':
        return 'The credential is used in a different authentication flow. Please use the correct flow.';
      case 'operation-not-allowed-in-this-context':
        return 'The operation is not allowed in this context. Please use a different context.';
      case 'invalid-claims':
        return 'The claims are invalid. Please check your claims.';
      case 'phone-number-already-exists':
        return 'The phone number already exists. Please use a different phone number.';
      case 'redirect-operation-pending':
        return 'A redirect operation is pending. Please complete the operation.';
      case 'email-change-needs-verification':
        return 'The email change needs to be verified. Please check your email.';
      case 'invalid-verification-link':
        return 'The verification link is invalid. Please request a new verification link.';
      case 'invalid-email-link':
        return 'The email link is invalid. Please request a new email link.';
      case 'missing-android-pkg-name':
        return 'The Android package name is missing. Please provide a package name.';
      case 'missing-continue-uri':
        return 'The continue URI is missing. Please provide a continue URI.';
      case 'missing-ios-bundle-id':
        return 'The iOS bundle ID is missing. Please provide a bundle ID.';
      case 'invalid-continue-uri':
        return 'The continue URI is invalid. Please provide a valid continue URI.';
      case 'unauthorized-domain':
        return 'The domain is not authorized. Please use a different domain.';
      case 'invalid-dynamic-link-domain':
        return 'The dynamic link domain is invalid. Please use a different domain.';
      case 'argument-error':
        return 'An argument error occurred. Please check your arguments.';
      case 'invalid-message-expiration':
        return 'The message expiration is invalid. Please check the expiration.';
      case 'invalid-message-topic':
        return 'The message topic is invalid. Please check the topic.';
      case 'message-rate-exceeded':
        return 'The message rate has been exceeded. Please try again later.';
      case 'invalid-message-ttl':
        return 'The message TTL is invalid. Please check the TTL.';
      case 'invalid-page-token':
        return 'The page token is invalid. Please check the token.';
      case 'invalid-oob-code':
        return 'The OOB code is invalid. Please check the code.';
      case 'invalid-provider-id':
        return 'The provider ID is invalid. Please check the provider ID.';
      case 'missing-oob-code':
        return 'The OOB code is missing. Please provide an OOB code.';
      case 'invalid-dynamic-link':
        return 'The dynamic link is invalid. Please check the dynamic link.';
      case 'invalid-app-id':
        return 'The app ID is invalid. Please check the app ID.';
        
      default:
        return 'An unknown error occurred. Please try again later.';
    }
  }

}