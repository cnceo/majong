//
//  VZGameCenterManager.m
//  DianShuHeTi
//
//  Created by ZhangJinKui on 16/10/9.
//  Copyright © 2016年 Apportable. All rights reserved.
//

#import "VZGameCenter.h"
#import "cocos2d.h"

@implementation VZGameCenter

NSString * const kVZGameCenterLeaderboardID = @"CrazyAirBubbleFilm.leaderboard";

VZ_SYNTHESIZE_SINGLETON_FOR_CLASS(VZGameCenter)

-(id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

-(void)setupManager
{
    [[GameCenterManager sharedManager] setupManagerAndSetShouldCryptWithKey:@"TestKey"];
    [[GameCenterManager sharedManager] setDelegate:self];
}

-(void)showLeaderboardWithLeaderboard:(NSString*)leaderboardID
{
    [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:[CCDirector sharedDirector] withLeaderboard:leaderboardID];
}

-(void)reportScore:(long long)score leaderboard:(NSString *)identifier sortOrder:(GameCenterSortOrder)order
{
    [[GameCenterManager sharedManager] saveAndReportScore:score leaderboard:identifier sortOrder:order];
}

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController
{
    [[CCDirector sharedDirector] presentViewController:gameCenterLoginController animated:YES completion:^{
        NSLog(@"Finished Presenting Authentication Controller");
    }];
}

@end
