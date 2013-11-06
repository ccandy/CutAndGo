//
//  cLine.m
//  CutAndGo
//
//  Created by Hua Dong on 13-09-18.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cLine.h"
#import "cBall.h"

@implementation cLine
@synthesize startPoint;
@synthesize endPoint;
@synthesize inter;
@synthesize interPoint;
@synthesize lineType;
+(id) makeLineWithSp:(CGPoint)sp andEndPoint:(CGPoint)ep{
    return [[self alloc] initLineWithSp:sp andEndPoint:ep];
}


-(id) initLineWithSp:(CGPoint)sp andEndPoint:(CGPoint)ep{
    if(self = [super init]){
        startPoint = sp;
        endPoint = ep;
        normal = CGPointMake((ep.y - sp.y), -(ep.x - sp.x));
    }
    return self;
}

-(id) init{
    if(self = [super init]){
        
    }
    return self;
}

-(void) draw{
    glLineWidth(1.0f);
    ccDrawLine(startPoint, endPoint);
}

-(BOOL) interWithBall:(cBall*)ball{
    double distance = [self findDistance:ball];
    if(distance <=ball.radius){
        if(lineType == 1){
            double bl = [self lenght:ball.speed];
            double nl = [self lenght:normal];
    
            CGPoint normalBS = CGPointMake(ball.speed.x/bl, ball.speed.y/bl);
            CGPoint normaln = CGPointMake(normal.x/nl, normal.y/nl);
        
            double dot = (normalBS.x * normaln.x + normalBS.y * normaln.y);
        
            CGPoint normaln1 = CGPointMake(normaln.x*dot * -2, normaln.y * dot*-2);
            CGPoint R = ccpAdd(normaln1, normalBS);
            R = CGPointMake(R.x * bl, R.y * bl);
            ball.speed = R;
        }
        return true;
    }
    return false;
    /*
    double distance = [self findDistance:ball];
    
    return (distance <= ball.radius);
     */
}


-(BOOL) interWithLine:(cLine*) line{

    double s1_x = endPoint.x - startPoint.x;
    double s1_y = endPoint.y - startPoint.y;
    
    double s2_x = line.endPoint.x - line.startPoint.x;
    double s2_y = line.endPoint.y - line.startPoint.y;
    
    double f = (-s2_x * s1_y + s1_x * s2_y);
    double s = (-s1_y * (startPoint.x - line.startPoint.x) + s1_x *(startPoint.y - line.startPoint.y))/f;
    double t = (s2_x * (startPoint.y - line.startPoint.y) - s2_y * (startPoint.x - line.startPoint.x))/f;
    if(s >= 0 && s<= 1 && t >= 0 && t<=1){
        interPoint = ccp((startPoint.x +(t*s1_x)),(startPoint.y + (t * s1_y)));
        inter = YES;
        return true;
    }
    return false;
    
}

-(CGPoint) getInterPoint{
    return interPoint;
}

-(double) findDistance:(cBall*) ball{
 
    double px = endPoint.x - startPoint.x;
    double py = endPoint.y - startPoint.y;
    
    double f = px*px + py*py;
    CGPoint center = [ball getCenter];
    double u = ((center.x - startPoint.x)*px +(center.y - startPoint.y)*py )/f;
    if( u > 1){
        u = 1;
    }else if(u <= 0){
        u = 0;
    }
    
    double x = startPoint.x + u*px;
    double y = startPoint.y + u*py;
    
    double dx = x - center.x;
    double dy = y - center.y;
    
    return sqrt(dx*dx + dy*dy);
    
}


-(BOOL) checkPoint:(CGPoint) p withBall:(cBall*) b{
    CGPoint center = [b getCenter];
    double dx = center.x - p.x;
    double dy = center.y - p.y;
    double dis = sqrt(dx*dx + dy*dy);
    return (dis <= b.radius);
}



-(double) getSlope{
    double s1 = endPoint.x - startPoint.x;
    if(s1 == 0){
        return -1;
    }
    double s2 = endPoint.y - startPoint.y;
    return s2/s1;
}

-(double) lenght:(CGPoint) p{
    return sqrt(p.x * p.x + p.y * p.y);
}

-(double) getLength{
    return sqrt(pow(startPoint.x - endPoint.x,2) + pow(startPoint.y - endPoint.y,2));
}

@end
