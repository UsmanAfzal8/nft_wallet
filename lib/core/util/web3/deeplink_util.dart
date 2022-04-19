import 'dart:io';

import '../../../pages/begin/data/models/crypto_wallet_link.dart';

class DeeplinkUtil {
  static const wcBridge = 'wc?uri=';

  static String getDeeplink({
    required CryptoWalletLink wallet,
    required String uri,
  }) {
    if (Platform.isIOS) {
      return wallet.universalLink + wcBridge + Uri.encodeComponent(uri);
    } else {
      return uri;
    }
  }
}
