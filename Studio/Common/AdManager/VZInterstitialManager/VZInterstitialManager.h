//
//  VZInterstitialManager.h
//  Unblock
//
//  Created by VincentZhang on 15/8/3.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VZCommonDefine.h"
#import "VZInterstitialBase.h"
#import "VZAudioManager.h"
extern NSString * const kVZIntertitialMangerRewardNotifacation;

@interface VZInterstitialManager : NSObject
{
    
}

@property(nonatomic, strong)NSMutableDictionary* items;

@property (nonatomic, assign)NSRange intervalRange;
@property (nonatomic, assign)NSInteger showInterval;
@property (nonatomic, assign)NSInteger requestTimes;
@property (nonatomic, strong)NSMutableDictionary* dictionary;

VZ_DECLARE_SINGLETON_FOR_CLASS(VZInterstitialManager)

-(void)cache;
-(void)config;

-(BOOL)isInterstitialReady:(VZLocation)location;
-(void)showInterstitial:(VZLocation)location;
-(void)forceShowInterstitial:(VZLocation)location;

-(BOOL)isRewardPlayble:(VZLocation)location;
-(void)showReward:(VZLocation)location;

-(void)postRewardNotificationPlayable;




-(void)rewardAdCompelte;

-(void)pauseDirector;
-(void)resumeDirector;

@end
