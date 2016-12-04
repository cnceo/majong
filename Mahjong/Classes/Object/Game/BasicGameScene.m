//
//  BasicGameScene.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-17.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "BasicGameScene.h"

@implementation BasicGameScene

+ (BasicGameScene *)sceneWithSeason:(int)season Level:(int)level
{
    return [[self alloc] initWithSeason:season Level:level];
}

-(id)initWithSeason:(int)season Level:(int)level
{
    if(self = [super init])
    {
        _level = level;
        _season = season;
        _score = 0;
        _stars = 0;
    }
    return self;
}



@end
