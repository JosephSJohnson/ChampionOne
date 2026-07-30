import '../data/staff_data.dart';

class IDGenerator {
  static String generateStaffID() {
    final nextNumber = StaffData.staffList.length + 1;

    return "CHAMP-${nextNumber.toString().padLeft(3, '0')}";
  }
}