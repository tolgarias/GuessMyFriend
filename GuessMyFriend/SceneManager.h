//
//  SceneManager.h
//  GuessMyFriend
//
//  Created by bilal demirci on 10/17/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LoginLayer.h"
#import "GameLayer.h"
#import "ChooseProfile.h"
#import "PlayGame.h"
#import "GamesInProgress.h"

@interface SceneManager : NSObject
typedef enum {
    kLoginLayer,
    kProfileLayer,
    kCreateGameLayer,
    kGameInProgressLayer
} SceneToPlay;

+(SceneManager*) sharedSceneManager;
-(void) changeScene:(SceneToPlay) scene;

@end
