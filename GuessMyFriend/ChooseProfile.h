//
//  ChooseProfile.h
//  GuessMyFriend
//
//  Created by bilal demirci on 10/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Utilities.h"
#import "SceneManager.h"

@interface ChooseProfile : CCLayer {
    NSMutableArray* friendIds;
}


+(CCScene*) scene;
-(void) displayFriends:(NSArray*)friends;
@end
