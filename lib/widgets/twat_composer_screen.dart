import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math';
import '../models/twat.dart';
import 'package:image_picker/image_picker.dart';

class TwatComposerScreen extends StatefulWidget {
  final Function(String, String?) onSubmit;
  final Function(File) onImageUpload;
  final Twat? replyTo;

  const TwatComposerScreen(
      {super.key,
      required this.onSubmit,
      this.replyTo,
      required this.onImageUpload});

  @override
  _TwatComposerScreenState createState() => _TwatComposerScreenState();
}

class _TwatComposerScreenState extends State<TwatComposerScreen> {
  final TextEditingController _twatController = TextEditingController();
  String? _imageUrl;

  @override
  void dispose() {
    _twatController.dispose();
    super.dispose();
  }

  void _submitTwat() {
    if (_twatController.text.isNotEmpty) {
      widget.onSubmit(_twatController.text, _imageUrl);
      Navigator.of(context).pop();
    }
  }

  void _addImage() {
    setState(() {
      _imageUrl =
          'https://picsum.photos/seed/${Random().nextInt(1000)}/400/300';
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageUrl = await widget.onImageUpload(File(pickedFile.path));

      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  Future<void> _takeImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final imageUrl = await widget.onImageUpload(File(pickedFile.path));

      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.replyTo != null ? 'Reply' : 'Compose Twat'),
        actions: [
          TextButton(
            onPressed: _submitTwat,
            child: Text(
              widget.replyTo != null ? 'Reply' : 'Twat',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.replyTo != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Replying to ${widget.replyTo!.handle}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ),
            TextField(
              controller: _twatController,
              maxLength: 280,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "What's happening?",
              ),
            ),
            if (_imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  _imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            Wrap(
              spacing: 8.0, // Space between buttons
              children: [
                ElevatedButton(
                  onPressed: _addImage,
                  child: const Icon(Icons.photo_album),
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Icon(Icons.image),
                ),
                ElevatedButton(
                  onPressed: _takeImage,
                  child: const Icon(Icons.camera),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
