import 'package:flutter/material.dart';

import 'package:flutter_math_fork/flutter_math.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../core/ads/ad_helper.dart';

class ViewQuestion extends StatefulWidget {
  final String header;
  final String body;
  final String anwer;
  const ViewQuestion(
      {Key? key, required this.header, required this.body, required this.anwer})
      : super(key: key);

  @override
  State<ViewQuestion> createState() => _ViewQuestionState();
}

class _ViewQuestionState extends State<ViewQuestion> {
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
  void initState() {
    super.initState();
    _createBottomBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionHeader = Math.tex(
      widget.header,
      textStyle: TextStyle(
        color: Colors.red,
        fontSize: MediaQuery.of(context).size.width / 20,
      ),
      mathStyle: MathStyle.display,
    );
    final questionBody = Math.tex(
      widget.body,
      textStyle: TextStyle(
        color: Colors.black,
        fontSize: MediaQuery.of(context).size.width / 20,
      ),
      mathStyle: MathStyle.display,
    );
    final questionAnswer = Math.tex(
      widget.anwer,
      textStyle: TextStyle(
        color: Colors.green,
        fontSize: MediaQuery.of(context).size.width / 20,
      ),
      mathStyle: MathStyle.display,
    );

    final breakHeader = questionHeader.texBreak();
    final breakBody = questionBody.texBreak();
    final breakAnswer = questionAnswer.texBreak();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black26,
        ),
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 3.0,
            ),
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListView(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Q):"),
                      Wrap(
                        runSpacing: 15,
                        alignment: WrapAlignment.start,
                        children: breakHeader.parts,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Solution :"),
                      Wrap(
                        runSpacing: 15,
                        alignment: WrapAlignment.start,
                        children: breakBody.parts,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Final Answer:"),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black12,
                            )),
                        child: Wrap(
                          runSpacing: 15,
                          alignment: WrapAlignment.start,
                          children: breakAnswer.parts,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
}
