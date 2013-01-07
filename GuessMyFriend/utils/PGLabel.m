//
//  PGLabel.m
//  Amip
//
//  Created by YALCIN YAVUZ on 2/4/12.
//  Copyright 2011. All rights reserved.
//

#import "PGLabel.h"
#define CC_FONT_LABEL_SUPPORT	1.

@implementation PGLabel
@synthesize fontSize;
@synthesize text;
@synthesize aText=_aText;
@synthesize aLabelColor=_aLabelColor;

@synthesize color;


- (id) labelWithString:(NSString *)text fontName:(NSString *)name fontSize:(CGFloat)size lblSize:(CGSize) lblSize alingment:(CCTextAlignment)alignment
{
    if ((self = [super init]))
	{
        [_text autorelease];
        [_fontName autorelease];
        
        _text = [text retain];
        _fontName = [name retain];
        _labelColor = ccc3(255,255,255);
        _shadowLabelColor  = ccc3(0,0,0);
        _fontSize = size;
        _lblSize=lblSize;
        _alignment=alignment;
        [self initLabels];
	}
	return self;
    
	//PGLabel* lbl = [[PGLabel alloc] initWithString:text fontName:name fontSize:size lblSize:lblSize alingment:alignment];	
	//return lbl;
}

-(void) initLabels
{
    label= [[CCLabelTTF labelWithString:_text
                             dimensions:_lblSize alignment:_alignment fontName:_fontName fontSize:_fontSize] retain];
    // label = [[CCLabelTTF labelWithString:_text fontName:_fontName fontSize:_fontSize ] retain];
    label.color = _labelColor;
    // shadowLabel = [[CCLabelTTF labelWithString:_text fontName:_fontName fontSize:_fontSize] retain];
    
    shadowLabel=[[CCLabelTTF labelWithString:_text
                                  dimensions:_lblSize alignment:_alignment fontName:_fontName fontSize:_fontSize] retain];
    shadowLabel.position =  ccp(label.position.x+1, label.position.y-1);
    shadowLabel.color = _shadowLabelColor;
    [self addChild:shadowLabel];
    [self addChild:label];
}

-(void) removeLabels {
    if (label) {
        [self removeChild:label cleanup:YES];
        [label release];
    }
    if (shadowLabel) {
        [self removeChild:shadowLabel cleanup:YES];
        [shadowLabel release];
    }
    label=nil;
    shadowLabel=nil;
}

- (id) init
{
	NSAssert(NO, @"-init not available on PGLabel class");
	return nil;
}

- (id) initWithString:(NSString *)text fontName:(NSString *)name fontSize:(CGFloat)size lblSize:(CGSize) lblSize alingment:(CCTextAlignment)alignment
{
    
}

- (void)dealloc 
{
    // [[TextureMgr sharedTextureMgr] removeUnusedTextures];
    [self removeLabels];
    [_text release];
    [_aText release];
    [_fontName release];
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

#pragma mark -
#pragma mark setters/ getters


- (NSUInteger) fontSize
{
    return(_fontSize);
}

-(void) setFontSize:(NSUInteger)fontSize
{
    if (fontSize==_fontSize)
        return;
    [self removeLabels];
    _fontSize =fontSize;
    [self initLabels];
}

-(void) setAnchorPoint:(CGPoint)anchorPoint
{
    [shadowLabel setAnchorPoint:anchorPoint];
    [label setAnchorPoint:anchorPoint];
}

- (ccColor3B) color
{
    return(_labelColor);
}
- (void) setColor:(ccColor3B)newColor
{
    _labelColor = newColor;
    [self removeLabels];
    [self initLabels];
}
- (void) setShadowColor:(ccColor3B)newColor
{
    _shadowLabelColor = newColor;
    [self removeLabels];
    [self initLabels];
}

-(void) setcolorAndShadow:(ccColor3B)newColor:(ccColor3B)newShadowColor
{
    _labelColor = newColor;
    _shadowLabelColor = newShadowColor;
    [self removeLabels];
    [self initLabels];
}

- (NSString *) text
{
    return(_text);
}

-(void) setAnimText:(NSString *) Text:(ccColor3B) Color 
{
    
    
    // id actionBy = [CCScaleBy actionWithDuration:0.3 scaleX:1.0 scaleY:0.0];
    id actionBy = [CCFadeOut actionWithDuration:0.3];
    id actionByBack = [actionBy reverse];
    CCSequence *ccSeq=[CCSequence actions:                          
                       actionBy,
                       [CCCallFunc actionWithTarget:self selector:@selector(endAnim)],actionByBack,
                       nil];
    [self runAction:ccSeq];
    self.aLabelColor=Color;
    self.aText=Text;
}


-(void)endAnim
{
    _labelColor=self.aLabelColor;
    self.text=self.aText;
    
}

-(CGSize) getSize
{
    return label.contentSize;
}


-(void) setText:(NSString *)text
{
    
    
   // if (_text && ([_text compare:text]==NSOrderedSame))
   //     return;
    [_text release];
    _text = [text retain];
    
    [self removeLabels];
    [self initLabels];
}

-(void) setOpacity:(GLbyte)opcatiy
{
    [shadowLabel setOpacity:opcatiy];
    [label setOpacity:opcatiy];
}
-(GLbyte) getOpacity
{
    return label.opacity;
}




@end
