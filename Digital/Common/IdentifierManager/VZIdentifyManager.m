//
//  IdentifieManager.m
//  minesweeper
//
//  Created by 张朴军 on 12-12-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "VZIdentifyManager.h"

#import "cocos2d.h"

NSString * const kVZIdentifyAppID = @"kVZIdentifyAppID";

NSString * const kVZIdentifyIAdBannerID = @"kVZIdentifyIAdBannerID";
NSString * const kVZIdentifyIAdInterstitalID = @"kVZIdentifyIAdInterstitalID";

NSString * const kVZIdentifyAdmobBannerID = @"kVZIdentifyAdmobBannerID";
NSString * const kVZIdentifyAdmobInterstitalID = @"kVZIdentifyAdmobInterstitalID";

NSString * const kVZIdentifyLeaderboards = @"kVZIdentifyLeaderboards";
NSString * const kVZIdentifyArchievements = @"kVZIdentifyArchievements";

NSString * const kVZIdentifyMoreGameLink = @"kVZIdentifyMoreGameLink";

NSString * const kVZIdentifyShareContent = @"kVZIdentifyShareContent";
NSString * const kVZIdentifyDownloadLink = @"kVZIdentifyDownloadLink";

NSString * const kVZIdentifyInAppPurchases = @"kVZIdentifyInAppPurchases";

@implementation VZIdentifyManager



VZ_SYNTHESIZE_SINGLETON_FOR_CLASS(VZIdentifyManager)

-(id)init
{
    if(self = [super init])
    {
        NSString* file = @"IdentifyInfo.plist";
        NSBundle* bundle = [NSBundle mainBundle];
        NSString *imageDirectory = [file stringByDeletingLastPathComponent];
        NSString* path = [bundle pathForResource:file ofType:nil inDirectory:imageDirectory];
		self.info = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    return self;
}

- (id)objectForIdentifyInfoDictionaryKey:(NSString *)key
{
    if(self.info)
    {
        return [self.info objectForKey:key];
    }
    return nil;
}

@end
