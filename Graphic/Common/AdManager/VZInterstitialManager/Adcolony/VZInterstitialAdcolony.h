//
//  VZinterstitialAdcolony.h
//  Unblock
//
//  Created by VincentZhang on 15/8/3.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "VZInterstitialBase.h"
#import <AdColony/AdColony.h>

@interface VZInterstitialAdcolony : VZInterstitialBase <VZInterstitialProtocol, AdColonyDelegate, AdColonyAdDelegate>
{
    
}
@property(nonatomic, strong)NSMutableDictionary* locations;

@end
