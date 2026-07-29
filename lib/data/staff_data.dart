import '../models/staff_model.dart';

class StaffData {
  StaffData._();

  static final List<StaffModel> staffList = [];

  static void addStaff(StaffModel staff) {
    staffList.add(staff);
  }

  static void updateStaff(StaffModel updatedStaff) {
    final index = staffList.indexWhere(
      (staff) => staff.staffID == updatedStaff.staffID,
    );

    if (index != -1) {
      staffList[index] = updatedStaff;
    }
  }

  static void deleteStaff(String staffID) {
    staffList.removeWhere(
      (staff) => staff.staffID == staffID,
    );
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
}