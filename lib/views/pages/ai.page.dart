import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final GenerativeModel _gemini = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey:
        'AIzaSyCaC6g7vSAZEtifi8L92B6JtHXVJs6zSNU', // Replace with your actual API key
  );
  bool _isReplying = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _textController.clear();
      _isReplying = true;
    });
    _scrollToBottom();

    try {
      final response = await _gemini.generateContent([Content.text(text)]);
      if (response?.text != null) {
        setState(() {
          _messages.add(ChatMessage(text: response!.text!, isUser: false));
          _isReplying = false;
        });
      } else {
        setState(() {
          _messages.add(
            ChatMessage(
                text: "Sorry, I couldn't get a response.", isUser: false),
          );
          _isReplying = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: 'Error: $e', isUser: false));
        _isReplying = false;
      });
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(
      //   title: const Text('Gemini Chat'),
      //  centerTitle: true,
      // ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatMessageWidget(message: message);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _isReplying
                      ? null
                      : () => _sendMessage(_textController.text),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _isReplying
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : const Text('Send'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.black87 : Colors.black87,
          ),
        ),
      ),
    );
  }
}
