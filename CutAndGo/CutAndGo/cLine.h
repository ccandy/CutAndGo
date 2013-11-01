//
//  cLine.h
//  CutAndGo
//
//  Created by Hua Dong on 13-09-18.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cBall.h"
@interface cLine : CCNode {
    CGPoint startPoint;
    CGPoint endPoint;
    CGPoint normal;
    
}

@property (assign) CGPoint startPoint;
@property (assign) CGPoint endPoint;
@property (assign) CGPoint interPoint;
@property (assign) BOOL inter;
@property (assign) int lineType;
+(id) makeLineWithSp:(CGPoint) sp andEndPoint:(CGPoint) ep;
-(id) initLineWithSp:(CGPoint) sp andEndPoint:(CGPoint) ep;
-(BOOL) interWithBall:(cBall*)ball;
-(BOOL) interWithLine:(cLine*) line;
-(CGPoint) getInterPoint;
-(double) getLength;
@end
