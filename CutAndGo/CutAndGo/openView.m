//
//  openView.m
//  CutAndGo
//
//  Created by Hua Dong on 11/5/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "openView.h"
#import "HelloWorldLayer.h"

@implementation openView

+(CCScene*) scene{
    
    CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	openView *layer = [openView node];
    // add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
    
}

-(id) init{
    
    if(self = [super init]){
        size = [[CCDirector sharedDirector] winSize];
        [self initLabel];
        [self initMenu];
        ball = [cBall makeBallWithRad:10 atPos:ccp(size.width/2,size.height/2)];
        NSMutableArray* pointArray = [[NSMutableArray alloc] init];
        CGPoint p1 = CGPointMake(size.width/2- 50, size.height/2+50);
        [pointArray addObject:[NSValue valueWithCGPoint:p1]];
        CGPoint p2 = CGPointMake(size.width/2+ 50,size.height/2+50);
        [pointArray addObject:[NSValue valueWithCGPoint:p2]];
        CGPoint p3 = CGPointMake(size.width/2+ 50,size.height/2-50);
        [pointArray addObject:[NSValue valueWithCGPoint:p3]];
        CGPoint p4 = CGPointMake(size.width/2- 50,size.height/2-50);
        [pointArray addObject:[NSValue valueWithCGPoint:p4]];
        shape = [cShape makeShapeWith:pointArray layer:self];
        [self addChild:ball z:3];
        [self scheduleUpdate];
    }
    return self;    
}


-(void) initLabel{
    CCLabelTTF* title = [CCLabelTTF labelWithString:@"Cut And Go" fontName:@"TimesNewRomanPSMT" fontSize:30];
    title.position = ccp(size.width/2, size.height - 50);
    [self addChild:title z:3];
}

-(void) initMenu{
    [CCMenuItemFont setFontName:@"TimesNewRomanPSMT"];
    [CCMenuItemFont setFontSize:20];
    CCMenuItem* newGame = [CCMenuItemFont itemWithString:@"Lets Play" target:self selector:@selector(newGame:)];
    CCMenuItem* gameCredit = [CCMenuItemFont itemWithString:@"Credit" target:self selector:@selector(gameCredit:)];
    CCMenuItem* gameHow = [CCMenuItemFont itemWithString:@"How to Play" target:self selector:@selector(gameHow:)];
    gameMenu = [CCMenu menuWithItems:newGame, gameHow, gameCredit,nil];
    gameMenu.position = ccp(size.width -75, 75);
    [gameMenu alignItemsVertically];
    [self addChild:gameMenu z:3];
    
    
}

-(void) gameHow:(id) sender{
    
}

-(void) gameCredit:(id) sender{
    
}

-(void) newGame:(id) sender{
    perfs = [NSUserDefaults standardUserDefaults];
    [perfs setObject:[NSNumber numberWithDouble:[ball getCenter].x] forKey:@"x"];
    [perfs setObject:[NSNumber numberWithDouble:[ball getCenter].y] forKey:@"y"];
    [perfs synchronize];
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

-(void) update:(ccTime) dt{
    if(shape != NULL){
        if([shape interWithBall:ball]){
            return;
        }
    }
}

@end
