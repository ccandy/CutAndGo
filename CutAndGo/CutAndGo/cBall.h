//
//  cBall.h
//  CutAndGo
//
//  Created by Hua Dong on 13-09-18.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface cBall : CCNode {
    int radius;
    CGPoint position;
    CGPoint speed;
}
@property(assign) int radius;
@property(assign) CGPoint speed;
+(id) makeBallWithRad:(int) rad atPos:(CGPoint) pos;
-(id) initBallWithRad:(int) rad atPos:(CGPoint) pos;
-(CGPoint) getCenter;
-(void) setUpSpeed:(CGPoint) p;

@end
