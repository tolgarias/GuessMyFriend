//
//  PGLabel.h
//  Amip
//
//  Created by YALCIN YAVUZ on 2/4/12.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PGLabel : CCLayer {
    CCLabelTTF *label, *shadowLabel;
    
    NSString *_text;
    NSString *_aText;
    
    NSUInteger _fontSize;  
    ccColor3B _labelColor;
    ccColor3B _aLabelColor;
    ccColor3B _shadowLabelColor;
    BOOL _hasShadow;
    NSString *_fontName;
    CGSize _lblSize;
    CCTextAlignment _alignment;
}

@property (nonatomic, assign) NSUInteger fontSize;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *aText;

@property (nonatomic, assign) ccColor3B color;
@property (nonatomic, assign) ccColor3B aLabelColor;


- (id) labelWithString:(NSString *)text fontName:(NSString *)name fontSize:(CGFloat)size lblSize:(CGSize) lblSize alingment:(CCTextAlignment)alignment;

-(void) setOpacity:(GLbyte)opcatiy;
-(GLbyte) getOpacity;

- (void) setColor:(ccColor3B)newColor;
- (void) setShadowColor:(ccColor3B)newColor;
-(void) setcolorAndShadow:(ccColor3B)newColor:(ccColor3B)newShadowColor;
-(CGSize) getSize;

@end
