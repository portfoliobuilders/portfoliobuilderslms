import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRegisteredStudentsPage extends StatefulWidget {
  const AdminRegisteredStudentsPage({Key? key}) : super(key: key);

  @override
  _AdminRegisteredStudentsPageState createState() =>
      _AdminRegisteredStudentsPageState();
}

class _AdminRegisteredStudentsPageState
    extends State<AdminRegisteredStudentsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedCourse;

  // Fetch all registered users with role 'user'
  Stream<QuerySnapshot> _getStudents() {
    return _firestore.collection('users').where('role', isEqualTo: 'user').snapshots();
  }

  // Fetch the name of a course by its ID
  Future<String> _getCourseNameById(String courseId) async {
    try {
      DocumentSnapshot courseDoc = await _firestore.collection('courses').doc(courseId).get();
      return courseDoc.exists ? courseDoc['name'] ?? 'Unnamed Course' : 'Course Not Found';
    } catch (e) {
      print('Error fetching course name: $e');
      return 'Error';
    }
  }

  // Add course to student
  Future<void> _addCourseToStudent(String uid, String courseId) async {
    try {
      await _firestore.collection('users').doc(uid).collection('courses').doc(courseId).set({
        'courseId': courseId,
        'enrollmentDate': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Course added successfully!')));
      setState(() {}); // Refresh the UI after adding the course
    } catch (e) {
      print('Error adding course: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add course: $e')));
    }
  }

  // Remove course from student
  Future<void> _removeCourseFromStudent(String uid, String courseId) async {
    try {
      await _firestore.collection('users').doc(uid).collection('courses').doc(courseId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Course removed successfully!')));
      setState(() {}); // Refresh the UI after removing the course
    } catch (e) {
      print('Error removing course: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove course: $e')));
    }
  }

  // Delete a user
  Future<void> _deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User deleted successfully!')));
      setState(() {}); // Refresh the UI after deleting the user
    } catch (e) {
      print('Error deleting user: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete user: $e')));
    }
  }

  // Show dialog to select and add a course to a student
  Future<void> _showAddCourseDialog(BuildContext context, String studentUid) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Course to Add'),
          content: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('courses').snapshots(),
            builder: (context, courseSnapshot) {
              if (!courseSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final courses = courseSnapshot.data!.docs;
              List<String> courseNames = [];
              List<String> courseIds = [];
              for (var course in courses) {
                courseNames.add(course['name']);
                courseIds.add(course.id);
              }

              return DropdownButton<String>(
                hint: const Text('Select a Course'),
                value: selectedCourse,
                onChanged: (newValue) {
                  setState(() {
                    selectedCourse = newValue;
                  });
                },
                items: courseNames.map((courseName) {
                  return DropdownMenuItem<String>(
                    value: courseIds[courseNames.indexOf(courseName)],
                    child: Text(courseName),
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedCourse != null) {
                  _addCourseToStudent(studentUid, selectedCourse!);
                  Navigator.pop(context); // Close the dialog after adding the course
                }
              },
              child: const Text('Add Course'),
            ),
          ],
        );
      },
    );
  }

  // Show dialog to remove a course from a student
  Future<void> _showRemoveCourseDialog(BuildContext context, String studentUid) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Course to Remove'),
          content: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('users').doc(studentUid).collection('courses').snapshots(),
            builder: (context, studentCoursesSnapshot) {
              if (!studentCoursesSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final studentCourses = studentCoursesSnapshot.data!.docs;
              List<String> studentCourseNames = [];
              List<String> studentCourseIds = [];
              for (var studentCourse in studentCourses) {
                studentCourseNames.add(studentCourse['courseId']);
                studentCourseIds.add(studentCourse.id);
              }

              return DropdownButton<String>(
                hint: const Text('Select a Course'),
                value: selectedCourse,
                onChanged: (newValue) {
                  setState(() {
                    selectedCourse = newValue;
                  });
                },
                items: studentCourseIds.map((courseId) {
                  return DropdownMenuItem<String>(
                    value: courseId,
                    child: FutureBuilder<String>(
                      future: _getCourseNameById(courseId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text('Loading...');
                        }
                        if (snapshot.hasData) {
                          return Text(snapshot.data!);
                        }
                        return const Text('Error');
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedCourse != null) {
                  _removeCourseFromStudent(studentUid, selectedCourse!);
                  Navigator.pop(context); // Close the dialog after removing the course
                }
              },
              child: const Text('Remove Course'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Students'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getStudents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final students = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index].data() as Map<String, dynamic>;
                final studentUid = students[index].id; // This is the user's UID
                final studentEmail = student['email'] ?? 'Unknown User';
                final studentName = student['name'] ?? 'No name';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FutureBuilder<QuerySnapshot>(
                      future: _firestore.collection('users').doc(studentUid).collection('courses').get(),
                      builder: (context, courseSnapshot) {
                        if (!courseSnapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final studentCourses = courseSnapshot.data!.docs;
                        List<Future<String>> courseNames = [];
                        for (var studentCourse in studentCourses) {
                          final courseId = studentCourse['courseId'];
                          if (courseId != null) {
                            courseNames.add(_getCourseNameById(courseId));
                          }
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Text(studentName)),
                            SizedBox(width: 10),
                            Expanded(child: Text(studentEmail)),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: FutureBuilder<List<String>>(
                                future: Future.wait(courseNames),
                                builder: (context, courseNamesSnapshot) {
                                  if (courseNamesSnapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (courseNamesSnapshot.hasData && courseNamesSnapshot.data != null) {
                                    final courses = courseNamesSnapshot.data!;
                                    return Text(courses.join(', '));
                                  }
                                  return const Text('No courses');
                                },
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  _showAddCourseDialog(context, studentUid);
                                },
                                child: const Text(
                                  'Add Course',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  _showRemoveCourseDialog(context, studentUid);
                                },
                                child: const Text(
                                  'Remove Course',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                             Expanded(
                              child: TextButton(
                                onPressed: () {
                                  _deleteUser(studentUid);
                                },
                                child: const Text(
                                  'Delete User',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
