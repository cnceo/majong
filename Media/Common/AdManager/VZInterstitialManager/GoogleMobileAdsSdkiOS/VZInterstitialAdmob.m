//
//  VZInterstitialAdmob.m
//  Unblock
//
//  Created by VincentZhang on 15/8/3.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "VZInterstitialAdmob.h"
#import "VZInterstitialManager.h"



@implementation VZInterstitialAdmob

NSString* const DefaultAdmobInterstitialID = @"ca-app-pub-3464821182263759/5583342027";
NSString* const DefaultAdmobRewardVideoID = @"ca-app-pub-3464821182263759/5583342027";

-(instancetype)init
{
    if(self = [super init])
    {
        self.platform = VZPlatformAdmob;
    }
    return self;
}

-(void)dealloc
{
    [self.interstitialAd setDelegate:nil];
}


-(GADRequest *)createRequest
{
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as
    // well as any devices you want to receive test ads.
    request.testDevices =
    [NSArray arrayWithObjects:
     // TODO: Add your device/simulator test identifiers here. They are
     // printed to the console when the app is launched.
     kGADSimulatorID,
     //@"3b25562aa73c23e33bc7d5ddf89963b6",
     nil];
    return request;
}

-(void)cacheInterstitial
{
    if(!self.isConfiged)
        return;
    
    if([[VZReachability sharedVZReachability] currentReachabilityStatus] == NotReachable)
        return;
    
    self.interstitialAd.delegate = nil;
    self.interstitialAd = nil;
    
    self.interstitialAd = [[GADInterstitial alloc] initWithAdUnitID:self.identifer];
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadRequest: [self createRequest]];
    
    
}


- (void)config
{
    self.identifer = DefaultAdmobInterstitialID;
    self.isConfiged = YES;
    
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:[self createRequest]
                                           withAdUnitID:DefaultAdmobRewardVideoID];
}

-(void)cache
{
    if(!self.isConfiged)
        return;
    
    [self cacheInterstitial];
    
}

-(void)showIntersitial:(VZLocation)location
{
    if(self.interstitialAd.isReady)
    {
        [self.interstitialAd presentFromRootViewController:[CCDirector sharedDirector]];
        self.interstitialDisplayTimes++;
        NSLog(@"[%s]",__FUNCTION__);
    }
    else
    {
        [self cacheInterstitial];
        CCLOG(@"[AdmobInterstitial]: No Content to show");
    }
}

-(BOOL)isIntersitialReady:(VZLocation)location
{
    return self.interstitialAd.isReady;
}

-(void)showReward:(VZLocation)location
{
    if(_allowReward)
    {
        [self showIntersitial:location];
    }
    else
    {
        if ([[GADRewardBasedVideoAd sharedInstance] isReady])
        {
            [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:[CCDirector sharedDirector]];
        }
    }
}

-(BOOL)isRewardReady:(VZLocation)location
{
    if(_allowReward)
    {
        return self.interstitialAd.isReady;
    }
    else
    {
       return [[GADRewardBasedVideoAd sharedInstance] isReady];
    }
    
    
}

// 加载失败
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    //[self GADCycleInterstitial];
    
    [self performSelector:@selector(cacheInterstitial) withObject:self afterDelay:10];
    CCLOG(@"[AdmobInterstitial]: Faild to load Interstital: %@", error);
}

// 加载成功
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    CCLOG(@"[AdmobInterstitial]: Interstital has loaded.");
    if(_allowReward)
    {
        [[VZInterstitialManager sharedVZInterstitialManager] postRewardNotificationPlayable];
    }
    else
    {
        
    }
    
}

// 广告消失
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    [self cacheInterstitial];
    if(_allowReward)
    {
        [[VZInterstitialManager sharedVZInterstitialManager] rewardAdCompelte];
    }
    else
    {
        
    }
}

// 即将展示
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    [[VZInterstitialManager sharedVZInterstitialManager] pauseDirector];
}

// 即将消失
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad
{   
    [[VZInterstitialManager sharedVZInterstitialManager] resumeDirector];
    
}

// 即将离开应用
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    
}



//////////////////////


- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    NSString *rewardMessage =
    [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
     reward.type,
     [reward.amount doubleValue]];
    NSLog(@"%@",rewardMessage);
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is received.");
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Opened reward based video ad.");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is closed.");
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad will leave application.");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    NSLog(@"Reward based video ad failed to load.");
}

@end
