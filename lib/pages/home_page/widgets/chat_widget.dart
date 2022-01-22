import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:int20h_app/constants.dart';
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
            messages: state.messages,
            onSendPressed: (message) =>
                context.read<ChatCubit>().sendMessage(message.text),
          );
        },
      ),
    );
  }
}
