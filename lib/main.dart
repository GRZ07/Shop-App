import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../screens/cart_screen.dart';
import './providers/auth.dart';
import './providers/products.dart';
import 'screens/auth_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/user_products_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(authToken: '', itemsProd: [], userId: ''),
            update: (ctx, auth, previousProducts) => Products(
                authToken: auth.token,
                itemsProd: previousProducts?.itemsProd ?? [],
                userId: auth.userId),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders(authToken: '', order: [], userId: ''),
            update: (ctx, auth, previousOrders) => Orders(
                authToken: auth.token,
                order: previousOrders?.order ?? [],
                userId: auth.userId),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                primaryColor: Colors.purple,
                hintColor: Colors.black,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth
                  ? const ProductsOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? const SplashScreen()
                              : const AuthScreen(),
                    ),
              routes: {
                ProductDetailScreen.routeName: (ctx) =>
                    const ProductDetailScreen(),
                CartScreen.routeName: (ctx) => const CartScreen(),
                OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                UserProductsScreen.routeName: (ctx) =>
                    const UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => const EditProductScreen(),
              }),
        ));
  }
}
