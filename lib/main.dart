import 'package:flutter/material.dart';
import 'package:gemini_ai_example/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();
  List<String> listDatas = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Gemini AI Generator'),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () async {
                if (controller.text.isNotEmpty) {
                  listDatas.add(controller.text);
                  setState(() {
                    isLoading = true;
                  });
                  final model = GenerativeModel(
                    model: 'gemini-pro',
                    apiKey: geminiApiKey,
                  );

                  final prompt = controller.text;
                  final content = [Content.text(prompt)];
                  final response = await model.generateContent(content);
                  listDatas.add(response.text ?? "");
                  setState(() {
                    isLoading = false;
                  });
                  controller.clear();
                }
              },
              child: const Icon(
                Icons.send,
                size: 25,
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
      body: ElevatedButton(onPressed: () async {}, child: const Text("Hello")),
    );
  }
}
