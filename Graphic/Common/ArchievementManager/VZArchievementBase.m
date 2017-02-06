//
//  VZArchievementCheker.m
//  Mahjong
//
//  Created by 穆暮 on 14-9-10.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZArchievementBase.h"
@implementation VZArchievementBase

+(id)archievementChekerWithID:(NSString *)archievementID
{
    return [[self alloc] initWithID:archievementID];
}

-(id)initWithID:(NSString *)archievementID
{
    if (self = [super init])
    {
        self.archievementID = archievementID;
    }
    return self;
}

-(void)check
{
    
}

@end
