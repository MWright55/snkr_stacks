import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../shared/loading.dart';

class ShopifyCheckoutScreen extends StatefulWidget {
  final String checkoutUrl; // Pass full Shopify checkout link here

  const ShopifyCheckoutScreen({Key? key, required this.checkoutUrl}) : super(key: key);

  @override
  State<ShopifyCheckoutScreen> createState() => _ShopifyCheckoutScreenState();
}

class _ShopifyCheckoutScreenState extends State<ShopifyCheckoutScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print('📦 ShopifyCheckoutScreen initialized with URL: ${widget.checkoutUrl}');

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (url) async {
            setState(() => _isLoading = false);

            // ✅ Inject JavaScript to hide header/footer
            await _controller.runJavaScript("""
              // Hide header
              var header = document.querySelector('header');
              if (header) { header.style.display = 'none'; }

              // Hide footer
              var footer = document.querySelector('footer');
              if (footer) { footer.style.display = 'none'; }

              // Optional: hide nav bar if it exists
              var nav = document.querySelector('.site-nav');
              if (nav) { nav.style.display = 'none'; }
              """);
          },
          onNavigationRequest: (request) {
            // ✅ Allow cart + checkout pages, block everything else
            if (request.url.contains('cart') || request.url.contains('checkout')) {
              return NavigationDecision.navigate;
            }
            print('❌ Blocked navigation to: ${request.url}');
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) Center(child: Loading()),
        ],
      ),
    );
  }

  Future<String> createCheckout({
    required String storefrontToken,
    required String shopDomain, // e.g. "mystore.myshopify.com"
    required String variantId, // Shopify *variant ID* (not product ID)
    required int quantity,
  }) async {
    final url = Uri.https('$shopDomain', '/api/2025-01/graphql.json');

    // ✅ GraphQL mutation for checkoutCreate
    const String mutation = r'''
    mutation checkoutCreate($input: CheckoutCreateInput!) {
      checkoutCreate(input: $input) {
        checkout {
          id
          webUrl
        }
        checkoutUserErrors {
          field
          message
        }
      }
    }
  ''';

    // ✅ Build variables payload
    final Map<String, dynamic> variables = {
      "input": {
        "lineItems": [
          {"variantId": variantId, "quantity": quantity},
        ],
      },
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json", "X-Shopify-Storefront-Access-Token": storefrontToken},
        body: json.encode({"query": mutation, "variables": variables}),
      );

      print('📡 Shopify API Response: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('❌ Shopify API error: ${response.statusCode}');
      }

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // ✅ Check for user errors (e.g., invalid variant ID)
      final userErrors = jsonResponse['data']['checkoutCreate']['checkoutUserErrors'];
      if (userErrors != null && userErrors.isNotEmpty) {
        throw Exception('❌ Checkout error: ${userErrors[0]['message']}');
      }

      final checkoutUrl = jsonResponse['data']['checkoutCreate']['checkout']['webUrl'];
      print('✅ Checkout URL created: $checkoutUrl');

      return checkoutUrl;
    } catch (e) {
      print('❌ Failed to create checkout: $e');
      rethrow;
    }
  }
}
