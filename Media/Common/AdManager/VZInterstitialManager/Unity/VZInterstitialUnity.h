//
//  VZInterstitialUnity.h
//  SwordsSouls
//
//  Created by VincentZhang on 15/11/26.
//  Copyright © 2015年 Apportable. All rights reserved.
//

#import "VZInterstitialBase.h"
#import <UnityAds/UnityAds.h>

@interface VZInterstitialUnity : VZInterstitialBase <UnityAdsDelegate>
{
    
}
@property(nonatomic, strong)NSMutableDictionary* locations;

@end
