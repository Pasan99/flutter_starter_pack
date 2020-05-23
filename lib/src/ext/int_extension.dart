extension CustomInt on int {
  ///check whether the current string value is null or empty
  bool isInvalid() {
    return (this == null || this < -1);
  }
  ///check whether the given strings are matching
  bool equals(int matcher) {
    return !this.isInvalid()  && this == matcher;
  }
}