import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:int20h_app/constants.dart';
import 'package:int20h_app/dto/audio_message.dart';
import 'package:int20h_app/pages/history_page/history_page.dart';
import 'package:int20h_app/pages/home_page/cubit/chat_cubit.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state.bookType != null) {
            return HistoryPagePage(bookType: state.bookType);
          }

          return Chat(
            user: myUser,
            messages: state.messages
                .map((e) => _mapAudioMessageToMessage(e))
                .toList(),
            onSendPressed: (message) =>
                context.read<ChatCubit>().sendMessage(message.text),
            scrollPhysics: AlwaysScrollableScrollPhysics(),
            emptyState: Center(
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyText2,
                  children: [
                    TextSpan(text: 'Send '),
                    TextSpan(
                      text: 'Hi ',
                      style: theme.textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(text: 'to start a conversation'),
                  ],
                ),
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
