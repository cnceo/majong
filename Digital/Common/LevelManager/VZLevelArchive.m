//
//  VZLevelArchive.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-13.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZLevelArchive.h"

@implementation VZLevelArchive

+(id)levelArchive
{
    return [[self alloc] init] ;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.isLocked forKey:@"isLocked"];
    [aCoder encodeFloat:self.highscore forKey:@"score"];
    [aCoder encodeInt:self.stars forKey:@"stars"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.isLocked = [aDecoder decodeBoolForKey:@"isLocked"];
        self.highscore = [aDecoder decodeFloatForKey:@"score"];
        self.stars = [aDecoder decodeIntForKey:@"stars"];
    }
    return self;
}

-(id)init
{
    if(self = [super init])
    {
        self.isLocked = YES;
        self.highscore = 0;
        self.stars = 0;
    }
    return self;
}



@end
