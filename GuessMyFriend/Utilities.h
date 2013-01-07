//
//  Utilities.h
//  GuessMyFriend
//
//  Created by bilal demirci on 10/17/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BasicButton.h"


@interface Utilities : NSObject

+(Utilities*) sharedInstance;
-(CCSprite*) getProfileImage:(NSString*) username imgType:(NSString*) type;
-(CCSprite*) getProfileImage:(NSString*) username imgType:(NSString*) type withUrl:(NSString*) url;
-(BasicButton*) makeButton:(NSString*) file text:(NSString*) tx x:(int) xPos y:(int) yPos param:(int)p;
-(BasicButton*) makeButtonWithSprite:(CCSprite*) file text:(NSString*) tx x:(int) xPos y:(int) yPos param:(int)p;

@end
