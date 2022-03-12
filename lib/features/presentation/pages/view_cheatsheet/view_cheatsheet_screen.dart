import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:self_host_group_chat_app/features/domain/entities/cheatsheet_entity.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/ads/ad_helper.dart';

class ViewCheasheetScreen extends StatefulWidget {
  final CheatSheetEntity cheatSheetEntity;
  const ViewCheasheetScreen({Key? key, required this.cheatSheetEntity})
      : super(key: key);

  @override
  State<ViewCheasheetScreen> createState() => _ViewCheasheetScreenState();
}

class _ViewCheasheetScreenState extends State<ViewCheasheetScreen> {
  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;
  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
  }

  late WebViewController _controller;
  int position = 1;

  @override
  void initState() {
    _createBottomBannerAd();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black26,
          ),
          elevation: 0,
          title: Text(
            widget.cheatSheetEntity.name,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: IndexedStack(
          index: position,
          children: [
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              margin: const EdgeInsets.all(20),
              child: WebView(
                initialUrl: 'about:blank',
                javascriptMode: JavascriptMode.unrestricted,
                onPageStarted: (index) {
                  setState(() {
                    position = 1;
                  });
                },
                onPageFinished: (index) {
                  setState(() {
                    position = 0;
                  });
                },
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                  _controller.loadUrl(Uri.dataFromString(
                          """  ${widget.cheatSheetEntity.body}""",
                          mimeType: 'text/html',
                          encoding: Encoding.getByName('utf-8'))
                      .toString());
                },
              ),
            ),
            Container(
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
        bottomNavigationBar: _isBottomBannerAdLoaded
            ? Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: _bottomBannerAd.size.height.toDouble(),
                width: _bottomBannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bottomBannerAd),
              )
            : null,
      );
}
