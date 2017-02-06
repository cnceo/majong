//
//  VZArchievementCombo.h
//  Mahjong
//
//  Created by 穆暮 on 14-9-11.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZArchievementBase.h"

@interface VZArchievementCombo : VZArchievementBase
{
    
}

@property (nonatomic, assign)float target;

+(id)archievementChekerWithID:(NSString*)archievementID Target:(int)target;

@end
