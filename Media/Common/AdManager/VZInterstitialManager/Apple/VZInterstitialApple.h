//
//  VZInterstitialApple.h
//  Unblock
//
//  Created by VincentZhang on 15/8/3.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "VZInterstitialBase.h"
#import <iAd/iAd.h>

@interface VZInterstitialApple : VZInterstitialBase <ADInterstitialAdDelegate>
{
    
}
@property (nonatomic, strong)ADInterstitialAd *interstitialAd;

@end
