import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:self_host_group_chat_app/features/domain/entities/subject_entity.dart';
import 'package:self_host_group_chat_app/features/presentation/cubit/cheatsheet/cheatsheet_cubit.dart';
import 'package:self_host_group_chat_app/core/page_const.dart';

import '../../../../core/ads/ad_helper.dart';
import '../../cubit/content/content_cubit.dart';

const int maxFailedLoadAttempts = 3;

class ContentScreen extends StatefulWidget {
  final SubjectEntity subjectEntity;
  const ContentScreen({Key? key, required this.subjectEntity})
      : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  int _interstitialLoadAttempts = 0;
  InterstitialAd? _interstitialAd;
  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  @override
  void initState() {
    BlocProvider.of<ContentCubit>(context)
        .getContents(widget.subjectEntity.subjectId);
    BlocProvider.of<CheatsheetCubit>(context)
        .getCheatSheets(widget.subjectEntity.subjectId);
    super.initState();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();

    _interstitialAd?.dispose();
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black26,
        ),
        elevation: 0,
        title: Text(
          widget.subjectEntity.name,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: BlocBuilder<ContentCubit, ContentState>(
          builder: (context, state) {
            if (state is ContentLoaded) {
              if (state.contents.isNotEmpty) {
                return _buildContentGrid(state);
              }
              return Center(
                child: const Text('Empty'),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _buildContentGrid(ContentLoaded state) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.black12,
                  width: 0.6,
                )),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 0),
              dragStartBehavior: DragStartBehavior.start,
              itemCount: state.contents.length,
              itemBuilder: (context, index) => _buildContents(state, index),
            ),
          ),
        ),
        _buildCheatSheet(),
        SizedBox(
          height: 40,
        )
      ],
    );
  }

  Widget _buildContents(ContentLoaded state, int index) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, PageConst.questionsScreen, arguments: {
          'sid': widget.subjectEntity.subjectId,
          'sname': state.contents[index].name,
          'conId': state.contents[index].contentID,
        });
      },
      child: Container(
          margin: EdgeInsets.only(
            top: 10,
            right: 5,
            left: 5,
          ),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(widget.subjectEntity.color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            state.contents[index].name,
            style: TextStyle(color: Color(widget.subjectEntity.color)),
          )),
    );
  }

  Widget _buildCheatSheet() {
    return BlocBuilder<CheatsheetCubit, CheatsheetState>(
      builder: (context, state) {
        if (state is CheatsheetLoaded) {
          if (state.cheatsheets.isNotEmpty) {
            return _buildCheatSheetList(state);
          }
        }
        if (state is CheatsheetFailure) {
          return const Center(
            child: Text("Error"),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildCheatSheetList(CheatsheetLoaded state) {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black12,
            width: 0.6,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: Text(
              "CHEATSHEET",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.cheatsheets.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      _showInterstitialAd();
                      Navigator.pushNamed(
                          context, PageConst.viewCheatsheetScreen,
                          arguments: state.cheatsheets[index]);
                    },
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          color: Color(widget.subjectEntity.color)
                              .withOpacity(0.05),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            state.cheatsheets[index].name,
                            style: TextStyle(
                                color: Color(widget.subjectEntity.color)),
                          ),
                        )),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
