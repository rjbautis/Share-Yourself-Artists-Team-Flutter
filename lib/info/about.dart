import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget aboutUs = Container(
      child: new RichText(
        text: new TextSpan(
            text: 'ShareYourselfArtists.com ',
            style: new TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
            children: <TextSpan>[
              new TextSpan(
                  text: 'connects visual artists to the art pages and '
                      'sites that are making internet artists famous all around '
                      'the world. ',
                  style: new TextStyle(
                      fontWeight: FontWeight.normal
                  )
              ),
              new TextSpan(
                  text: 'Share Yourself Artists ',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                  )
              ),
              new TextSpan(
                text: 'makes the submission process simple and fun! We have helped '
                    'hundreds of artists get recognition for their artwork. We '
                    'are also the only submission platform that helps art pages '
                    'earn money for maintaining their blog. By using our site, '
                    'you are supporting the online arts industry!',
                style: new TextStyle(
                  fontWeight: FontWeight.normal,
                )
              )
            ]
        ),
        textAlign: TextAlign.justify,
      ),
    );

    Widget persons = Container(
      padding: EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        children: <Widget>[
          Text(
            'Nick McElmurry',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,

            ),
          ),
          Padding (
            padding: EdgeInsets.only(top:10.0),
          ),
          Text(
            '(Founder/Chief Executive Officer)',
            style: TextStyle(
              fontStyle: FontStyle.italic,
            )
          ),
          Padding (
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          Text(
            "Nick's business and marketing expertise derive from both his "
              "work experiences and his personal endeavors. He has worked as a "
              "marketing executive for companies including, but not limited to, "
              "Jamba Juice, Sunpower, and State Farm. Though his specialty is "
              "social media and internet marketing, for he has accumulated over "
              "100,000 followers across his personal project pages, Nick also "
              "has experience throwing and organizing events. He founded Battle "
              "of The Bay (Bands) in 2018, a competition including over 30 bands "
              "from 5 different cities. He also has a soft spot for the arts industry. "
              "He is a musician in many different bands, but is most known for his "
              "band Water Color Weekend.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16.0
            ),
          ),
          Padding (
            padding: EdgeInsets.all(20.0),
          ),
          Text(
            'Scott Davis',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding (
            padding: EdgeInsets.only(top:10.0),
          ),
          Text(
              '(Software Engineer)',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              )
          ),
          Padding (
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          Text(
            "Scott handles much of our development work and other stuff. As our "
                "Chief Creative/Developer, he's responsible for the overall work "
                "product of the company, overseeing our Design & Development. In "
                "the rare event that he's not working, he spends as much time "
                "as possible with his wife and his daughter. While he does occasionally "
                "get some sleep, it's usually when he passes out in his chair "
                "while working through the middle of the night.",
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontSize: 16.0
            ),
          )
        ],
      )
    );


    return new Scaffold(
      appBar: AppBar(
        title: new Image.asset('images/logo.png'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding (
                  padding: EdgeInsets.all(20.0),
                ),
                Center(
                  child: new Text(
                    'About Us',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 40.0,
                        color: Color.fromRGBO(255, 160, 0, 1.0)),
                  ),
                ),
                Padding (
                  padding: EdgeInsets.all(20.0),
                ),
                aboutUs,
                persons
              ],
            ),
          ],
        ),
      ),
    );
  }
}
