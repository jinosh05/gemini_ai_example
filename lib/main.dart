import 'package:flutter/material.dart';
import 'package:gemini_ai_example/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
            onPressed: () async {
              final model = GenerativeModel(
                model: 'gemini-pro',
                apiKey: geminiApiKey,
              );

              const prompt = 'Tell me about Yourself';
              final content = [Content.text(prompt)];
              final response = await model.generateContent(content);

              print(response.text);
            },
            child: const Text("Hello")),
      ),
    );
  }
}
