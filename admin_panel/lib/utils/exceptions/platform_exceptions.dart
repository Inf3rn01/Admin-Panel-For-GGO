/// Exception class for handling various platform-related errors.
class GPlatformException implements Exception{
  /// The error code associated with the exception
  final String code;
  
  /// Constructor that takes an error code
  GPlatformException(this.code);

  /// Get the corresponding error message based on the error code
  String get message {
    switch (code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return 'The email address is already in use by another account.';
      case 'ERROR_WRONG_PASSWORD':
        return 'The password is invalid.';
      case 'ERROR_USER_NOT_FOUND':
        return 'There is no user record corresponding to this identifier. The user may have been deleted.';
      case 'ERROR_USER_DISABLED':
        return 'The user account has been disabled by an administrator.';
      case 'ERROR_TOO_MANY_REQUESTS':
        return 'We have blocked all requests from this device due to unusual activity. Try again later.';
      case 'ERROR_OPERATION_NOT_ALLOWED':
        return 'This operation is not allowed. You must enable this service in the console.';
      case 'ERROR_INVALID_EMAIL':
        return 'The email address is badly formatted.';
      case 'ERROR_INVALID_PASSWORD':
        return 'The given password is invalid. [ Password should be at least 6 characters ]';
      case 'ERROR_USER_MISMATCH':
        return 'The supplied credentials do not correspond to the previously signed in user.';
      case 'ERROR_REQUIRES_RECENT_LOGIN':
        return 'This operation is sensitive and requires recent authentication. Log in again before retrying this request.';
      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return 'An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.';
      case 'ERROR_EMAIL_ALREADY_EXISTS':
        return 'The email address is already in use by another account.';
      case 'ERROR_CREDENTIAL_TOO_OLD_LOGIN_AGAIN':
        return 'This credential is no longer valid. User must sign in again.';
      case 'ERROR_USER_NOT_VERIFIED':
        return 'The user email has not been verified.';
      case 'ERROR_TOO_MANY_ATTEMPTS_TRY_LATER':
        return 'We have blocked all requests from this device due to unusual activity. Try again later.';
      case 'ERROR_EXPIRED_CREDENTIAL':
        return 'The user\'s credential has expired. Please sign in again.';
      case 'ERROR_INVALID_PHONE_NUMBER':
        return 'The format of the phone number provided is incorrect. Please enter the phone number in a valid format.';
      case 'ERROR_INVALID_VERIFICATION_CODE':
        return 'The verification code used to create the phone auth credential is invalid. Please resend the verification code and be sure to use the verification code provided by the user.';
      case 'ERROR_WEAK_PASSWORD':
        return 'The password is not strong enough.';
      case 'ERROR_INVALID_CUSTOM_TOKEN':
        return 'The custom token format is incorrect. Please check the token and try again.';
      case 'ERROR_CUSTOM_TOKEN_MISMATCH':
        return 'The custom token corresponds to a different audience.';
      case 'ERROR_INVALID_IDP_RESPONSE':
        return 'The response received from the identity provider was invalid. Please try again.';
      case 'ERROR_NETWORK_REQUEST_FAILED':
        return 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.';
      case 'ERROR_USER_TOKEN_EXPIRED':
        return 'The user\'s credential has expired. Please sign in again.';
      case 'ERROR_WEB_STORAGE_UNSUPPORTED':
        return 'This browser or app does not support web storage. Please use a device with more modern browsers or upgrade your browser.';
      case 'ERROR_APP_NOT_AUTHORIZED':
        return 'The app is not authorized to use Firebase Authentication. Please verify your app configuration.';
      case 'ERROR_INVALID_API_KEY':
        return 'The provided API key is invalid. Please check your key and try again.';
      case 'ERROR_API_KEY_NOT_FOUND':
        return 'The API key not found. Please check your API key.';
      case 'ERROR_AUTH_DOMAIN_CONFIG_REQUIRED':
        return 'The domain configuration required to initialize the Firebase Auth SDK is missing. Please add it in the Firebase console.';
      case 'ERROR_USER_SIGNED_OUT':
        return 'The user is signed out. Please sign in again.';
      case 'ERROR_EXPIRED_OOB_CODE':
        return 'The action code has expired. Please request a new one.';
      case 'ERROR_INVALID_OOB_CODE':
        return 'The action code is invalid. This can happen if the code is malformed, expired, or has already been used.';
      case 'ERROR_INVALID_VERIFICATION_ID':
        return 'The verification ID used to create the phone auth credential is invalid.';
      case 'ERROR_POPUP_BLOCKED':
        return 'Unable to establish a connection with the popup. It may have been blocked by the browser.';
      case 'ERROR_POPUP_CLOSED_BY_USER':
        return 'The popup has been closed by the user before finalizing the operation.';
      case 'ERROR_UNAUTHORIZED_DOMAIN':
        return 'The domain for this operation is not authorized. Please check the rules in the Firebase console.';
      case 'ERROR_INVALID_DYNAMIC_LINK_DOMAIN':
        return 'The provided dynamic link domain is not configured or authorized for the current project.';
      case 'ERROR_CUSTOM_TOKEN_CREATION':
        return 'The custom token creation request failed.';
      case 'ERROR_PENDING_CREDENTIAL':
        return 'A credential already exists for the provided email address.';
      case 'ERROR_CREDENTIAL_NOT_FOUND':
        return 'The credential used to sign in to the provider was not found.';
      case 'ERROR_INVALID_EMAIL_LINK':
        return 'The email link is invalid. Please request a new email link.';
      case 'ERROR_EMAIL_CHANGE_NEEDS_VERIFICATION':
        return 'The email change needs to be verified. Please check your email.';
      case 'ERROR_EMAIL_ALREADY_VERIFIED':
        return 'The email address is already verified.';
      case 'ERROR_INVALID_CREDENTIAL':
        return 'The supplied auth credential is malformed or has expired.';
      default:
        return 'An unknown error occurred. Please try again later.';
    }
  }
}