//
//  SceneManager.m
//  GuessMyFriend
//
//  Created by bilal demirci on 10/17/12.
//
//

#import "SceneManager.h"


@implementation SceneManager

static SceneManager* sceneManager;

+(SceneManager*) sharedSceneManager {
    if(sceneManager==nil){
        sceneManager = [[SceneManager alloc] init];
    }
    return sceneManager;
}

-(id) init {
    self = [super init];
    return self;
}


-(void) changeScene:(SceneToPlay)scene {
    switch(scene){
            
            case kLoginLayer:
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LoginLayer scene] withColor:ccWHITE]];
            break;
            
            case kCreateGameLayer:
            //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ChooseProfile scene] withColor:ccWHITE]];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[PlayGame scene] withColor:ccWHITE]];
            break;
            
            case kProfileLayer:
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene] withColor:ccWHITE]];
            break;
            case kGameInProgressLayer:
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GamesInProgress scene] withColor:ccWHITE]];
            break;
            default:
            break;
            
            
    }
}



@end
