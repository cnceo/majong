//
//  VZInterstitialBase.m
//  Unblock
//
//  Created by VincentZhang on 15/8/3.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "VZInterstitialBase.h"


VZLocation const VZLocationMainMenu     = @"VZLocationMainMenu";

VZLocation const VZLocationReward       = @"VZLocationReward";

VZAdPlatform const VZPlatformApple      = @"VZPlatformApple";
VZAdPlatform const VZPlatformAdmob      = @"VZPlatformAdmob";
VZAdPlatform const VZPlatformAdcolony   = @"VZPlatformAdcolony";
VZAdPlatform const VZPlatformChartboost = @"VZPlatformChartboost";
VZAdPlatform const VZPlatformVungle     = @"VZPlatformVungle";
VZAdPlatform const VZPlatformUnity      = @"VZPlatformUnity";

VZAdNotification const VZAdNotificationPlayable = @"VZAdNotificationPlayable";


@implementation VZInterstitialBase

-(instancetype)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kVZReachabilityChangedNotification object:nil];
        self.interstitialDisplayTimes = 0;
        self.platform = @"unknow";
    }
    return self;
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)config
{
    
}

-(void)cache
{
    
}

-(void)cacheValueExchange
{
    
}

- (void)reachabilityChanged:(NSNotification *)note
{
    if([[VZReachability sharedVZReachability] currentReachabilityStatus] != NotReachable)
    {
        [self cache];
        [self cacheValueExchange];
    }
}

-(void)showIntersitial:(VZLocation)location
{
    
}

-(BOOL)isIntersitialReady:(VZLocation)location
{
    return NO;
}

-(void)showReward:(VZLocation)location
{
    
}

-(BOOL)isRewardReady:(VZLocation)location
{
    return NO;
}

@end
