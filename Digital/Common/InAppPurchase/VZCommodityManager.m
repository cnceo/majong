//
//  CommodityManager.m
//  unblock
//
//  Created by 张朴军 on 13-1-18.
//  Copyright (c) 2013年 张朴军. All rights reserved.
//

#import "VZCommodityManager.h"
#import "VZInAppPurchaseManager.h"
#import "VZIdentifyManager.h"
#import "cocos2d.h"
#import "VZUserDefault.h"
#import "SecurityUtil.h"
@implementation VZCommodityManager


VZ_SYNTHESIZE_SINGLETON_FOR_CLASS(VZCommodityManager)

-(id)init
{
    if(self = [super init])
    {
        
        if(![[VZUserDefault sharedVZUserDefault] objectForKey:@"CommodityData"])
        {
            NSMutableDictionary* InitialDictionary = [NSMutableDictionary dictionary];
            
            NSData *hintData = [SecurityUtil encryptAESDataInt:10];
            [InitialDictionary setObject:hintData forKey:@"CommodityDataHint"];
            
            NSData *shuffleData = [SecurityUtil encryptAESDataInt:5];
            [InitialDictionary setObject:shuffleData forKey:@"CommodityDataShuffle"];
            
            NSData *sunshineData = [SecurityUtil encryptAESDataInt:3];
            [InitialDictionary setObject:sunshineData forKey:@"CommodityDataSunshine"];
            
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
            [InitialDictionary setObject:version forKey:@"CommodityDataVersion"];
            [[VZUserDefault sharedVZUserDefault] setObject:InitialDictionary forKey:@"CommodityData"];
            
        }
        else
        {
            NSMutableDictionary* dictionary = [[VZUserDefault sharedVZUserDefault] objectForKey:@"CommodityData"];
            
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
            NSString* string = [dictionary objectForKey:@"CommodityDataVersion"];
            
            if(!(string && [string isEqualToString:version]))
            {
                NSMutableDictionary* InitialDictionary = [NSMutableDictionary dictionary];
                
                NSData *hintData = [dictionary objectForKey:@"CommodityDataHint"];
                [InitialDictionary setObject:hintData forKey:@"CommodityDataHint"];
                
                NSData *shuffleData = [dictionary objectForKey:@"CommodityDataShuffle"];
                [InitialDictionary setObject:shuffleData forKey:@"CommodityDataShuffle"];
                
                NSData *sunshineData = [dictionary objectForKey:@"CommodityDataSunshine"];
                [InitialDictionary setObject:sunshineData forKey:@"CommodityDataSunshine"];
                
                NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
                [InitialDictionary setObject:version forKey:@"CommodityDataVersion"];
                [[VZUserDefault sharedVZUserDefault] setObject:InitialDictionary forKey:@"CommodityData"];
            }
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyPurchase:) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
        
        [self load];

    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)verifyPurchase:(NSNotification*)notify
{
    NSDictionary *userInfo  = [notify userInfo];
    SKPaymentTransaction* transaction = [userInfo objectForKey:@"transaction"];
    
    if([transaction.payment.productIdentifier isEqualToString:@"mahjong.hint1"])
    {
        self.hint = self.hint + 10;
    }
    if([transaction.payment.productIdentifier isEqualToString:@"mahjong.hint2"])
    {
        self.hint = self.hint + 120;
    }
    if([transaction.payment.productIdentifier isEqualToString:@"mahjong.shuffle1"])
    {
        self.shuffle = self.shuffle + 5;
    }
    if([transaction.payment.productIdentifier isEqualToString:@"mahjong.shuffle2"])
    {
        self.shuffle = self.shuffle + 60;
    }
    if([transaction.payment.productIdentifier isEqualToString:@"mahjong.sunshine1"])
    {
        self.sunshine = self.sunshine + 3;
    }
    if([transaction.payment.productIdentifier isEqualToString:@"mahjong.sunshine2"])
    {
        self.sunshine = self.sunshine + 35;
    }
    
    
}

-(int)hint
{
    NSData *hintData = [self.dictionary objectForKey:@"CommodityDataHint"];
    int hint = [SecurityUtil decryptAESDataInt:hintData];
    return hint;
}

-(void)setHint:(int)hint
{
    if(hint < 0)
        hint = 0;
    
    NSData *hintData = [SecurityUtil encryptAESDataInt:hint];
    [self.dictionary setObject:hintData forKey:@"CommodityDataHint"];
    [self save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommodityManagerNeedUpdate object:self userInfo:nil];
}

-(int)shuffle
{
    NSData *hintData = [self.dictionary objectForKey:@"CommodityDataShuffle"];
    return [SecurityUtil decryptAESDataInt:hintData];
}

-(void)setShuffle:(int)shuffle
{
    if(shuffle < 0)
        shuffle = 0;
    
    NSData *shuffleData = [SecurityUtil encryptAESDataInt:shuffle];
    [self.dictionary setObject:shuffleData forKey:@"CommodityDataShuffle"];
    [self save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommodityManagerNeedUpdate object:self userInfo:nil];
}

-(int)sunshine
{
    NSData *sunshineData = [self.dictionary objectForKey:@"CommodityDataSunshine"];
    return [SecurityUtil decryptAESDataInt:sunshineData];
}

-(void)setSunshine:(int)sunshine
{
    if(sunshine < 0)
        sunshine = 0;
    
    NSData *sunshineData = [SecurityUtil encryptAESDataInt:sunshine];
    [self.dictionary setObject:sunshineData forKey:@"CommodityDataSunshine"];
    [self save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCommodityManagerNeedUpdate object:self userInfo:nil];
}

-(void)load
{
    self.dictionary = [[VZUserDefault sharedVZUserDefault] objectForKey:@"CommodityData"];
}

-(void)save
{
    [[VZUserDefault sharedVZUserDefault] setObject:self.dictionary forKey:@"CommodityData"];
    [[VZUserDefault sharedVZUserDefault] synchronize];
}


@end
