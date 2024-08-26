import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Controller extends StatefulWidget {
  const Controller({super.key});

  @override
  State<Controller> createState() => _ControllerState();
}

const baseUrl = 'http://192.168.1.5:3000/signage';
const base = 'http://192.168.1.5:3000';

Future<void> uploadFile(Uint8List bytes, type) async {
  final dio = Dio();

  try {
    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(
        bytes,
        filename: filename, // Use appropriate filename here
      ),
      'name': type,
      'type': type,
      'url': '$base/files/$filename'
    });

    final response = await dio.post(
      '$baseUrl/upload',
      data: formData,
    );

    debugPrint('Upload successful: ${response.data}');
  } catch (e) {
    debugPrint('Error during upload: $e');
  }
}

String? filename;

Uint8List? banner1;
Uint8List? banner2;
Uint8List? banner3;
Uint8List? banner4;
Uint8List? video;

class _ControllerState extends State<Controller> {
  final textController = TextEditingController();
  Future<void> updateText() async {
    if (textController.text.isNotEmpty) {
      try {
        final dio = Dio();
        final response = await dio.post(
          '$baseUrl/text',
          data: {'type': 'text','url':textController.text},
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ),
        );

        debugPrint('Response status: ${response.statusCode}');
        debugPrint('Response data: ${response.data}');

        if (response.statusCode == 200) {
          debugPrint('Update successful');
        } else {
          debugPrint('Update failed with status code: ${response.statusCode}');
        }
      } catch (e) {
        if (e is DioException) {
          debugPrint('DioException details: ${e.message}');
          debugPrint('DioException type: ${e.type}');
          debugPrint('DioException response: ${e.response}');
        } else {
          debugPrint('Error occurred: $e');
        }
      }
    } else {
      debugPrint('Text field is empty');
    }
  }

  Future<void> pickFile(String type) async {
    if (type == 'video') {
      var result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['3gp', 'mkv', 'mov', 'webp', 'avi', 'mp4'],
      );
      if (result != null) {
        filename = result.files.single.name.toString().replaceAll(' ', '');
        up(result.files.single.bytes, type);
      }
    } else {
      var result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );
      if (result != null) {
        filename = result.files.single.name.toString().replaceAll(' ', '');
        up(result.files.single.bytes, type);
      }
    }
  }

  void up(Uint8List? result, String type) async {
    if (result != null) {
      switch (type) {
        case 'banner1':
          {
            setState(() {
              banner1 = result;
            });
            await uploadFile(banner1!, type);
            break;
          }
        case 'banner2':
          {
            setState(() {
              banner2 = result;
            });
            await uploadFile(banner2!, type);
            break;
          }
        case 'banner3':
          {
            setState(() {
              banner3 = result;
            });
            await uploadFile(banner3!, type);
            break;
          }
        case 'banner4':
          {
            setState(() {
              banner4 = result;
            });
            await uploadFile(banner4!, type);
            break;
          }
        case 'video':
          {
            setState(() {
              video = result;
            });
            await uploadFile(video!, type);
            break;
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      pickFile('banner1');
                    },
                    child: banner1 != null
                        ? Image.memory(
                            banner1!,
                            width: 300,
                            height: 300,
                          )
                        : Column(
                            children: [
                              const Text('Banner 1'),
                              Container(
                                decoration: BoxDecoration(border: Border.all()),
                                width: 300,
                                height: 300,
                                child: const Icon(
                                  Icons.add,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      pickFile('banner2');
                    },
                    child: banner2 != null
                        ? Image.memory(
                            banner2!,
                            width: 300,
                            height: 300,
                          )
                        : Column(
                            children: [
                              const Text('Banner 2'),
                              Container(
                                decoration: BoxDecoration(border: Border.all()),
                                width: 300,
                                height: 300,
                                child: const Icon(
                                  Icons.add,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      pickFile('banner3');
                    },
                    child: banner3 != null
                        ? Image.memory(
                            banner3!,
                            width: 300,
                            height: 300,
                          )
                        : Column(
                            children: [
                              const Text('Banner 3'),
                              Container(
                                decoration: BoxDecoration(border: Border.all()),
                                width: 300,
                                height: 300,
                                child: const Icon(
                                  Icons.add,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      pickFile('banner4');
                    },
                    child: banner4 != null
                        ? Image.memory(
                            banner4!,
                            width: 300,
                            height: 300,
                          )
                        : Column(
                            children: [
                              const Text('Banner 4'),
                              Container(
                                decoration: BoxDecoration(border: Border.all()),
                                width: 300,
                                height: 300,
                                child: const Icon(
                                  Icons.add,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  pickFile('video');
                },
                child: video != null
                    ? Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.green, border: Border.all()),
                              width: 610,
                              height: 300,
                              child: const Center(
                                child: Text('Berhasil upload video'),
                              )),
                        ],
                      )
                    : Column(
                        children: [
                          const Text('Video'),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            width: 600,
                            height: 300,
                            child: const Icon(
                              Icons.add,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(hintText: 'Teks bejalan'),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await updateText();
                      },
                      icon: Icon(
                        Icons.send,
                        size: 22,
                      ))
                ],
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
