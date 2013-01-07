//
//  MessageDisplayer.m
//  GuessMyFriend
//
//  Created by Tolga Saglam on 12/19/12.
//
//

#import "MessageDisplayer.h"

@implementation MessageDisplayer

-(id) initWithMessageLayer:(MessageLayer *) m delegate:(id)del {
    self = [super init];
    delegate = del;
    _m = m;
    return self;
}
-(void) showMessageLayer:(NSString *)m1 message2:(NSString *)m2 selector:(SEL)sel{
    message1 = m1;
    message2 = m2;
    selector = sel;
    [self schedule:@selector(showMessage:) interval:1 repeat:3 delay:0];
}
-(void) showMessage:(ccTime*) dt{
    [_m showMessageLayer:@"your answer is correct define new string after 3 seconds..." message2:[NSString stringWithFormat:@"%i",listenCounter] showButton:NO buttonAction:0];
    listenCounter--;
    [_m setVisible:YES];
    if(listenCounter<0){
        [_m setVisible:NO];
        listenCounter = 3;
        [delegate performSelector:selector];
    }
}
@end
