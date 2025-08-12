import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

class ShopifyService {
  final String storeUrl; // e.g. https://snkrgram.myshopify.com
  final String accessToken; // Admin API token
  final String storefrontToken; // Storefront API token for checkout

  ShopifyService({required this.storeUrl, required this.accessToken, required this.storefrontToken});

  /// ✅ Fetch products from Shopify Admin API
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final url = Uri.parse('$storeUrl/admin/api/2025-01/products.json?limit=50');

    final response = await http.get(url, headers: {'X-Shopify-Access-Token': accessToken});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List products = data['products'];
      print('✅ Shopify returned ${products.length} products');
      return products.cast<Map<String, dynamic>>();
    } else {
      throw Exception('❌ Failed to fetch products: ${response.body}');
    }
  }

  /// ✅ Push products into Firebase Realtime Database
  Future<void> pushProductsToFirebase(List<Map<String, dynamic>> products) async {
    final dbRef = FirebaseDatabase.instance.ref().child('products');

    for (var product in products) {
      try {
        final id = product['id'].toString();
        final title = product['title'] ?? 'Untitled';
        final description = product['body_html'] ?? '';

        // ✅ Extract `price from first variant (fallback)
        final price = (product['variants'] != null && product['variants'].isNotEmpty) ? product['variants'][0]['price'] : '0.0';

        // ✅ Extract images
        final images = (product['images'] as List).map((img) => img['src'].toString()).toList();

        // ✅ Extract variants (important for checkout)
        final variants = (product['variants'] as List)
            .map((v) => {'id': v['id'].toString(), 'title': v['title'] ?? '', 'price': v['price'] ?? '', 'sku': v['sku'] ?? '', 'available': v['available'] ?? true})
            .toList();

        // ✅ Build product page URL (Shopify handle)
        final handle = product['handle'] ?? '';
        final pageUrl = handle.isNotEmpty ? '$storeUrl/products/$handle' : product['admin_graphql_api_id'] ?? '';

        // ✅ Push product to Firebase
        await dbRef.child(id).set({
          'id': id,
          'title': title,
          'price': double.tryParse(price) ?? 0.0,
          'description': product['body_html'] ?? '',
          'imageUrls': images,
          'variants': variants, // ✅ include
          'pageUrl': pageUrl,
          'status': 'New', // MVP placeholder
          'type': 'Footwear', // MVP placeholder
          'size': 'Other', // MVP placeholder
          'poster': 'shopify-import',
          'postertimeStamp': DateTime.now().toIso8601String(),
          'isFavorite': false,
          'shippingAddress': '',
          'shippingEmail': '',
          'buyer': '',
        });

        print('✅ Synced product: $title (Variants: ${variants.length})');
      } catch (e) {
        print('❌ Error syncing product: $e');
      }
    }

    print('✅ All products pushed to Firebase');
  }

  Future<String> createCheckout(String variantId, int quantity) async {
    print('🛒 [createCheckout] Starting checkout creation...');
    print('🌐 Using Storefront URL: $storeUrl');
    print('🔑 Storefront Token: $storefrontToken');

    final url = Uri.parse('$storeUrl/api/2025-01/graphql.json');

    // ✅ Convert numeric variant ID to Shopify GID
    final gidVariantId = "gid://shopify/ProductVariant/$variantId";
    print('🆔 Converted Variant ID: $gidVariantId');

    final mutation = '''
    mutation checkoutCreate(\$input: CheckoutCreateInput!) {
      checkoutCreate(input: \$input) {
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

    final requestBody = {
      'query': mutation,
      'variables': {
        'input': {
          'lineItems': [
            {'variantId': gidVariantId, 'quantity': quantity},
          ],
        },
      },
    };

    print('📤 Sending request: ${jsonEncode(requestBody)}');

    final response = await http.post(url, headers: {'Content-Type': 'application/json', 'X-Shopify-Storefront-Access-Token': storefrontToken}, body: jsonEncode(requestBody));

    print('📥 Response status: ${response.statusCode}');
    print('📥 Response body: ${response.body}');

    final data = jsonDecode(response.body);

    if (data['errors'] != null) {
      print('❌ Shopify Storefront API error: ${data['errors']}');
      throw Exception('❌ Shopify Storefront API error: ${data['errors']}');
    }

    final checkoutData = data['data']?['checkoutCreate'];
    if (checkoutData == null) {
      throw Exception('❌ Shopify did not return checkoutCreate: ${response.body}');
    }

    final userErrors = checkoutData['checkoutUserErrors'] as List;
    if (userErrors.isNotEmpty) {
      throw Exception('❌ Shopify checkoutUserErrors: $userErrors');
    }

    final checkoutUrl = checkoutData['checkout']['webUrl'];
    print('✅ Checkout URL: $checkoutUrl');

    return checkoutUrl;
  }

  // 🔄 Fetch store configurations from Firebase
  Future<List<Map<String, dynamic>>> fetchStoreConfigs() async {
    final dbRef = FirebaseDatabase.instance.ref().child('stores');
    final snapshot = await dbRef.get();

    if (!snapshot.exists) {
      print('❌ No Shopify store configs found in Firebase.');
      return [];
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return data.entries.map((entry) {
      final storeData = Map<String, dynamic>.from(entry.value);
      return {'storeUrl': storeData['storeUrl'], 'accessToken': storeData['accessToken'], 'storefrontToken': storeData['storefrontToken']};
    }).toList();
  }

  // 🔁 Run scraper for all configured stores
  Future<void> runScraperForAllStores() async {
    final stores = await fetchStoreConfigs();

    for (var store in stores) {
      final storeUrl = store['storeUrl'];
      final accessToken = store['accessToken'];
      final storefrontToken = store['storefrontToken'];

      if (storeUrl == null || accessToken == null || storefrontToken == null) {
        print('❌ Skipping store with missing config: $store');
        continue;
      }

      final shopifyService = ShopifyService(storeUrl: storeUrl, accessToken: accessToken, storefrontToken: storefrontToken);

      final products = await shopifyService.fetchProducts();
      await shopifyService.pushProductsToFirebase(products);
    }

    print('✅ All stores processed successfully.');
  }
}

Future<ShopifyService> getPrimaryShopifyService() async {
  final dbRef = FirebaseDatabase.instance.ref('stores');
  final snapshot = await dbRef.get();

  if (!snapshot.exists) {
    throw Exception('❌ No Shopify store config found');
  }

  final data = Map<String, dynamic>.from(snapshot.value as Map);
  final firstEntry = data.entries.first.value;

  return ShopifyService(storeUrl: firstEntry['storeUrl'], accessToken: firstEntry['accessToken'], storefrontToken: firstEntry['storefrontToken']);
}
