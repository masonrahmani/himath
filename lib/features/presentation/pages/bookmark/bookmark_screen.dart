import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:screenshot/screenshot.dart';
import 'package:self_host_group_chat_app/core/share_equation.dart';
import 'package:self_host_group_chat_app/features/presentation/cubit/bookmark/bookmark_cubit.dart';

import '../../../../core/ads/ad_helper.dart';
import '../../../../core/page_const.dart';

class BookMarkScreen extends StatefulWidget {
  final String uid;
  const BookMarkScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  final _inlineAdIndex = 1;

  late BannerAd _inlineBannerAd;

  bool _isInlineBannerAdLoaded = false;

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
    BlocProvider.of<BookmarkCubit>(context).getBookMarks(widget.uid);
    super.initState();
    _createInlineBannerAd();
  }

  @override
  void dispose() {
    super.dispose();

    _inlineBannerAd.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100.withOpacity(0.2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Bookmark",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) {
          if (state is BookMarkLoaded) {
            if (state.bookmarks.isNotEmpty) {
              return _buildVavoriteList(context, state);
            } else {
              return Center(
                child: Text("Empty"),
              );
            }
          }
          if (state is BookMarkFailure) {
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

  Widget _buildVavoriteList(BuildContext context, BookMarkLoaded state) {
    return ListView.builder(
        itemCount: state.bookmarks.length,
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
          return questionBox(context, state, index);
        });
  }

  Widget questionBox(BuildContext context, BookMarkLoaded state, int index) {
    final longEq = Math.tex(
      state.bookmarks[index].header,
      textStyle: TextStyle(
        color: Colors.deepOrange.shade400,
        fontSize: MediaQuery.of(context).size.width / 20,
        fontWeight: FontWeight.w100,
      ),
      mathStyle: MathStyle.display,
    );

    final breakResult = longEq.texBreak();
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 3.0,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.bookmarks[index].subjectname,
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                PageConst.viewQuestion,
                arguments: {
                  'header': state.bookmarks[index].header,
                  'body': state.bookmarks[index].body,
                  'answer': state.bookmarks[index].answer,
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.black12),
                    borderRadius: BorderRadius.circular(10)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    runSpacing: 15,
                    alignment: WrapAlignment.start,
                    children: breakResult.parts,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.withOpacity(0.1)),
                  child: Text(
                    state.bookmarks[index].date,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey.withOpacity(0.1)),
                        child: InkWell(
                          onTap: () {
                            BlocProvider.of<BookmarkCubit>(context)
                                .deleteBookMark(
                                    state.bookmarks[index].bookmarkID);
                          },
                          child: Icon(
                            Icons.bookmark_remove_outlined,
                            size: 20,
                          ),
                        )),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey.withOpacity(0.1)),
                        child: InkWell(
                          onTap: () {
                            shareEquation(state.bookmarks[index].header);
                          },
                          child: Icon(
                            Icons.share,
                            size: 20,
                          ),
                        )),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
