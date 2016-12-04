//
//  AppDelegate.m
//  Mahjong
//
//  Created by 穆暮 on 14-9-7.
//  Copyright 穆暮 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

#import "AppDelegate.h"
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "VZBannerManager.h"
#import "VZInterstitialManager.h"
#import "VZIdentifyManager.h"

#import "OALSimpleAudio.h"
#import "VZUserDefault.h"
#import "VZArchiveManager.h"
#import "VZAudioManager.h"
#import "VZRateManager.h"
#import "Appirater.h"
#import "WXApi.h"
#import "VZInAppPurchaseManager.h"
#import "VZCommodityManager.h"

#import "VZArchievementManager.h"
#import "VZGameCenter.h"
@implementation AppDelegate

// 
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// This is the only app delegate method you need to implement when inheriting from CCAppDelegate.
	// This method is a good place to add one time setup code that only runs when your app is first launched.
	
	// Setup Cocos2D with reasonable defaults for everything.
	// There are a number of simple options you can change.
	// If you want more flexibility, you can configure Cocos2D yourself instead of calling setupCocos2dWithOptions:.
	[self setupCocos2dWithOptions:@{
		// Show the FPS and draw call label.
		CCSetupShowDebugStats: @(NO),
		
		// More examples of options you might want to fiddle with:
		// (See CCAppDelegate.h for more information)
		
		// Use a 16 bit color buffer: 
//		CCSetupPixelFormat: kEAGLColorFormatRGB565,
		// Use a simplified coordinate system that is shared across devices.
		CCSetupScreenMode: CCScreenModeFlexible,
		// Run in portrait mode.
		CCSetupScreenOrientation: CCScreenOrientationLandscape,
		// Run at a reduced framerate.
		CCSetupAnimationInterval: @(1.0/60.0),
		// Run the fixed timestep extra fast.
//		CCSetupFixedUpdateInterval: @(1.0/180.0),
		// Make iPad's act like they run at a 2x content scale. (iPad retina 4x)
		CCSetupTabletScale2X: @(YES),
	}];
    
    
    [WXApi registerApp:@"wx08e77be83c48b69e"];

    [Appirater setDebug:NO];
    [Appirater setAppId:[[VZIdentifyManager sharedVZIdentifyManager] objectForIdentifyInfoDictionaryKey:kVZIdentifyAppID]];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:2];
    [Appirater setSignificantEventsUntilPrompt:20];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setUsesAnimation:YES];
    [Appirater setOpenInAppStore:YES];
    [Appirater appLaunched:NO];
    
    
    
    [[VZBannerManager sharedVZBannerManager] load];
    [[VZInterstitialManager sharedVZInterstitialManager] config];
    [[VZInterstitialManager sharedVZInterstitialManager] cache];
    
    [[VZGameCenter sharedVZGameCenter] setupManager];
    

    [[VZCommodityManager sharedVZCommodityManager] load];
    [[VZInAppPurchaseManager sharedVZInAppPurchaseManager] loadStore];
    
    
	return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] stopAnimation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation]; 
}

-(CCScene *)startScene
{
	// This method should return the very first scene to be run when your app starts.
	return [IntroScene scene];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [super applicationDidBecomeActive:application];
    
    [Appirater appEnteredForeground:YES];
}

-(void) onReq:(BaseReq*)req
{
    
}

-(void) onResp:(BaseResp*)resp
{
    
}

@end
