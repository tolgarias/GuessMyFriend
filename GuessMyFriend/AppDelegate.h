//
//  AppDelegate.h
//  GuessMyFriend
//
//  Created by bilal demirci on 10/15/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import <FacebookSDK/FacebookSDK.h>
#import <AVFoundation/AVFoundation.h>
#import "SimpleAudioEngine.h"
#import "GameManager.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate,FBFriendPickerDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
    FBFriendPickerViewController *friendController_;
    
}

@property (strong,nonatomic) FBFriendPickerViewController *friendController;
@property (strong,nonatomic) NSArray *selectedFriends;

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (strong,nonatomic) NSArray* appInstalledFriends;
@property (nonatomic,assign) BOOL showAllFriends;

//-(void) sessionStateChanged:(FBSession*) session state:(FBSessionState)state error:(NSError*) error;
//-(void) openSession;
-(void) showFriendSelector:(BOOL)showAll;

-(void)playSound:(NSString *)sound format:(NSString *)format;

-(void) showProfileScreen;

-(void) getAppInstalledFriends;

@end
