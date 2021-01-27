extension TruncateStringExtension on String {
  String truncateTo(int maxLength) => (this.length <= maxLength)
      ? this
      : '${this.substring(0, maxLength - 3)}...';
}
