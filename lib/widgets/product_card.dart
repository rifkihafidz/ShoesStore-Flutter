import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shamo_frontend/bloc/auth/auth_bloc.dart';
import 'package:shamo_frontend/models/product_model.dart';
import 'package:shamo_frontend/pages/product_page.dart';
import 'package:shamo_frontend/services/wishlist_service.dart';
import 'package:shamo_frontend/theme.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  ProductCard(this.product, {Key? key}) : super(key: key);

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
              width: 215,
              height: 278,
              margin: EdgeInsets.only(right: defaultMargin),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xffECEDEF),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Image.network(
                    product.galleries![0].url,
                    width: 215,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
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
                          style: blackTextStyle.copyWith(
                            fontWeight: semiBold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
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
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
