import 'package:flutter/material.dart';
import 'package:lab3/utils/secure_storage_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SecureStorageService _storageService = SecureStorageService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  String? savedUsername;
  String? savedCourse;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final username = await _storageService.readData('username');
    final course = await _storageService.readData('course');
    setState(() {
      savedUsername = username;
      savedCourse = course;
    });
  }

  Future<void> saveData() async {
    if (usernameController.text.isEmpty || courseController.text.isEmpty) return;

    await _storageService.saveData('username', usernameController.text);
    await _storageService.saveData('course', courseController.text);

    usernameController.clear();
    courseController.clear();

    await loadData();
  }

  @override
  void dispose() {
    usernameController.dispose();
    courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secure Storage'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(labelText: 'Course'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveData,
                child: const Text('Save'),
              ),
            ),
            const SizedBox(height: 30),

            if (savedUsername != null && savedCourse != null) ...[
              const Text(
                'Saved Data:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 18),
                        const SizedBox(width: 8),
                        Text('Username: $savedUsername'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.book, size: 18),
                        const SizedBox(width: 8),
                        Text('Course: $savedCourse'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}