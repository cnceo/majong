//
//  VZInterstitialManager.m
//  Unblock
//
//  Created by VincentZhang on 15/8/3.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "VZInterstitialManager.h"

#import "VZInterstitialAdmob.h"



NSString * const kVZIntertitialMangerRewardNotifacation = @"kVZIntertitialMangerRewardNotifacation";



@implementation VZInterstitialManager

VZ_SYNTHESIZE_SINGLETON_FOR_CLASS(VZInterstitialManager)

- (id)init
{
    if(self = [super init])
    {
        
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"InterstitialData"])
        {
            NSMutableDictionary* InitialDictionary = [NSMutableDictionary dictionary];
            [[NSUserDefaults standardUserDefaults] setObject:InitialDictionary forKey:@"InterstitialData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [VZReachability sharedVZReachability];
        self.items = [NSMutableDictionary dictionaryWithCapacity:5];
        
//        VZInterstitialApple* apple = [[VZInterstitialApple alloc] init];
//        apple.interstitialPriority = 100;
//        apple.rewardPriority = 100;
//        apple.rewardMax = 5;
//        [self.items setObject:apple forKey:apple.platform];
        
        VZInterstitialAdmob* admob = [[VZInterstitialAdmob alloc] init];
        admob.interstitialPriority = 100;
        admob.rewardPriority = 100;
        admob.rewardMax = 5;
        admob.allowReward = YES;
        [self.items setObject:admob forKey:admob.platform];
        
//        VZInterstitialChartboost* chartboost = [[VZInterstitialChartboost alloc] init];
//        chartboost.interstitialPriority = 10;
//        chartboost.rewardPriority = 10;
//        chartboost.rewardMax = 5;
//        [self.items setObject:chartboost forKey:chartboost.platform];
//        
//        VZInterstitialAdcolony* adcolony = [[VZInterstitialAdcolony alloc] init];
//        adcolony.interstitialPriority = 10;
//        adcolony.rewardPriority = 10;
//        adcolony.rewardMax = 5;
//        [self.items setObject:adcolony forKey:adcolony.platform];
        
//        VZInterstitialUnity* unity = [[VZInterstitialUnity alloc] init];
//        unity.interstitialPriority = 10;
//        unity.rewardPriority = 10;
//        unity.rewardMax = 5;
//        [self.items setObject:unity forKey:unity.platform];
        
        
        self.intervalRange = NSMakeRange(0,1);
        self.showInterval = arc4random() % self.intervalRange.length + self.intervalRange.location;
        self.requestTimes = 0;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        [self load];
    }
    return self;
}

- (void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)config
{
    NSEnumerator* enumerator = [self.items objectEnumerator];
    
    VZInterstitialBase* object = nil;
    while ((object = [enumerator nextObject]))
    {
        [object config];
    }
}

-(void)cache
{
    NSEnumerator* enumerator = [self.items objectEnumerator];
    
    VZInterstitialBase* object = nil;
    while ((object = [enumerator nextObject]))
    {
        [object cache];
    }
}

-(BOOL)isInterstitialReady:(VZLocation)location
{
    NSEnumerator* enumerator = [self.items objectEnumerator];
    
    //[object show:location];
    
    VZInterstitialBase* object = nil;
    while ((object = [enumerator nextObject]))
    {
        if([object isIntersitialReady:location])
        {
            return YES;
        }
    }
    return NO;
}

-(void)showInterstitial:(VZLocation)location
{
    self.requestTimes++;
    if(self.requestTimes < self.showInterval)
        return;
    
    self.requestTimes = 0;
    self.showInterval = arc4random() % self.intervalRange.length + self.intervalRange.location;
        
    
    
    float totalPriority = 0;
    NSInteger totalDispalyTimes = 0;
    
    NSMutableArray* platforms = [NSMutableArray arrayWithCapacity:4];
    
    NSEnumerator* enumerator = [self.items objectEnumerator];
    
    //[object show:location];
    
    VZInterstitialBase* object = nil;
    while ((object = [enumerator nextObject]))
    {
        if([object isIntersitialReady:location])
        {
            totalDispalyTimes += object.interstitialDisplayTimes;
            totalPriority+= object.interstitialPriority;
            [platforms addObject:object.platform];
        }
    }
    [self printPercentage:location Platforms:platforms];
    
    if(totalDispalyTimes == 0)
    {
        for (VZAdPlatform platform in platforms)
        {
            object = [self.items objectForKey:platform];
            if([object isIntersitialReady:location])
            {
                [object showIntersitial:location];
                break;
            }
        }
    }
    else
    {
        NSInteger index = -1;
        float minpercentage = 0;
        float minpriority = 0;
        for (int i = 0; i < platforms.count; i++)
        {
            object = [self.items objectForKey:[platforms objectAtIndex:i]];
            
            if([object isIntersitialReady:location])
            {
                float percentage = object.interstitialDisplayTimes * 1.0f / totalDispalyTimes * 1.0f;
                float priority = object.interstitialPriority * 1.0f / totalPriority * 1.0f;
                
                if(percentage < priority)
                {
                    if(index == -1)
                    {
                        index = i;
                        minpercentage = percentage;
                        minpriority = priority;
                    }
                    else
                    {
                        if((priority - percentage) < (minpriority - minpercentage))
                        {
                            index = i;
                            minpercentage = percentage;
                            minpriority = priority;
                        }
                    }
                    break;
                }
            }
        }
        if(index == -1)
        {
            index = arc4random() % platforms.count;
        }
        object = [self.items objectForKey:[platforms objectAtIndex:index]];
        [object showIntersitial:location];
    }
}

-(void)forceShowInterstitial:(VZLocation)location
{
    float totalPriority = 0;
    NSInteger totalDispalyTimes = 0;
    NSMutableArray* platforms = [NSMutableArray arrayWithCapacity:4];
    
    NSEnumerator* enumerator = [self.items objectEnumerator];
    
    VZInterstitialBase* object = nil;
    while ((object = [enumerator nextObject]))
    {
        if([object isIntersitialReady:location])
        {
            totalDispalyTimes += object.interstitialDisplayTimes;
            totalPriority+= object.interstitialPriority;
            [platforms addObject:object.platform];
        }
    }
    [self printPercentage:location Platforms:platforms];
    
    if(totalDispalyTimes == 0)
    {
        for (VZAdPlatform platform in platforms)
        {
            object = [self.items objectForKey:platform];
            if([object isIntersitialReady:location])
            {
                [object showIntersitial:location];
                break;
            }
        }
    }
    else
    {
        NSInteger index = -1;
        float minpercentage = 0;
        float minpriority = 0;
        for (int i = 0; i < platforms.count; i++)
        {
            object = [self.items objectForKey:[platforms objectAtIndex:i]];
            
            if([object isIntersitialReady:location])
            {
                float percentage = object.interstitialDisplayTimes * 1.0f / totalDispalyTimes * 1.0f;
                float priority = object.interstitialPriority * 1.0f / totalPriority * 1.0f;
                
                if(percentage < priority)
                {
                    if(index == -1)
                    {
                        index = i;
                        minpercentage = percentage;
                        minpriority = priority;
                    }
                    else
                    {
                        if((priority - percentage) < (minpriority - minpercentage))
                        {
                            index = i;
                            minpercentage = percentage;
                            minpriority = priority;
                        }
                    }
                    break;
                }
            }
        }
        if(index == -1)
        {
            index = arc4random() % platforms.count;
        }
        object = [self.items objectForKey:[platforms objectAtIndex:index]];
        [object showIntersitial:location];
    }
}

-(void)showReward:(VZLocation)location
{
    NSMutableArray* readyAds = [NSMutableArray arrayWithCapacity:self.items.count];
    NSEnumerator* enumerator = [self.items objectEnumerator];
    VZInterstitialBase* object = nil;
    while ((object = [enumerator nextObject]))
    {
        if([object isRewardReady:location])
        {
            [readyAds addObject:object];
            break;
        }
    }
    
    NSInteger count = readyAds.count;
    if(readyAds.count > 0)
    {
        NSInteger index = arc4random() % count;
        VZInterstitialBase* presentAds = [readyAds objectAtIndex:index];
        [presentAds showReward:location];
    }
}

-(BOOL)isRewardPlayble:(VZLocation)location
{
    NSEnumerator* enumerator = [self.items objectEnumerator];
    
    //[object show:location];
    
    VZInterstitialBase* object = nil;
    while ((object = [enumerator nextObject]))
    {
        if([object isRewardReady:location])
        {
            return YES;
        }
    }
    return NO;
}

-(void)postRewardNotificationPlayable
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VZAdNotificationPlayable object:self userInfo:nil];
}

-(void)pauseDirector
{
    [[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] stopAnimation];
    [[VZAudioManager sharedVZAudioManager] pause];
}

-(void)resumeDirector
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
    [[VZAudioManager sharedVZAudioManager] resume];
}

-(void)printPercentage:(VZLocation)location Platforms:(NSArray*)platforms
{

    NSInteger totalDispalyTimes = 0;
    float totalPriority = 0;
    
    for (VZAdPlatform platform in platforms)
    {
        VZInterstitialBase* object = [self.items objectForKey:platform];
        totalDispalyTimes += object.interstitialDisplayTimes;
        totalPriority += object.interstitialPriority;
    }
    if(totalDispalyTimes > 0)
    {
        for (VZAdPlatform platform in platforms)
        {
            VZInterstitialBase* object = [self.items objectForKey:platform];
            float percentage = object.interstitialDisplayTimes * 1.0f / totalDispalyTimes * 1.0f;
            float priority = object.interstitialPriority * 1.0f / totalPriority * 1.0f;
            NSLog(@"%@ : [Percentage %.4f -- Priority %.4f]", object.platform, percentage, priority);
        }
    }
}

-(void)rewardAdCompelte
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kVZIntertitialMangerRewardNotifacation object:self userInfo:nil];
}


-(void)load
{
    self.dictionary = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"InterstitialData"]];
    
    NSEnumerator* enumerator = [self.items objectEnumerator];
    
    VZInterstitialBase* object = nil;
    while ((object = [enumerator nextObject]))
    {
        NSString* key = object.platform;
        key = [key stringByAppendingString:@"Max"];
        
        NSNumber* displayTimes = [self.dictionary objectForKey:key];
        if(displayTimes)
        {
            object.rewardDisplayTimes = [displayTimes integerValue];
        }
        else
        {
            NSNumber* initTimes = [NSNumber numberWithInteger:0];
            [self.dictionary setObject:initTimes forKey:key];
        }
    }
}

-(void)save
{
    
    NSEnumerator* enumerator = [self.items objectEnumerator];
    
    VZInterstitialBase* object = nil;
    while ((object = [enumerator nextObject]))
    {
        NSString* key = object.platform;
        key = [key stringByAppendingString:@"Max"];
        
        NSNumber* displaytimes = [NSNumber numberWithInteger:object.rewardDisplayTimes];
        [self.dictionary setObject:displaytimes forKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.dictionary forKey:@"InterstitialData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//- (void) testSEL
//{
//    SEL say1 = @selector(say); //创建say方法的SEL对象
//    SEL say2 = NSSelectorFromString(@"say"); //从方法名字符串 创建SEL对象
//    [self performSelector:say1]; //执行 ss指向的方法
//    [self performSelector:say2]; //-[NSObject performSelector]
//    
//    /*
//     以下可以作为Log输出
//     */
//    NSLog(@"------------------------------------------------");
//    SEL s = _cmd; // 每一个方法内都有一个_cmd，表示方法自身
//    NSLog(@"当前方法（NSStringFromSelector）：%@", NSStringFromSelector(s)); //NSStringFromSelector 返回方法名
//    NSLog(@"所在文件完整路径（__FILE__）：%s", __FILE__);
//    NSLog(@"所在文件名：%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent]);
//    NSLog(@"当前行号（__LINE__）：%d", __LINE__);
//    NSLog(@"当前方法签名（__func__）：%s", __func__);
//    NSLog(@"当前方法签名（__PRETTY_FUNCTION__）：%s", __PRETTY_FUNCTION__);//在c++代码中，会包含类型的详细信息
//    NSString* clz = NSStringFromClass([self class]); //返回一个Class对象的类名
//    NSLog(@"当前类名（NSStringFromClass）：%@", clz);
//    
//    NSLog(@"%@", [NSThread callStackSymbols]);// 返回当前调用栈信息
//}

@end
