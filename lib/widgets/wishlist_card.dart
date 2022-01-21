import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shamo_frontend/bloc/auth/auth_bloc.dart';
import 'package:shamo_frontend/models/product_model.dart';
import 'package:shamo_frontend/models/user_model.dart';
import 'package:shamo_frontend/services/wishlist_service.dart';
import 'package:shamo_frontend/theme.dart';

// ignore: must_be_immutable
class WishlistCard extends StatelessWidget {
  ProductModel product;

  WishlistCard(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    deleteWishlist(UserModel user) async {
      await WishlistService().deleteWishlist(user: user, product: product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: alertColor,
          content: Text(
            'Item removed from wishlist.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(
        top: 10,
        left: 12,
        right: 14,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: backgroundColor4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.galleries![0].url,
              width: 60,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name!,
                  style: primaryTextStyle.copyWith(
                    fontWeight: semiBold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '\$${product.price}',
                  style: priceTextStyle,
                ),
              ],
            ),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoggedIn) {
                return GestureDetector(
                  onTap: () async {
                    deleteWishlist(state.user);
                  },
                  child: Image.asset(
                    'assets/button_wishlist_blue.png',
                    width: 34,
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
