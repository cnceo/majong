//
//  PauseLayer.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-16.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "DailyChallengePauseLayer.h"
#import "VZCommonDefine.h"
#import "VZButton.h"
#import "VZMusicSwitch.h"
#import "VZSoundSwitch.h"
#import "LevelScene.h"
#import "DailyChallengeGameScene.h"
#import "TitleScene.h"
@implementation DailyChallengePauseLayer

+(DailyChallengePauseLayer*)layerWithSeason:(int)season Level:(int)level
{
    return [[self alloc] initWithSeason:season Level:level];
}

-(id)initWithSeason:(int)season Level:(int)level
{
    CCColor* color = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.90];
    if(self = [super initWithColor:color])
    {
        CCSprite* bg = [CCSprite spriteWithImageNamed:@"bg_window.png"];
        bg.position = ccp(0, 0);
        [self.window addChild:bg];
        
        CCLabelTTF* title = [CCLabelTTF labelWithString:NSLocalizedString(@"Pause", nil)  fontName:SYSTEM_FONT fontSize:28];
        title.position = ccp(0, 60);
        title.color = [CCColor colorWithCcColor3b:ccc3(0, 209, 251)];
        [self.window addChild:title];
        
        _levelLabel = [CCLabelTTF labelWithString:@"" fontName:SYSTEM_FONT fontSize:16];
        _levelLabel.position = ccp(0, 35);
        _levelLabel.shadowColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _levelLabel.shadowBlurRadius = 2;
        _levelLabel.outlineColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _levelLabel.outlineWidth = 1;
        [self.window addChild:_levelLabel];
        
        VZButton* btResume = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_resume.png"]];
        btResume.position = ccp(0, -5);
        [btResume setTarget:self selector:@selector(onResume:)];
        [self.window addChild:btResume];
        
        VZButton* btMenu = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_menu.png"]];
        btMenu.position = ccp(-80, -50);
        [btMenu setTarget:self selector:@selector(onMenu:)];
        [self.window addChild:btMenu];
        
        VZButton* btReplay = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_replay.png"]];
        btReplay.position = ccp(80, -50);
        [btReplay setTarget:self selector:@selector(onReplay:)];
        [self.window addChild:btReplay];
     
        
        VZMusicSwitch *btMusic = [VZMusicSwitch buttonWithTitle:@""
                                                    spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_music_off.png"]
                                         highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_music_on.png"]
                                            disabledSpriteFrame:nil];
        
        
        btMusic.position = ccp(-25, -53);
        [self.window addChild:btMusic];
        
        
        VZSoundSwitch *btSound = [VZSoundSwitch buttonWithTitle:@""
                                                    spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_sound_off.png"]
                                         highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_sound_on.png"]
                                            disabledSpriteFrame:nil];
        
        btSound.position = ccp(25, -53);
        [self.window addChild:btSound];
        
        self.level = level;
        _season = season;
        
    }
    return self;
}

-(void)setLevel:(int)level
{
    _level = level;
    
    _levelLabel.string = @"";
}

- (void)onResume:(id)sender
{
    self.parent.paused = NO;
    [self removeFromParent];
   
}

- (void)onMenu:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

- (void)onReplay:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[DailyChallengeGameScene scene] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}


@end
