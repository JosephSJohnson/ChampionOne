import 'package:flutter/material.dart';

class AiSupportAssistantScreen extends StatefulWidget {
  const AiSupportAssistantScreen({
    super.key,
  });

  @override
  State<AiSupportAssistantScreen> createState() =>
      _AiSupportAssistantScreenState();
}

class _AiSupportAssistantScreenState
    extends State<AiSupportAssistantScreen> {
  final TextEditingController _messageController =
      TextEditingController();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          'Hello! I am the ChampionOne Support Assistant. '
          'I can help you learn how to use ChampionOne '
          'and guide you through common problems.',
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message =
        _messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(
        _ChatMessage(
          text: message,
          isUser: true,
        ),
      );

      _messages.add(
        const _ChatMessage(
          text:
              'Thank you. The AI support service is '
              'not connected yet. This screen is the '
              'foundation for the ChampionOne AI '
              'Support Assistant.',
          isUser: false,
        ),
      );
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Support Assistant',
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (
                context,
                index,
              ) {
                final message =
                    _messages[index];

                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints:
                        const BoxConstraints(
                      maxWidth: 500,
                    ),
                    margin:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),
                    padding:
                        const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Colors.amber
                          : Colors.grey.shade200,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                12,
                8,
                12,
                12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller:
                          _messageController,
                      textInputAction:
                          TextInputAction.send,
                      onSubmitted: (_) =>
                          _sendMessage(),
                      decoration:
                          const InputDecoration(
                        hintText:
                            'Ask ChampionOne Support...',
                        border:
                            OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Send',
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.send,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage({
    required this.text,
    required this.isUser,
  });
}