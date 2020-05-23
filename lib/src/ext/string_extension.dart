extension CustomString on String {
  ///check whether the current string value is null or empty
  bool isInvalid() {
    return (this == null || this.isEmpty);
  }
  ///check whether the given strings are matching
  bool equals(String matcher) {
    return !this.isInvalid() && !matcher.isInvalid() && this == matcher;
  }
}