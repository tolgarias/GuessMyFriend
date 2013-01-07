//
//  MessageDisplayer.h
//  GuessMyFriend
//
//  Created by Tolga Saglam on 12/19/12.
//
//

#import <Foundation/Foundation.h>
#import "MessageLayer.h"

@interface MessageDisplayer : CCLayer {
    int listenCounter;
    SEL selector;
    id delegate;
    NSString* message1;
    NSString* message2;
    MessageLayer* _m;
}

-(id) initWithMessageLayer:(MessageLayer*) m delegate:(id) del;
-(void) showMessageLayer:(NSString*) m1 message2:(NSString*) m2 selector:(SEL)sel ;

@end
