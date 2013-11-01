//
//  cBall.m
//  CutAndGo
//
//  Created by Hua Dong on 13-09-18.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cBall.h"


@implementation cBall
@synthesize speed,radius;
+(id) makeBallWithRad:(int)rad atPos:(CGPoint)pos{
    return [[self alloc] initBallWithRad:rad atPos:pos];
}

-(id) initBallWithRad:(int)rad atPos:(CGPoint)pos{
    if(self = [super init]){
        radius = rad;
        position = pos;
        speed.x = 0.1;
        speed.y = 0.2;

        [self scheduleUpdate];
    }
    return self;
}

-(void) draw{
    ccDrawCircle(position, radius, 360, 30, false);
}

-(void) update:(ccTime) dt{
    position = ccp(position.x +speed.x, position.y + speed.y);
}

-(void) setUpSpeed:(CGPoint)p{
    speed.x = p.x;
    speed.y = p.y;
}

-(CGPoint) getCenter{
    return position;
}

@end
