extension CustomList<T> on List<T> {
  ///check whether the current string value is null or empty
  bool isInvalid() {
    return (this == null || this.isEmpty);
  }
}