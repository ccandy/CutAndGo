//
//  openView.h
//  CutAndGo
//
//  Created by Hua Dong on 11/5/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cBall.h"
#import "cShape.h"
@interface openView : CCLayer {
    CGSize size;
    CCMenu* gameMenu;
    cBall* ball;
    cShape* shape;
    NSUserDefaults* perfs;
}

+(CCScene*) scene;

@end
