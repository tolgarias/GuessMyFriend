//
//  LoginLayer.m
//  GuessMyFriend
//
//  Created by bilal demirci on 10/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginLayer.h"
#import "AppDelegate.h"

@implementation LoginLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LoginLayer *layer = [LoginLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    self = [super init];
    BasicButton* button = [[Utilities sharedInstance] makeButton:@"Icon.png" text:@"Login" x:100 y:100 param:1];
    button.delegate = self;
    [self addChild:button];
    return self;
}

-(void) onEnter {
    //AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    //[[FacebookManager sharedInstance] openSession];
}
-(void) onButtonPressed:(id)sender {
    //AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    //[app openSession];
     [FBSession.activeSession closeAndClearTokenInformation];
}





@end
