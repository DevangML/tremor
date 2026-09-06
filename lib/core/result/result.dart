sealed class Result<S, F>();

final class Success<S, F>(final S value) extends Result<S, F>;

final class FailureResult<S, F>(final F value) extends Result<S, F>;
