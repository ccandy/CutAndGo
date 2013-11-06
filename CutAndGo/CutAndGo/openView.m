//
//  openView.m
//  CutAndGo
//
//  Created by Hua Dong on 11/5/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "openView.h"


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



@end
