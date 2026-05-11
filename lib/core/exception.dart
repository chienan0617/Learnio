class IndexOutOfBoundError extends Error {
}

class NoElementError extends Error {
}

class DebugError extends Error {
}

class InternetError extends Error {
  InternetError(String reason);
}

class GenerationError extends Error {
  GenerationError(String reason);
}

class InvalidParamError extends Error {
  InvalidParamError(String reason);
}

class NameNotFoundError extends Error {
  NameNotFoundError(String reason);
}

class IllegalArgumentError extends Error {
}
