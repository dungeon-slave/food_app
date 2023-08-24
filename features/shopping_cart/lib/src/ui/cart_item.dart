import 'package:core/core.dart' show BlocProvider;
import 'package:core_ui/core_ui.dart';
import 'package:domain/models/cart_items/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:shopping_cart/src/bloc/shopping_cart/shopping_cart_bloc.dart';

class CartItem extends StatelessWidget {
  final CartItemModel _model;

  const CartItem({
    required CartItemModel model,
    super.key,
  }) : _model = model;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).indicatorColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Hero(
            tag: _model.dishModel.id,
            child: AppImage(
              imageRef: _model.dishModel.imageRef,
              width: AppDimens.size100,
              height: AppDimens.size100,
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                _model.dishModel.name,
                style: AppFonts.normal22,
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () =>
                        BlocProvider.of<ShoppingCartBloc>(context).add(
                      DecrementEvent(model: _model),
                    ),
                    icon: const Icon(Icons.remove_circle),
                    color: Theme.of(context).indicatorColor,
                  ),
                  Text(
                    _model.count.toString(),
                    style: AppFonts.normal22,
                  ),
                  IconButton(
                    onPressed: () =>
                        BlocProvider.of<ShoppingCartBloc>(context).add(
                      IncrementEvent(model: _model),
                    ),
                    icon: const Icon(Icons.add_circle),
                    color: Theme.of(context).indicatorColor,
                  ),
                ],
              )
            ],
          ),
          Text(
            '${_model.averagePrice.toStringAsFixed(AppNumConstants.priceSize)}\$',
            style: AppFonts.normal22,
          ),
        ],
      ),
    );
  }
}
