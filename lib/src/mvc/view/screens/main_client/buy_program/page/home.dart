import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../controller/add_program/add_proram_cubit.dart';
import '../../../../../controller/add_program/add_proram_state.dart';
import '../../../../../controller/services.dart';
import '../../../../../model/models.dart';

import '../../../../model_widgets/button_screen.dart';
import '../../../../model_widgets/line_button_screen.dart';
import '../../../../screens.dart';

class HomeBuyProgram extends StatefulWidget {
  const HomeBuyProgram({Key? key}) : super(key: key);

  @override
  State<HomeBuyProgram> createState() => _HomePageState();
}

class _HomePageState extends State<HomeBuyProgram> {
  final PageController _pageController = PageController(initialPage: 0);

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => OrderBloc(),
      child: BlocConsumer<OrderBloc, ProramState>(
        listener: (context, state) {
          if (state is ErrorProgram) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error creating order'),
              ),
            );
          }
        },
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  customAppBar(context),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  customSliver(size),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      BlocBuilder<OrderBloc, ProramState>(
                        builder: (context, state) => ButtonInBording(
                          text: currentPage < onBordingList.length - 1
                              ? 'Next'
                              : 'Finish',
                          size: size,
                          onTap: () {
                            setState(() {
                              currentPage < onBordingList.length - 1
                                  ? nextPage()
                                  : finish();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      LineInscreen(size: size),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded customSliver(Size size) {
    return Expanded(
        child: PageView.builder(
      controller: _pageController,
      onPageChanged: (int page) {
        setState(() {
          currentPage++;
          currentPage = page;
        });
      },
      itemCount: onBordingList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Text(
              onBordingList[index].titleone!,
              style: AppStyles.titleone,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              onBordingList[index].title2!,
              style: AppStyles.titletwo,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: onBordingList[index].body!,
              ),
            ),
          ],
        );
      },
    ));
  }

  Row customAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          padding: const EdgeInsets.only(left: 20),
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: previousPage,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(20),
                value: (currentPage + 1) / onBordingList.length,
                backgroundColor: Colors.grey,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width *
                0.12, // Set the desired width
            child: Text(
              '${currentPage + 1} /7',
              style: AppStyles.textStyle16,
            )),
      ],
    );
  }

  void previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void nextPage() {
    currentPage++;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void finish() {
    context.read<OrderBloc>().creatorderProgram();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SplashPayment()),
    );
  }
}
