
//
//  ChooseProfile.m
//  GuessMyFriend
//
//  Created by bilal demirci on 10/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ChooseProfile.h"
#import "GameManager.h"

@implementation ChooseProfile

-(id) init {
    self = [super init];
    NSString *query =
    @"SELECT uid, name, pic_square,username FROM user WHERE uid IN "
    @"(SELECT uid2 FROM friend WHERE uid1 = me() order by rand() LIMIT 20)";
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
                                  NSArray* friends = (NSArray*)[result data];
                                  [self displayScreen:friends];
                                 
                              }
                          }];
    friendIds = [[NSMutableArray alloc] init];
    return self;
}

+(CCScene*) scene {
    CCScene* scn = [CCScene node];
    ChooseProfile* profile = [ChooseProfile node];
    [scn addChild:profile];
    return scn;
}


-(void) displayScreen:(NSArray*) friends {
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:@"Choose Friend Picture To Ask" fontName:@"Marker Felt" fontSize:20];
    nameLabel.position = ccp(size.width/2, size.height-30);
    [self addChild:nameLabel];
    
    [self displayFriends:friends];
    
    
    BasicButton* backButton=[[Utilities sharedInstance] makeButton:@"Icon.png" text:@"Back" x:size.width/2 y:40 param:1];
    backButton.selector = @selector(onBackButtonPressed:);
    backButton.delegate = self;
    [self addChild:backButton];
    
}
-(void) onBackButtonPressed:(id) sender{
    [[SceneManager sharedSceneManager] changeScene:kProfileLayer];
}
-(void) displayFriends:(NSArray *)friends {
    int i=0;
    int j=0;
    CGSize size = [[CCDirector sharedDirector] winSize];
    int x,y;
    int marginX=65;
    int marginY=80;
    int indexer=0;
    for(NSDictionary* user in friends){
        x=marginX+i*60;
        y=size.height-(marginY+j*60);
        CCSprite* sprite = [[Utilities sharedInstance] getProfileImage:[user objectForKey:@"username"] imgType:@"square" withUrl:[user objectForKey:@"pic_square"]];
        BasicButton* profile = [[Utilities sharedInstance] makeButtonWithSprite:sprite text:@"" x:x y:y param:indexer];
        profile.delegate = self;
        [self addChild:profile];
        i++;
        if(i%4==0){
            i=0;
            j++;
        }
        indexer++;
        [friendIds addObject:[user objectForKey:@"uid"]];
    }

}
-(void) onButtonPressed:(id)sender {
    BasicButton* button = (BasicButton*)sender;
    NSString* uid = [friendIds objectAtIndex:button.param_1];
    [[GameData sharedInstance] setSelectedFriendId:uid];
    [[GameData sharedInstance] setFriendsToPlay:friendIds];
    [[GameManager sharedInstance] createGame];
    [[SceneManager sharedSceneManager] changeScene:kProfileLayer];

}
@end
