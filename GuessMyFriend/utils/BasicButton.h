//
//  BasicButton.h
//  Amip
//
// Created by YALCIN YAVUZ on 2/4/12.
//  Copyright 2011. All rights reserved.
//
//  based on http://blog.petermares.com/2010/12/29/cocos2d-iphone-a-basic-button-class/
//  but with some extensions/ midifications
//  how to use:
//
//  BasicButton *btn = [BasicButton buttonWithFile:@"button.png"];
//  btn.position = ccp( winSize.width/2, winSize.height/2 );
//
//  btn.delegate = self;
//  btn.selector = @selector(onButtonPressed);
//
//  btn.actionTouch = [CCScaleTo actionWithDuration:0.1 scale:1.1f];
//  btn.actionRelease = [CCScaleTo actionWithDuration:0.1 scale:1.0f];
//
//  [self addChild:btn];
//
//- (void) onButtonPressed
//{
//	NSLog(@"The button was pressed");
//}

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PGLabel.h"

@interface BasicButton : CCLayer 
{
	id m_delegate;
    SEL m_selector;
	CCAction *m_actionTouch;
	CCAction *m_actionRelease;
    //CCLabelTTF *label, *shadowLabel;
    PGLabel *label;
    NSString *m_text;
    NSString *m_fontName;
    NSUInteger _fontSize;
    NSInteger  _param_1;
    BOOL _highlighted;
    
    CCSprite *SPshadow;
    CCSprite *SPbtn;
    CCSprite *SPhighlight;
    
    BOOL changeBtnImage;
    BOOL isTouchBegan;
    NSInteger _priority;
    
    GLbyte _opcatiy;
    
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, retain) CCAction *actionTouch;
@property (nonatomic, retain) CCAction *actionRelease;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *m_text;
@property (readonly) PGLabel *label;
@property (nonatomic, retain) NSString *fontName;
@property (nonatomic, assign) NSUInteger fontSize;
@property (nonatomic, assign) NSInteger param_1;
@property (nonatomic, assign) NSInteger priority;

@property (nonatomic, assign) CCSprite *SPshadow;
@property (nonatomic, assign) CCSprite *SPbtn;
@property (nonatomic, assign) CCSprite *SPhighlight;

@property (nonatomic, assign) BOOL highlighted;

@property (nonatomic, assign) GLbyte opcatiy;


+ (BasicButton*) buttonWithFile:(NSString*)file shadowFile:(NSString *)shadowFile andText:(NSString *)txt;
+ (BasicButton*) buttonWithFile:(NSString*)file shadowFile:(NSString *)shadowFile highlightFile:(NSString *)highlightFile andText:(NSString *)txt;
+ (BasicButton*) buttonWithFileAndPriority:(NSString*)file  highlightFile:(NSString *)highlightFile shadowFile:(NSString *)shadowFile andText:(NSString *)txt Priority:(NSInteger)Priority;

+ (BasicButton*) buttonWithSprite:(CCSprite*)file shadowFile:(NSString *)shadowFile andText:(NSString *)txt;

- (id) initWithFile:(CCSprite*)file shadowFile:(NSString *)shadowFile highlightFile:(NSString *)highlightFile andText:(NSString *)txt fontName:(NSString *)fontName fontSize:(NSUInteger)fontSize;
- (id) initWithFile:(NSString*)file shadowFile:(NSString *)shadowFile highlightFile:(NSString *)highlightFile andText:(NSString *)txt;
- (id) initWithFile:(NSString*)file shadowFile:(NSString *)shadowFile andText:(NSString *)txt;
- (id) initWithFileAndPriorty:(NSString*)file shadowFile:(NSString *)shadowFile   highlightFile:(NSString *)highlightFile andText:(NSString *)txt Priorty:(NSInteger) Priorty;

//- (id) initWithSprite:(CCSprite *) sprite shadowFile:(NSString *) shadowSprite andText:(NSString*)txt;


-(void) setAllOpacity:(GLbyte)opcatiy;
-(void) setOpacity:(GLbyte)opcatiy;
-(GLbyte) getAllOpacity;
-(void) setAllTexture:(CCTexture2D *)texture;
-(void) registerWithTouchDispatcher;

-(void) runPressActions;
@end
