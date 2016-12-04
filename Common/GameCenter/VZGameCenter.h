//
//  VZGameCenterManager.h
//  DianShuHeTi
//
//  Created by ZhangJinKui on 16/10/9.
//  Copyright © 2016年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZCommonDefine.h"
#import "GameCenterManager.h"

extern NSString * const kVZGameCenterLeaderboardID;

@interface VZGameCenter : NSObject <GameCenterManagerDelegate>
{
    
}

VZ_DECLARE_SINGLETON_FOR_CLASS(VZGameCenter)

-(void)setupManager;
-(void)showLeaderboardWithLeaderboard:(NSString*)leaderboardID;
-(void)reportScore:(long long)score leaderboard:(NSString *)identifier sortOrder:(GameCenterSortOrder)order;
@end
