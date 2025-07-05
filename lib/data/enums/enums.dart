// Export all enum files
// export 'account_status.dart';
// export 'package_type.dart';
// export 'user_type.dart';
// Add other enum exports as needed

enum AccountStatus { pending, approved, rejected }

enum ConsultationStatus {
  pending,
  accepted,
  rejected,
  pendingUpdated,
  acceptedUpdated,
  canceled,
  incomplete,
  enabled,
  restricted
}

enum DayEnum {
  monday('Monday'),
  tuesday('Tuesday'),
  wednesday('Wednesday'),
  thursday('Thursday'),
  friday('Friday'),
  saturday('Saturday'),
  sunday('Sunday');

  const DayEnum(this.day);
  final String day;
}

enum FirebaseErrorCode {
  invalidEmail,
  userNotFound,
  wrongPassword,
  userDisabled,
  emailAlreadyInUse,
  weakPassword,
  operationNotAllowed,
  userTokenExpired,
  userTokenInvalid,
  tooManyRequests,
  permissionDenied,
  notFound,
  aborted,
  alreadyExists,
  resourceExhausted,
  failedPrecondition,
  invalidArgument,
  unauthenticated,
  unavailable,
  unknown,
}

enum MessageType { text, video, audio }

enum PackageType { text, video }

enum UserType {
  CUSTOMER,
  SPECIALIST,
}

enum TransactionType { TOPUP, WITHDRAW, CONSULTATION }

enum TransactionStatus { PENDING, COMPLETED, CANCELED }

enum SpecialistCategory {
  All,
  Floweriest,
  Palmist,
}

enum NotificationType {
  consultation_request,
  request_approved,
  request_rejected,
  consultation_expired,
  request_updated,
  request_sent,
  request_cancel, //by sender,
  message_send,
}
enum StripeStatus {
  enabled,
  incomplete,
  pending,
  restricted,
}
