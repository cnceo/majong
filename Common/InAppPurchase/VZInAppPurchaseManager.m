//
//  InAppPurchaseManager.m
//  unblock
//
//  Created by 张朴军 on 13-1-18.
//  Copyright (c) 2013年 张朴军. All rights reserved.
//

#import "VZInAppPurchaseManager.h"
#import "cocos2d.h"
#import "VZIdentifyManager.h"
@implementation VZInAppPurchaseManager



VZ_SYNTHESIZE_SINGLETON_FOR_CLASS(VZInAppPurchaseManager)

- (void)requestProUpgradeProductData
{
    
    NSArray* array = [[VZIdentifyManager sharedVZIdentifyManager] objectForIdentifyInfoDictionaryKey:@"kVZIdentifyInAppPurchases"];
    
    NSSet *productIdentifiers = [NSSet setWithArray:array];
    
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.proUpgradeProduct = response.products;

    for (SKProduct* productItem in self.proUpgradeProduct)
    {
        NSLog(@"Product title: %@" , productItem.localizedTitle);
        NSLog(@"Product description: %@" , productItem.localizedDescription);
        NSLog(@"Product price: %@ %@" , productItem.price, [productItem.priceLocale objectForKey:NSLocaleCurrencySymbol]);
        NSLog(@"Product id: %@" , productItem.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    

    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

#pragma -
#pragma Public methods

//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (BOOL)purchaseProduct:(NSString*)string
{
    if(![self canMakePurchases])
    {
        [self showAlert];
    }
    else
    {
        SKProduct * products = nil;
        for (SKProduct* temp in self.proUpgradeProduct)
        {
            if ([temp.productIdentifier isEqualToString:string])
            {
                products = temp;
                break;
            }
        }
        
        if (products != nil)
        {
            SKPayment *payment = [SKPayment paymentWithProduct:products];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            return YES;
        }
        else
        {
            [self showAlert];
            NSLog(@"Can not find Product %@",string);
            return NO;
        }
    }
    return NO;
}

- (SKProduct*)productWithIdentifier:(NSString*)identifer
{
    for (SKProduct* temp in self.proUpgradeProduct)
    {
        if ([temp.productIdentifier isEqualToString:identifer])
        {
            return temp;
            break;
        }
    }
    return nil;
}

- (NSString*)priceWithIdentifier:(NSString*)identifer
{
    for (SKProduct* temp in self.proUpgradeProduct)
    {
        if ([temp.productIdentifier isEqualToString:identifer])
        {
            NSString* symbol = [temp.priceLocale objectForKey:NSLocaleCurrencySymbol];
            NSString* price = [NSString stringWithFormat:@"%.2f",[temp.price floatValue]];
            return [NSString stringWithFormat:@"%@%@",symbol,price];
            break;
        }
    }
    return @"--";
}

-(void)restorePurchases
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}



- (void)showAlert
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Can't Make Purchases.",nil)
                                                message:NSLocalizedString(@"Can not connect iTune Store, please try again later.",nil)
                                               delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                      otherButtonTitles:nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsNotFoundNotification object:self userInfo:nil];
}


#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
//    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
//    {
//        // save the transaction receipt to disk
//        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
//    if ([productId isEqualToString:kInAppPurchaseProUpgradeProductId])
//    {
//        // enable the pro features
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionCancelNotification object:self userInfo:nil];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionRemovedNotification object:self userInfo:nil];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionRestoreCompleteNotification object:self userInfo:nil];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    //NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionRestoreFailedNotification object:self userInfo:nil];
}

@end
