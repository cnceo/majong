//
//  VZArchievementDailyZen.h
//  Mahjong
//
//  Created by 穆暮 on 14-9-18.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZArchievementBase.h"

@interface VZArchievementDailyZen : VZArchievementBase
{
    
}

@property (nonatomic, assign)int target;

+(id)archievementChekerWithID:(NSString*)archievementID Target:(int)target;

@end
