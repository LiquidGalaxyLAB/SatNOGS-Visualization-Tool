import 'package:flutter/material.dart';
import 'package:satnogs_visualization_tool/utils/app.dart';
import 'package:satnogs_visualization_tool/utils/colors.dart';
import 'package:satnogs_visualization_tool/widgets/svt_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  /// Property that defines the project mentors names.
  final _mentors = [
    'Andreu Ibáñez Perales',
    'Karine A. Pistili Rodrigues',
    'Marc Gonzalez Capdevila',
    'Otávio J. França Oliveira'
  ];

  /// Property that defines the author email.
  final _authorEmail = 'michell.algarra@gmail.com';

  /// Property that defines the author GitHub profile name.
  final _authorGitHub = 'mchalgarra';

  /// Property that defines the author LinkedIn profile name.
  final _authorLinkedIn = 'mchalgarra';

  /// Property that defines the organization Instagram.
  final _orgInstagram = '_liquidgalaxy';

  /// Property that defines the organization Twitter.
  final _orgTwitter = '_liquidgalaxy';

  /// Property that defines the organization GitHub profile name.
  final _orgGitHub = 'LiquidGalaxyLAB';

  /// Property that defines the organization LinkedIn profile name.
  final _orgLinkedIn = 'google-summer-of-code---liquid-galaxy-project';

  /// Property that defines the organization website URL.
  final _orgWebsite = 'www.liquidgalaxy.eu';

  /// Opens the email app with the given [email] in it.
  void _sendEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  /// Opens the [account]'s GitHub profile.
  void _openGitHub(String account) async {
    final Uri ghLaunchUri = Uri.https('github.com', '/$account');

    if (await canLaunchUrl(ghLaunchUri)) {
      await launchUrl(ghLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  /// Opens the [account]'s LinkedIn profile.
  void _openLinkedIn(String account) async {
    final Uri liLaunchUri = Uri.https('linkedin.com', '/$account');

    if (await canLaunchUrl(liLaunchUri)) {
      await launchUrl(liLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  /// Opens the [account]'s Instagram profile.
  void _openInstagram(String account) async {
    final Uri liLaunchUri = Uri.https('instagram.com', '/$account');

    if (await canLaunchUrl(liLaunchUri)) {
      await launchUrl(liLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  /// Opens the [account]'s Twitter profile.
  void _openTwitter(String account) async {
    final Uri liLaunchUri = Uri.https('twitter.com', '/$account');

    if (await canLaunchUrl(liLaunchUri)) {
      await launchUrl(liLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  /// Opens the given [link].
  void _openLink(String link) async {
    final Uri liLaunchUri = Uri.parse(link);

    if (await canLaunchUrl(liLaunchUri)) {
      await launchUrl(liLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        shadowColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            splashRadius: 24,
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.info_outline_rounded),
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        Container(
                          height: 240,
                          width: 240,
                          decoration: BoxDecoration(
                            color: ThemeColors.logo,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(60),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: const Image(
                              image: AssetImage('assets/images/logo.png')),
                        ),
                        Text(
                          'SatNOGS Visualization Tool',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ThemeColors.logo,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: _defaultPadding(),
                    child: Column(
                      children: [
                        _buildSectionTitle('Author'),
                        const Text(
                          'Michell Algarra Barros',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 30,
                              icon: const Icon(
                                Icons.mail_rounded,
                                color: Colors.white,
                              ),
                              splashRadius: 24,
                              tooltip: _authorEmail,
                              onPressed: () {
                                _sendEmail(_authorEmail);
                              },
                            ),
                            IconButton(
                              iconSize: 30,
                              splashRadius: 24,
                              icon: const Icon(
                                SVT.github,
                                color: Colors.white,
                              ),
                              tooltip: _authorGitHub,
                              onPressed: () {
                                _openGitHub(_authorGitHub);
                              },
                            ),
                            IconButton(
                              iconSize: 30,
                              icon: const Icon(
                                SVT.linkedin_in,
                                color: Colors.white,
                              ),
                              splashRadius: 24,
                              tooltip: _authorLinkedIn,
                              onPressed: () {
                                _openLinkedIn('in/$_authorLinkedIn');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: _defaultPadding(),
                    child: Column(
                      children: [
                        _buildSectionTitle('Mentors'),
                        ..._mentors
                            .map(
                              (mentor) => Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    mentor,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: _defaultPadding(),
                    child: Column(children: [
                      _buildSectionTitle('Organization Contact/Social'),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 30,
                            icon: const Icon(
                              SVT.instagram,
                              color: Colors.white,
                            ),
                            splashRadius: 24,
                            tooltip: '@$_orgInstagram',
                            onPressed: () {
                              _openInstagram(_orgInstagram);
                            },
                          ),
                          IconButton(
                            iconSize: 30,
                            icon: const Icon(
                              SVT.twitter,
                              color: Colors.white,
                            ),
                            splashRadius: 24,
                            tooltip: '@$_orgTwitter',
                            onPressed: () {
                              _openTwitter(_orgTwitter);
                            },
                          ),
                          IconButton(
                            iconSize: 30,
                            splashRadius: 24,
                            icon: const Icon(
                              SVT.github,
                              color: Colors.white,
                            ),
                            tooltip: _orgGitHub,
                            onPressed: () {
                              _openGitHub(_orgGitHub);
                            },
                          ),
                          IconButton(
                            iconSize: 30,
                            icon: const Icon(
                              SVT.linkedin_in,
                              color: Colors.white,
                            ),
                            splashRadius: 24,
                            tooltip:
                                'Liquid Galaxy Project (Google Summer of Code)',
                            onPressed: () {
                              _openLinkedIn('company/$_orgLinkedIn');
                            },
                          ),
                          IconButton(
                            iconSize: 30,
                            icon: const Icon(
                              Icons.language_rounded,
                              color: Colors.white,
                            ),
                            splashRadius: 24,
                            tooltip: _orgWebsite,
                            onPressed: () {
                              _openLink('https://$_orgWebsite');
                            },
                          ),
                          IconButton(
                            iconSize: 24,
                            icon: const Icon(
                              SVT.google_play,
                              color: Colors.white,
                            ),
                            splashRadius: 24,
                            tooltip: 'Liquid Galaxy LAB',
                            onPressed: () {
                              _openLink(
                                  'https://play.google.com/store/apps/developer?id=Liquid+Galaxy+LAB');
                            },
                          ),
                        ],
                      ),
                    ]),
                  ),
                  Padding(
                    padding: _defaultPadding(),
                    child: Column(children: [
                      _buildSectionTitle('Logos'),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                          left: 32,
                          right: 32,
                        ),
                        padding: const EdgeInsets.all(16),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 5,
                            color: Colors.grey.shade600,
                          ),
                          color: Colors.white,
                        ),
                        child: const Image(
                            image: AssetImage('assets/images/logos.png')),
                      ),
                    ]),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 32, left: 20, right: 20),
                    child: Column(children: [
                      _buildSectionTitle('Project description'),
                      _buildDescriptionParagraph(
                          'SatNOGS Visualization Tool aims to collect and show data from satellites and ground stations using the SatNOGS database, the SatNOGS API and the Liquid Galaxy system.'),
                      _buildDescriptionParagraph(
                          'The data is visible into the app and also into the Google Earth (running on the Liquid Galaxy rig) as placemarks, polygons, balloons and more.'),
                      _buildDescriptionParagraph(
                          'It\'s possible to search and filter satellites/ground stations, synchronize the data between the application and the database, run some of the Liquid Galaxy system commands/tasks, check the orbit of satellites, play orbit tours and more.'),
                    ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 32, bottom: 16),
                    child: Text(
                      'Version ${App.version}',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the default padding top.
  EdgeInsets _defaultPadding() {
    return const EdgeInsets.only(top: 32);
  }

  /// Builds a [Text] that will be used to show the section [title].
  Text _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Builds a [Widget] that will be used to render a paragraph according to the
  /// given [text].
  Widget _buildDescriptionParagraph(String text) {
    const tab = '        ';

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        '$tab$text',
        textAlign: TextAlign.justify,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
