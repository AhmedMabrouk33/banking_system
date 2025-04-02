import 'dart:io';

E convertUserSelectedInput<E extends Enum>(List<E> values) {
  stdout.write("Enter a number to select an option: ");

  // Read user input and try parsing it
  int? index = int.tryParse(stdin.readLineSync() ?? '');

  // Validate input index
  if (index != null && index > 0 && index <= values.length) {
    return values[index - 1]; // Convert 1-based input to 0-based index
  }

  // Return the last value as a fallback (safe default)
  return values.last;
}
