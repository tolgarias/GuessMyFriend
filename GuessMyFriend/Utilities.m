//
//  Utilities.m
//  GuessMyFriend
//
//  Created by bilal demirci on 10/17/12.
//
//

#import "Utilities.h"

@implementation Utilities

static Utilities* sharedInstance;
+(Utilities*) sharedInstance {
    if(sharedInstance==nil){
        sharedInstance = [[Utilities alloc] init];
    }
    //Utilities* util = [Utilities node];
    return sharedInstance;
}

-(id) init{
    self = [super init];
    return self;
}

-(CCSprite*) getProfileImage:(NSString *)username imgType:(NSString *)type {
    NSString *imgAdd = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=%@",username,type];
    //NSString *fileName = [NSString stringWithFormat:@"%@.png",username];
    return [self getProfileImage:username imgType:type withUrl:imgAdd];
}

-(CCSprite*) getProfileImage:(NSString *)username imgType:(NSString *)type withUrl:(NSString *)url{
    //NSString *imgAdd = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=%@",username,type];
    NSURL* url2 = [NSURL URLWithString:url];
    CCSprite *spr;
    UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url2]];
    spr=[CCSprite spriteWithCGImage:img.CGImage key:username];
    return spr;
}


-(BasicButton*) makeButton:(NSString*) file text:(NSString*) tx x:(int) xPos y:(int) yPos param:(int)p{
    BasicButton *btnSDown = [BasicButton buttonWithFile:file  shadowFile:nil highlightFile:file andText:tx];
    btnSDown.fontName=@"Helvetica-Bold";
    btnSDown.label.position=ccp(btnSDown.label.position.x,btnSDown.label.position.y);
    btnSDown.anchorPoint=ccp(0.0f,0.0f);
    btnSDown.position = ccp(xPos,yPos);
    btnSDown.delegate = self;
    btnSDown.selector = @selector(onButtonPressed:);
    btnSDown.actionTouch = [CCScaleTo actionWithDuration:0.1 scale:0.9f];
    btnSDown.actionRelease = [CCScaleTo actionWithDuration:0.1 scale:1.0f];
    btnSDown.visible = YES;
    btnSDown.param_1=p;
    return btnSDown;
}

-(BasicButton*) makeButtonWithSprite:(CCSprite*) file text:(NSString*) tx x:(int) xPos y:(int) yPos param:(int)p{
    BasicButton *btnSDown = [BasicButton buttonWithSprite:file  shadowFile:nil andText:tx];
    btnSDown.fontName=@"Helvetica-Bold";
    btnSDown.label.position=ccp(btnSDown.label.position.x,btnSDown.label.position.y);
    btnSDown.anchorPoint=ccp(0.0f,0.0f);
    btnSDown.position = ccp(xPos,yPos);
    btnSDown.delegate = self;
    btnSDown.selector = @selector(onButtonPressed:);
    btnSDown.actionTouch = [CCScaleTo actionWithDuration:0.1 scale:0.9f];
    btnSDown.actionRelease = [CCScaleTo actionWithDuration:0.1 scale:1.0f];
    btnSDown.visible = YES;
    btnSDown.param_1=p;
    return btnSDown;
}
@end
