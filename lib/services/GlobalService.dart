import 'package:get/get.dart';

class GlobalService extends GetxController {
  var studentId = '677b8e7bf42ad731fbd9d4f1'.obs;
  var teacherId = '677d41ba64483994d1d4584c'.obs;
  var internshipId = '677b8f03f42ad731fbd9d4f7'.obs;
  var groupId = '24'.obs;

  void setStudentId(String id) {
    studentId.value = id; 
    print(studentId.value);
    print('Student ID global saved: $id'); 
  }

  void setTeacherId(String id) {
    teacherId.value = id;
    print('Teacher ID saved: $id'); 
  }

  void setInternshipId(String id) {
    internshipId.value = id;
    print('Internship ID saved: $id'); 
  }

  void setGroupId(String id) {
    groupId.value = id;
    print('Group ID saved: $id'); 
  }
}
