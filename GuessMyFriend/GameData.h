//
//  GameData.h
//  GuessMyFriend
//
//  Created by bilal demirci on 10/18/12.
//
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject{
    NSString* userId;
    NSMutableArray* friendsToPlay;
    NSString* opponentId;
    NSMutableArray* questionsAndAnswers;
    //int guessCount;
    NSString* selectedFriendId;
}

@property (strong,atomic) NSString* userID;
@property (strong,atomic) NSMutableArray* string;
@property (strong,atomic) NSNumber* stringLength;
@property (strong,atomic) NSNumber* gameStatus;
@property (strong,atomic) NSNumber* gameId;
@property (strong,atomic) NSDictionary* inProgress;
@property (strong,atomic) NSMutableDictionary* facebookInfos;
@property (strong,atomic) NSString* opponentId;
@property (strong,atomic) NSNumber* guessCount;

+(GameData*) sharedInstance;


-(void) setGameData:(NSString*) user opponent:(NSString*)opponent friendIds:(NSArray*) friendIds questions:(NSArray*) questions guess:(int) guess;
-(void) setUser:(NSString*) user;
-(void) setOpponent:(NSString*) opponent;
-(void) setFriendsToPlay:(NSArray*) friends;
-(void) setQuestions:(NSArray*) questions;
//-(void) setGuessCount:(int) guess;
-(void) setSelectedFriendId:(NSString*) friendId;
-(NSDictionary*) getGameData;



@end
