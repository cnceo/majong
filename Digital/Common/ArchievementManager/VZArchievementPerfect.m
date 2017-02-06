//
//  VZArchievementPerfect.m
//  Mahjong
//
//  Created by 穆暮 on 14-9-11.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZArchievementPerfect.h"

@implementation VZArchievementPerfect

+(id)archievementChekerWithID:(NSString*)archievementID Range:(NSRange)range
{
    return [[self alloc] initWithID:archievementID Range:range];
}

-(id)initWithID:(NSString*)archievementID Range:(NSRange)range
{
    if(self = [super initWithID:archievementID])
    {
        self.range = range;
    }
    return self;
}

-(void)check
{
    
    
}

@end
