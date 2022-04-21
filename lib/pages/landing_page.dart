import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nodblix/defaults.dart';
import 'package:url_launcher/url_launcher.dart';

import '../styles.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _launchNodblixSourcePage() async {
    if (!await launch(GITHUB_URL)) throw 'Could not launch $GITHUB_URL';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 50.0,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: _launchNodblixSourcePage,
            splashRadius: 20.0,
            tooltip: 'Nodblix Source',
            hoverColor: NodblixStyles.primaryColor,
            icon: const Icon(FontAwesomeIcons.github),
          ),
          const SizedBox(width: 5.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/app_logo_transparent.png',
                  width: 300,
                ),
              ),
              const SizedBox(height: 45.0),
              SizedBox(
                width: 800.0,
                child: SelectableText(
                  'Nodblix provides patterns of diagnosis and treatment that point to potential off label usage of drugs based on various healthcare data.',
                  style: Theme.of(context).primaryTextTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 45.0),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.of(context).pushNamed('/playground');
                },
                style: NodblixStyles.buttonStyle,
                icon: Icon(
                  FontAwesomeIcons.diagramProject,
                  color: Colors.grey[800],
                ),
                label: Text(
                  ' Explore Nodblix',
                  style:
                      Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                ),
              ),
              const SizedBox(height: 45.0),
              Wrap(
                spacing: 50.0,
                runSpacing: 18.0,
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                children: const [
                  FeatureCard(
                    cardHeader: 'Explore by Condition',
                    cardDescription:
                        'Discover patterns of a medical condition treaded by numerous off label usage of drugs',
                    imagePath: 'assets/by_condition.png',
                  ),
                  FeatureCard(
                    cardHeader: 'Explore by Drug',
                    cardDescription:
                        'Discover off label usage of drugs to treat many medical conditions effectively',
                    imagePath: 'assets/by_drug.png',
                  ),
                  FeatureCard(
                    cardHeader: 'Explore by Trial & More',
                    cardDescription:
                        'Discover patterns of how each trials were conducted and associated results',
                    imagePath: 'assets/by_trial.png',
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              SizedBox(
                width: 800.0,
                child: SelectableText(
                  'MEDICAL ADVICE DISCLAIMER: THIS WEBSITE DOES NOT PROVIDE ANY MEDICAL ADVICE. The information, including but not limited to, text, graphics, images and other material contained on this website are for informational purposes only. No material on this site is intended to be a substitute for professional medical advice, diagnosis or treatment. Always seek the advice of your physician or other qualified health care provider with any questions you may have regarding a medical condition or treatment and before undertaking a new health care regimen, and never disregard professional medical advice or delay in seeking it because of something you have read on this website.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard(
      {Key? key,
      required this.cardHeader,
      required this.imagePath,
      required this.cardDescription})
      : super(key: key);
  final String cardHeader;
  final String cardDescription;
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 30.0,
          ),
          child: Column(
            children: [
              SelectableText(
                cardHeader,
                style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SelectableText(
                  cardDescription,
                  style:
                      Theme.of(context).primaryTextTheme.titleSmall!.copyWith(
                            color: NodblixStyles.primaryColor,
                          ),
                  textAlign: TextAlign.center,
                ),
              ),
              Image.asset(
                imagePath.isEmpty
                    ? 'assets/app_logo_transparent.png'
                    : imagePath,
                height: 250.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
