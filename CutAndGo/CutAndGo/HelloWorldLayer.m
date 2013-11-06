//
//  HelloWorldLayer.m
//  CutAndGo
//
//  Created by Hua Dong on 13-09-18.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "cBall.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "cLine.h"
#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init]) ) {
        
        size = [[CCDirector sharedDirector] winSize];
        [self initLabels];
        [self initMenu];
        [self initBack];
        /*
         prefs = [NSUserDefaults standardUserDefaults];
         NSDictionary* user = [prefs objectForKey:@"currentUser"];
         if(user == NULL){
         user = [[NSDictionary alloc] init];
         [prefs setObject:user forKey:@"currentUser"];
         [prefs synchronize];
         }
         NSMutableDictionary* u = [NSMutableDictionary dictionaryWithDictionary:user];*/
        lifes = 3;
        
        ball = [cBall makeBallWithRad:10 atPos:CGPointMake(size.width/2, size.height/2)];
        [self addChild:ball z:3];
		self.isTouchEnabled = YES;
        currentLine = [[cLine alloc]init];
        currentLine.lineType = 2;
        [self addChild:currentLine z:3];
        pointArray = [[NSMutableArray alloc] init];
        CGPoint p1 = CGPointMake(size.width/2- 50, size.height/2+50);
        [pointArray addObject:[NSValue valueWithCGPoint:p1]];
        CGPoint p2 = CGPointMake(size.width/2+ 50,size.height/2+50);
        [pointArray addObject:[NSValue valueWithCGPoint:p2]];
        CGPoint p3 = CGPointMake(size.width/2+ 50,size.height/2-50);
        [pointArray addObject:[NSValue valueWithCGPoint:p3]];
        CGPoint p4 = CGPointMake(size.width/2- 50,size.height/2-50);
        [pointArray addObject:[NSValue valueWithCGPoint:p4]];
        shape = [cShape makeShapeWith:pointArray layer:self];
        [self addChild:shape z:3];
        
        [self scheduleUpdate];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects

-(void) initBack{
    CCSprite* back = [CCSprite spriteWithFile:@"back.jpg"];
    back.scaleX = size.width/back.contentSize.width;
    back.scaleY = size.height/back.contentSize.height;
    back.anchorPoint = ccp(0,0);
    [self addChild:back z:1];
}

-(void) initLabels{
    CCLabelTTF* l1 = [CCLabelTTF labelWithString:@"Life: " fontName:@"Marker Felt" fontSize:25];
    l1.position = ccp(size.width - 75, size.height - 50);
    [self addChild:l1 z:3];
    
    lifeLabel = [CCLabelTTF labelWithString:@"3" fontName:@"Marker Felt" fontSize:25];
    lifeLabel.position = ccp(size.width - 30, size.height - 50);
    [self addChild:lifeLabel z:3];
    
    CCLabelTTF* l2 = [CCLabelTTF labelWithString:@"Score: " fontName:@"Marker Felt" fontSize:25];
    l2.position = ccp(75, size.height - 50);
    [self addChild:l2 z:3];
    
    scoreLabel = [CCLabelTTF labelWithString:@"0"fontName:@"Marker Felt" fontSize:25];
    scoreLabel.position = ccp(125,size.height - 50);
    [self addChild:scoreLabel z:3];
    
    infoLabel = [CCLabelTTF labelWithString:@"info label" fontName:@"Marker Felt" fontSize:25];
    infoLabel.position = ccp(size.width/2, size.height/2 + 50);
    infoLabel.visible = NO;
    [self addChild:infoLabel z:3];
    
    
}

-(void) initMenu{
    [CCMenuItemFont setFontSize:20];
    CCMenuItem* reGame = [CCMenuItemFont itemWithString:@"Try Again" target:self selector:@selector(reGame:)];
    buttonMenu = [CCMenu menuWithItems:reGame, nil];
    buttonMenu.position = ccp(infoLabel.position.x, infoLabel.position.y - 50);
    buttonMenu.visible = NO;
    [self addChild:buttonMenu z:3];
}

-(void) reGame:(id) sender{
    lifes = 3;
    infoLabel.visible = NO;
    NSLog(@"point array %d",[pointArray count]);
    [shape rebulidWith:pointArray];
    [self removeChild:ball cleanup:YES];
    [ball release];
    ball = [cBall makeBallWithRad:10 atPos:CGPointMake(size.width/2, size.height/2)];
    [self addChild:ball z:3];
    buttonMenu.visible = NO;
    [self scheduleUpdate];
    self.isTouchEnabled = YES;
    
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if(currentLine == NULL){
        currentLine = [[cLine alloc] init];
        [self addChild:currentLine z:3];
    }
    currentLine.startPoint = [touch locationInView: [touch view]];
    currentLine.startPoint = [[CCDirector sharedDirector] convertToGL: currentLine.startPoint];
    currentLine.endPoint = currentLine.startPoint;

    [currentLine draw];
    
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if(currentLine != NULL){
        currentLine.endPoint = [touch locationInView:[touch view]];
        currentLine.endPoint = [[CCDirector sharedDirector]convertToGL:currentLine.endPoint];
        if([currentLine interWithBall:ball]){
            [self removeChild:currentLine cleanup:YES];
            [currentLine release];
            currentLine = NULL;
            lifes--;
        }else{
            [currentLine draw];
        }
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if([currentLine interWithBall:ball]){
        [currentLine release];
        currentLine = NULL;
        [self removeChild:currentLine cleanup:YES];
        lifes --;
    }
    if(currentLine != NULL){
        currentLine.endPoint = [touch locationInView:[touch view]];
        currentLine.endPoint = [[CCDirector sharedDirector]convertToGL:currentLine.endPoint];
        [currentLine draw];
        if(shape != NULL){
            [shape interWithBall:ball];
            if(currentLine != NULL && ![currentLine interWithBall:ball]){
                [shape interWithLine:currentLine];
            }
            [shape reshape];
        }
        currentLine.endPoint = currentLine.startPoint;
    }
    
    
    
    
}

-(void) update:(ccTime) dt{
    
    [lifeLabel setString:[NSString stringWithFormat:@"%d",lifes]];
    
    
    if(lifes < 0){
        [lifeLabel setString:[NSString stringWithFormat:@"0"]];
        [self stopGame];
        [self checkForLose];
        
    }
    
    if(shape != NULL){
        if([shape interWithBall:ball]){
            return;
        }
    }
    
    if (![self checkPoint:[ball getCenter] insideShape:shape]){
        [self stopGame];
        [self checkForLose];
    }
    
    if([self checkForWin]){
        [self stopGame];
        [self calScore];
    }
    
    
}

-(void) calScore{
    double s = 0;
    double area = 0;
    for(int n = 0; n < [shape getLineNumber]; n++){
        cLine* l = [shape getLineIn:n];
        if([l getLength] > 1){
            s+=[l getLength];
        }
    }
    s = s/2;
    double a = 1;
    for(int n = 0; n < [shape getLineNumber]; n++){
        cLine* l = [shape getLineIn:n];
        if([l getLength] > 1){
            a*= (s - [l getLength]);
        }
    }
    area = sqrt(a);
}

-(void) stopGame{
    [self unscheduleUpdate];
    [ball unscheduleUpdate];
    self.isTouchEnabled = NO;
    buttonMenu.visible = YES;
    
}

-(void) checkForLose{
    [infoLabel setString:@"You Lose"];
    infoLabel.visible = YES;
}


-(BOOL) checkForWin{
    if([shape getLineNumber] == 3){
        return YES;
    }else{
        int rest = [shape getLineNumber] - 3;
        int restCount = 0;
        for(int i = 0;i < [shape getLineNumber]; i++){
            cLine* l = [shape getLineIn:i];
            if([l getLength] < 1){
                restCount++;
                if(rest == restCount){
                    return YES;
                }
            }
        }
        restCount = 0;
    }
    return NO;
}

-(BOOL) checkPoint:(CGPoint) point insideShape:(cShape*) s{
    double angle = 0;
    for(int n = 0; n < [s getPointNumber]-1; n++){
        CGPoint p1 = ccp([s getPoint:n].x - point.x, [s getPoint:n].y - point.y);
        CGPoint p2 = ccp([s getPoint:n+1].x - point.x, [s getPoint:n+1].y - point.y);
        angle += [self findAngle:p1 point2:p2];
    }
    
    if(angle < 0){
        angle = -angle;
    }
    if (angle < M_PI) {
        return false;
    }else{
        return true;
    }
}


-(double) findAngle:(CGPoint) p1 point2:(CGPoint) p2{
    double dtheta, theta1, theta2;
    theta1 = atan2(p1.y, p1.x);
    theta2 = atan2(p2.y, p2.x);
    dtheta = theta2 - theta1;
    while (dtheta > M_PI) {
        dtheta -= 2 * M_PI;
    }
    while (dtheta <-M_PI) {
        dtheta += 2 * M_PI;
    }
    return dtheta;
}


- (void) dealloc
{
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
