//
//  GamesInProgress.m
//  GuessMyFriend
//
//  Created by Tolga Saglam on 11/14/12.
//
//

#import "GamesInProgress.h"


@implementation GamesInProgress
@synthesize games;

+(CCScene*) scene {
    CCScene* scn = [CCScene node];
    GamesInProgress* profile = [GamesInProgress node];
    [scn addChild:profile];
    return scn;
}
- (id)init
{
    self = [super init];
    if (self) {
        size = [[CCDirector sharedDirector] winSize];
        games= [[NSMutableArray alloc] init];
        [[GameManager sharedInstance] getGamesInProgressWithSelector:@selector(gamesInProgressResult:) delegate:self];
        BasicButton* backButton = [[Utilities sharedInstance] makeButton:@"Icon.png" text:@"Back" x:size.width/2 y:25 param:1];
        [self addChild:backButton z:10];
        backButton.delegate = self;
        backButton.selector = @selector(onBackButtonPressed:);
        
    }
    return self;
}
-(void) gamesInProgressResult:(NSDictionary*)jsonData {
    
    
   
    int x,y;
    y=size.height-100;
    x=80;
    
    CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:@"Your turn" fontName:@"Marker Felt" fontSize:20];
    nameLabel.position = ccp(x, y+70);
    [self addChild:nameLabel];
    int index=0;
    if (jsonData) {
        NSArray* myturn = [jsonData objectForKey:@"myturn"];
        for(NSDictionary* gd in myturn){
            NSNumber* stringLength = [gd objectForKey:@"stringLength"];
            NSNumber* gameId = [gd objectForKey:@"gameId"];
            
            NSMutableDictionary* datas = [[NSMutableDictionary alloc] init];
            [datas setObject:gameId forKey:@"gameId"];
            NSString* string = (NSString*)[gd objectForKey:@"string"];
            [datas setObject:string forKey:@"string"];
            [datas setObject:stringLength forKey:@"stringLength"];
            [datas setObject:[gd objectForKey:@"opponentId"] forKey:@"opponentId"];
            [games addObject:datas];
            [self displayWaitingGame:x y:y myTurn:YES name:[gd objectForKey:@"name"] image:[gd objectForKey:@"image"] stringLength:[stringLength intValue] index:index];
            y-=150;
            index++;
        }
        //y-=30;
        CCLabelTTF *theirLabel = [CCLabelTTF labelWithString:@"Their turn" fontName:@"Marker Felt" fontSize:20];
        theirLabel.position = ccp(x, y);
        [self addChild:theirLabel z:10];
        y-=80;
        NSArray* waiting = [jsonData objectForKey:@"waiting"];
        for(NSDictionary* gd in waiting){
            NSNumber* stringLength = [gd objectForKey:@"stringLength"];
            NSNumber* gameId = [gd objectForKey:@"gameId"];
            
            NSMutableDictionary* datas = [[NSMutableDictionary alloc] init];
            [datas setObject:gameId forKey:@"gameId"];
            NSString* string = (NSString*)[gd objectForKey:@"string"];
            [datas setObject:string forKey:@"string"];
            [datas setObject:stringLength forKey:@"stringLength"];
            [datas setObject:[gd objectForKey:@"opponentId"] forKey:@"opponentId"];
            [games addObject:datas];
            [self displayWaitingGame:x y:y myTurn:NO name:[gd objectForKey:@"name"] image:[gd objectForKey:@"image"] stringLength:[stringLength intValue] index:index];
            y-=150;
            index++;
        }
    }
}
-(void) displayWaitingGame:(int)x y:(int)y myTurn:(BOOL)myTurn name:(NSString *)name image:(NSString *)image stringLength:(int)stringLength index:(int)index{
    CCSprite* profileImage = [[Utilities sharedInstance] getProfileImage:name imgType:@"" withUrl:image];
    NSString *text = @"";
    if (!myTurn) {
        text = @"nudge";
    }
    BasicButton* button = [[Utilities sharedInstance] makeButtonWithSprite:profileImage text:text x:x y:y param:index];
    [self addChild:button];
    button.delegate = self;
    if (myTurn) {
        button.selector = @selector(onPlayGameButtonPressed:);
    }
    else {
        button.selector = @selector(onNudgeButtonPressed:);
    }
    
    CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:name fontName:@"Marker Felt" fontSize:20];
    nameLabel.position = ccp(x+110, y+20);
    [self addChild:nameLabel];
    
    CCLabelTTF *stringLengthLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"String length:%i",stringLength] fontName:@"Marker Felt" fontSize:20];
    stringLengthLabel .position = ccp(x+110, y-10);
    [self addChild:stringLengthLabel];
}


-(void) onPlayGameButtonPressed:(id) sender {
    BasicButton* button = (BasicButton*) sender;
    int index = button.param_1;
    NSMutableDictionary* datas = [games objectAtIndex:index];
    NSNumber* gameId = (NSNumber*)[datas objectForKey:@"gameId"];
    NSString* string = (NSString*)[datas objectForKey:@"string"];
    NSNumber* stringLength = (NSNumber*)[datas objectForKey:@"stringLength"];
    [GameData sharedInstance].gameId = gameId;
    [GameData sharedInstance].gameStatus = [NSNumber numberWithInt:1];
    [GameData sharedInstance].stringLength = stringLength;
    [GameData sharedInstance].opponentId = (NSString*)[datas objectForKey:@"opponentId"];;
    
    NSArray* stringArray = [string componentsSeparatedByString:@","];
    [GameData sharedInstance].string = [[NSMutableArray alloc] initWithArray:stringArray];
    
    [[SceneManager sharedSceneManager] changeScene:kCreateGameLayer];
}
-(void) onNudgeButtonPressed:(id) sender {
    NSLog(@"nudge");
}
-(void) onBackButtonPressed:(id) sender {
    [[SceneManager sharedSceneManager] changeScene:kProfileLayer];
}
@end