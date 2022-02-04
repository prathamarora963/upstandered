import 'package:flutter/material.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/user_avatar.dart';

class StartGroupChatScreen extends StatelessWidget {
  double startPoint = 30;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: MyTheme.secondryColor,
                ),
                onPressed: () {},
              ),
              Text(
                "GROUP CHAT",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
            ],
          )),
      body: Container(
        color: MyTheme.grey800,
        child: Stack(
          children: [
            InkWell(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height * 0.14,
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Positioned(
                            left: startPoint,
                            child: UserAvatarAsset(
                                asset:"assets/users/CrystalGaskell.png",
                                avatarRadius: size.height * 0.12),
                          ),
                          Positioned(
                            left: startPoint + 30,
                            child: UserAvatarAsset(
                                asset:"assets/users/CrystalGaskell.png",
                                    // "https://m.media-amazon.com/images/M/MV5BZDA1ODgyODEtOWI3Yy00N2UzLTk5ZGMtZGI1MzU5YzFkZDQ1XkEyXkFqcGdeQXVyMTc4MzI2NQ@@._V1_UY1200_CR285,0,630,1200_AL_.jpg",
                                avatarRadius: size.height * 0.12),
                          ),
                          Positioned(
                            left: startPoint + 60,
                            child: UserAvatarAsset(
                                asset:"assets/users/CrystalGaskell.png",
                                    // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhS1n9AgNPFrsPjj0fHqwPdIJPJLl9hXUq5Q&usqp=CAU",
                                avatarRadius: size.height * 0.12),
                          ),
                          Positioned(
                            left: startPoint + 90,
                            child: UserAvatarAsset(
                                asset:"assets/users/CrystalGaskell.png",
                                    // "https://img.mensxp.com/media/content/2020/Aug/Michele-Morrone-From-365-Days-Floored-Us-With-His-Fashion-Game-1200x900_5f2a761253b66_1200x900.jpeg",
                                avatarRadius: size.height * 0.12),
                          ),
                          Positioned(
                            left: startPoint + 120,
                            child: UserAvatarAsset(
                                asset:"assets/users/CrystalGaskell.png",
                                    // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS44UpSZW-GZwDVxU3763H9HPOWqdB6ThRAoQ&usqp=CAU",
                                avatarRadius: size.height * 0.12),
                          ),
                          Positioned(
                            left: startPoint + 150,
                            child: UserAvatarAsset(
                                asset:"assets/users/CrystalGaskell.png",
                                    // "https://img1.nickiswift.com/img/gallery/the-untold-truth-of-michele-morrone-from-365-days/intro-1593017194.jpg",
                                avatarRadius: size.height * 0.12),
                          ),
                          Positioned(
                            left: startPoint + 180,
                            child: UserAvatarAsset(
                                asset:"assets/users/CrystalGaskell.png",
                                    // "https://images2.minutemediacdn.com/image/upload/c_fill,w_720,ar_16:9,f_auto,q_auto,g_auto/shape/cover/sport/Bar-Giuseppe-Red-Carpet---14th-Rome-Film-Fest-2019-7de8f118ccdbce430f2d706463c8e09c.jpg",
                                avatarRadius: size.height * 0.12),
                          ),
                          Positioned(
                            left: startPoint + 210,
                            child: UserAvatarAsset(
                                asset:"assets/users/CrystalGaskell.png",
                                    // "https://stat2.bollywoodhungama.in/wp-content/uploads/2021/04/Netflixs-365-Days-breakout-star-Michele-Morrone-looks-sharp-on-the-cover-of-Elle-India-..jpg",
                                avatarRadius: size.height * 0.12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Text(
                      "START CHAT",
                      style: TextStyle(
                          color: MyTheme.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: size.height * 0.08,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: MyTheme.primaryColor,
                  ),
                  child: Text(
                    "CONTINUE",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
