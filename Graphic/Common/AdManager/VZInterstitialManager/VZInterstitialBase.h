//
//  VZInterstitialBase.h
//  Unblock
//
//  Created by VincentZhang on 15/8/3.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZReachability.h"
#import "cocos2d.h"
typedef NSString * const VZLocation;


extern VZLocation const VZLocationMainMenu;

extern VZLocation const VZLocationReward;

typedef NSString * const VZAdPlatform;

extern VZAdPlatform const VZPlatformApple;
extern VZAdPlatform const VZPlatformAdmob;
extern VZAdPlatform const VZPlatformAdcolony;
extern VZAdPlatform const VZPlatformChartboost;
extern VZAdPlatform const VZPlatformVungle;
extern VZAdPlatform const VZPlatformUnity;


typedef NSString * const VZAdNotification;
extern VZAdNotification const VZAdNotificationPlayable;

@protocol VZInterstitialProtocol<NSObject>

- (void)config;
- (void)cache;
- (void)reachabilityChanged:(NSNotification *)note;
- (void)showIntersitial:(VZLocation)location;
- (BOOL)isIntersitialReady:(VZLocation)location;


- (void)showReward:(VZLocation)location;
- (BOOL)isRewardReady:(VZLocation)location;


@end


@interface VZInterstitialBase : NSObject <VZInterstitialProtocol>
{
    
}

@property (nonatomic, strong)Reachability* internetReach;
@property (nonatomic, assign)BOOL isConfiged;
@property (nonatomic, assign)NSInteger  interstitialDisplayTimes;
@property (nonatomic, assign)NSInteger  interstitialPriority;
@property (nonatomic, assign)NSInteger  rewardDisplayTimes;
@property (nonatomic, assign)NSInteger  rewardPriority;
@property (nonatomic, assign)NSInteger  rewardMax;
@property (nonatomic, strong)VZAdPlatform platform;

@end
