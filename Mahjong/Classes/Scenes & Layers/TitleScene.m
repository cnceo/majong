//
//  TitleScene.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-11.
//  Copyright 2014年 穆暮. All rights reserved.
//

#import "TitleScene.h"
#import "VZAlertLayer.h"
#import "VZButton.h"
#import "VZMusicSwitch.h"
#import "VZSoundSwitch.h"
#import "HelpLayer.h"
#import "SeasonScene.h"

#import "VZIdentifyManager.h"
#import "VZShareManager.h"

#import "VZAudioManager.h"
#import "StatisticsLayer.h"
#import "ShopLayer.h"
#import "DailyChallengeGameScene.h"
#import "VZArchiveManager.h"
#import "VZCircleMoveForParticle.h"
@implementation TitleScene
{
    
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (TitleScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    CGPoint PosBG       = [self APFP:ccp(240, 160)];
    CGPoint PosTitle    = [self APFP:ccp(229, 258)];
    CGPoint PosPlay     = [self APFP:ccp(240, 148)];
    
    CGPoint PosUIBG     = [self APFP:ccp(240, 56)];
    CGPoint PosLeader   = [self APFP:ccp(65,  56)];
    CGPoint PosShop     = [self APFP:ccp(138, 56)];
    CGPoint PosShare    = [self APFP:ccp(240, 56)];
    CGPoint PosMusic    = [self APFP:ccp(317, 56)];
    CGPoint PosSound    = [self APFP:ccp(365, 56)];
    CGPoint PosHelp     = [self APFP:ccp(415, 56)];
    CGPoint PosDaily    = [self APFP:ccp(380, 128)];
    CGPoint PosPlum     = [self APFP:ccp(240, 320)];
    
    float   FontSize1   = 12;
    
    CCSprite* bg = [CCSprite spriteWithImageNamed:@"bg_title.png"];
    bg.position = PosBG;
    [self addChild:bg];
    
    CCSprite* title = [CCSprite spriteWithImageNamed:@"lb_title.png"];
    title.position = PosTitle;
    [self addChild:title];
    
    CCSprite* fan = [CCSprite spriteWithImageNamed:@"lb_fan.png"];
    fan.position = PosPlay;
    [self addChild:fan];
    
    CCSprite* ink = [CCSprite spriteWithImageNamed:@"lb_ink_1.png"];
    ink.position = PosPlay;
    [self addChild:ink];
    
    
    VZButton* btPlay = [VZButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_play.png"]];
    btPlay.position = PosPlay;
    [btPlay setTarget:self selector:@selector(onPlay:)];
    [self addChild:btPlay];
    
    CCSprite* UIBG = [CCSprite spriteWithImageNamed:@"lb_bg_best.png"];
    UIBG.position = PosUIBG;
    [self addChild:UIBG];

    VZButton* btStatistics = [VZButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_statistics.png"]];
    btStatistics.position = PosLeader;
    [btStatistics setTarget:self selector:@selector(onStatistics:)];
    [self addChild:btStatistics];
    
    VZButton* btShop = [VZButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_shop.png"]];
    btShop.position = PosShop;
    [btShop setTarget:self selector:@selector(onShop:)];
    [self addChild:btShop];
    
//    VZButton* btShare = [VZButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_share.png"]];
//    btShare.position = PosShare;
//    [btShare setTarget:self selector:@selector(onShare:)];
//    [self addChild:btShare];
    
    
    VZButton* btHelp = [VZButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_help.png"]];
    btHelp.position = PosHelp;
    [btHelp setTarget:self selector:@selector(onHelp:)];
    [self addChild:btHelp];
    
    
    VZMusicSwitch *btMusic = [VZMusicSwitch buttonWithTitle:@""
                                              spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_music_off.png"]
                                   highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_music_on.png"]
                                      disabledSpriteFrame:nil];
    
    
    btMusic.position = PosMusic;
    [self addChild:btMusic];
    
    
    VZSoundSwitch *btSound = [VZSoundSwitch buttonWithTitle:@""
                                      spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_sound_off.png"]
                           highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_sound_on.png"]
                              disabledSpriteFrame:nil];
    
    btSound.position = PosSound;
    [self addChild:btSound];
    
    
    
    
    
    if([[VZArchiveManager sharedVZArchiveManager] canDaily])
    {
        VZButton* btDaily = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_daily.png"]];
        btDaily.position = PosDaily;
        [btDaily setTarget:self selector:@selector(onDailyChallenge:)];
        [self addChild:btDaily];
        
        CCLabelTTF* label = [CCLabelTTF labelWithString:NSLocalizedString(@"Daily Zen", nil) fontName:SYSTEM_FONT fontSize:FontSize1];
        label.position = ccp(btDaily.position.x, btDaily.position.y - btDaily.contentSize.height * 0.5);
        label.outlineColor = [CCColor blackColor];
        label.outlineWidth = 1;
        [self addChild:label];
        
        CCParticleSystem* sparkle = [CCParticleSystem particleWithFile:@"par_sparkle.plist"];
        [self addChild:sparkle];
        
        VZCircleMoveForParticle* circle = [VZCircleMoveForParticle actionWithDuration:3 Origin:ccp(btDaily.position.x, btDaily.position.y + 5.0f * btDaily.contentSize.height / 88.0f) Radius:btDaily.contentSize.width * 35.0f / 44.0f * 0.5f  StartAngle:0 EndAngle:-M_PI*2 Rotate:NO];
        CCActionRepeatForever* repeat = [CCActionRepeatForever actionWithAction:circle];
        [sparkle runAction:repeat];
    }
    
    CCParticleSystem* plum = [CCParticleSystem particleWithFile:@"par_plum.plist"];
    plum.position = PosPlum;
    [self addChild:plum];
    
    [[VZAudioManager sharedVZAudioManager] playBGM:@"bgm_menu.mp3" loop:YES];
    
    return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

-(void)onEnter
{
    [super onEnter];
    
    CCSprite* leftBamboo = [CCSprite spriteWithImageNamed:@"lb_bamboo_0.png"];
    leftBamboo.anchorPoint = ccp(0, 0);
    leftBamboo.position = ccp(-leftBamboo.contentSize.width * 0.1, self.contentSize.height - leftBamboo.contentSize.height + 10);
    [self addChild:leftBamboo];
    
    
    leftBamboo.rotation = -15;
    CCActionSequence* leftSequence = [CCActionSequence actions:
                                      [CCActionEaseOut actionWithAction:[CCActionRotateBy actionWithDuration:2.4 angle:15] rate:1.3],
                                      [CCActionCallBlock actionWithBlock:^{[self addAcitonToLeftBamboo:leftBamboo];}],
                                      nil];
    [leftBamboo runAction:leftSequence];
    
    
    
    CCSprite* rightBamboo = [CCSprite spriteWithImageNamed:@"lb_bamboo_1.png"];
    rightBamboo.anchorPoint = ccp(1, 0);
    rightBamboo.position = ccp(self.contentSize.width, self.contentSize.height - leftBamboo.contentSize.height + 10);
    [self addChild:rightBamboo];
    
    
    rightBamboo.rotation = 15;
    CCActionSequence* rightSequence = [CCActionSequence actions:
                                      [CCActionEaseOut actionWithAction:[CCActionRotateBy actionWithDuration:2.4 angle:-15] rate:1.3],
                                      [CCActionCallBlock actionWithBlock:^{[self addAcitonToRightBamboo:rightBamboo];}],
                                      nil];
    [rightBamboo runAction:rightSequence];
    
    
}

-(void)addAcitonToLeftBamboo:(CCSprite*)bamboo
{
    
    float angle = (arc4random() % 5) + 6;
    float inDuration = (arc4random() % 500) / 1000.0f + 1.5 * 2;
    float outDuration = inDuration * 1.5;
    
    CCActionSequence* leftSqeuence = [CCActionSequence actions:
                                      [CCActionRotateBy actionWithDuration:inDuration angle:-angle],
                                      [CCActionRotateBy actionWithDuration:outDuration angle:angle],
                                      [CCActionCallBlock actionWithBlock:^{
                                            [self addAcitonToLeftBamboo:bamboo];
                                        }]
                                      , nil];
    
    [bamboo runAction:leftSqeuence];
}

-(void)addAcitonToRightBamboo:(CCSprite*)bamboo
{
    
    float angle = (arc4random() % 3) + 3;
    float inDuration = (arc4random() % 500) / 1000.0f + 2 * 2;
    float outDuration = inDuration * 2;
    
    CCActionSequence* leftSqeuence = [CCActionSequence actions:
                                      [CCActionRotateBy actionWithDuration:inDuration angle:angle],
                                      [CCActionRotateBy actionWithDuration:outDuration angle:-angle],
                                      [CCActionCallBlock actionWithBlock:^{
                                            [self addAcitonToRightBamboo:bamboo];
                                        }]
                                      , nil];
    
    [bamboo runAction:leftSqeuence];
}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

- (void)onPlay:(id)sender
{
    CCLOG(@"Play");
    
    
    [[CCDirector sharedDirector] replaceScene:[SeasonScene sceneWithSeason:0] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];

}

- (void)onStatistics:(id)sender
{
    StatisticsLayer* layer = [StatisticsLayer layer];
    [self addChild:layer];
}

- (void)onShop:(id)sender
{
    ShopLayer* layer = [ShopLayer layer];
    [self addChild:layer];
}

- (void)onShare:(id)sender
{
    [[VZShareManager sharedVZShareManager] shareWithScreenShot];
}

- (void)onHelp:(id)sender
{
    CCLOG(@"Help");
    HelpLayer* layer = [HelpLayer layer];
    layer.name = @"HelpLayer";
    [self addChild:layer];
    
#ifdef DEBUG_MODE
    [[VZGameCenterManager sharedVZGameCenterManager] resetAchievements];
#endif
}

- (void)onDailyChallenge:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[DailyChallengeGameScene scene] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
   
}


@end
