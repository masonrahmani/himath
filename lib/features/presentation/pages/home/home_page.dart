import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:screenshot/screenshot.dart';
import 'package:self_host_group_chat_app/features/domain/use_cases/get_all_questions_usecase.dart';
import 'package:self_host_group_chat_app/features/presentation/cubit/content/content_cubit.dart';
import 'package:self_host_group_chat_app/features/presentation/cubit/question/question_cubit.dart';
import 'package:self_host_group_chat_app/features/presentation/cubit/user/user_cubit.dart';

import '../../../../core/ads/ad_helper.dart';
import '../../../../core/page_const.dart';

import '../../cubit/subject/subject_cubit.dart';

import '../../widgets/question_box_widget.dart';

class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({Key? key, required this.uid}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  final _inlineAdIndex = 3;

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
    BlocProvider.of<SubjectCubit>(context).getSubjects();
    BlocProvider.of<UserCubit>(context).getUser(widget.uid);
    BlocProvider.of<ContentCubit>(context).getContents('6AlRo7Lbv9VSqL8pZx3C');
    BlocProvider.of<QuestionCubit>(context)
        .getQuestions('6AlRo7Lbv9VSqL8pZx3C', 'FyI9mbwAQPunvr4IiCKd');

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
        key: _scaffoldState,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                if (state.props.isNotEmpty) {
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(width: 2, color: Colors.black26)),
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.black26,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Hi " + state.user.name,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }
                return Text("");
              }
              return Text("");
            },
          ),
          actions: [
            Icon(
              Icons.more_vert,
              color: Colors.black26,
              size: 40,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), //color of shadow
                        spreadRadius: 1, //spread radius
                        blurRadius: 1, // blur radius
                        offset: Offset(0, 1), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      ),
                      //you can set more BoxShadow() here
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Easy Math with HiMath",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            height: screenHeight / 3.5,
                            width: screenWidth,
                            child: SvgPicture.asset(
                              'assets/2D-polar.svg',
                              color: Colors.greenAccent,
                            )),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subjects",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          Text(
                            "See All",
                            style: TextStyle(
                              color: Colors.black26,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      height: 80,
                      child: _buildSubject(),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Contents",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          Text(
                            "See All",
                            style: TextStyle(
                              color: Colors.black26,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: 80,
                  child: _buildContent(),
                ),
                _buildFeed(),
              ],
            ),
          ),
        ));
  }

  Widget _buildSubject() {
    return BlocBuilder<SubjectCubit, SubjectState>(
      builder: (context, state) {
        if (state is SubjectLoaded) {
          if (state.subjects.isNotEmpty) {
            return SizedBox(
              height: 80,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.subjects.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        BlocProvider.of<ContentCubit>(context)
                            .getContents(state.subjects[index].subjectId);
                      },
                      onDoubleTap: () {
                        Navigator.pushNamed(context, PageConst.contentScreen,
                            arguments: state.subjects[index]);
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              top: 5, right: 5, left: 5, bottom: 10),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Color(state.subjects[index].color)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                state.subjects[index].name,
                                style: TextStyle(
                                    color: Color(state.subjects[index].color),
                                    fontWeight: FontWeight.w100,
                                    fontSize: 15),
                              ),
                            ],
                          )),
                    );
                  }),
            );
          }
        }
        if (state is SubjectFailure) {
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

  Widget _buildContent() {
    return BlocBuilder<ContentCubit, ContentState>(
      builder: (context, state) {
        if (state is ContentLoaded) {
          if (state.contents.isNotEmpty) {
            return SizedBox(
              height: 80,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: state.contents.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        BlocProvider.of<QuestionCubit>(context).getQuestions(
                            state.contents[index].subjectID,
                            state.contents[index].contentID);
                      },
                      onDoubleTap: () {
                        Navigator.pushNamed(context, PageConst.contentScreen,
                            arguments: state.contents[index]);
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              top: 5, right: 5, left: 5, bottom: 10),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                state.contents[index].name,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 15),
                              ),
                            ],
                          )),
                    );
                  }),
            );
          } else {
            return Container();
          }
        }
        if (state is SubjectFailure) {
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

  Widget _buildFeed() {
    return BlocBuilder<QuestionCubit, QuestionState>(
      builder: (context, state) {
        if (state is QuestionLoaded) {
          if (state.questions.isNotEmpty) {
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
                      contentName: "",
                      scaffoldState: _scaffoldState,
                      context: context,
                      state: state,
                      index: index);
                });
          }
          return Container();
        }
        if (state is QuestionFailure) {
          return Text("Failed");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
