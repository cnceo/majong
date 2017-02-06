//
//  VZToggle.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-11.
//  Copyright 2014年 穆暮. All rights reserved.
//

#import "VZSwitch.h"
#import "CCControlSubclass.h"
#import "VZAudioManager.h"
@implementation VZSwitch

-(id)initWithTitle:(NSString *)title spriteFrame:(CCSpriteFrame *)spriteFrame highlightedSpriteFrame:(CCSpriteFrame *)highlighted disabledSpriteFrame:(CCSpriteFrame *)disabled
{
    if(self = [super initWithTitle:title spriteFrame:spriteFrame highlightedSpriteFrame:highlighted disabledSpriteFrame:disabled])
    {
        [self setBackgroundColor:[CCColor colorWithWhite:0.7 alpha:1] forState:CCControlStateDisabled];
        [self setLabelColor:[CCColor colorWithWhite:0.7 alpha:1] forState:CCControlStateDisabled];
        
        [self setBackgroundOpacity:0.7f forState:CCControlStateHighlighted];
        [self setLabelOpacity:0.7f forState:CCControlStateHighlighted];
        
        [self setBackgroundSpriteFrame:[self backgroundSpriteFrameForState:CCControlStateNormal] forState:CCControlStateHighlighted];
        [self setBackgroundSpriteFrame:[self backgroundSpriteFrameForState:CCControlStateNormal] forState:CCControlStateDisabled];
        self.effectFile = @"button.mp3";
        self.togglesSelectedState = YES;
    }
    return self;
}

-(void)dealloc
{
    self.effectFile = nil;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected)
    {
        [self setBackgroundSpriteFrame:[self backgroundSpriteFrameForState:CCControlStateSelected] forState:CCControlStateHighlighted];
        [self setBackgroundSpriteFrame:[self backgroundSpriteFrameForState:CCControlStateSelected] forState:CCControlStateDisabled];
    }
    else
    {
        [self setBackgroundSpriteFrame:[self backgroundSpriteFrameForState:CCControlStateNormal] forState:CCControlStateHighlighted];
        [self setBackgroundSpriteFrame:[self backgroundSpriteFrameForState:CCControlStateNormal] forState:CCControlStateDisabled];
    }
}

-(void)triggerAction
{
    //[[VZAudioManager sharedVZAudioManager] playEffect:self.effectFile];
    [super triggerAction];
}

- (void) touchEntered:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super touchEntered:touch withEvent:event];
    if (self.effectFile)
    {
        [[VZAudioManager sharedVZAudioManager] playEffect:self.effectFile];
    }
}

-(void)setOpacity:(CGFloat)opacity
{
    [super setOpacity:opacity];
    self.background.opacity = opacity;
    self.label.opacity = opacity;
}

@end
