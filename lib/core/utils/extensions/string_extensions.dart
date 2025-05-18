extension StringFormattingExtensions on String? {
  String capitalizeFirstLetter() {
    if (this == null || this!.isEmpty) {
      return '';
    }
    if (this!.length == 1) {
      return this!.toUpperCase();
    }
    return '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}';
  }

  String capitalizeEachWord() {
    if (this == null || this!.isEmpty) {
      return '';
    }
    return this!
        .toLowerCase()
        .split(' ')
        .map(
          (word) => word.isNotEmpty ? word.capitalizeFirstLetter() : '',
        ) // Can call other extensions
        .join(' ');
  }

  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (this == null || this!.length <= maxLength) {
      return this ?? '';
    }
    if (maxLength <= ellipsis.length) {
      return ellipsis.substring(0, maxLength);
    }
    return '${this!.substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
}

// Optional: Extension on non-nullable String if you prefer
extension NonNullableStringFormattingExtensions on String {
  String capitalizeFirst() {
    // Different name to avoid clash if both used
    if (isEmpty) return '';
    if (length == 1) return toUpperCase();
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
