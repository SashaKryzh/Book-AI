import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:int20h_app/constants.dart';
import 'package:int20h_app/dto/audio_message.dart';
import 'package:int20h_app/pages/home_page/cubit/chat_cubit.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return Chat(
            user: myUser,
            messages: state.messages
                .map((e) => _mapAudioMessageToMessage(e))
                .toList(),
            onSendPressed: (message) =>
                context.read<ChatCubit>().sendMessage(message.text),
            scrollPhysics: AlwaysScrollableScrollPhysics(),
            emptyState: Center(
              child: Text(
                'Send Hi to start a conversation',
              ),
            ),
            theme: DefaultChatTheme(
              primaryColor: Color(0xFFE46DCA),
            ),
          );
        },
      ),
    );
  }

  types.Message _mapAudioMessageToMessage(AudioMessage audioMessage) {
    return types.TextMessage(
      id: audioMessage.id,
      author: audioMessage.user,
      text: audioMessage.text,
    );
  }
}
