import 'package:chat/core/errors/failures.dart';
import 'package:chat/core/strings/failure.dart';

String mapFailureToString(Failure failure) {
  if (failure is OfflineFailure) {
    return OFFLINE_FAILURE_MESSAGE;
  } else if (failure is ServerFailure) {
    return failure.message;
  } else if (failure is EmptyCacheFailure) {
    return CACHE_FAILURE_MESSAGE;
  } else if (failure is EmailIsNotVerifiedFailure) {
    return EMAIL_IS_NOT_VERIFIED;
  }
  return UN_EXPECTED_ERROR;
}
