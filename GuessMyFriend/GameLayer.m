//
//  GameLayer.m
//  GuessMyFriend
//
//  Created by bilal demirci on 10/16/12.
//
//

#import "GameLayer.h"
#import "AppDelegate.h"
#import "SceneManager.h"
@implementation GameLayer : CCLayer

@synthesize userProfileImage;

+(CCScene*) scene {
    CCScene* scene = [CCScene node];
    GameLayer* layer = [GameLayer node];
    [scene addChild:layer];
    return scene;
}
-(id) init {
    self = [super init];
        
    [self displayProfileWithFql];
    BasicButton* logout = [[Utilities sharedInstance] makeButton:@"Icon.png" text:@"Logout" x:250 y:10 param:1];
    logout.delegate = self;
    logout.selector = @selector(onLogoutButtonPressed:);
    [self addChild:logout];

    return self;
}


-(void) onLogoutButtonPressed:(id) sender {
     [FBSession.activeSession closeAndClearTokenInformation];
     [[SceneManager sharedSceneManager] changeScene:kLoginLayer];
}


-(void) onGamesButtonPressed:(id) sender {
    
    [[SceneManager sharedSceneManager] changeScene:kGameInProgressLayer];
}
-(void) onCreateGameButtonPressed:(id) sender {
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app showFriendSelector];
}

-(void) displayProfileWithFql {
    NSString *query =
    @"SELECT uid, name, pic,username FROM user WHERE uid=me()";
    // Set up the query parameter
    NSDictionary *queryParam =
    [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  NSArray* profileArray = (NSArray*)[result data];
                                  NSDictionary* profile = (NSDictionary*)[profileArray objectAtIndex:0];
                                  [self displayProfileScreen:[profile objectForKey:@"name"] username:[profile objectForKey:@"username"] imgUrl:[profile objectForKey:@"pic"]];
                                  //[[GameData sharedInstance] setUser:(NSString*)[profile objectForKey:@"username"]];
                                  [GameData sharedInstance].userID = (NSString*)[profile objectForKey:@"uid"];
                                  [[GameManager sharedInstance] loginControl:[profile objectForKey:@"uid"] name:[profile objectForKey:@"name"] image:[profile objectForKey:@"pic"] deviceToken:@""];
                              }
                          }];

}

-(void) displayProfileScreen:(NSString *)name username:(NSString *)username imgUrl:(NSString *)imgUrl {
   
    CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:name fontName:@"Marker Felt" fontSize:40];
    nameLabel.position = ccp(100, 100);
    [self addChild:nameLabel];
    
    if(imgUrl==nil) {
        CCSprite* profilePicture = [[Utilities sharedInstance] getProfileImage:username imgType:@"normal"];
        profilePicture.position = ccp(100,200);
        [self addChild:profilePicture];
    }
    else {
        CCSprite* profilePicture = [[Utilities sharedInstance] getProfileImage:username imgType:@"normal" withUrl:imgUrl];
        profilePicture.position = ccp(100,200);
        [self addChild:profilePicture];
    }
    
    
    BasicButton* games = [[Utilities sharedInstance] makeButton:@"Icon.png" text:@"Games" x:250 y:200 param:1];
    games.delegate = self;
    games.selector = @selector(onGamesButtonPressed:);
    
    [self addChild:games];
    
    
    BasicButton* createGame = [[Utilities sharedInstance] makeButton:@"Icon.png" text:@"Create Game" x:250 y:150 param:1];
    createGame.delegate = self;
    createGame.selector = @selector(onCreateGameButtonPressed:);
    
    [self addChild:createGame];
    
}

-(void) displayProfile {
    if(FBSession.activeSession.isOpen){
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if(!error){
                
                //[[GameData sharedInstance] setUser:[NSString stringWithFormat:@"%@",[user objectForKey:@"id"]]];
                
                [self displayProfileScreen:user.name username:user.username imgUrl:nil];
                
                [[GameData sharedInstance] setUser:user.username];
                
                
            }
            else {
                NSLog(@"burda");
                // NSLog(error.description);
            }
        }];
    }

}

@end
