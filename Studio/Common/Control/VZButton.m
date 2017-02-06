//
//  VZButton.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-11.
//  Copyright 2014年 穆暮. All rights reserved.
//

#import "VZButton.h"
#import "CCControlSubclass.h"
#import "VZAudioManager.h"
@implementation VZButton

- (id) initWithTitle:(NSString*) title spriteFrame:(CCSpriteFrame*) spriteFrame
{
    if (self = [super initWithTitle:title spriteFrame:spriteFrame highlightedSpriteFrame:NULL disabledSpriteFrame:NULL])
    {
        // Setup default colors for when only one frame is used
        [self setBackgroundColor:[CCColor colorWithWhite:0.7 alpha:1] forState:CCControlStateDisabled];
        [self setLabelColor:[CCColor colorWithWhite:0.7 alpha:1] forState:CCControlStateDisabled];
        
        [self setBackgroundOpacity:0.7f forState:CCControlStateHighlighted];
        [self setLabelOpacity:0.7f forState:CCControlStateHighlighted];
        
        self.effectFile = @"button.mp3";
        
        self.labelPosition = ccp(0.5, 0.5);
    }
    return self;
}

-(void)dealloc
{
    self.effectFile = nil;
}

- (void) layout
{
    [super layout];
    self.label.positionType = CCPositionTypeNormalized;
    self.label.position = self.labelPosition;
}

-(void)setLabelPosition:(CGPoint)labelPosition
{
    _labelPosition = labelPosition;
    [self layout];
}

-(void)triggerAction
{
    if(self.effectFile)
    {
        [[VZAudioManager sharedVZAudioManager] playEffect:self.effectFile];
    }
    [super triggerAction];
}

-(void)setOpacity:(CGFloat)opacity
{
    [super setOpacity:opacity];
    self.background.opacity = opacity;
    self.label.opacity = opacity;
}


@end
