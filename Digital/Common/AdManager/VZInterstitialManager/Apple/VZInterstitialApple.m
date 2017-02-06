//
//  VZInterstitialApple.m
//  Unblock
//
//  Created by VincentZhang on 15/8/3.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "VZInterstitialApple.h"
#import "VZInterstitialManager.h"
@implementation VZInterstitialApple

-(instancetype)init
{
    if(self = [super init])
    {
        self.platform = VZPlatformApple;
    }
    return self;
}

-(void)dealloc
{
    [self.interstitialAd setDelegate:nil];
}

- (BOOL)canDisplayIAD
{
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    
    NSMutableSet* countries = [NSMutableSet setWithObjects:
                               @"AI",//Anguilla
                               @"AG",//Antigua & Barbuda
                               @"AR",//Argentina
                               @"AM",//Armenia
                               @"AU",//Australia
                               @"AT",//Austria
                               @"BS",//Bahamas
                               @"BB",//Barbados
                               @"BY",//Belarus
                               @"BE",//Belgium
                               @"BZ",//Belize
                               @"BM",//Bermuda
                               @"BO",//Bolivia
                               @"BW",//Botswana
                               @"BR",//Brazil
                               @"VG",//British Virgin Islands
                               @"BN",//Brunei Darussalam
                               @"BG",//Bulgaria
                               @"BF",//Burkina-Faso
                               @"KH",//Cambodia
                               @"CA",//Canada
                               @"CV",//Cape Verde
                               @"KY",//Cayman Islands
                               @"CL",//Chile
                               @"CO",//Colombia
                               @"CR",//Costa Rica
                               @"CY",//Cyprus
                               @"CZ",//Czech Republic
                               @"DK",//Denmark
                               @"DM",//Dominica
                               @"DO",//Dominican Republic
                               @"EC",//Ecuador
                               @"SV",//El Salvador
                               @"EE",//Estonia
                               @"FJ",//Fiji
                               @"FI",//Finland
                               @"FR",//France
                               @"GM",//Gambia
                               @"DE",//Germany
                               @"GH",//Ghana
                               @"GD",//Grenada
                               @"GR",//Greece
                               @"GT",//Guatemala
                               @"GW",//Guinea-Bissau
                               @"HN",//Honduras
                               @"HK",//Hong Kong
                               @"IN",//India
                               @"IE",//Ireland
                               @"IT",//Italy
                               @"JP",//Japan
                               @"KZ",//Kazakhstan
                               @"KE",//Kenya
                               @"KG",//Kyrgyzstan
                               @"LA",//Laos
                               @"LV",//Latvia
                               @"LT",//Lithuania
                               @"LU",//Luxembourg
                               @"MO",//Macau
                               @"MY",//Malaysia
                               @"MT",//Malta
                               @"MU",//Mauritius
                               @"MX",//Mexico
                               @"FM",//Micronesia
                               @"MN",//Mongolia
                               @"MZ",//Mozambique
                               @"NA",//Namibia
                               @"NP",//Nepal
                               @"NL",//Netherlands
                               @"NZ",//New Zealand
                               @"NI",//Nicaragua
                               @"NE",//Niger
                               @"NG",//Nigeria
                               @"NO",//Norway
                               @"PA",//Panama
                               @"PG",//Papua New Guinea
                               @"PY",//Paraguay
                               @"PE",//Peru
                               @"PL",//Poland
                               @"PT",//Portugal
                               @"RO",//Romania
                               @"RU",//Russia
                               @"SK",//Slovakia
                               @"SI",//Slovenia
                               @"ZA",//South Africa
                               @"ES",//Spain
                               @"LK",//Sri Lanka
                               @"VC",//St Kitts & Nevis
                               @"SZ",//Swaziland
                               @"SE",//Sweden
                               @"CH",//Switzerland
                               @"TW",//Taiwan
                               @"TJ",//Tajikistan
                               @"TH",//Thailand
                               @"TT",//Trinidad and Tobago
                               @"TR",//Turkey
                               @"TM",//Turkmenistan
                               @"UG",//Uganda
                               @"UA",//Ukraine
                               @"GB",//United Kingdom
                               @"US",//United States
                               @"VE",//Venezuela
                               @"ZW",//Zimbabwe
                               nil];
    if ([countries containsObject:countryCode])
    {
        return YES;
    }
    return NO;
}

-(void)cacheInterstitial
{
    if(!self.isConfiged)
        return;
    
    if([[VZReachability sharedVZReachability] currentReachabilityStatus] == NotReachable)
        return;
    
    if(![self canDisplayIAD])
        return;
    
    self.interstitialAd.delegate = nil;
    self.interstitialAd = nil;
    
    self.interstitialAd = [[ADInterstitialAd alloc] init] ;
    self.interstitialAd.delegate = self;
}


- (void)config
{
    self.isConfiged = YES;
}

-(void)cache
{
    if(!self.isConfiged)
        return;
    
    [self cacheInterstitial];
    
}

-(void)showIntersitial:(VZLocation)location
{
    if(self.interstitialAd.loaded)
    {
        [self.interstitialAd presentFromViewController:[CCDirector sharedDirector]];
        self.interstitialDisplayTimes++;
        NSLog(@"[%s]",__FUNCTION__);
    }
    else
    {
        [self cache];
        CCLOG(@"[iAdInterstitial]: No Content to show");
    }
}
-(BOOL)isIntersitialReady:(VZLocation)location
{
    return self.interstitialAd.loaded;
}

-(void)showReward:(VZLocation)location
{
    
}

-(BOOL)isRewardReady:(VZLocation)location
{
    return NO;
}

// 加载广告失败
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    [self performSelector:@selector(cacheInterstitial) withObject:self afterDelay:10];
    CCLOG(@"[iAdInterstitial]: Faild to load Interstital: %@", error);
}

// 广告加载完毕
- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd
{
    CCLOG(@"[iAdInterstitial]: Interstital has loaded.");
}

// 广告消失
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
    [[VZInterstitialManager sharedVZInterstitialManager] resumeDirector];
}

//即将加载广告
- (void)interstitialAdWillLoad:(ADInterstitialAd *)interstitialAd
{
    
}

// 是否允许展示广告
- (BOOL)interstitialAdActionShouldBegin:(ADInterstitialAd *)interstitialAd willLeaveApplication:(BOOL)willLeave
{
    if(willLeave)
        [[VZInterstitialManager sharedVZInterstitialManager] pauseDirector];
    return YES;
}

/*!
 * @method interstitialAdActionDidFinish:
 * This message is sent when the action has completed and control is returned to
 * the application. Games, media playback, and other activities that were paused
 * in response to the beginning of the action should resume at this point.
 */
- (void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd
{
    [[VZInterstitialManager sharedVZInterstitialManager] resumeDirector];
    [self cacheInterstitial];
}



@end
