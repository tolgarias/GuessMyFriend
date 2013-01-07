//
//  GameManager.h
//  GuessMyFriend
//
//  Created by Tolga Saglam on 10/22/12.
//
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject

+(GameManager*) sharedInstance;
-(void) createGame;
-(void) createGameWithSelector:(SEL) selector delegate:(id) delegate;
-(void) createGameStringWithSelector:(SEL) selector delegate:(id) delegate;
-(void) getGamesInProgressWithSelector:(SEL) selector delegate:(id) delegate;
-(void) loginControl:(NSString*) uid name:(NSString*) name image:(NSString*) image deviceToken:(NSString*) deviceToken;
@end
