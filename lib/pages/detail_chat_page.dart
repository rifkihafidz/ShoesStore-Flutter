import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shamo_frontend/bloc/auth/auth_bloc.dart';
import 'package:shamo_frontend/models/message_model.dart';
import 'package:shamo_frontend/models/product_model.dart';
import 'package:shamo_frontend/models/user_model.dart';
import 'package:shamo_frontend/services/message_service.dart';
import 'package:shamo_frontend/theme.dart';
import 'package:shamo_frontend/widgets/chat_bubble.dart';

// ignore: must_be_immutable
class DetailChatPage extends StatefulWidget {
  ProductModel product;

  DetailChatPage(this.product, {Key? key}) : super(key: key);

  @override
  _DetailChatPageState createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  TextEditingController messageController = TextEditingController(text: '');

  handleAddMessage(UserModel user) async {
    await MessageService().addMessage(
      user: user,
      isFromUser: true,
      product: widget.product,
      message: messageController.text,
    );

    setState(() {
      widget.product = UnitializedProductModel();
      messageController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    header() {
      return PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          margin: EdgeInsets.only(
            top: 7,
          ),
          child: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: backgroundColor1,
            centerTitle: false,
            title: Row(
              children: [
                Image.asset(
                  'assets/image_shop_logo_online.png',
                  width: 50,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shoes Store',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Online',
                      style: secondaryTextStyle.copyWith(
                        fontWeight: light,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget productReview() {
      return Container(
        width: 225,
        height: 74,
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor5,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primaryColor,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.product.galleries![0].url,
                width: 54,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name!,
                    style: primaryTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    '\$${widget.product.price}',
                    style: priceTextStyle.copyWith(
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.product = UnitializedProductModel();
                });
              },
              child: Image.asset(
                'assets/button_close.png',
                width: 22,
              ),
            ),
          ],
        ),
      );
    }

    Widget content(UserModel user) {
      return StreamBuilder<List<MessageModel>>(
        stream: MessageService().getMessagesByUserId(userId: user.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: defaultMargin,
              ),
              children: snapshot.data!
                  .map((MessageModel message) => ChatBubble(
                        isSender: message.isFromUser,
                        text: message.message,
                        product: message.product,
                      ))
                  .toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }

    Widget chatInput(UserModel user) {
      return Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kondisi ketika model product kosong (mengakses chat dari menu chat, bukan dari product page)
            widget.product is UnitializedProductModel
                ? SizedBox()
                : productReview(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor4,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextFormField(
                        controller: messageController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type Message...',
                          hintStyle: subtitleTextStyle,
                        ),
                        style: primaryTextStyle,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () async {
                    handleAddMessage(user);
                  },
                  child: Image.asset(
                    'assets/button_send.png',
                    width: 45,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoggedIn) {
          return Scaffold(
            backgroundColor: backgroundColor3,
            appBar: header(),
            bottomNavigationBar: chatInput(state.user),
            body: content(state.user),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
