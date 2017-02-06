//
//  ShopLayer.m
//  Mahjong
//
//  Created by 穆暮 on 14-9-8.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "ShopLayer.h"
#import "VZCommonDefine.h"
#import "VZButton.h"
#import "VZIdentifyManager.h"
#import "VZInAppPurchaseManager.h"
#import "VZCommodityManager.h"

@implementation ShopLayer

+(ShopLayer*)layer
{
    return [[self alloc] init];
}

-(id)init
{
    CCColor* color = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    if(self = [super initWithColor:color])
    {
        
        float  FontSize1    = 16;
        float  FontSize2    = 12;
        float  FontSize3    = 20;
        
        CCSprite* bg = [CCSprite spriteWithImageNamed:@"bg_shop.png"];
        bg.position = ccp(0, 0);
        [self.window addChild:bg];
        
        CCSprite* title = [CCSprite spriteWithImageNamed:@"lb_shop.png"];
        title.position = ccp(0, 134);
        [self.window addChild:title];
        
        
        VZButton* btTerminate = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_terminate.png"]];
        btTerminate.position = ccp(100, 124);
        [btTerminate setTarget:self selector:@selector(onTerminate:)];
        [self.window addChild:btTerminate];
        
        
        
        
        
        CCLabelTTF* lbOwned = [CCLabelTTF labelWithString:NSLocalizedString(@"Props you owned:", nil) fontName:SYSTEM_FONT fontSize:FontSize1];
        lbOwned.anchorPoint = ccp(0, 0.5);
        lbOwned.position = ccp(-95, 106);
        [self.window addChild:lbOwned];
        
        
        CCSprite* iconHint = [CCSprite spriteWithImageNamed:@"lb_search.png"];
        iconHint.position = ccp(-60, 76);
        [self.window addChild:iconHint];
        
        _hint = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[VZCommodityManager sharedVZCommodityManager].hint] fontName:SYSTEM_FONT fontSize:FontSize2];
        _hint.position = ccp(-40, 64);
        [self.window addChild:_hint];
        
        
        CCSprite* iconShuffle = [CCSprite spriteWithImageNamed:@"lb_reorder.png"];
        iconShuffle.position = ccp(0, 76);
        [self.window addChild:iconShuffle];
        
        _shuffle = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[VZCommodityManager sharedVZCommodityManager].shuffle] fontName:SYSTEM_FONT fontSize:FontSize2];
        _shuffle.position = ccp(20, 64);
        [self.window addChild:_shuffle];
        
        
        CCSprite* iconSunshine = [CCSprite spriteWithImageNamed:@"lb_sun.png"];
        iconSunshine.position = ccp(60, 76);
        [self.window addChild:iconSunshine];
        
        _sunshine = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[VZCommodityManager sharedVZCommodityManager].sunshine] fontName:SYSTEM_FONT fontSize:FontSize2];
        _sunshine.position = ccp(80, 64);
        [self.window addChild:_sunshine];
        
        
        CCLabelTTF* lbBuy = [CCLabelTTF labelWithString:NSLocalizedString(@"Props to Buy", nil) fontName:SYSTEM_FONT fontSize:FontSize3];
        lbBuy.anchorPoint = ccp(0.5, 0.5);
        lbBuy.position = ccp(0, 40);
        [self.window addChild:lbBuy];
        
        
        _productNode = [CCNode node];
        [self.window addChild:_productNode];
        
        
        
        
        
        
        
        [self updatePropsCount];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePropsCount) name:kCommodityManagerNeedUpdate object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProducts) name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productNotFound) name:kInAppPurchaseManagerProductsNotFoundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseFailed) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseCancled) name:kInAppPurchaseManagerTransactionCancelNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseSucceeded) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreSucceeded) name:kInAppPurchaseManagerTransactionRestoreCompleteNotification object:nil];
        
        _loadingNode = [CCNode node];
        [self.window addChild:_loadingNode];
        
        
        CCLabelTTF* lbLoad = [CCLabelTTF labelWithString:NSLocalizedString(@"Loading...", nil) fontName:SYSTEM_FONT fontSize:30];
        lbLoad.position = ccp(0, -30);
        [_loadingNode addChild:lbLoad z:0 name:@"Label"];
        
        _loadingNode.visible = YES;
        
        _productNode.visible = NO;
        [[VZInAppPurchaseManager sharedVZInAppPurchaseManager] requestProUpgradeProductData];
        

        _lockLayer = [VZAlertLayer nodeWithColor:[CCColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        [self addChild:_lockLayer];
        
        [self purchaseCancled];
        
        if([VZInAppPurchaseManager sharedVZInAppPurchaseManager].proUpgradeProduct.count > 0)
        {
            [self showProducts];
        }
        else
        {
            _hasFailed = NO;
            [[VZInAppPurchaseManager sharedVZInAppPurchaseManager] requestProUpgradeProductData];
            [self scheduleOnce:@selector(loadProductsFailed) delay:10];
        }

        
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadProductsFailed
{
    _loadingNode.visible = YES;
    
    CCLabelTTF* label = (CCLabelTTF*)[_loadingNode getChildByName:@"Label" recursively:NO];
    label.string = NSLocalizedString(@"Can't Load Products.", nil);
    _productNode.visible = NO;
    _hasFailed = YES;
}

-(void)showProducts
{
    if(_hasFailed)
        return;
    
    float  FontSize1    = 10;
    float  FontSize2    = 12;
    NSString* fontName = @"STHeitiTC-Medium";
    
    
    _loadingNode.visible = NO;
    _productNode.visible = YES;
    
    CCSprite* bIconHint1 = [CCSprite spriteWithImageNamed:@"lb_search.png"];
    bIconHint1.position = ccp(-60, 3);
    [_productNode addChild:bIconHint1];
    
    CCLabelTTF* bHint1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",10] fontName:SYSTEM_FONT fontSize:FontSize2];
    bHint1.position = ccp(-40, -9);
    [_productNode addChild:bHint1];
    
    
    VZButton* btHint1 = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_buy.png"]];
    btHint1.position = ccp(-60, -28);
    [btHint1 setTarget:self selector:@selector(onBuy:)];
    btHint1.name =@"mahjong.hint1";
    btHint1.label.fontName = fontName;
    btHint1.label.outlineColor = [CCColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];;
    btHint1.label.outlineWidth = 0.5;
    btHint1.label.fontSize = FontSize1;
    btHint1.label.string = [[VZInAppPurchaseManager sharedVZInAppPurchaseManager] priceWithIdentifier:btHint1.name];
    [_productNode addChild:btHint1];
    
    
    
    
    CCSprite* bIconShuffle1 = [CCSprite spriteWithImageNamed:@"lb_reorder.png"];
    bIconShuffle1.position = ccp(0, 3);
    [_productNode addChild:bIconShuffle1];
    
    CCLabelTTF* bShuffle1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",5] fontName:SYSTEM_FONT fontSize:FontSize2];
    bShuffle1.position = ccp(20, -9);
    [_productNode addChild:bShuffle1];
    
    VZButton* btShuffle1 = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_buy.png"]];
    btShuffle1.position = ccp(0, -28);
    [btShuffle1 setTarget:self selector:@selector(onBuy:)];
    btShuffle1.name =@"mahjong.shuffle1";
    btShuffle1.label.fontName = fontName;
    btShuffle1.label.outlineColor = [CCColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];;
    btShuffle1.label.outlineWidth = 0.5;
    btShuffle1.label.fontSize = FontSize1;
    btShuffle1.label.string = [[VZInAppPurchaseManager sharedVZInAppPurchaseManager] priceWithIdentifier:btShuffle1.name];
    [_productNode addChild:btShuffle1];
    
    
    
    CCSprite* bIconSunshine1 = [CCSprite spriteWithImageNamed:@"lb_sun.png"];
    bIconSunshine1.position = ccp(60, 3);
    [_productNode addChild:bIconSunshine1];
    
    CCLabelTTF* bSunshine1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",3] fontName:SYSTEM_FONT fontSize:FontSize2];
    bSunshine1.position = ccp(80, -9);
    [_productNode addChild:bSunshine1];
    
    VZButton* btSunshine1 = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_buy.png"]];
    btSunshine1.position = ccp(60, -28);
    [btSunshine1 setTarget:self selector:@selector(onBuy:)];
    btSunshine1.name =@"mahjong.sunshine1";
    btSunshine1.label.fontName = fontName;
    btSunshine1.label.outlineColor = [CCColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];;
    btSunshine1.label.outlineWidth = 0.5;
    btSunshine1.label.fontSize = FontSize1;
    btSunshine1.label.string = [[VZInAppPurchaseManager sharedVZInAppPurchaseManager] priceWithIdentifier:btSunshine1.name];
    [_productNode addChild:btSunshine1];
    
    
    
    
    CCSprite* bIconHint2 = [CCSprite spriteWithImageNamed:@"lb_search.png"];
    bIconHint2.position = ccp(-60, -65);
    [_productNode addChild:bIconHint2];
    
    CCLabelTTF* bHint2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",120] fontName:SYSTEM_FONT fontSize:FontSize2];
    bHint2.position = ccp(-40, -77);
    [_productNode addChild:bHint2];
    
    VZButton* btHint2 = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_buy.png"]];
    btHint2.position = ccp(-60, -96);
    [btHint2 setTarget:self selector:@selector(onBuy:)];
    btHint2.name =@"mahjong.hint2";
    btHint2.label.fontName = fontName;
    btHint2.label.outlineColor = [CCColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];;
    btHint2.label.outlineWidth = 0.5;
    btHint2.label.fontSize = FontSize1;
    btHint2.label.string = [[VZInAppPurchaseManager sharedVZInAppPurchaseManager] priceWithIdentifier:btHint2.name];
    [_productNode addChild:btHint2];
    
    
    CCSprite* bIconShuffle2 = [CCSprite spriteWithImageNamed:@"lb_reorder.png"];
    bIconShuffle2.position = ccp(0, -65);
    [_productNode addChild:bIconShuffle2];
    
    CCLabelTTF* bShuffle2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",60] fontName:SYSTEM_FONT fontSize:FontSize2];
    bShuffle2.position = ccp(20, -77);
    [_productNode addChild:bShuffle2];
    
    VZButton* btShuffle2 = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_buy.png"]];
    btShuffle2.position = ccp(0, -96);
    [btShuffle2 setTarget:self selector:@selector(onBuy:)];
    btShuffle2.name =@"mahjong.shuffle2";
    btShuffle2.label.fontName = fontName;
    btShuffle2.label.outlineColor = [CCColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];;
    btShuffle2.label.outlineWidth = 0.5;
    btShuffle2.label.fontSize = FontSize1;
    btShuffle2.label.string = [[VZInAppPurchaseManager sharedVZInAppPurchaseManager] priceWithIdentifier:btShuffle2.name];
    [_productNode addChild:btShuffle2];
    
    
    CCSprite* bIconSunshine2 = [CCSprite spriteWithImageNamed:@"lb_sun.png"];
    bIconSunshine2.position = ccp(60, -65);
    [_productNode addChild:bIconSunshine2];
    
    CCLabelTTF* bSunshine2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",35] fontName:SYSTEM_FONT fontSize:FontSize2];
    bSunshine2.position = ccp(80, -77);
    [_productNode addChild:bSunshine2];
    
    VZButton* btSunshine2 = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_buy.png"]];
    btSunshine2.position = ccp(60, -96);
    [btSunshine2 setTarget:self selector:@selector(onBuy:)];
    btSunshine2.name =@"mahjong.sunshine2";
    btSunshine2.label.fontName = fontName;
    btSunshine2.label.outlineColor = [CCColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];;
    btSunshine2.label.outlineWidth = 0.5;
    btSunshine2.label.fontSize = FontSize1;
    btSunshine2.label.string = [[VZInAppPurchaseManager sharedVZInAppPurchaseManager] priceWithIdentifier:btSunshine2.name];
    [_productNode addChild:btSunshine2];
}

-(void)updatePropsCount
{
    _hint.string = [NSString stringWithFormat:@"%d",[VZCommodityManager sharedVZCommodityManager].hint];
    _shuffle.string = [NSString stringWithFormat:@"%d",[VZCommodityManager sharedVZCommodityManager].shuffle];
    _sunshine.string = [NSString stringWithFormat:@"%d",[VZCommodityManager sharedVZCommodityManager].sunshine];
}

- (void)onTerminate:(id)sender
{
    self.parent.paused = NO;
    [self removeFromParent];
}

- (void)onBuy:(id)sender
{
    VZButton* button = (VZButton*)sender;
   [[VZInAppPurchaseManager sharedVZInAppPurchaseManager] purchaseProduct:button.name];
    [self lock];
}


-(void)productNotFound
{
    _lockLayer.visible = NO;
    _lockLayer.userInteractionEnabled = NO;
    [_activityIndicator removeFromSuperview];
    _activityIndicator = nil;
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:NSLocalizedString(@"Product Not Found", nil) fontName:SYSTEM_FONT fontSize:16];
    label.position = ccp(0, 0);
    [self.window addChild:label];
    
    CCActionSequence* sequence = [CCActionSequence actions:
                                  [CCActionDelay actionWithDuration:1],
                                  [CCActionCallFunc actionWithTarget:label selector:@selector(removeFromParent)],
                                  nil];
    [label runAction:sequence];
}

-(void)purchaseFailed
{
    _lockLayer.visible = NO;
    _lockLayer.userInteractionEnabled = NO;
    [_activityIndicator removeFromSuperview];
    _activityIndicator = nil;
}

-(void)purchaseCancled
{
    _lockLayer.visible = NO;
    _lockLayer.userInteractionEnabled = NO;
    [_activityIndicator removeFromSuperview];
    _activityIndicator = nil;
}

-(void)purchaseSucceeded
{
    _lockLayer.visible = NO;
    _lockLayer.userInteractionEnabled = NO;
    [_activityIndicator removeFromSuperview];
    _activityIndicator = nil;
    
}

-(void)restoreSucceeded
{
    _lockLayer.visible = NO;
    _lockLayer.userInteractionEnabled = NO;
    [_activityIndicator removeFromSuperview];
    _activityIndicator = nil;
}

-(void)lock
{
    if(_activityIndicator != nil)
    {
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }

    _lockLayer.visible = YES;
    _lockLayer.userInteractionEnabled = YES;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    ;
    [_activityIndicator setCenter:CGPointMake([CCDirector sharedDirector].view.frame.size.width * 0.5, [CCDirector sharedDirector].view.frame.size.height * 0.5)];
    [[CCDirector sharedDirector].view addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
}

@end
