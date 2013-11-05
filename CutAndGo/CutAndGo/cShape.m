//
//  cShape.m
//  CutAndGo
//
//  Created by Hua Dong on 13-09-18.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cShape.h"
#import "cLine.h"
#import "cBall.h"
@implementation cShape

+(id) makeShapeWith:(NSArray *)ps layer:(CCLayer*) layer{
    return [[self alloc] initShapeWith:ps layer:layer];
}

-(id) initShapeWith:(NSMutableArray *)ps layer:(CCLayer*) layer{
    if(self = [super init]){
        points = [[NSMutableArray alloc] init];
        for(int n = 0; n < [ps count]; n++){
            [points addObject:[ps objectAtIndex:n]];
        }
        tempPoints = [[NSMutableArray alloc] init];
        lines = [[NSMutableArray alloc] init];
        interPoints = [[NSMutableArray alloc] init];
        upLayer = layer;
        [self findCeneter];
        [self reshape];
               
    }
    return self;
}

-(BOOL) interWithBall:(cBall*) b{
    for(int n = 0; n < [lines count]; n++){
        cLine* l = [lines objectAtIndex:n];
        if([l interWithBall:b]){
            return true;
        }
    }
    return false;
}

-(void) interWithLine:(cLine *)line{
    for(int n = 0; n < [lines count]; n++){
        cLine* l = [lines objectAtIndex:n];
        if([l interWithLine:line]){
            [interPoints addObject:[NSValue valueWithCGPoint:[l getInterPoint]]];
        }
    }
    
}

-(void) cleanShape{
    [tempPoints removeAllObjects];
    for(int n = 0; n < [lines count]; n++){
        [upLayer removeChild:[lines objectAtIndex:n] cleanup:YES];
    }
    [lines removeAllObjects];
    //[interPoints removeAllObjects];
}

-(void) rebulidWith:(NSMutableArray *)ps{
    [self cleanShape];
    [points removeAllObjects];
    for(int n = 0; n < [ps count]; n++){
        [points addObject:[ps objectAtIndex:n]];
    }
    [self reshape];
}

-(void) reshape{
    [self cleanShape];
    if([interPoints count] >= 2 && [points count] > 0){
        cLine* interLine;
        for(int n = 0; n < [interPoints count]-1;n++){
            CGPoint p1 = [[interPoints objectAtIndex:n] CGPointValue];
            CGPoint p2 = [[interPoints objectAtIndex:n+1] CGPointValue];
            interLine = [cLine makeLineWithSp:p1 andEndPoint:p2];
            //[lines addObject:interLine];
            //[upLayer addChild:interLine z:3];
        }
        
        centerLeft = [self isLeft:interLine.startPoint pb:interLine.endPoint pc:center];
        for (int n = 0; n < [points count]; n++){
            CGPoint p = [[points objectAtIndex:n] CGPointValue];
            bool check = [self isLeft:interLine.startPoint pb:interLine.endPoint pc:p];
            
            if(check != centerLeft){
                /*
                if([interPoints count] > 0){

                    [points replaceObjectAtIndex:n withObject:[interPoints objectAtIndex:0]];
                    [interPoints removeObjectAtIndex:0];
                }*/
                [points removeObjectAtIndex:n];
                n--;
            }
            
        }
        for(int n = 0; n < [interPoints count];n++){
            [points addObject:[interPoints objectAtIndex:n]];
        }
    
    }
    [self sortPoints];
    for (int n = 0; n < [points count]-1; n++){
        CGPoint p1 = [[points objectAtIndex:n] CGPointValue];
        CGPoint p2 = [[points objectAtIndex:n+1] CGPointValue];
        cLine* l = [cLine makeLineWithSp:p1 andEndPoint:p2];
        l.lineType = 1;
        [lines addObject:l];
        [upLayer addChild:l z:3];
    }
    CGPoint p3 = [[points objectAtIndex:0] CGPointValue];
    CGPoint p4 = [[points objectAtIndex:[points count]-1] CGPointValue];
    cLine* l = [cLine makeLineWithSp:p3 andEndPoint:p4];
    l.lineType = 1;
    [lines addObject:l];
    [upLayer addChild:l z:3];
    
    [interPoints removeAllObjects];
    [self findCeneter];
}

-(void) findCeneter{
    CGPoint minPoint = CGPointMake(999, 999);
    CGPoint maxPoint = CGPointMake(0, 0);
    for(int n = 0; n< [points count]; n++){
        CGPoint tempPoint = [[points objectAtIndex:n] CGPointValue];
        if(tempPoint.x > maxPoint.x){
            maxPoint.x = tempPoint.x;
        }
        if(tempPoint.y > maxPoint.y){
            maxPoint.y = tempPoint.y;
        }
        
        if(tempPoint.x < minPoint.x){
            minPoint.x = tempPoint.x;
        }
        if(tempPoint.y < minPoint.y){
            minPoint.y = tempPoint.y;
        }
    }
    center = CGPointMake((maxPoint.x - minPoint.x)/2 + minPoint.x, (maxPoint.y - minPoint.y)/2 + minPoint.y);
}

-(BOOL) isLeft:(CGPoint) a pb:(CGPoint) b pc:(CGPoint) c{
    return (((b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x)) > 0);
}

-(void) sortPoints{
    int maxIndex = 0;
    for(int i = 0; i <[points count] - 1; i++){
        maxIndex = i;
        for(int j = i+1; j < [points count]; j++){
            CGPoint p1 = [[points objectAtIndex:maxIndex] CGPointValue];
            CGPoint p2 = [[points objectAtIndex:j] CGPointValue];
            if([self isLESS:p2 pointB:p1]){
                maxIndex = j;
            }
        }
        if([points count] > 0){
            NSValue* temp = [points objectAtIndex:maxIndex];
            CGPoint tempPoint = CGPointMake([temp CGPointValue].x, [temp CGPointValue].y);
            [points replaceObjectAtIndex:maxIndex withObject:[points objectAtIndex:i]];
            [points replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:tempPoint]];
        }
    }
}

-(BOOL) isLESS:(CGPoint) a pointB:(CGPoint) b{
        
    double dx1 = a.x - center.x;
    double dy1 = a.y - center.y;
    double angle1 = atan2(dy1,dx1);
    double dx2 = b.x - center.x;
    double dy2 = b.y - center.y;
    double angle2 = atan2(dy2,dx2);
    return (angle1 <= angle2);
}

-(int) getLineNumber{
    return [lines count];
}

-(cLine*) getLineIn:(int)n{
    return [lines objectAtIndex:n];
}

-(int) getPointNumber{
    return [points count];
}

-(CGPoint) getPoint:(int) n{
    return [[points objectAtIndex:n] CGPointValue];
}

@end
