import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../../core/ads/ad_helper.dart';
import '../../cubit/question/question_cubit.dart';
import '../../widgets/question_box_widget.dart';

class QuestionScreen extends StatefulWidget {
  final String sid;
  final String sname;
  final String conId;
  const QuestionScreen({
    Key? key,
    required this.sid,
    required this.sname,
    required this.conId,
  }) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final _inlineAdIndex = 2;
  late BannerAd _inlineBannerAd;

  bool _isInlineBannerAdLoaded = false;

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  void _createInlineBannerAd() {
    _inlineBannerAd = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isInlineBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _inlineBannerAd.load();
  }

  @override
  void initState() {
    BlocProvider.of<QuestionCubit>(context)
        .getQuestions(widget.sid, widget.conId);
    super.initState();
    _createInlineBannerAd();
  }

  @override
  void dispose() {
    super.dispose();

    _inlineBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          widget.sname,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: BlocBuilder<QuestionCubit, QuestionState>(
        builder: (context, state) {
          if (state is QuestionLoaded) {
            print(state.questions);
            if (state.questions.isNotEmpty) {
              return _buildVavoriteList(context, state);
            } else {
              return Center(
                child: Text("Empty"),
              );
            }
          }
          if (state is QuestionFailure) {
            return Center(
              child: Text("Error"),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildVavoriteList(BuildContext context, QuestionLoaded state) {
    return ListView.builder(
        itemCount: state.questions.length,
        itemBuilder: (context, index) {
          if (_isInlineBannerAdLoaded && index == _inlineAdIndex) {
            return Container(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              width: _inlineBannerAd.size.width.toDouble(),
              height: _inlineBannerAd.size.height.toDouble(),
              child: AdWidget(ad: _inlineBannerAd),
            );
          }
          return question_box_widget(
              contentName: widget.sname,
              scaffoldState: _scaffoldState,
              context: context,
              state: state,
              index: index);
        });
  }
}
