/// Custom exceptoin class to handle various Firebase-related errors
class GFirebaseException implements Exception{
  /// The error code associated with the exception
  final String code;
  
  /// Constructor that takes an error code
  GFirebaseException(this.code);

  /// Get the corresponding error message based on the error code
  String get message {
    switch (code) {
      case 'unknown':
        return 'An unknown error occurred.';
      case 'invalid-argument':
        return 'Invalid argument provided. Please check your input.';
      case 'deadline-exceeded':
        return 'The operation took too long to complete. Please try again.';
      case 'not-found':
        return 'The requested resource was not found.';
      case 'already-exists':
        return 'The resource you are trying to create already exists.';
      case 'permission-denied':
        return 'You do not have the required permissions to perform this operation.';
      case 'resource-exhausted':
        return 'The service has reached its quota limit. Please try again later.';
      case 'failed-precondition':
        return 'The operation was not executed due to a failed precondition.';
      case 'aborted':
        return 'The operation was aborted.';
      case 'out-of-range':
        return 'The operation was attempted past the valid range.';
      case 'unimplemented':
        return 'The operation is not implemented or is not supported/enabled.';
      case 'internal':
        return 'An internal error occurred. Please try again.';
      case 'unavailable':
        return 'The service is currently unavailable. Please try again later.';
      case 'data-loss':
        return 'Data loss has occurred.';
      case 'unauthenticated':
        return 'The request does not have valid authentication credentials.';
        
      default:
        return 'An unknown Firebase error occurred. Please try again.';
    }
  }
}