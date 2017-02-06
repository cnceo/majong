//
//  VZArchievementComplete.h
//  Mahjong
//
//  Created by 穆暮 on 14-9-11.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZArchievementBase.h"

@interface VZArchievementComplete : VZArchievementBase
{
    
}

@property (nonatomic, assign)NSRange range;

+(id)archievementChekerWithID:(NSString*)archievementID Range:(NSRange)range;

@end
