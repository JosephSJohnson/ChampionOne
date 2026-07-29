class IDGenerator {

  static int _staffCounter = 1;

  static String generateStaffID() {

    String number = _staffCounter
        .toString()
        .padLeft(3, '0');

    _staffCounter++;

    return "CHAMP-$number";

  }

}