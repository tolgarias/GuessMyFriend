//
//  GameLayer.h
//  GuessMyFriend
//
//  Created by bilal demirci on 10/16/12.
//
//

#import "CCLayer.h"
#import "cocos2d.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Utilities.h"
#import "GameData.h"
#import "UserData.h"
@interface GameLayer : CCLayer

+(CCScene*) scene;

@property (strong,nonatomic) IBOutlet FBProfilePictureView *userProfileImage;

//-(void) getUserProfile;

-(void) displayProfileScreen:(NSString*) name username:(NSString*) username imgUrl:(NSString*) imgUrl;

-(void) displayProfile;
-(void) displayProfileWithFql;
@end
