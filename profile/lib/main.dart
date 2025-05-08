import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(3, 73, 129, 1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ProfilePage(title: 'My Profile'),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = "John Doe";
  String _title = "Flutter Developer";
  String _bio = "Passionate about creating beautiful apps.";
  File? _profileImage;
  bool _isEditing = false;
  List<String> _skills = ['Flutter', 'Dart', 'Firebase', 'UI/UX', 'API Integration'];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _name;
    _titleController.text = _title;
    _bioController.text = _bio;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _name = _nameController.text;
        _title = _titleController.text;
        _bio = _bioController.text;
      } else {
        _nameController.text = _name;
        _titleController.text = _title;
        _bioController.text = _bio;
      }
    });
  }

  void _addSkill() {
    if (_skillController.text.isNotEmpty) {
      setState(() {
        _skills.add(_skillController.text);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(3, 73, 129, 1),
              Color.fromRGBO(3, 73, 129, 0.7),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _isEditing ? _pickImage : null,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const NetworkImage(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                        ) as ImageProvider,
                  child: _isEditing
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              _isEditing
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your name',
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    )
                  : Text(
                      _name,
                      style: const TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
              const SizedBox(height: 10),
              _isEditing
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextField(
                        controller: _titleController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16, 
                            color: Colors.white70),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your title',
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    )
                  : Text(
                      _title,
                      style: const TextStyle(
                          fontSize: 16, 
                          color: Colors.white70),
                    ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About Me',
                      style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    _isEditing
                        ? TextField(
                            controller: _bioController,
                            maxLines: 4,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                              hintText: 'Write something about yourself',
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          )
                        : Text(
                            _bio,
                            style: const TextStyle(
                                fontSize: 16, 
                                color: Colors.white),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Skills',
                      style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    if (_isEditing) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _skillController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Add new skill',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              ),
                            ),
                            ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: _addSkill,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _skills.map((skill) {
                        return _isEditing
                            ? InputChip(
                                label: Text(skill, 
                                    style: const TextStyle(color: Colors.white)),
                                backgroundColor: const Color.fromRGBO(3, 73, 129, 0.8),
                                deleteIcon: const Icon(Icons.close, 
                                    color: Colors.white, size: 18),
                                onDeleted: () => _removeSkill(skill),
                              )
                            : Chip(
                                label: Text(skill, 
                                    style: const TextStyle(color: Colors.white)),
                                backgroundColor: const Color.fromRGBO(3, 73, 129, 0.8),
                              );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}