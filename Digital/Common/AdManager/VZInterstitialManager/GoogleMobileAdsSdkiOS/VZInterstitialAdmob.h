//
//  VZInterstitialAdmob.h
//  Unblock
//
//  Created by VincentZhang on 15/8/3.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "VZInterstitialBase.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface VZInterstitialAdmob : VZInterstitialBase <GADInterstitialDelegate, GADRewardBasedVideoAdDelegate>
{
    
}

@property (nonatomic, strong)GADInterstitial *interstitialAd;
@property (nonatomic, strong)NSString* identifer;
@property (nonatomic, assign)BOOL allowReward;

@end
