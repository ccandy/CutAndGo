//
//  HelloWorldLayer.h
//  CutAndGo
//
//  Created by Hua Dong on 13-09-18.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "cLine.h"
#import "cShape.h"
#import "cBall.h"
// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CGPoint startPoint;
    CGPoint endPoint;
    cLine* currentLine;
    NSMutableArray* pointArray;
    cBall* ball;
    cShape* shape;
    NSUserDefaults* prefs;
    int lifes;
    int score;
    CGSize size;
    CCLabelTTF* scoreLabel;
    CCLabelTTF* lifeLabel;
    CCLabelTTF* infoLabel;
    BOOL touchBall;
    CCMenu* buttonMenu;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
