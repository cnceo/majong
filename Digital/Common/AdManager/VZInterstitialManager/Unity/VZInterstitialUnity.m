//
//  VZInterstitialUnity.m
//  SwordsSouls
//
//  Created by VincentZhang on 15/11/26.
//  Copyright © 2015年 Apportable. All rights reserved.
//

#import "VZInterstitialUnity.h"
#import "VZInterstitialManager.h"
@implementation VZInterstitialUnity

NSString* const DefaultUnityAppID = @"1092266";

-(instancetype)init
{
    if(self = [super init])
    {
        self.locations = [NSMutableDictionary dictionaryWithCapacity:20];
        self.platform = VZPlatformUnity;
    }
    return self;
}

-(void)dealloc
{
    
}

- (void)config
{
    [self.locations setObject:@"video" forKey:VZLocationMainMenu];
    [self.locations setObject:@"rewardedVideo" forKey:VZLocationReward];
    
    NSMutableSet* zoneSets = [NSMutableSet setWithCapacity:20];
    NSEnumerator* enumerator = [self.locations objectEnumerator];
    NSString* object = nil;
    while ((object = [enumerator nextObject]))
    {
        [zoneSets addObject:object];
    }
    
    
    
    NSMutableArray* zoneIDs = [NSMutableArray arrayWithCapacity:10];
    enumerator = [zoneSets objectEnumerator];
    while ((object = [enumerator nextObject]))
    {
        [zoneIDs addObject:object];
    }
    [[UnityAds sharedInstance] startWithGameId:DefaultUnityAppID andViewController:[CCDirector sharedDirector]];
    [[UnityAds sharedInstance] setDelegate:self];
    
    self.isConfiged = YES;
}

-(void)cache
{
    if(!self.isConfiged)
        return;
}


-(void)showIntersitial:(VZLocation)location
{
    NSString* zoneID = [self.locations objectForKey:VZLocationMainMenu];
    [[UnityAds sharedInstance] setZone:zoneID];
    [[UnityAds sharedInstance] show];
    self.interstitialDisplayTimes++;
}

-(BOOL)isIntersitialReady:(VZLocation)location
{
    NSString* zoneID = [self.locations objectForKey:VZLocationMainMenu];
    [[UnityAds sharedInstance] setZone:zoneID];
    return [[UnityAds sharedInstance] canShow];
}

-(void)showReward:(VZLocation)location
{
    NSString* zoneID = [self.locations objectForKey:VZLocationReward];
    [[UnityAds sharedInstance] setZone:zoneID];
    [[UnityAds sharedInstance] show];
    self.rewardDisplayTimes++;
}

-(BOOL)isRewardReady:(VZLocation)location
{
    if (self.rewardDisplayTimes > self.rewardMax)
    {
        return NO;
    }
    NSString* zoneID = [self.locations objectForKey:VZLocationReward];
    [[UnityAds sharedInstance] setZone:zoneID];
    return [[UnityAds sharedInstance] canShow];
}


-(void)unityAdsVideoCompleted:(NSString *)rewardItemKey skipped:(BOOL)skipped
{
    if (!skipped)
    {
        [[VZInterstitialManager sharedVZInterstitialManager] rewardAdCompelte];
    }
    else
    {
        
    }
}

- (void)unityAdsWillShow
{
    [[VZInterstitialManager sharedVZInterstitialManager] pauseDirector];
}
- (void)unityAdsDidShow
{
    
}
- (void)unityAdsWillHide
{
    
}
- (void)unityAdsDidHide
{
    [[VZInterstitialManager sharedVZInterstitialManager] resumeDirector];
}
- (void)unityAdsWillLeaveApplication
{
    
}
- (void)unityAdsVideoStarted
{
    
}
- (void)unityAdsFetchCompleted
{
    NSString* rewardID = [self.locations objectForKey:VZLocationReward];
    [[UnityAds sharedInstance] setZone:rewardID];
    if([[UnityAds sharedInstance] canShow])
        [[VZInterstitialManager sharedVZInterstitialManager] postRewardNotificationPlayable];
    NSLog(@"[%s]",__FUNCTION__);
    
}
- (void)unityAdsFetchFailed
{
    NSLog(@"[%s]",__FUNCTION__);
}

@end
