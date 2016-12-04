//
//  VZReachability.h
//  Untitled
//
//  Created by VincentZhang on 15/3/15.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "Reachability.h"
#import "VZCommonDefine.h"

extern NSString *const kVZReachabilityChangedNotification;

@interface VZReachability : Reachability
{
    
}
VZ_DECLARE_SINGLETON_FOR_CLASS(VZReachability)

@property (nonatomic, strong)Reachability* internetReach;


- (NetworkStatus)currentReachabilityStatus;

@end
