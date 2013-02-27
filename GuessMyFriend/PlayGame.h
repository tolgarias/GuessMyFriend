//
//  PlayGame.h
//  GuessMyFriend
//
//  Created by Tolga Saglam on 11/19/12.
//
//

#import "cocos2d.h"
#import "BasicButton.h"
#import "MessageLayer.h"
#import "Utilities.h"
#import "GameData.h"
#import "MessageDisplayer.h"


typedef enum {
    kPlayString,
    kNoAction,
    kAnswerIsCorrect,
    kAnswerIsWrong,
    kGameOver
} JobToDo;

@interface PlayGame : CCLayer{
    int stringIndex;
    MessageLayer* _m;
    int listenCounter;
    CCLabelTTF *lengthLabel;
    CCLabelTTF *guessCountLabel;
    //MessageDisplayer* displayer;
    
    NSString* message1;
    NSString* message2;
    JobToDo* action;
    
}


@property (retain,atomic) NSMutableArray* tempString;


+(CCScene*) scene;

-(void) displayGameScreen;
-(void) displayHeaderLabel;
-(id) initWithMessageLayer:(MessageLayer*) ml;
-(void) showMessageScreen:(NSString*) m1 message2:(NSString*) m2 action:(JobToDo*) act;

@end
