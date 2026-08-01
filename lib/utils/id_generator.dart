import '../data/staff_data.dart';

class IDGenerator {

  static String generateStaffID() {

    final now = DateTime.now();

    return "CHAMP-${now.year}"
        "${now.month.toString().padLeft(2, '0')}"
        "${now.day.toString().padLeft(2, '0')}"
        "${now.hour.toString().padLeft(2, '0')}"
        "${now.minute.toString().padLeft(2, '0')}"
        "${now.second.toString().padLeft(2, '0')}";

  }

}