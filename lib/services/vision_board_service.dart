import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VisionBoardItem {
  final String id;
  final String type; // 'text' or 'image'
  final String content;

  VisionBoardItem({required this.id, required this.type, required this.content});

  Map<String, dynamic> toJson() => {'id': id, 'type': type, 'content': content};

  factory VisionBoardItem.fromJson(Map<String, dynamic> json) {
    return VisionBoardItem(
      id: json['id'],
      type: json['type'],
      content: json['content'],
    );
  }
}

class VisionBoardService {
  static final VisionBoardService instance = VisionBoardService._internal();
  VisionBoardService._internal();

  final ValueNotifier<List<VisionBoardItem>> visionItems = ValueNotifier([]);
  final ImagePicker _picker = ImagePicker();

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsStr = prefs.getString('vision_board_items');
    if (itemsStr != null) {
      final List decoded = jsonDecode(itemsStr);
      visionItems.value = decoded.map((e) => VisionBoardItem.fromJson(e)).toList();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(visionItems.value.map((e) => e.toJson()).toList());
    await prefs.setString('vision_board_items', str);
  }

  Future<void> addTextCard(String text) async {
    final newItem = VisionBoardItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'text',
      content: text,
    );
    visionItems.value = [...visionItems.value, newItem];
    await _save();
  }

  Future<void> addImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Save image to local app directory so it persists
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        final savedImage = await File(image.path).copy('${appDir.path}/$fileName');

        final newItem = VisionBoardItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'image',
          content: savedImage.path,
        );
        visionItems.value = [...visionItems.value, newItem];
        await _save();
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> deleteItem(String id) async {
    visionItems.value = visionItems.value.where((item) => item.id != id).toList();
    await _save();
  }
}
