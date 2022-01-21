import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shamo_frontend/bloc/auth/auth_bloc.dart';
import 'package:shamo_frontend/models/product_model.dart';
import 'package:shamo_frontend/pages/product_page.dart';
import 'package:shamo_frontend/services/wishlist_service.dart';
import 'package:shamo_frontend/theme.dart';

class ProductTile extends StatelessWidget {
  final ProductModel product;

  ProductTile(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late bool isWishlist;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoggedIn) {
          return GestureDetector(
            onTap: () async {
              isWishlist = await WishlistService()
                  .checkWishlist(user: state.user, product: product);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(product, isWishlist),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(
                left: defaultMargin,
                right: defaultMargin,
                bottom: defaultMargin,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      product.galleries![0].url,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.category!.name,
                          style: secondaryTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          product.name!,
                          style: primaryTextStyle.copyWith(
                            fontWeight: semiBold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(height: 6),
                        Text(
                          '\$${product.price}',
                          style: priceTextStyle.copyWith(
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
