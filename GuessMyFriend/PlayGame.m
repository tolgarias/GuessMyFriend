//
//  PlayGame.m
//  GuessMyFriend
//
//  Created by Tolga Saglam on 11/19/12.
//
//

#import "PlayGame.h"
#import "AppDelegate.h"

@implementation PlayGame
@synthesize tempString;
+(CCScene*) scene {
    CCScene* scn = [CCScene node];
    MessageLayer* m=[MessageLayer node];
    [scn addChild:m z:1];
    //PlayGame* profile = [PlayGame node];
    PlayGame* profile = [[[PlayGame alloc] initWithMessageLayer:m] autorelease];
    [scn addChild:profile];
    return scn;
}

-(id) init {
    //self = [super init];
    tempString  = [[NSMutableArray alloc] init];
    //displayer = [[MessageDisplayer alloc] initWithMessageLayer:_m delegate:self];
    [self displayHeaderLabel];
    [self displayGameScreen];
    return self;
}

-(id) initWithMessageLayer:(MessageLayer *)ml {
    self = [super init];
    _m = ml;
    return [self init];
}
-(void) displayGameScreen{
   
    CGSize size = [[CCDirector sharedDirector] winSize];
    _m.visible = NO;
    
    
    NSArray*  colors  = [NSArray arrayWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:238],[NSNumber numberWithInt:238],[NSNumber numberWithInt:0], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithInt:173],[NSNumber numberWithInt:255],[NSNumber numberWithInt:47], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithInt:255],[NSNumber numberWithInt:15],[NSNumber numberWithInt:0], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:238],[NSNumber numberWithInt:238], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithInt:135],[NSNumber numberWithInt:206],[NSNumber numberWithInt:135], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithInt:131],[NSNumber numberWithInt:111],[NSNumber numberWithInt:255], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithInt:238],[NSNumber numberWithInt:0],[NSNumber numberWithInt:238], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithInt:255],[NSNumber numberWithInt:62],[NSNumber numberWithInt:150], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithInt:107],[NSNumber numberWithInt:42],[NSNumber numberWithInt:135], nil],
                         nil];
    int i=0;
    int j=0;
    //CGSize size = [[CCDirector sharedDirector] winSize];
    int x,y;
    int marginX=65;
    int marginY=80;
    //int indexer=0;
    for(int indexer=0;indexer<9;indexer++){
        x=marginX+i*90;
        y=size.height-(marginY+j*70);
       // CCSprite* sprite = [[Utilities sharedInstance] getProfileImage:[user objectForKey:@"username"] imgType:@"square" withUrl:[user objectForKey:@"pic_square"]];
        CCSprite* bg = [CCSprite spriteWithFile:@"blank.png" rect:CGRectMake(0, 0, 40, 60)];
        NSNumber* c1 = [[colors objectAtIndex:indexer] objectAtIndex:0];
        NSNumber* c2 = [[colors objectAtIndex:indexer] objectAtIndex:1];
        NSNumber* c3 = [[colors objectAtIndex:indexer] objectAtIndex:2];
        bg.color = ccc3([c1 intValue], [c2 intValue], [c3 intValue]);
        //BasicButton* profile = [[Utilities sharedInstance] makeButton:@"Icon.png" text:[NSString stringWithFormat:@"%i",indexer] x:x y:y param:indexer];
        BasicButton* profile = [[Utilities sharedInstance] makeButtonWithSprite:bg text:@"" x:x y:y param:indexer];
        profile.delegate = self;
        [self addChild:profile z:0 tag:indexer];
        i++;
        if(i%3==0){
            i=0;
            j++;
        }
        //indexer++;
        //[friendIds addObject:[user objectForKey:@"uid"]];
    }
    
}
-(void) onButtonPressed:(id)sender {
    BasicButton* button = (BasicButton*)sender;
    NSString* sound = [NSString stringWithFormat:@"sound%i",button.param_1];
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app playSound:sound format:@"wav"];
    
    if([[GameData sharedInstance].gameStatus intValue]==2){
        [tempString addObject:[NSNumber numberWithInt:button.param_1]];
    }
    else if([[GameData sharedInstance].gameStatus intValue]==0 || [[GameData sharedInstance].gameStatus intValue]==1){
         [[GameData sharedInstance].string addObject:[NSNumber numberWithInt:button.param_1]];
    }
    stringIndex++;
    if(stringIndex>=[[GameData sharedInstance].stringLength intValue]) {
        stringIndex = 0;
        if ([[GameData sharedInstance].gameStatus intValue]==0) {
            [_m showWait:@"Your string is sending..."];
            [[GameManager sharedInstance] createGameStringWithSelector:@selector(createGameStringResult:) delegate:self];
        }
        else if ([[GameData sharedInstance].gameStatus intValue]==1) {
            [_m showWait:@"Your string is sending..."];
            [[GameManager sharedInstance] createGameStringWithSelector:@selector(createGameStringResult:) delegate:self];
        }
        else {
            NSString* string1 = [[tempString valueForKey:@"description"] componentsJoinedByString:@","];
            NSString* string2 = [[[GameData sharedInstance].string valueForKey:@"description"] componentsJoinedByString:@","];
            if([string1 isEqualToString:string2]){
                //[self schedule:@selector(showAnswerIsCorrect:) interval:1 repeat:3 delay:0];
                [self showMessageScreen:@"your answer is correct" message2:@"define new string after 3 seconds" action:kAnswerIsCorrect];
            }
            else {
                [self showMessageScreen:@"your answer is wrong" message2:@"try again after 3 seconds" action:kAnswerIsWrong];
            }
        }
        
    }
}
-(void) createGameStringResult:(NSDictionary*) jsonData{
    NSNumber* errorCode = [jsonData objectForKey:@"errorCode"];
    if([errorCode intValue]==0){
        //[_m showStringSend];
        [_m showMessageLayer:@"" message2:@"your string is send" message3:@"" showButton:YES buttonAction:0];
        [_m setVisible:YES];
    }
}
-(void) displayHeaderLabel {
    CGSize size = [[CCDirector sharedDirector] winSize];
    NSString* headerString;
    NSLog(@"%i",[[GameData sharedInstance].gameStatus intValue]);
 
   
    
    
    
    guessCountLabel = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:20];
    guessCountLabel.position = ccp(size.width/2, 35);
    [self addChild:guessCountLabel];
    
    if([[GameData sharedInstance].gameStatus intValue]==0){
        headerString = @"Define your string";
    }
    else {
        NSString* guessCountStr = [NSString stringWithFormat:@"Guess Count: %i",[[GameData sharedInstance].guessCount intValue]];
        [guessCountLabel setString:guessCountStr];
        headerString = @"Follow the string";
        [self showMessageScreen:@"Wait 3 seconds" message2:@"" action:kPlayString];
        
    }
    
    CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:headerString fontName:@"Marker Felt" fontSize:20];
    nameLabel.position = ccp(size.width/2, size.height-10);
    [self addChild:nameLabel];
    
    NSString* lengthStr = [NSString stringWithFormat:@"String length must be %i",[[GameData sharedInstance].stringLength intValue]];
    lengthLabel = [CCLabelTTF labelWithString:lengthStr fontName:@"Marker Felt" fontSize:20];
    lengthLabel.position = ccp(size.width/2, size.height-35);
    [self addChild:lengthLabel];

}

-(void) playString:(ccTime*) dt{
    NSNumber* tag = (NSNumber*)[[GameData sharedInstance].string objectAtIndex:stringIndex];
    BasicButton* button = (BasicButton*)[self getChildByTag:[tag intValue]];
    [button runPressActions];
    NSString* sound = [NSString stringWithFormat:@"sound%i",button.param_1];
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app playSound:sound format:@"wav"];
    stringIndex++;
    if(stringIndex>=[[GameData sharedInstance].stringLength intValue]) {
        [GameData sharedInstance].gameStatus =[NSNumber numberWithInt:2];
        //[self schedule:@selector(showRepeatString:) interval:1 repeat:3 delay:0];
        [self showMessageScreen:@"repeat string after " message2:@"3 seconds..." action:kNoAction];
        stringIndex = 0;
    }
}

//-(void) showWaitString:(ccTime*) dt {
/*
-(void) showWaitString:(NSString*) s {
        [_m setVisible:NO];
        listenCounter=3;
        [self schedule:@selector(playString:) interval:1 repeat:[[GameData sharedInstance].stringLength intValue]-1 delay:1];
    
}

-(void) showRepeatString:(ccTime*) dt {
    [_m showMessageLayer:@"repeat string after 3 seconds..." message2:[NSString stringWithFormat:@"%i",listenCounter] showButton:NO buttonAction:0];
    listenCounter--;
    [_m setVisible:YES];
    if(listenCounter<0){
        [_m setVisible:NO];
        listenCounter = 3;
    }
}
-(void) showAnswerIsCorrect:(ccTime*) dt {
    [_m showMessageLayer:@"your answer is correct define new string after 3 seconds..." message2:[NSString stringWithFormat:@"%i",listenCounter] showButton:NO buttonAction:0];
    listenCounter--;
    [_m setVisible:YES];
    if(listenCounter<0){
        [_m setVisible:NO];
        listenCounter = 3;
        [GameData sharedInstance].gameStatus = [NSNumber numberWithInt:1];
        int stringLength = [[GameData sharedInstance].stringLength intValue];
        [GameData sharedInstance].stringLength = [NSNumber numberWithInt:stringLength+1];
        [[GameData sharedInstance].string removeAllObjects];
        NSString* lengthStr = [NSString stringWithFormat:@"String length must be %i",[[GameData sharedInstance].stringLength intValue]];
        [lengthLabel setString:lengthStr];
        stringIndex=0;
    }
}
-(void) showAnswerIsWrong:(ccTime*) dt {
    [_m showMessageLayer:@"your answer is wrong try again after 3 seconds..." message2:[NSString stringWithFormat:@"%i",listenCounter] showButton:NO buttonAction:0];
    listenCounter--;
    [_m setVisible:YES];
    if(listenCounter<0){
        [_m setVisible:NO];
        listenCounter = 3;
        stringIndex = 0;
        [tempString removeAllObjects];
    }
}*/

-(void) showMessageScreen:(NSString *)m1 message2:(NSString *)m2 action:(JobToDo *)act{
    message1 = m1;
    message2 = m2;
    listenCounter = 3;
    action = act;
    //[_m setVisible:YES];
    //[self stopAllActions];
    [self schedule:@selector(displayMessageScreen:) interval:1 repeat:3 delay:0];
}
-(void) displayMessageScreen:(ccTime*) dt{
    [_m showMessageLayer:message1 message2:message2 message3:[NSString stringWithFormat:@"%i",listenCounter] showButton:NO buttonAction:0];
    listenCounter--;
    [_m setVisible:YES];
    if(listenCounter<0){
        [_m setVisible:NO];
        listenCounter = 3;
        [self performSelector:@selector(performAction)];
        [_m setVisible:NO];
    }
}
-(void) performAction {
    if(action!=kNoAction){
        if(action == kPlayString) {
            [self schedule:@selector(playString:) interval:1 repeat:[[GameData sharedInstance].stringLength intValue]-1 delay:1];
        }else if(action == kAnswerIsCorrect) {
            [GameData sharedInstance].gameStatus = [NSNumber numberWithInt:1];
            int stringLength = [[GameData sharedInstance].stringLength intValue];
            [GameData sharedInstance].stringLength = [NSNumber numberWithInt:stringLength+1];
            [[GameData sharedInstance].string removeAllObjects];
            NSString* lengthStr = [NSString stringWithFormat:@"String length must be %i",[[GameData sharedInstance].stringLength intValue]];
            [lengthLabel setString:lengthStr];
            stringIndex=0;
            
        }
        else if(action == kAnswerIsWrong) {
            stringIndex = 0;
            [GameData sharedInstance].guessCount = [NSNumber numberWithInt:[[GameData sharedInstance].guessCount intValue]-1];
            NSString* guessCountStr = [NSString stringWithFormat:@"Guess Count: %i",[[GameData sharedInstance].guessCount intValue]];
            [guessCountLabel setString:guessCountStr];
            [tempString removeAllObjects];
        }
    }

}


@end
