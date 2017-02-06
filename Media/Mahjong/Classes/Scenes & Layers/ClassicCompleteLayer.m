//
//  CompleteLayer.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-17.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "ClassicCompleteLayer.h"
#import "VZSpreadForSprite.h"
#import "VZButton.h"
#import "TitleScene.h"
#import "ClassicGameScene.h"
#import "LevelScene.h"
#import "SeasonScene.h"
#import "VZArchiveManager.h"
#import "VZScrollNumberForLabel.h"
#import "VZAudioManager.h"
#import "VZIdentifyManager.h"

#import "VZInterstitialManager.h"
#import "Appirater.h"
#import "VZShareManager.h"
#import "VZArchievementManager.h"

#import "VZGameCenter.h"
#define SPREAD_DURATION 1.5

@implementation ClassicCompleteLayer

+(ClassicCompleteLayer*)layerWithSeason:(int)season Level:(int)level Score:(float)score Stars:(int)stars
{
    return [[self alloc] initWithSeason:season Level:level Score:score Stars:stars];
}

-(id)initWithSeason:(int)season Level:(int)level Score:(float)score Stars:(int)stars
{
    CCColor* color = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    if(self = [super initWithColor:color])
    {
        _season = season;
        _score = score;
        _level = level;
        _stars = stars;
        
        
        
        
        
        
        CGPoint PosBG       = ccp(0,    0);
        CGPoint PosTitle    = ccp(0,    116);
        CGPoint PosScore    = ccp(0,    55);
        CGPoint PosBest     = ccp(0,    23);
        CGPoint PosLeader   = ccp(205,  55);
        CGPoint PosArchieve = ccp(205,  55);
        CGPoint PosMenu     = ccp(-157, -75);
        CGPoint PosReplay   = ccp(-98,  -75);
        CGPoint PosShare    = ccp(-4,   -75);
        CGPoint PosNext     = ccp(125,  -75);
        CGPoint PosStamp    = ccp(-73,  60);
        CGPoint PosStar[3];
        PosStar[0]          = ccp(-56,  -20);
        PosStar[1]          = ccp(0,    -20);
        PosStar[2]          = ccp(56,   -20);
        
        CGPoint PosFlash[3];
        PosFlash[0]          = ccp(-118, 120);
        PosFlash[1]          = ccp(-22,  96);
        PosFlash[2]          = ccp(41,   113);
        
        float  FontSize1    = 22;
        float  FontSize2    = 18;
        
        BOOL    newHighScore = NO;
        
        
        if(_score > [[VZArchiveManager sharedVZArchiveManager] highScoreWithSeason:_season Level:_level])
        {
            [[VZArchiveManager sharedVZArchiveManager] setHighScore:_score Season:_season Level:_level];
            newHighScore= YES;
        }
        
        if(_stars > [[VZArchiveManager sharedVZArchiveManager] starsWithSeason:_season Level:_level])
        {
            [[VZArchiveManager sharedVZArchiveManager] setStars:_stars Season:_season Level:_level];
        }
        
        
        NSArray* array = [[VZIdentifyManager sharedVZIdentifyManager] objectForIdentifyInfoDictionaryKey:kVZIdentifyLeaderboards];
        [[VZGameCenter sharedVZGameCenter] reportScore:[[VZArchiveManager sharedVZArchiveManager] totalStars]
                                            leaderboard:[array objectAtIndex:0]
                                              sortOrder:GameCenterSortOrderHighToLow];
        
        
        [[VZArchiveManager sharedVZArchiveManager] setLocked:NO Season:season Level:level + 1];
        
        [Appirater userDidSignificantEvent:YES];
        
        CCSprite* bg = [CCSprite spriteWithImageNamed:@"bg_result.png"];
        bg.position = PosBG;
        [self.window addChild:bg];
        
        
        VZSpreadForSprite* spread = [VZSpreadForSprite actionWithDuration:SPREAD_DURATION direction:VZActionSpreadDirectionHorizontal];
        CCActionEaseOut* easeIn = [CCActionEaseOut actionWithAction:spread rate:1.4];
        [bg runAction:easeIn];
        
        
        CCSprite* title = [CCSprite spriteWithImageNamed:@"lb_cleared.png"];
        title.position = PosTitle;
        [self.window addChild:title];
        [self AddEnterActionToNode:title WithDelay:0];
        
        
        for (int i = 0; i < 3; i++)
        {
            CCSprite* star = [CCSprite spriteWithImageNamed:@"lb_light.png"];
            star.position = PosFlash[i];
            [self.window addChild:star];
            [self AddEnterActionToNode:star WithDelay:0.25];
            
            float dutation = (arc4random() % 1000) / 1000.0f + 1.0;
            float scaleMin = (arc4random() % 250) / 1000.0f + 0.25;
            float scaleMax = (arc4random() % 250) / 1000.0f + 0.75;
            
            CCActionSequence* sequenceShine = [CCActionSequence actions:
                                               [CCActionEaseOut actionWithAction:[CCActionFadeTo actionWithDuration:dutation opacity:0.25] rate:1.3],
                                               [CCActionEaseIn actionWithAction:[CCActionFadeTo actionWithDuration:dutation opacity:1.0] rate:1.3],
                                               nil];
            CCActionRepeatForever* repeatShine = [CCActionRepeatForever actionWithAction:sequenceShine];
            [star runAction:repeatShine];
            
            
            CCActionSequence* sequenceZoom = [CCActionSequence actions:
                                              [CCActionEaseOut actionWithAction:[CCActionScaleTo actionWithDuration:dutation scale:scaleMin] rate:1.3],
                                              [CCActionEaseIn actionWithAction:[CCActionScaleTo actionWithDuration:dutation scale:scaleMax] rate:1.3],
                                              nil];
            CCActionRepeatForever* repeatZoom = [CCActionRepeatForever actionWithAction:sequenceZoom];
            [star runAction:repeatZoom];
            
            CCActionRepeatForever* rotate = [CCActionRepeatForever actionWithAction:[CCActionRotateBy actionWithDuration:dutation angle:360]];
            [star runAction:rotate];
        }
        
        
        _scoreLabel = [CCLabelTTF labelWithString:@"" fontName:SYSTEM_FONT fontSize:FontSize1];
        _scoreLabel.position = PosScore;
        [self.window addChild:_scoreLabel];
        [self AddEnterActionToNode:_scoreLabel WithDelay:0.5];
        
        CCActionSequence* scoreScroll = [CCActionSequence actions:
                                         [CCActionDelay actionWithDuration:SPREAD_DURATION * 0.8 + 0.5],
                                         [CCActionCallBlock actionWithBlock:^{[[VZAudioManager sharedVZAudioManager] playEffect:@"scorllScore.mp3"];}],
                                         [VZScrollNumberForLabel actionWithDuration:1.2 StartNumber:0 EndNumber:_score PrefixString:@"Score: "],
                                         nil];
        [_scoreLabel runAction:scoreScroll];
        
        
        
        
        _bestLable = [CCLabelTTF labelWithString:[NSString stringWithFormat:NSLocalizedString(@"Best: %.0f", nil),[[VZArchiveManager sharedVZArchiveManager] highScoreWithSeason:_season Level:_level]] fontName:SYSTEM_FONT fontSize:FontSize2];
        _bestLable.position = PosBest;
        [self.window addChild:_bestLable];
        [self AddEnterActionToNode:_bestLable WithDelay:0.5];
        
        
        for (int i = 0; i < 3; i++)
        {
            
            CCSprite* star = [CCSprite spriteWithImageNamed:@"lb_starResult_black.png"];
            star.position = PosStar[i];
            [self.window addChild:star];
            star.visible = YES;
            [self AddEnterActionToNode:star WithDelay:0.5];
        }
        
        
        for (int i = 0; i < _stars; i++)
        {
            
            CCSprite* star = [CCSprite spriteWithImageNamed:@"lb_starResult.png"];
            star.position = ccpAdd(PosStar[i], ccp((i - 1) * star.contentSize.width * 0.5, star.contentSize.height * 0.5));
            [self.window addChild:star];
            star.visible = NO;
            star.scale = 1.5;
            star.opacity = 0.5;
            CCActionSequence* stampIn = [CCActionSequence actions:
                                             [CCActionDelay actionWithDuration:SPREAD_DURATION * 0.8 + 1.0 + i * 0.5],
                                             [CCActionCallBlock actionWithBlock:^{star.visible = YES;}],
                                             [CCActionEaseIn actionWithAction:[CCActionScaleTo actionWithDuration:0.5 scale:1.0] rate:1.3],
                                             nil];
            [star runAction:stampIn];
            
            CCActionSequence* fadeIn = [CCActionSequence actions:
                                         [CCActionDelay actionWithDuration:SPREAD_DURATION * 0.8 + 1.0 + i * 0.5],
                                         [CCActionCallBlock actionWithBlock:^{
                                            star.visible = YES;
                                            [[VZAudioManager sharedVZAudioManager] playEffect:[NSString stringWithFormat:@"star_%d.mp3",i]];
                                            }],
                                         [CCActionEaseIn actionWithAction:[CCActionFadeIn actionWithDuration:0.5] rate:1.3],
                                         nil];
            [star runAction:fadeIn];
            
            CCActionSequence* moveDown = [CCActionSequence actions:
                                        [CCActionDelay actionWithDuration:SPREAD_DURATION * 0.8 + 1.0 + i * 0.5],
                                        [CCActionCallBlock actionWithBlock:^{star.visible = YES;}],
                                        [CCActionEaseIn actionWithAction:[CCActionMoveTo actionWithDuration:0.5 position:PosStar[i]] rate:1.3],
                                        nil];
            [star runAction:moveDown];
        }
        
        
        VZButton* btMenu = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_menu.png"]];
        btMenu.position = PosMenu;
        [self.window addChild:btMenu];
        [self AddEnterActionToNode:btMenu WithDelay:2.5];
        [btMenu setTarget:self selector:@selector(onMenu:)];
        
        
        VZButton* btReplay= [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_replay.png"]];
        btReplay.position = PosReplay;
        [self.window addChild:btReplay];
        [self AddEnterActionToNode:btReplay WithDelay:2.5];
        [btReplay setTarget:self selector:@selector(onReplay:)];
        
//        VZButton* btShare= [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_showOff.png"]];
//        btShare.position = PosShare;
//        [self.window addChild:btShare];
//        [self AddEnterActionToNode:btShare WithDelay:2.5];
//        [btShare setTarget:self selector:@selector(onShare:)];
        
        
        VZButton* btNext= [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_next.png"]];
        btNext.position = PosNext;
        [self.window addChild:btNext];
        [self AddEnterActionToNode:btNext WithDelay:2.5];
        [btNext setTarget:self selector:@selector(onNext:)];
        
        VZButton* btLeader = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_leaderboard.png"]];
        btLeader.position = PosLeader;
        [self.window addChild:btLeader];
        [self AddEnterActionToNode:btLeader WithDelay:2.5];
        [btLeader setTarget:self selector:@selector(onLeaderboard:)];
        

        
        if(newHighScore)
        {
            [[VZArchiveManager sharedVZArchiveManager] setHighScore:_score Season:_season Level:_level];
            
            CCSprite* stamp = [CCSprite spriteWithImageNamed:@"lb_highscore.png"];
            stamp.position = ccpAdd(PosStamp, ccp(-stamp.contentSize.width * 0.6, stamp.contentSize.height * 0.5));
            [self.window addChild:stamp];
            
            stamp.visible = NO;
            stamp.scale = 1.5;
            stamp.opacity = 0.5;
            CCActionSequence* stampIn = [CCActionSequence actions:
                                         [CCActionDelay actionWithDuration:SPREAD_DURATION * 0.8 + 3.0],
                                         [CCActionCallBlock actionWithBlock:^{
                stamp.visible = YES;
                [[VZAudioManager sharedVZAudioManager] playEffect:@"stamp.mp3"];
            }],
                                         [CCActionEaseIn actionWithAction:[CCActionScaleTo actionWithDuration:0.25 scale:1.0] rate:1.3],
                                         nil];
            [stamp runAction:stampIn];
            
            CCActionSequence* fadeIn = [CCActionSequence actions:
                                        [CCActionDelay actionWithDuration:SPREAD_DURATION * 0.8 + 3.0],
                                        [CCActionCallBlock actionWithBlock:^{stamp.visible = YES;}],
                                        [CCActionEaseIn actionWithAction:[CCActionFadeIn actionWithDuration:0.25] rate:1.3],
                                        nil];
            [stamp runAction:fadeIn];
            
            CCActionSequence* moveDown = [CCActionSequence actions:
                                          [CCActionDelay actionWithDuration:SPREAD_DURATION * 0.8 + 3.0],
                                          [CCActionCallBlock actionWithBlock:^{stamp.visible = YES;}],
                                          [CCActionEaseIn actionWithAction:[CCActionMoveTo actionWithDuration:0.25 position:PosStamp] rate:1.3],
                                          nil];
            [stamp runAction:moveDown];
        }
        
       
        
        
        _canReplaceScene = NO;
        CCActionSequence* showAd = [CCActionSequence actions:
                                    [CCActionDelay actionWithDuration:4.5],
                                    [CCActionCallBlock actionWithBlock:^{
                                    [[VZInterstitialManager sharedVZInterstitialManager] showInterstitial:VZLocationMainMenu];
                                    _canReplaceScene = YES;
                                    }],
                                    nil];
        [self runAction:showAd];
        
        [[VZArchievementManager sharedVZArchievementManager] checkArchievemens];
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    [[VZAudioManager sharedVZAudioManager] playEffect:@"complete.mp3"];
    
}

-(void)AddEnterActionToNode:(CCNode*)node WithDelay:(float)delay
{
    node.opacity = 0;
    CCActionSequence* action = [CCActionSequence actions:
                                [CCActionDelay actionWithDuration:SPREAD_DURATION * 0.8 + delay],
                                [CCActionFadeIn actionWithDuration:0.5],
                                nil];
    [node runAction:action];
}

- (void)onMenu:(id)sender
{
    if(!_canReplaceScene)
        return;
    
    [[CCDirector sharedDirector] replaceScene:[LevelScene sceneWithSeason:_season Level:_level] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

- (void)onReplay:(id)sender
{
    if(!_canReplaceScene)
        return;
    [[CCDirector sharedDirector] replaceScene:[ClassicGameScene sceneWithSeason:_season Level:_level] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

- (void)onShare:(id)sender
{
    if(!_canReplaceScene)
        return;
    [[VZShareManager sharedVZShareManager] shareWithScreenShot];
}


- (void)onNext:(id)sender
{
    if(!_canReplaceScene)
        return;
    
    if(_level + 1 >= MAX_LEVELS)
    {
        [[CCDirector sharedDirector] replaceScene:[SeasonScene sceneWithSeason:_season] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[ClassicGameScene sceneWithSeason:_season Level:_level + 1] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    }
}

- (void)onLeaderboard:(id)sender
{
    if(!_canReplaceScene)
        return;
    NSArray* array = [[VZIdentifyManager sharedVZIdentifyManager] objectForIdentifyInfoDictionaryKey:kVZIdentifyLeaderboards];
    [[VZGameCenter sharedVZGameCenter] showLeaderboardWithLeaderboard:[array objectAtIndex:0]];

}

- (void)onArchievement:(id)sender
{
  
}

@end
