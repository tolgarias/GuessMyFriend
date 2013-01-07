//
//  BasicButton.m
//  Amip
//
//  Created by YALCIN YAVUZ on 2/4/12..
//  Copyright 2011.. All rights reserved.
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

#import "BasicButton.h"

#define kBtnTag 20
#define kShadowTag 21
#define kHighlightTag 22

@interface BasicButton (Private)
- (BOOL) touchInButton:(UITouch*)touch;
@end

@implementation BasicButton

@synthesize delegate = m_delegate;
@synthesize selector = m_selector;
@synthesize actionTouch = m_actionTouch;
@synthesize actionRelease = m_actionRelease;
@synthesize  param_1;
@synthesize text;
@synthesize label;
@synthesize fontName;
@synthesize fontSize;
@synthesize highlighted;
@synthesize priority;
@synthesize SPshadow;
@synthesize SPbtn;
@synthesize SPhighlight;
@synthesize m_text;
@synthesize opcatiy=_opcatiy;



+ (BasicButton*) buttonWithFile:(NSString*)file shadowFile:(NSString *)shadowFile andText:(NSString *)txt
{
	BasicButton* btn = [[[BasicButton alloc] initWithFile:file shadowFile:shadowFile andText:txt] autorelease];
	
	return btn;
}

+ (BasicButton*) buttonWithFileAndPriority:(NSString*)file  highlightFile:(NSString *)highlightFile shadowFile:(NSString *)shadowFile andText:(NSString *)txt Priority:(NSInteger)Priority
{
   	BasicButton* btn = [[[BasicButton alloc] initWithFileAndPriorty:file shadowFile:shadowFile  highlightFile:highlightFile andText:txt  Priorty:Priority] autorelease];
    return btn;
}



+ (BasicButton*) buttonWithFile:(NSString*)file shadowFile:(NSString *)shadowFile highlightFile:(NSString *)highlightFile andText:(NSString *)txt
{
	BasicButton* btn = [[[BasicButton alloc] initWithFile:file shadowFile:shadowFile highlightFile:highlightFile andText:txt] autorelease];
	return btn;
}


+ (BasicButton*) buttonWithSprite:(CCSprite*)file shadowFile:(NSString *)shadowFile andText:(NSString *)txt
{
	BasicButton* btn = [[[BasicButton alloc] initWithFile:file shadowFile:shadowFile highlightFile:nil andText:txt fontName:@"Arial Rounded MT Bold" fontSize:13] autorelease];
	
	return btn;
}

- (id) init
{
    
	NSAssert(NO, @"-init not available on BasicButton class");
	return nil;
}




//- (id) initWithFile:(NSString*)file shadowFile:(NSString *)shadowFile highlightFile:(NSString *)highlightFile andText:(NSString *)txt fontName:(NSString *)fontName fontSize:(NSUInteger)fontSize
-(id) initWithFile:(CCSprite*)file shadowFile:(NSString *)shadowFile highlightFile:(NSString *)highlightFile andText:(NSString *)txt fontName:(NSString *)fontName fontSize:(NSUInteger)fontSize
{
	if ( (self = [super init]) )
	{
        changeBtnImage=false;
        isTouchBegan=FALSE;
        
		//self.SPbtn = [CCSprite spriteWithFile:file];
        self.SPbtn = file;
		self.SPbtn.tag = kBtnTag;
		[self addChild:self.SPbtn];
        if (shadowFile) {
            self.SPshadow = [CCSprite spriteWithFile:shadowFile];
            self.SPshadow.tag = kShadowTag;
            self.SPshadow.anchorPoint=ccp(0.0f,0.0f);
            [self addChild:self.SPshadow z:-1];
            self.SPshadow.position = ccp(self.SPbtn.position.x+1, self.SPbtn.position.x-1);
        }
        if (highlightFile) {
            self.SPhighlight = [CCSprite spriteWithFile:highlightFile];
            self.SPhighlight.anchorPoint=ccp(0.0f,0.0f);
            self.SPhighlight.tag = kHighlightTag;
            [self addChild:self.SPhighlight z:2];
            self.SPhighlight.position = self.SPbtn.position;
            self.SPhighlight.anchorPoint=self.SPbtn.anchorPoint;
            self.SPhighlight.visible = NO;
        }
        
        //if(![file isEqualToString:highlightFile])
          //  changeBtnImage=true;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        
		[self setContentSize:self.SPbtn.contentSize];
        m_text = [txt retain];
        m_fontName = [fontName retain];
        label = [[PGLabel alloc] labelWithString:m_text fontName:m_fontName fontSize:fontSize lblSize:CGSizeMake(self.SPbtn.contentSize.width,fontSize+4.0) alingment:UITextAlignmentCenter];
        label.position=ccp(  self.SPbtn.position.x,self.SPbtn.position.y);
        //   NSLog(@"w:%f  h:%f",self.SPbtn.contentSize.width,self.SPbtn.contentSize.height);
		[self addChild:label z:3];
		self.isTouchEnabled = YES;
        _fontSize = fontSize;
        _highlighted = NO;
	}
	return self;
}



- (id) initWithFile:(NSString*)file shadowFile:(NSString *)shadowFile highlightFile:(NSString *)highlightFile andText:(NSString *)txt 
{
    CCSprite* sprite = [CCSprite spriteWithFile:file];
    return([self initWithFile:sprite shadowFile:shadowFile highlightFile:highlightFile andText:txt fontName:@"Arial Rounded MT Bold" fontSize:13]);
}
- (id) initWithFile:(NSString*)file shadowFile:(NSString *)shadowFile andText:(NSString *)txt
{
    return([self initWithFile:file shadowFile:shadowFile highlightFile:nil andText:txt]);
}

- (id) initWithFileAndPriorty:(NSString*)file shadowFile:(NSString *)shadowFile   highlightFile:(NSString *)highlightFile andText:(NSString *)txt Priorty:(NSInteger) Priorty
{
    self.priority=Priorty;
    return([self initWithFile:file shadowFile:shadowFile highlightFile:highlightFile andText:txt]);
}

- (void) dealloc
{
    
    
    
    [m_actionTouch stop];
    [m_actionRelease stop];
	[m_actionTouch release];
	[m_actionRelease release];
    [self stopAllActions];
    [text release];
    [m_text release]; 
    [fontName release];
    
    [label release];
    
	[super dealloc];
}

-(void) registerWithTouchDispatcher
{	
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:self.priority swallowsTouches:YES];
}


- (BOOL) touchInButton:(UITouch*)touch:(CGRect) margin
{
	BOOL result = NO;
    
	CGPoint pt = self.SPbtn.position;
    
    //	CGPoint touchPt = [touch locationInView:touch.view];
    CGPoint touchPt = [touch locationInView: [[CCDirector sharedDirector]  openGLView]];    // button pos should be relative to screen, not if moved in views (like scrollview)
	touchPt = [[CCDirector sharedDirector] convertToGL:touchPt];
	CGPoint local = [self.SPbtn convertToNodeSpace:touchPt];
	CGRect r = CGRectMake(pt.x-margin.origin.x, pt.y-margin.origin.y, self.SPbtn.contentSize.width+margin.size.width, self.SPbtn.contentSize.height+margin.size.height);
	r.origin = CGPointZero;
 
	if( CGRectContainsPoint( r, local ) )
	{
		result = YES;
	}
	
	return result;
}

#pragma mark -
#pragma mark Touch events

- (BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
    
	if ([self touchInButton:touch:CGRectMake(0.0,0.0,0.0,0.0)] && self.visible)
	{
		if ( m_actionTouch )
		{
            if(!changeBtnImage){
                [self stopAllActions];
                [self runAction:m_actionTouch];
            }else
            {
                [self setHighlighted:TRUE];
            }
            // [m_delegate performSelector:m_selector withObject:self];
		}
		isTouchBegan=true;
		return YES;
	}
	
	return NO;
}


- (void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent*)event
{
	if (![self touchInButton:touch:CGRectMake(40.0, 40.0, 40.0, 40.0)]  && self.visible && isTouchBegan)
	{
        isTouchBegan=FALSE;
		if ( m_actionRelease )
		{
            if(!changeBtnImage)
            {
                [self stopAllActions];
                [self runAction:m_actionRelease];
            }
            else
            {
                [self setHighlighted:FALSE];
            }
            
            // NSLog(@"ETKIII");
        }
    }
}


-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self touchEndAnim];
}


-(void) touchEndAnim
{
    if (self.visible&&isTouchBegan)
	{
        isTouchBegan=false;
        
		if ( m_actionRelease )
        {
            if(!changeBtnImage)
            {
                if ([self numberOfRunningActions]>0) {
                    CCSequence *sq = [CCSequence actions:(CCFiniteTimeAction*)m_actionTouch, m_actionRelease, nil];
                    [self stopAllActions];
                    [self runAction:sq];
                } else
                    [self runAction:m_actionRelease];
            }else
            {
                [self setHighlighted:FALSE];
            }
		}
	}
}


- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    [self touchEndAnim];
    if([self touchInButton:touch:CGRectMake(20.0, 20.0, 20.0, 20.0)]  && self.visible)
    {
        if ( m_delegate && m_selector )
			[m_delegate performSelector:m_selector withObject:self];
    }
}

#pragma mark -


- (NSUInteger) fontSize
{
    return(_fontSize);
}

-(void) setFontSize:(NSUInteger)fontSize
{
    if (fontSize==_fontSize)
        return;
    label.fontSize = fontSize;
}



- (NSInteger) param_1
{
    return(_param_1);
}

-(void) setParam_1:(NSInteger)param_1
{
    if (param_1==_param_1)
        return;
    _param_1=param_1;
}

-(void) setAllOpacity:(GLbyte)opcatiy
{
    [self.SPbtn setOpacity:opcatiy];
    [self.SPshadow setOpacity:opcatiy];
    [self.SPhighlight setOpacity:opcatiy];
    [self.label  setOpacity:opcatiy];
    
}


-(void) setOpacity:(GLbyte)opcatiy
{
    _opcatiy=opcatiy;
    [self.SPbtn setOpacity:opcatiy];
    [self.SPshadow setOpacity:opcatiy];
    [self.SPhighlight setOpacity:opcatiy];
    [self.label  setOpacity:opcatiy];
  //  [super setOpacity:opcatiy];
}


-(void) setAllTexture:(CCTexture2D *)texture;
{
    [self.SPbtn setTexture:texture];
    [self.SPshadow setTexture:texture];    
}



- (NSString *) text
{
    return(m_text);
}

- (void) setText:(NSString *)text {
    m_text = text;
    label.text = text;
}

- (NSString *) fontName
{
    return(m_fontName);
}

- (void) setFontName:(NSString *)fontName {
    m_fontName = fontName;
    [label removeFromParentAndCleanup:YES];
    [label release];
    label = [[PGLabel alloc] labelWithString:m_text fontName:m_fontName fontSize:_fontSize lblSize:CGSizeMake(self.SPbtn.contentSize.width,_fontSize+4.0)  alingment:UITextAlignmentCenter];
    label.position=ccp(  self.SPbtn.position.x,self.SPbtn.position.y);
    // label.position=ccp(  btn.position.x,self.contentSize.height-  btn.position.y+ btn.contentSize.height/2);
    [self addChild:label z:3];
}

- (BOOL) highlighted
{
    return(_highlighted);
}

- (void) setHighlighted:(BOOL)value {
    if (_highlighted == value)
        return;
    _highlighted = value;
    CCSprite *btn = (CCSprite*)[self getChildByTag:kBtnTag];
    CCSprite *shadow = (CCSprite*)[self getChildByTag:kShadowTag];
    CCSprite *highlight = (CCSprite*)[self getChildByTag:kHighlightTag];
    
    highlight.position=btn.position;
    highlight.opacity=btn.opacity;
    highlight.rotation=btn.rotation;
    highlight.anchorPoint=btn.anchorPoint;
    
    if (!highlight)
        return;
    btn.visible = !_highlighted;
    shadow.visible = !_highlighted;
    highlight.visible = _highlighted;
}

-(void) runPressActions {
    CCSequence *sq = [CCSequence actions:(CCFiniteTimeAction*)m_actionTouch, m_actionRelease, nil];
    [self stopAllActions];
    [self runAction:sq];
}

@end