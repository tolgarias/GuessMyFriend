//
//  GameData.m
//  GuessMyFriend
//
//  Created by bilal demirci on 10/18/12.
//
//

#import "GameData.h"

@implementation GameData

@synthesize userID;
@synthesize gameId,gameStatus,string,stringLength,opponentId,guessCount;
@synthesize inProgress;
@synthesize facebookInfos;


static GameData* sharedInstance;

+(GameData*) sharedInstance {
    if(sharedInstance==nil){
        sharedInstance = [[GameData alloc] init];
    }
    return sharedInstance;
}
-(id) init {
    questionsAndAnswers = [[NSMutableArray alloc] init];
    friendsToPlay = [[NSMutableArray alloc] init];
    guessCount = 0;
    string = [[NSMutableArray alloc] init];
    return self;
}
-(void) setGameData:(NSString*) user opponent:(NSString*)opponent friendIds:(NSMutableArray*) friendIds questions:(NSMutableArray*) questions guess:(int)guess{
    userId = user;
    opponentId = opponent;
    friendsToPlay = friendIds;
    questionsAndAnswers = questions;
    //guessCount = guess;
}

-(void) setFriendsToPlay:(NSMutableArray *)friends {
    friendsToPlay = friends;
}


-(void) setQuestions:(NSMutableArray *)questions {
    questionsAndAnswers = questions;
}

-(void) setUser:(NSString*)user {
    userId = user;
}

-(void) setOpponent:(NSString*)opponent {
    opponentId = opponent;
}

/*-(void) setGuessCount:(int)guess{
    guessCount = guess;
}*/
-(void) setSelectedFriendId:(NSString *)friendId {
    selectedFriendId = friendId;
    
}

-(NSDictionary*) getGameData{
    //NSDictionary* gd = [[NSDictionary alloc] initWithObjectsAndKeys:@"userId",userId,@"friendId",opponentId,@"selectedFriendId",selectedFriendId,@"selectedFriends",friendsToPlay,nil];
    NSMutableDictionary* gd = [[NSMutableDictionary alloc] init];
    //[gd setObject:userId forKey:@"userId"];
    
    [gd setObject:opponentId forKey:@"friendId"];
    //[gd setObject:selectedFriendId forKey:@"selectedFriendId"];
    //[gd setObject:friendsToPlay forKey:@"selectedFriends"];
    //[gd setObject:[[NSNumber alloc] initWithInt:guessCount] forKey:@"guessCount"];
    //[gd setObject:userId forKey:@"uid"];
    //[gd setObject:@"745780221" forKey:@"uid"];
    //[gameData setObject:questionsAndAnswers forKey:@"questionsAndAnswers"];

    return gd;
}


@end
