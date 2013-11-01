//
//  cShape.h
//  CutAndGo
//
//  Created by Hua Dong on 13-09-18.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cBall.h"
#import "cLine.h"
@interface cShape : CCNode {
    NSMutableArray* lines;
    NSMutableArray* points;
    NSMutableArray* interPoints;
    NSMutableArray* tempPoints;
    CCLayer* upLayer;
    CGPoint center;
    BOOL centerLeft;
}

+(id) makeShapeWith:(NSArray*) points layer:(CCLayer*) layer;
-(id) initShapeWith:(NSArray*) points layer:(CCLayer*) layer;
-(BOOL) interWithBall:(cBall*) b;
-(void) interWithLine:(cLine*) line;
-(void) reshape;
-(void) cleanShape;
-(int) getLineNumber;
-(cLine*) getLineIn:(int) n;
-(void) rebulidWith:(NSMutableArray*) ps;
@end
