import 'package:equatable/equatable.dart';

class AuthTokens extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  bool get isExpired {
    if (expiresAt == null) return false; // If no expiry, assume valid
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isExpiringSoon {
    if (expiresAt == null) return false; // If no expiry, assume not expiring
    final now = DateTime.now();
    final timeUntilExpiry = expiresAt!.difference(now);
    return timeUntilExpiry.inMinutes < 5; // Consider expired if less than 5 minutes
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt];
}
