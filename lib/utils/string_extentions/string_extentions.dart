extension StringExtensions on String {
  /// Returns the first two letters of the string, combining the first letter
  /// of up to two words, in uppercase.
  String getFirstTwoLetters() {
    // Remove leading and trailing spaces, then split into words
    List<String> words = this.trim().split(' ');

    // Get the first letter from each word
    String firstTwoLetters = words.map((word) => word[0].toUpperCase()).take(2).join();

    return firstTwoLetters;
  }
}

extension FirstWord on String {
  String get firstWord {
    // Split the string by space and return the first word
    return this.trim().split(' ').first;
  }
}
