import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> question = [
      "1. What the heck even is this website?",
      "2. Can I submit more than one piece?",
      "3. Can I pay for credits without a monthly plan?",
      "4. How can I sign up as a blog?",
      "5. Do I have to pay to use Share Yourself Artists?",
      "6. How can I sign up my blog/magazine/publication?",
      "7. What is the difference between standard and premium credits?",
      "8. If I want to use premium credits, how much do they cost?",
      "9. Where does the money go?",
      "10. Does using Share Yourself Artists guarantee I will get on blogs?",
      "11. I've got credits. Now what?",
      "12. How do blogs get paid?",
      "13. What is Share Yourself Artists's Refund Policy",
    ];

    List<String> answer = [
      "Share Yourself Artists is a community of the best internet artists and "
          "publications. Artists save tons of time and are exposed to new resources "
          "of exposure for less. For less than 2 quarters presubmission, artists "
          "can easily submit their artwork to, and possibly be featured on, the "
          "largest blogs in the art community. By purchasing a credit, the artists "
          "is entitled to feedback, critiques, or appraisals from the publication. "
          "Share Yourself Artists also offers hardworking bloggers and publications "
          "to receive an income for sharing incredible artwork.",
      "Yes you may! Our user interface allows artists to upload as many pieces as "
          "their hearts may possibly desire. Credits can be used on any and all "
          "of artists's works.",
      "Yes you may! Our one time purchase deal is 8 credits for \$5.",
      "Blog Signup Options can be found with the Artist Sign-up. You will then "
          "be directed to upload and description page where you can set up your "
          "Publication Account. PLEASE NOTE: There is a 25,000 follower minimum "
          "for blogs/magazines.",
      "Nope. Standard credits are completely free.",
      "Head to www.shareyourselfartists.com/business_signup for more information!",
      "Credits are used to send your song to a blog. There are two types: standard "
          "and premium.When you use a premium credit, your submission filters to "
          "the top of that blog's dashboard. The blog you send to then has to: 1) "
          "respond within 48 hours (96 hours for labels); 2) listen to at least 20 "
          "seconds; 3) approve the song, or provide a minimum of 10 words explaining "
          "why it was not a good fit.If they do not satisfy these requirements, "
          "you get your credit back to be used again.Premium credits tend to have "
          "a higher approval rate because blogs are encouraged to spend time with "
          "the song, rather than making a split-second decision.With standard "
          "credits, there are no such requirements: a blog can choose to provide "
          "feedback if they wish, but may instead make a quick decision and move "
          "onto the next song. You receive two standard credits every four hours, "
          "and should see a countdown on the submit page that indicates when they "
          "will refresh.",
      "Premium credits start at about 65-70 cents per credit. When buying a "
          "monthly credit package, however, credits are as low as 40 cents per credit.",
      "The majority of money from premium purchases goes to the blogs. The rest "
          "goes toward transaction fees, hosting fees, and salaries so that we can "
          "keep making Share Yourself Artists better.",
      "I'm afraid not. SYA’s mission is to connect blogs with people who want their "
          "work promoted. We make the process transparent, and work to improve "
          "the chances that you'll actually hear back after sending your masterpiece "
          "out. That said, we cannot force a blog to share your submission. "
          "That's entirely up to them :)",
      "Select the upload icon from the top of your dashboard... Once there, you'll be able to add "
          "a new art piece, or select one you've already uploaded. After you've "
          "done that, you can then select the type of credit you'd like to use, "
          "and choose the blogs you want to send your art to.",
      "Blogs get paid at least \$0.15 per response given. Larger and more active "
          "publications will be given an increased rate all the way up to \$0.50 "
          "per submission(will likely increase in the future). Blogs are required "
          "to write a 50 character response to each photo. A blog could easily "
          "respond to 100 submissions per hour, earning them a wage of \$15/per hour. "
          "With these calculations the largest blogs can make up to \$50/per hour.",
      "Although all credit purchases are final, each artist will be refunded each "
          "credit for any blog that does not respond or comment on their submission. "
          "Share Yourself Artists wants to help artists get seen by large players "
          "in the art industry, not make artists pay to be ignored."
    ];

    var _children = <Widget>[
      Padding(
        padding: EdgeInsets.all(20.0),
      ),
      Center(
        child: new Text(
          'Support/FAQs',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 40.0, color: Color.fromRGBO(255, 160, 0, 1.0)),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(20.0),
      ),
    ];

    // Add questions to the rest of the children
    for (var i = 0; i < question.length; i++) {
      _children.add(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(question[i]),
            subtitle: Text(answer[i]),
          ),
          Divider(
            height: 5.0,
          )
        ],
      ));
    }

    return new Scaffold(
      appBar: AppBar(
        title: new Image.asset('images/logo.png'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(children: _children),
          ],
        ),
      ),
    );
  }
}
