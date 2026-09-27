import 'dart:math';

/// Result of a payment initialization.
class PaymentInitResult {
  final bool success;
  final String? authorizationUrl;
  final String? reference;
  final String? error;

  const PaymentInitResult({
    required this.success,
    this.authorizationUrl,
    this.reference,
    this.error,
  });
}

/// Result of a payment verification.
class PaymentVerifyResult {
  final bool success;
  final String? message;

  const PaymentVerifyResult({required this.success, this.message});
}

/// Abstraction over a payment gateway (Paystack / Flutterwave / Stripe).
///
/// To use a real gateway:
/// 1. Add the gateway's Flutter package (e.g. `paystack_flutter`, `flutterwave_standard`).
/// 2. Replace the mock bodies below with real SDK calls.
/// 3. Store your secret key in an environment variable or secure backend —
///    never hardcode it in the app.
abstract class PaymentGateway {
  /// Initializes a payment and returns the checkout URL + reference.
  Future<PaymentInitResult> initializePayment({
    required double amount,
    required String email,
    required String reference,
  });

  /// Verifies a payment by its reference.
  Future<PaymentVerifyResult> verifyPayment(String reference);
}

/// Mock implementation for offline development.
class MockPaymentGateway implements PaymentGateway {
  @override
  Future<PaymentInitResult> initializePayment({
    required double amount,
    required String email,
    required String reference,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return PaymentInitResult(
      success: true,
      authorizationUrl: 'https://checkout.mock-gateway.com/pay/$reference',
      reference: reference,
    );
  }

  @override
  Future<PaymentVerifyResult> verifyPayment(String reference) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const PaymentVerifyResult(success: true, message: 'Payment verified');
  }
}

/// Generates a unique payment reference.
String generatePaymentReference() {
  final rnd = Random();
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final randomPart = List.generate(10, (_) => chars[rnd.nextInt(chars.length)]).join();
  return 'DV_${DateTime.now().millisecondsSinceEpoch}_$randomPart';
}
