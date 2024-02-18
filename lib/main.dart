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
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        cardTheme: const CardTheme(
          color: Colors.black,
        ),
      ),
      home: const ChatPage(),
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
  ValueNotifier<bool> isLoading = ValueNotifier(false);

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

                  isLoading.value = true;

                  final model = GenerativeModel(
                    model: 'gemini-pro',
                    apiKey: geminiApiKey,
                  );

                  final prompt = controller.text;
                  final content = [Content.text(prompt)];
                  controller.clear();
                  final response = await model.generateContent(content);

                  listDatas.add(response.text ?? "");

                  isLoading.value = false;

                  controller.clear();
                }
                setState(() {});
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
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: listDatas.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return Align(
                  alignment: index.isOdd
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        listDatas[index],
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: index.isOdd ? Colors.yellow : Colors.blue,
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
