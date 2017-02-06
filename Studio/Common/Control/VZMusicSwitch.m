//
//  VZMusicSwitch.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-12.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZMusicSwitch.h"
#import "VZAudioManager.h"
@implementation VZMusicSwitch


-(id)initWithTitle:(NSString *)title spriteFrame:(CCSpriteFrame *)spriteFrame highlightedSpriteFrame:(CCSpriteFrame *)highlighted disabledSpriteFrame:(CCSpriteFrame *)disabled
{
    if(self = [super initWithTitle:title spriteFrame:spriteFrame highlightedSpriteFrame:highlighted disabledSpriteFrame:disabled])
    {
        [self setBackgroundColor:[CCColor colorWithWhite:0.7 alpha:1] forState:CCControlStateDisabled];
        [self setLabelColor:[CCColor colorWithWhite:0.7 alpha:1] forState:CCControlStateDisabled];
        
        [self setBackgroundOpacity:0.7f forState:CCControlStateHighlighted];
        [self setLabelOpacity:0.7f forState:CCControlStateHighlighted];
        
        if([[VZAudioManager sharedVZAudioManager] isMusicEnable])
        {
            self.selected = YES;
        }
        else
        {
            self.selected = NO;
        }
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected)
    {
        [VZAudioManager sharedVZAudioManager].music = 1.0;
    }
    else
    {
        [VZAudioManager sharedVZAudioManager].music = 0.0;
    }
}

@end
