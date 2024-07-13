import 'package:flutter/material.dart';
import './api/api_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    ApiService.init();
  }

  void _sendMessage(String text) async {
    if (text.isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, sender: 'user'));
    });

    String? reply = await ApiService.sendMessage(text);
    if (reply != null) {
      setState(() {
        _messages.add(ChatMessage(text: reply, sender: 'bot'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yo-PT'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.sender == 'user'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: ChatBubble(
                    message: message.text,
                    isUser: message.sender == 'user',
                  ),
                );
              },
            ),
          ),
          _buildTextInput(),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _sendMessage(_textController.text),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final String sender; // 'user' 또는 'bot'

  ChatMessage({required this.text, required this.sender});
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  ChatBubble({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: isUser ? Colors.pink : Colors.grey[300],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isUser ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
