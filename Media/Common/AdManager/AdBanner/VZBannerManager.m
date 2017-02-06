//
//  ADBannerManager.m
//  Happy Jumping Bug
//
//  Created by 张朴军 on 13-4-22.
//  Copyright (c) 2013年 张朴军. All rights reserved.
//

#import "VZBannerManager.h"
#import "VZUserDefault.h"
#import "cocos2d.h"

NSString * const kVZBannerManagerDidLoadAd = @"kVZBannerManagerDidLoadAd";
NSString * const kVZBannerManagerDidFailToReceiveAd = @"kVZBannerManagerDidFailToReceiveAd";
NSString * const kVZBannerManagerRemoved = @"kVZBannerManagerRemoved";

NSString* const DefaultAdmobBannerID = @"ca-app-pub-3464821182263759/1153142422";

NSString * const kVZBannerManagerDataRootKey = @"kVZBannerManagerDataRootKey";
NSString * const kEnableKey = @"kEnableKey";

@implementation VZBannerManager

VZ_SYNTHESIZE_SINGLETON_FOR_CLASS(VZBannerManager)

-(id)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resize) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [self.GADView removeFromSuperview];
    self.GADView.delegate = nil;
    self.GADView = nil;
}


- (id)objectForKey:(NSString *)defaultName;
{
    NSString* key = [defaultName stringByAppendingString:kVZBannerManagerDataRootKey];
    return [[VZUserDefault sharedVZUserDefault] objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)defaultName
{
    NSString* key = [defaultName stringByAppendingString:kVZBannerManagerDataRootKey];
    [[VZUserDefault sharedVZUserDefault] setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)defaultName
{
    NSString* key = [defaultName stringByAppendingString:kVZBannerManagerDataRootKey];
    [[VZUserDefault sharedVZUserDefault] removeObjectForKey:key];
}

-(BOOL)isEnable
{
    NSNumber* number = [self objectForKey:kEnableKey];
    if(number)
        return [number boolValue];
    
    return YES;
}

-(void)setEnable:(BOOL)enable
{
    [self setObject:[NSNumber numberWithBool:enable] forKey:kEnableKey];
}


-(BOOL)hadBannerShowing
{
    return _GADHasLoaded;
}

-(CGSize)bannerSize
{
    CGSize size = CGSizeMake(0, 0);
    if(self.GADView)
    {
        CGRect bannerFrame = self.GADView.frame;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            size = CGSizeMake(bannerFrame.size.width * 0.5f, bannerFrame.size.height * 0.5f);
        }
        else
        {
            size = bannerFrame.size;
        }
    }
    
    return size;
}

-(void)remove
{
    [self setEnable:NO];
    [self.GADView removeFromSuperview];
    self.GADView.delegate = nil;
    self.GADView = nil;
    _GADHasLoaded = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kVZBannerManagerRemoved object:nil userInfo:nil];
}

-(void)load
{
    if([self isEnable])
    {
        [self creatGAD];
    }
}

#pragma mark GADBannerView Creat

-(void)creatGAD
{
    self.GADView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.GADView.delegate = self;
    self.GADView.adUnitID = DefaultAdmobBannerID;
    self.GADView.rootViewController = [CCDirector sharedDirector];
    [[CCDirector sharedDirector].view addSubview:self.GADView];
    _GADHasLoaded = NO;
    [self requestGAD];
}

-(void)requestGAD
{
    if(self.GADView && self.GADView.rootViewController)
    {
        [self.GADView loadRequest:[self createRequest]];
    }
}

#pragma mark GADBannerView Adjust

-(GADRequest *)createRequest
{
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as
    // well as any devices you want to receive test ads.
    request.testDevices =
    [NSArray arrayWithObjects:
     // TODO: Add your device/simulator test identifiers here. They are
     // printed to the console when the app is launched.
     @"",
     nil];
    return request;
}

- (void)layoutGADAnimated:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        self.GADView.adSize = kGADAdSizeSmartBannerPortrait;
    }
    else
    {
        self.GADView.adSize = kGADAdSizeSmartBannerLandscape;
    }
    
    CGRect contentFrame = [CCDirector sharedDirector].view.bounds;
    CGRect bannerFrame = self.GADView.frame;
    
    if (_isAdPositionAtTop)
    {
        if (_GADHasLoaded)
        {
            bannerFrame.origin.x = (contentFrame.size.width - bannerFrame.size.width) * 0.5;
            bannerFrame.origin.y =  contentFrame.origin.y ;
        }
        else
        {
            bannerFrame.origin.x = (contentFrame.size.width - bannerFrame.size.width) * 0.5;
            bannerFrame.origin.y = contentFrame.origin.y - bannerFrame.size.height;
        }
    }
    else
    {
        if (_GADHasLoaded)
        {
            bannerFrame.origin.x = (contentFrame.size.width - bannerFrame.size.width) * 0.5;
            contentFrame.size.height -= self.GADView.frame.size.height;
            bannerFrame.origin.y = contentFrame.size.height;
        }
        else
        {
            bannerFrame.origin.x = (contentFrame.size.width - bannerFrame.size.width) * 0.5;
            bannerFrame.origin.y = contentFrame.size.height;
        }
    }
    
    if(_GADHasLoaded)
    {
        self.GADView.hidden = !_GADHasLoaded;
        [UIView animateWithDuration:animated ? 0.25 : 0.0
                         animations:^{self.GADView.frame = bannerFrame;}
         ];
    }
    else
    {
        [UIView animateWithDuration:animated ? 0.25 : 0.0
                         animations:^{self.GADView.frame = bannerFrame;}
                         completion:^(BOOL finished){self.GADView.hidden = !_GADHasLoaded;}];
    }
}

#pragma mark GADBannerViewDelegate impl

- (void)adViewDidReceiveAd:(GADBannerView *)adView
{
    _GADHasLoaded = YES;
    [self layoutGADAnimated:YES];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kVZBannerManagerDidLoadAd object:nil userInfo:nil];
    
    NSLog(@"[AdmobBanner]:Banner did load");
    
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    _GADHasLoaded = NO;
    [self layoutGADAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kVZBannerManagerDidFailToReceiveAd object:nil userInfo:nil];
    
    [self performSelector:@selector(requestGAD) withObject:self afterDelay:3];
    
    
    NSLog(@"[AdmobBanner]:Failed to load the banner: %@", [error localizedFailureReason]);
}

// 在系统响应用户触摸发送者的操作而即将向其展示全屏广告用户界面时发送
- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
    
}
// 在用户关闭发送者的全屏用户界面前发送
- (void)adViewWillDismissScreen:(GADBannerView *)adView
{
    
}
// 当用户已退出发送者的全屏用户界面时发送
- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
    
}
// 在应用因为用户触摸 Click-to-App-Store 或 Click-to-iTunes 横幅广告而转至后台或终止运行前发送
- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
    
}

#pragma mark ADBannerViewResizeForOrientation

-(void)resize
{
    [self layoutGADAnimated:NO];
}
@end
