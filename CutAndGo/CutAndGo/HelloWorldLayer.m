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
    
    
    
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    currentLine.startPoint = [touch locationInView: [touch view]];
    currentLine.startPoint = [[CCDirector sharedDirector] convertToGL: currentLine.startPoint];
    currentLine.endPoint = currentLine.startPoint;
    //NSLog(@"startPoint.x %f startPoint.y %f", currentLine.startPoint.x, currentLine.startPoint.y);
    [currentLine draw];
    
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    currentLine.endPoint = [touch locationInView:[touch view]];
    currentLine.endPoint = [[CCDirector sharedDirector]convertToGL:currentLine.endPoint];
    [currentLine draw];
    /*
     NSLog(@"endpoint.x %f endpoint.y %f", currentLine.endPoint.x, currentLine.endPoint.y);
     NSLog(@"startPoint.x %f startPoint.y %f", currentLine.startPoint.x, currentLine.startPoint.y);*/
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    currentLine.endPoint = [touch locationInView:[touch view]];
    currentLine.endPoint = [[CCDirector sharedDirector]convertToGL:currentLine.endPoint];
    [currentLine draw];
    if(shape != NULL){
        [shape interWithBall:ball];
        if(currentLine != NULL && ![currentLine interWithBall:ball]){
            [shape interWithLine:currentLine];
        }
        [shape reshape];
        [shape reshape];
    }
    /*
     if([currentLine interWithBall:ball]){
     if(lifes > 1){
     lifes--;
     [scoreLabel setString:[NSString stringWithFormat:@"%d",lifes]];
     }
     currentLine.endPoint = currentLine.startPoint;
     }
     
     currentLine.endPoint = currentLine.startPoint;*/
    
    currentLine.endPoint = currentLine.startPoint;
    
    
}

-(void) update:(ccTime) dt{
    if(currentLine != NULL){
        
        if([currentLine interWithBall:ball]){
            currentLine.endPoint = currentLine.startPoint;
            [currentLine draw];
            if(lifes > 1){
                lifes--;
                [scoreLabel setString:[NSString stringWithFormat:@"%d",lifes]];
            }
        }
        
    }
    
    if(shape != NULL){
        if([shape interWithBall:ball]){
            return;
        }
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
    NSLog(@"%f",area);
    
    
}

-(void) stopGame{
    [self unscheduleUpdate];
    [ball unscheduleUpdate];
    self.isTouchEnabled = NO;
    
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
