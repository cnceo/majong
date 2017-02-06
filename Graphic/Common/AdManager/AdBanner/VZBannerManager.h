//
//  ADBannerManager.h
//  Happy Jumping Bug
//
//  Created by 张朴军 on 13-4-22.
//  Copyright (c) 2013年 张朴军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZCommonDefine.h"
#import <GoogleMobileAds/GoogleMobileAds.h>


extern NSString * const kVZBannerManagerDidLoadAd;
extern NSString * const kVZBannerManagerDidFailToReceiveAd;
extern NSString * const kVZBannerManagerRemoved;

@class GADBannerView, GADRequest;


@interface VZBannerManager : NSObject <GADBannerViewDelegate>
{
    BOOL                _GADHasLoaded;
    BOOL                _alreadyCreated;
}

VZ_DECLARE_SINGLETON_FOR_CLASS(VZBannerManager)

@property (nonatomic, assign)BOOL isAdPositionAtTop;
@property (nonatomic, strong)GADBannerView* GADView;

-(BOOL)isEnable;
-(void)setEnable:(BOOL)enable;

-(BOOL)hadBannerShowing;

-(CGSize)bannerSize;

-(void)remove;
-(void)load;

@end
