//
//  VZArchievementStatistics.h
//  Mahjong
//
//  Created by 穆暮 on 14-9-10.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZCommonDefine.h"

@interface VZArchievementManager : NSObject
{
    
}
VZ_DECLARE_SINGLETON_FOR_CLASS(VZArchievementManager)

@property (nonatomic, retain)NSMutableDictionary* dictionary;

-(void)checkArchievemens;

@end
