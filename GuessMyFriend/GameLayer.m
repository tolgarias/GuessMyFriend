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
    BasicButton* logout = [[Utilities sharedInstance] makeButton:@"Icon.png" text:@"Logout" x:[CCDirector sharedDirector].winSize.width/2 y:30 param:1];
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
    NSLog(@"dataTaken:%i",[[UserData sharedInstance].dataTaken intValue]);
    if([[UserData sharedInstance].dataTaken intValue] != 1){
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
                                  [UserData sharedInstance].dataTaken = [NSNumber numberWithInt:1];
                                  [UserData sharedInstance].name = [profile objectForKey:@"name"];
                                  [UserData sharedInstance].photoUrl = [profile objectForKey:@"pic"];
                                  
                              }
                          }];
    }
    else {
        [self displayProfileScreen:[UserData sharedInstance].name username:@"" imgUrl:[UserData sharedInstance].photoUrl];
    }

}

-(void) displayProfileScreen:(NSString *)name username:(NSString *)username imgUrl:(NSString *)imgUrl {
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:name fontName:@"Marker Felt" fontSize:30];
    nameLabel.position = ccp(size.width/2, size.height-20);
    [self addChild:nameLabel];
    
    if(imgUrl==nil) {
        CCSprite* profilePicture = [[Utilities sharedInstance] getProfileImage:username imgType:@"normal"];
        profilePicture.position = ccp(size.width/2,size.height-90);
        [self addChild:profilePicture];
    }
    else {
        CCSprite* profilePicture = [[Utilities sharedInstance] getProfileImage:username imgType:@"normal" withUrl:imgUrl];
        profilePicture.position = ccp(size.width/2,size.height-90);
        [self addChild:profilePicture];
    }
    
    
    BasicButton* games = [[Utilities sharedInstance] makeButton:@"Icon.png" text:@"Games" x:size.width/2-30 y:size.height-200 param:1];
    games.delegate = self;
    games.selector = @selector(onGamesButtonPressed:);
    
    [self addChild:games];
    
    
    BasicButton* createGame = [[Utilities sharedInstance] makeButton:@"Icon.png" text:@"Create Game" x:size.width/2+30 y:size.height-200 param:1];
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
