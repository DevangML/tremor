abstract class Failure(final String message, [final int? code]);

class ServerFailure([super.message = 'Server Error', super.code])
    extends Failure;

class NetworkError([super.message = 'Network Error', super.code])
    extends Failure;
