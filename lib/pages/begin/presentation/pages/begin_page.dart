import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/provider/shared_provider.dart';
import '../../../../core/util/theme.dart';
import '../../data/states/begin_state.dart';
import '../../domain/providers/begin_provider.dart';
import '../widgets/common_button.dart';
import 'home_page.dart';

class BeginPage extends ConsumerWidget {
  const BeginPage({Key? key}) : super(key: key);

  void onTapStart({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    if (ref.read(walletConnectedProvider.notifier).isWalletConnected) {
      HomePage.show(context);
    } else {
      Fluttertoast.showToast(msg: '請先連結或匯入錢包');
    }
  }

  void listenConnectWallet(WidgetRef ref) {
    ref.listen<ConnectWalletState>(connectWalletProvider, (previous, next) {
      if (next is ConnectWalletData) {
        ref.read(walletConnectedProvider.notifier).addWallet(next.walletInfo);
      } else if (next is ConnectWalletError) {
        Fluttertoast.showToast(msg: next.msg);
      }
    });
  }

  void listenImportWallet(WidgetRef ref) {
    ref.listen<ConnectWalletState>(
      importWalletProvider,
      (previous, next) {
        if (next is ConnectWalletError) {
          Fluttertoast.showToast(msg: next.msg);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: CustomTheme.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Consumer(builder: (context, ref, _) {
                    return CommonButton(
                      onPress: () => onTapStart(context: context, ref: ref),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/chicken-btn.png',
                            width: 51,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              '直接開始',
                              style: CustomTheme.textBlack,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: CustomTheme.bgColor,
                          )
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const Text(
                '其他連接方式',
                textAlign: TextAlign.center,
                style: CustomTheme.textSmallGray,
              ),
              const SizedBox(height: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Consumer(builder: (context, ref, _) {
                    listenConnectWallet(ref);

                    return CommonButton(
                      onPress: () => ref.read(connectWalletProvider.notifier).connectWallet(),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: ref.watch(connectWalletProvider).whenOrNull(
                              init: () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/metamask-icon.png',
                                    width: 26,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Connect Wallet',
                                    style: CustomTheme.textBlack,
                                  ),
                                ],
                              ),
                              loading: () => const SizedBox(
                                width: 24.0,
                                height: 24.0,
                                child: CircularProgressIndicator(
                                  color: CustomTheme.primaryColor,
                                ),
                              ),
                              data: (wallet) => Text(
                                wallet.address,
                                style: CustomTheme.textBlack,
                              ),
                            ),
                      ),
                    );
                  }),
                  const SizedBox(height: 18),
                  Consumer(builder: (context, ref, _) {
                    listenImportWallet(ref);

                    return CommonButton(
                      onPress: () => ref.read(importWalletProvider.notifier).importWallet(),
                      color: CustomTheme.secondColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: ref.watch(importWalletProvider).whenOrNull(
                              init: () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/key-btn.png',
                                    width: 26,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Import PrivateKey',
                                    style: CustomTheme.textWhite,
                                  ),
                                ],
                              ),
                              loading: () => const SizedBox(
                                width: 24.0,
                                height: 24.0,
                                child: CircularProgressIndicator(
                                  color: CustomTheme.primaryColor,
                                ),
                              ),
                              data: (wallet) => Text(
                                wallet.address,
                                style: CustomTheme.textBlack,
                              ),
                            ),
                      ),
                    );
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
