//
//  LevelInfo.m
//  unblock
//
//  Created by 张朴军 on 12-12-25.
//  Copyright (c) 2012年 张朴军. All rights reserved.
//

#import "VZModeArchive.h"

@implementation VZModeArchive

+(id)modeArchive
{
    return [[self alloc] init] ;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.isLocked forKey:@"isLocked"];
    [aCoder encodeObject:self.levelArchive forKey:@"levels"];
    [aCoder encodeInt:self.unlockStars forKey:@"unlockStars"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.isLocked = [aDecoder decodeBoolForKey:@"isLocked"];
        self.levelArchive = [aDecoder decodeObjectForKey:@"levels"];
        self.unlockStars = [aDecoder decodeIntForKey:@"unlockStars"];
    }
    return self;
}


-(id)init
{
    if(self = [super init])
    {
        self.isLocked = YES;
        self.levelArchive = [NSMutableArray array];
        self.unlockStars = 0;
    }
    return self;
}

-(void)dealloc
{
    self.levelArchive = nil;
}

-(VZLevelArchive*)levelArchiveAtIndex:(int)index
{
    return [self.levelArchive objectAtIndex:index];
}

-(void)setLevelArchive:(VZLevelArchive*)archive AtIndex:(int)index
{
    [self.levelArchive setObject:archive atIndexedSubscript:index];
}

-(BOOL)checkForUnLockWithStars:(int)stars
{
    if(stars >= self.unlockStars)
    {
        self.isLocked = NO;
        return YES;
    }
    
    return NO;
}

@end
