//
//  VZArchievementStar.m
//  Mahjong
//
//  Created by 穆暮 on 14-9-11.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZArchievementStar.h"


@implementation VZArchievementStar

+(id)archievementChekerWithID:(NSString*)archievementID Target:(int)target
{
    return [[self alloc] initWithID:archievementID Target:target];
}

-(id)initWithID:(NSString*)archievementID Target:(int)target
{
    if(self = [super initWithID:archievementID])
    {
        self.target = target;
    }
    return self;
}

-(void)check
{
    
   
}

@end
