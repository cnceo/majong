//
//  CommodityManager.h
//  unblock
//
//  Created by 张朴军 on 13-1-18.
//  Copyright (c) 2013年 张朴军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZCommonDefine.h"

#define kCommodityManagerNeedUpdate @"kCommodityManagerNeedUpdate"

@interface VZCommodityManager : NSObject
{

}

VZ_DECLARE_SINGLETON_FOR_CLASS(VZCommodityManager)


@property (nonatomic, assign)int hint;
@property (nonatomic, assign)int shuffle;
@property (nonatomic, assign)int sunshine;

@property (nonatomic, strong)NSMutableDictionary* dictionary;


-(void)load;
-(void)save;

@end
