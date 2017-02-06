//
//  VZInterstitialVungle.m
//  Common
//
//  Created by VincentZhang on 15/8/6.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "VZInterstitialVungle.h"
#import "VZInterstitialManager.h"

@implementation VZInterstitialVungle

NSString* const DefaultVungleAppID = @"577f556529c9043e35000012";

-(instancetype)init
{
    if(self = [super init])
    {
        self.platform = VZPlatformVungle;
    }
    return self;
}

-(void)dealloc
{
    [[VungleSDK sharedSDK] setDelegate:nil];
}

- (void)config
{
    [[VungleSDK sharedSDK] startWithAppId:DefaultVungleAppID];
    [[VungleSDK sharedSDK] setDelegate:self];
    self.isConfiged = YES;
}

-(void)cache
{
    if(!self.isConfiged)
        return;
}

-(void)showIntersitial:(VZLocation)location
{
    if([[VungleSDK sharedSDK] isAdPlayable])
    {
        NSMutableDictionary* options = [NSMutableDictionary dictionaryWithCapacity:10];
        [options setObject:[NSNumber numberWithBool:NO] forKey:VunglePlayAdOptionKeyIncentivized];
        NSError* error = [NSError errorWithDomain:@"" code:0 userInfo:[NSDictionary dictionary]];
        [[VungleSDK sharedSDK] playAd:[CCDirector sharedDirector] withOptions:options error:&error];
        self.interstitialDisplayTimes++;
    }
}

-(BOOL)isIntersitialReady:(VZLocation)location
{
    return [[VungleSDK sharedSDK] isAdPlayable];
}

-(void)showReward:(VZLocation)location
{
    if([[VungleSDK sharedSDK] isAdPlayable])
    {
        NSMutableDictionary* options = [NSMutableDictionary dictionaryWithCapacity:10];
        [options setObject:[NSNumber numberWithBool:YES] forKey:VunglePlayAdOptionKeyIncentivized];
        NSError* error = [NSError errorWithDomain:@"" code:0 userInfo:[NSDictionary dictionary]];
        [[VungleSDK sharedSDK] playAd:[CCDirector sharedDirector] withOptions:options error:&error];
        self.rewardDisplayTimes++;
    }
}

-(BOOL)isRewardReady:(VZLocation)location
{
    if (self.rewardDisplayTimes > self.rewardMax)
    {
        return NO;
    }
    return [[VungleSDK sharedSDK] isAdPlayable];
}


-(void)vungleSDKwillShowAd
{
    [[VZInterstitialManager sharedVZInterstitialManager] pauseDirector];
}

-(void)vungleSDKAdPlayableChanged:(BOOL)isAdPlayable
{
    if(isAdPlayable)
    {
        if (self.rewardDisplayTimes > self.rewardMax)
            return;
        NSLog(@"[%@] playale",NSStringFromClass([self class]));
        [[VZInterstitialManager sharedVZInterstitialManager] postRewardNotificationPlayable];
    }
    else
    {
        NSLog(@"[%@] not playale",NSStringFromClass([self class]));
    }
}

- (void)vungleSDKwillCloseAdWithViewInfo:(NSDictionary *)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet
{
    if(willPresentProductSheet == NO)
        [[VZInterstitialManager sharedVZInterstitialManager] resumeDirector];
    
    NSNumber* number = [viewInfo objectForKey:@"completedView"];
    if ([number boolValue])
    {
       [[VZInterstitialManager sharedVZInterstitialManager] rewardAdCompelte];
    }
}

- (void)vungleSDKwillCloseProductSheet:(id)productSheet
{
    [[VZInterstitialManager sharedVZInterstitialManager] resumeDirector];
}


@end
