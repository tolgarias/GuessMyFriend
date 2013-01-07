//
//  GameManager.m
//  GuessMyFriend
//
//  Created by Tolga Saglam on 10/22/12.
//
//

#import "GameManager.h"
#import "GameData.h"
#import "UrlConnectionManager.h"
@implementation GameManager

static GameManager* sharedInstance;

+(GameManager*) sharedInstance {
    if (sharedInstance==nil) {
        sharedInstance = [[GameManager alloc] init];
    }
    return sharedInstance;
}
-(void) createGame {
    NSDictionary* gameData = [[GameData sharedInstance] getGameData];
    //NSString* postData = [NSString stringWithFormat:@"&userId=%@&friendId=%@&selectedFriendId=%@&selectedFriends=%@",[GameData sharedInstance].userID,[gameData objectForKey:@"friendId"],[gameData objectForKey:@"selectedFriendId"],[gameData objectForKey:@"selectedFriends"]];
    NSString* postData = [NSString stringWithFormat:@"&userId=%@&friendId=%@&",[GameData sharedInstance].userID,[gameData objectForKey:@"friendId"]];
    [[UrlConnectionManager sharedInstance] postData:postData withUrl:@"http://54.246.95.210/tolga_g.php"];
}

-(void) createGameWithSelector:(SEL) selector delegate:(id) delegate{
    NSDictionary* gameData = [[GameData sharedInstance] getGameData];
    //NSString* postData = [NSString stringWithFormat:@"&userId=%@&friendId=%@&selectedFriendId=%@&selectedFriends=%@",[GameData sharedInstance].userID,[gameData objectForKey:@"friendId"],[gameData objectForKey:@"selectedFriendId"],[gameData objectForKey:@"selectedFriends"]];
    NSString* postData = [NSString stringWithFormat:@"&userId=%@&friendId=%@&",[GameData sharedInstance].userID,[gameData objectForKey:@"friendId"]];
    
    [UrlConnectionManager sharedInstance].selector = selector;
    [UrlConnectionManager sharedInstance].delegate = delegate;
    
    [[UrlConnectionManager sharedInstance] postData:postData withUrl:@"http://54.246.95.210/tolga_g.php"];
}

-(void) createGameStringWithSelector:(SEL) selector delegate:(id) delegate{
    //NSDictionary* gameData = [[GameData sharedInstance] getGameData];
    
    NSString* string=@"";
    NSNumber* gameId=[GameData sharedInstance].gameId;
    NSArray* stringArray = [GameData sharedInstance].string;
    NSNumber* stringLength = [GameData sharedInstance].stringLength;
    
    /*for(int i=0;i<[stringLength intValue]-1;i++){
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%@,",[stringArray objectAtIndex:i]]];
    }
    string = [string stringByAppendingString:[NSString stringWithFormat:@"%@",[stringArray objectAtIndex:[stringLength intValue]-1]]];
    */
    string = [[stringArray valueForKey:@"description"] componentsJoinedByString:@","];
    NSString* postData = [NSString stringWithFormat:@"&userId=%@&gameId=%i&stringLength=%i&string=%@&friendId=%@",[GameData sharedInstance].userID,[gameId intValue],[stringLength intValue],string,[GameData sharedInstance].opponentId];
    
    [UrlConnectionManager sharedInstance].selector = selector;
    [UrlConnectionManager sharedInstance].delegate = delegate;
    
    [[UrlConnectionManager sharedInstance] postData:postData withUrl:@"http://54.246.95.210/tolga_s.php"];
}
-(void) getGamesInProgressWithSelector:(SEL)selector delegate:(id)delegate{
    NSString* postData = [NSString stringWithFormat:@"&userId=%@",[GameData sharedInstance].userID];
    
    [UrlConnectionManager sharedInstance].selector = selector;
    [UrlConnectionManager sharedInstance].delegate = delegate;
    
    [[UrlConnectionManager sharedInstance] postData:postData withUrl:@"http://54.246.95.210/tolga_gs.php"];
    
}

-(void) loginControl:(NSString*) uid name:(NSString*) name image:(NSString*) image deviceToken:(NSString*) deviceToken {
    NSString* postData = [NSString stringWithFormat:@"&userId=%@&name=%@&image=%@&deviceToken=%@",uid,name,image,@""];
    [[UrlConnectionManager sharedInstance] postData:postData withUrl:@"http://54.246.95.210/tolga_u.php"];

}
@end
