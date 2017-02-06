//
//  VZReachability.m
//  Untitled
//
//  Created by VincentZhang on 15/3/15.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "VZReachability.h"

NSString *const kVZReachabilityChangedNotification = @"kVZReachabilityChangedNotification";

@implementation VZReachability

VZ_SYNTHESIZE_SINGLETON_FOR_CLASS(VZReachability)

-(id)init
{
    if(self = [super init])
    {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

        _internetReach = [Reachability reachabilityForInternetConnection];
        [_internetReach startNotifier];
        [self updateWithReachability:_internetReach];
        
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_internetReach stopNotifier];
    self.internetReach = nil;
}

-(NetworkStatus)currentReachabilityStatus
{
    return [_internetReach currentReachabilityStatus];
}

- (void)reachabilityChanged:(NSNotification *)note
{
    NSLog(@"%s",__FUNCTION__);
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateWithReachability:curReach];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kVZReachabilityChangedNotification object: note];
}

- (void)updateWithReachability:(Reachability *)curReach
{
    if (curReach == _internetReach)
    {
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        switch (netStatus)
        {
            case NotReachable:
            {
                NSLog(@"Internet Not Reach");
            }
                break;
            case ReachableViaWiFi:
            {
                NSLog(@"Internet WiFi Reach");
            }
                break;
            case ReachableViaWWAN:
            {
                NSLog(@"Internet WWAN Reach");
            }
                break;
                
            default:
                break;
        }
    }
}

@end
