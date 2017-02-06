//
//  StatisticsLayer.m
//  Mahjong
//
//  Created by 穆暮 on 14-9-8.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "StatisticsLayer.h"
#import "VZCommonDefine.h"
#import "VZButton.h"
#import "VZIdentifyManager.h"
#import "VZGameCenter.h"
#import "VZArchiveManager.h"
@implementation StatisticsLayer

+(StatisticsLayer*)layer
{
    return [[self alloc] init];
}

-(id)init
{
    CCColor* color = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    if(self = [super initWithColor:color])
    {
        
        float  FontSize1    = 18;
        
        CCSprite* bg = [CCSprite spriteWithImageNamed:@"bg_statistics.png"];
        bg.position = ccp(0, 0);
        [self.window addChild:bg];
        
        CCSprite* title = [CCSprite spriteWithImageNamed:@"lb_statistics.png"];
        title.position = ccp(0, 90);
        [self.window addChild:title];
        
        
        
        CCLabelTTF* lbStar = [CCLabelTTF labelWithString:NSLocalizedString(@"Stars", nil) fontName:SYSTEM_FONT fontSize:FontSize1];
        lbStar.anchorPoint = ccp(0, 0.5);
        lbStar.position = ccp(-135, 54);
        lbStar.color = [CCColor blackColor];
        [self.window addChild:lbStar];
        
        CCLabelTTF* nStar = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[[VZArchiveManager sharedVZArchiveManager] totalStars]] fontName:SYSTEM_FONT fontSize:FontSize1];
        nStar.anchorPoint = ccp(0, 0.5);
        nStar.position = ccp(98, 54);
        nStar.color = [CCColor blackColor];
        [self.window addChild:nStar];
        
        
        CCLabelTTF* lbComplete = [CCLabelTTF labelWithString:NSLocalizedString(@"Accomplished Levels", nil) fontName:SYSTEM_FONT fontSize:FontSize1];
        lbComplete.anchorPoint = ccp(0, 0.5);
        lbComplete.position = ccp(-135, 20);
        lbComplete.color = [CCColor blackColor];
        [self.window addChild:lbComplete];
        
        CCLabelTTF* nComplete = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[[VZArchiveManager sharedVZArchiveManager] AccomplishedLevels]] fontName:SYSTEM_FONT fontSize:FontSize1];
        nComplete.anchorPoint = ccp(0, 0.5);
        nComplete.position = ccp(98, 20);
        nComplete.color = [CCColor blackColor];
        [self.window addChild:nComplete];
        
        
        CCLabelTTF* lbDaily = [CCLabelTTF labelWithString:NSLocalizedString(@"Accomplished Daily Zen", nil) fontName:SYSTEM_FONT fontSize:FontSize1];
        lbDaily.anchorPoint = ccp(0, 0.5);
        lbDaily.position = ccp(-135, -14);
        lbDaily.color = [CCColor blackColor];
        [self.window addChild:lbDaily];
        
        CCLabelTTF* nDaily = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[[VZArchiveManager sharedVZArchiveManager] accomplishedDailyZen]] fontName:SYSTEM_FONT fontSize:FontSize1];
        nDaily.anchorPoint = ccp(0, 0.5);
        nDaily.position = ccp(98, -14);
        nDaily.color = [CCColor blackColor];
        [self.window addChild:nDaily];
        
        
        VZButton* btTerminate = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_terminate.png"]];
        btTerminate.position = ccp(152, 90);
        [btTerminate setTarget:self selector:@selector(onTerminate:)];
        [self.window addChild:btTerminate];
        
        VZButton* btLeaderboard = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_leaderboard.png"]];
        btLeaderboard.position = ccp(111, -54);
        [btLeaderboard setTarget:self selector:@selector(onLeaderboard:)];
        [self.window addChild:btLeaderboard];
        
        
    }
    return self;
}

- (void)onTerminate:(id)sender
{
    [self removeFromParent];
}

- (void)onLeaderboard:(id)sender
{
    NSArray* array = [[VZIdentifyManager sharedVZIdentifyManager] objectForIdentifyInfoDictionaryKey:kVZIdentifyLeaderboards];
    [[VZGameCenter sharedVZGameCenter] showLeaderboardWithLeaderboard:[array objectAtIndex:0]];

}

- (void)onArchievement:(id)sender
{
    
}


@end
