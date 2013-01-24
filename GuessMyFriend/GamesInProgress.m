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
        BasicButton* backButton = [[Utilities sharedInstance] makeButton:@"Icon.png" text:@"Back" x:size.width/2 y:25 param:-1];
        [self addChild:backButton z:10];
        backButton.delegate = self;
        backButton.selector = @selector(onBackButtonPressed:);
        paddingTop = 40;
        paddingBottom = 30;
        yBuffer = 0;
        [self setIsTouchEnabled:YES];
        
    }
    return self;
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"1");
    ySpeed = 0;
}
CGPoint  startPoint;
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"2");
    for( UITouch *touch in touches ) {
        startPoint = [touch locationInView: [touch view]];
        startPoint = [[CCDirector sharedDirector] convertToGL: startPoint];
        
        //NSLog(@"x:%f,y:%f",startPoint.x,startPoint.y);
        
    }

}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"3");
    for( UITouch *touch in touches ) {
        CGPoint tPoint = [touch locationInView: [touch view]];
        tPoint = [[CCDirector sharedDirector] convertToGL: startPoint];
        double diffY = tPoint.y-startPoint.y;
        if(diffY>10) {
            ySpeed=3;
        }
        else if(diffY<-10){
            ySpeed=-3;
            
        }
    }

}


-(void) gamesInProgressResult:(NSDictionary*)jsonData {
    int x,y;
    y=size.height-paddingTop;
    x=80;
    
    CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:@"Your turn" fontName:@"Marker Felt" fontSize:20];
    nameLabel.position = ccp(x, y);
    y-=70;
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
        if (y+150<0) {
            offScreenHeight = y*-1;
        }
        [self schedule:@selector(tick:) interval:1.0f/60.0f];
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
    [GameData sharedInstance].opponentId = (NSString*)[datas objectForKey:@"opponentId"];
    [GameData sharedInstance].guessCount = [NSNumber numberWithInt:3];
    
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
-(void) setObjectPositions {
    for (CCNode* node in self.children) {
        bool setPosition = TRUE;
        if ([node isKindOfClass:[BasicButton class]]) {
            BasicButton* b = (BasicButton*) node;
            if (b.param_1<0) {
                setPosition = false;
            }
        }
        if(setPosition)
        node.position = ccp(node.position.x,node.position.y+ySpeed);
    }
}
-(void) tick:(ccTime*) dt {
    if(ySpeed>0){
       if(yBuffer+ySpeed>offScreenHeight){
        ySpeed =0;
       }
       else {
           yBuffer+=ySpeed;
           // NSLog(@"ySpeed:%i",ySpeed);
       }
    }
    
    if(ySpeed<0){
        
    if(yBuffer+ySpeed<0){
        ySpeed =0;
    }
    else {
        yBuffer+=ySpeed;
        //NSLog(@"ySpeed:%i",ySpeed);
    }
    }


    [self setObjectPositions];
}
@end
