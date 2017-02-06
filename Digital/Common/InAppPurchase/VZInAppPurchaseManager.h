//
//  InAppPurchaseManager.h
//  unblock
//
//  Created by 张朴军 on 13-1-18.
//  Copyright (c) 2013年 张朴军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "VZCommonDefine.h"
#import "VZIdentifyManager.h"
#import "MBProgressHUD.h"
#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerProductsNotFoundNotification @"kInAppPurchaseManagerProductsNotFoundNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionCancelNotification @"kInAppPurchaseManagerTransactionCancelNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"
#define kInAppPurchaseManagerTransactionRemovedNotification @"kInAppPurchaseManagerTransactionRemovedNotification"
#define kInAppPurchaseManagerTransactionRestoreCompleteNotification @"kInAppPurchaseManagerTransactionRestoreCompleteNotification"
#define kInAppPurchaseManagerTransactionRestoreFailedNotification @"kInAppPurchaseManagerTransactionRestoreFailedNotification"

@interface VZInAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver, UIAlertViewDelegate>
{

}

VZ_DECLARE_SINGLETON_FOR_CLASS(VZInAppPurchaseManager)

@property (nonatomic, strong)SKProductsRequest* productsRequest;
@property (nonatomic, strong)NSArray* proUpgradeProduct;

- (void)requestProUpgradeProductData;
- (void)loadStore;
- (BOOL)canMakePurchases;

- (void)restorePurchases;

- (BOOL)purchaseProduct:(NSString*)string;

- (SKProduct*)productWithIdentifier:(NSString*)identifer;
- (NSString*)priceWithIdentifier:(NSString*)identifer;

- (void)showAlert;

@end
