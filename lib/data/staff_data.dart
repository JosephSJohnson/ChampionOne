import '../models/staff_model.dart';
import '../database/database_helper.dart';

class StaffData {
  StaffData._();

  static final List<StaffModel> staffList = [];

  static void addStaff(StaffModel staff) {
    staffList.add(staff);
  }

  static void deleteStaff(String staffID) {

  staffList.removeWhere(

    (staff) => staff.staffID == staffID,

  );

}

  static void updateStaff(StaffModel updatedStaff) {
    final index = staffList.indexWhere(
      (staff) => staff.staffID == updatedStaff.staffID,
    );

    if (index != -1) {
      staffList[index] = updatedStaff;
    }
  }


  static StaffModel? getStaffByID(String staffID) {
    try {
      return staffList.firstWhere(
        (staff) => staff.staffID == staffID,
      );
    } catch (_) {
      return null;
    }
  }

static Future<void> loadStaff() async {

  final records =
      await DatabaseHelper.instance.getStaff();


  staffList.clear();


  for (var record in records) {

    staffList.add(
      StaffModel.fromMap(record),
    );

  }

}
  
}