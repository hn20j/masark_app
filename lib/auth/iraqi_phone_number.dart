String? normalizeIraqiPhoneNumber(String value) {
  var digits = value.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('00964')) {
    digits = digits.substring(5);
  } else if (digits.startsWith('964')) {
    digits = digits.substring(3);
  }
  if (digits.startsWith('0')) digits = digits.substring(1);
  if (!RegExp(r'^7\d{9}$').hasMatch(digits)) return null;
  return '+964$digits';
}
