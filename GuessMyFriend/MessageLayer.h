//
//  MessageLayer.h
//  GuessMyFriend
//
//  Created by Tolga Saglam on 11/20/12.
//
//

#import "cocos2d.h"
#import "BasicButton.h"
#import "Utilities.h"
//#import "SceneManager.h"
#import "AppDelegate.h"

@interface MessageLayer : CCLayer {
    int buttonAction;
}

@property (retain,atomic) CCLabelTTF* label1;
@property (retain,atomic) CCLabelTTF* label2;
@property (retain,atomic) CCLabelTTF* label3;
@property (retain,atomic) BasicButton* button;
@property (retain,atomic) CCSprite* bg;
@property (retain,atomic) CCSprite* border;

-(void) showWait:(NSString*) message;
-(void) showStringSend;
-(void) showMessageLayer:(NSString*)message1 message2:(NSString*) message2 message3:(NSString*) message3 showButton:(BOOL) showButton buttonAction:(int) action;
@end
