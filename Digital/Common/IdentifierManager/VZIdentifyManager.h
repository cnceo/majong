//
//  IdentifieManager.h
//  minesweeper
//
//  Created by 张朴军 on 12-12-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZCommonDefine.h"

extern NSString * const kVZIdentifyAppID;

extern NSString * const kVZIdentifyIAdBannerID;
extern NSString * const kVZIdentifyIAdInterstitalID;

extern NSString * const kVZIdentifyAdmobBannerID;
extern NSString * const kVZIdentifyAdmobInterstitalID;

extern NSString * const kVZIdentifyLeaderboards;
extern NSString * const kVZIdentifyArchievements;

extern NSString * const kVZIdentifyMoreGameLink;

extern NSString * const kVZIdentifyShareContent;
extern NSString * const kVZIdentifyDownloadLink;

extern NSString * const kVZIdentifyInAppPurchases;


@interface VZIdentifyManager : NSObject
{
    
    
}

VZ_DECLARE_SINGLETON_FOR_CLASS(VZIdentifyManager)

@property (nonatomic, strong)NSDictionary* info;

- (id)objectForIdentifyInfoDictionaryKey:(NSString *)key;

@end
