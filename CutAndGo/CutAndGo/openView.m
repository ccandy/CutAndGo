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
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

@end
