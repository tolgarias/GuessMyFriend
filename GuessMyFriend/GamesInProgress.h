//
//  GamesInProgress.h
//  GuessMyFriend
//
//  Created by Tolga Saglam on 11/14/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameManager.h"
#import "Utilities.h"
#import "BasicButton.h"
#import "GameData.h"
#import "SceneManager.h"

@interface GamesInProgress :CCLayer {
    //CCScrollView * view;
    CGSize size;
    int paddingTop;
    int paddingBottom;
    int yBuffer;
    int offScreenHeight;
}
@property (retain,atomic) NSMutableArray* games;

+(CCScene*) scene;
-(void) displayWaitingGame:(int) x y:(int)y myTurn:(BOOL) myTurn name:(NSString*) name image:(NSString*) image stringLength:(int)stringLength  index:(int) index;
//-(void) displayWaitingGame:(int) x y:(int)y myTurn:(BOOL) myTurn name:(NSString*) name image:(NSString*) image index:(int) index;

@end