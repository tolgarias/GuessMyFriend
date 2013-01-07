//
//  MessageLayer.m
//  GuessMyFriend
//
//  Created by Tolga Saglam on 11/20/12.
//
//

#import "MessageLayer.h"

@implementation MessageLayer
@synthesize bg,border,label1,label3,button,label2;

-(void) initObjects {
    CGSize size = [[CCDirector sharedDirector] winSize];
    bg = [CCSprite spriteWithFile:@"blank.png" rect:CGRectMake(0, 0, 200, 200)];
    bg.color = ccc3(0, 0, 255);
    bg.position= ccp(size.width/2, size.height/2);
    
    border = [CCSprite spriteWithFile:@"blank.png" rect:CGRectMake(0, 0, 202, 202)];
    border.color = ccc3(255, 255, 255);
    border.position= ccp(size.width/2, size.height/2);
    
    
    label1 = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:20];
    label1.position = ccp(size.width/2, size.height/2+50);
    
    label2 = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:20];
    label2.position = ccp(size.width/2, size.height/2+35);
    
    label3 = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:20];
    label3.position = ccp(size.width/2, size.height/2);
    
    
    button = [[Utilities sharedInstance] makeButton:@"Icon.png" text:@"OK" x:size.width/2 y:size.height/2-60 param:1];
    button.selector = @selector(onOkButtonPressed:);
    button.delegate = self;
    
    [self addChild:border z:0];
    [self addChild:bg z:1];
    [self addChild:label1 z:2];
    [self addChild:label2 z:2];
    [self addChild:label3 z:2];
    [self addChild:button z:2];
}
-(id) init {
    self = [super init];
    [self initObjects];
    return  self;
}

-(void) showWait:(NSString *)message {
    CGSize size = [[CCDirector sharedDirector] winSize];
    /*CCSprite* bg = [CCSprite spriteWithFile:@"blank.png" rect:CGRectMake(0, 0, 200, 200)];
    bg.color = ccc3(0, 0, 255);
    bg.position= ccp(size.width/2, size.height/2);
    
    CCSprite* border = [CCSprite spriteWithFile:@"blank.png" rect:CGRectMake(0, 0, 202, 202)];
    border.color = ccc3(255, 255, 255);
    border.position= ccp(size.width/2, size.height/2);
    
    
    CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:message fontName:@"Marker Felt" fontSize:20];
    nameLabel.position = ccp(size.width/2, size.height/2);
    
    
    [self addChild:border z:0];
    [self addChild:bg z:1];
    [self addChild:nameLabel z:2];
    */
}
-(void) showStringSend {
    //[self cleanup];
    /*[self removeAllChildrenWithCleanup:YES];
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite* bg = [CCSprite spriteWithFile:@"blank.png" rect:CGRectMake(0, 0, 200, 200)];
    bg.color = ccc3(0, 0, 255);
    bg.position= ccp(size.width/2, size.height/2);
    
    CCSprite* border = [CCSprite spriteWithFile:@"blank.png" rect:CGRectMake(0, 0, 202, 202)];
    border.color = ccc3(255, 255, 255);
    border.position= ccp(size.width/2, size.height/2);
    
    
    CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:@"your string is sent..." fontName:@"Marker Felt" fontSize:20];
    nameLabel.position = ccp(size.width/2, size.height/2);
    
    BasicButton* button = [[Utilities sharedInstance] makeButton:@"Icon.png" text:@"OK" x:size.width/2 y:size.height/2-60 param:1];
    button.selector = @selector(onOkButtonPressed:);
    button.delegate = self;
    
    //[button setVisible:NO];
    [self addChild:border z:0];
    [self addChild:bg z:1];
    [self addChild:nameLabel z:2];
    [self addChild:button z:3];
     */
}
-(void) onOkButtonPressed:(id) sender {
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app showProfileScreen];

}
-(void) showMessageLayer:(NSString*)message1 message2:(NSString*) message2 message3:(NSString*) message3 showButton:(BOOL) showButton buttonAction:(int) action {
    [label1 setString:message1];
    [label2 setString:message2];
    [label3 setString:message3];
    buttonAction = action;
    [button setVisible:showButton];
}
@end
