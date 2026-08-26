import '../models/student_model.dart';
import '../database/database_helper.dart';

class StudentData {
  StudentData._();

  static final List<StudentModel> studentList = [];

  static void addStudent(
    StudentModel student,
  ) {
    studentList.add(student);
  }

  static void updateStudent(
    StudentModel updatedStudent,
  ) {
    final index = studentList.indexWhere(
      (student) =>
          student.studentID ==
          updatedStudent.studentID,
    );

    if (index != -1) {
      studentList[index] = updatedStudent;
    } else {
      studentList.add(updatedStudent);
    }
  }

  static void deleteStudent(
    String studentID,
  ) {
    studentList.removeWhere(
      (student) =>
          student.studentID == studentID,
    );
  }

  static StudentModel? getStudentByID(
    String studentID,
  ) {
    try {
      return studentList.firstWhere(
        (student) =>
            student.studentID == studentID,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> loadStudents() async {
    final records =
        await DatabaseHelper.instance
            .getStudents();

    studentList.clear();

    studentList.addAll(
      records.map(
        StudentModel.fromMap,
      ),
    );
  }
}