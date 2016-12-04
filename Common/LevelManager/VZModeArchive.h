//
//  LevelInfo.h
//  unblock
//
//  Created by 张朴军 on 12-12-25.
//  Copyright (c) 2012年 张朴军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZLevelArchive.h"
@interface VZModeArchive : NSObject <NSCoding>
{

}

@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, strong) NSMutableArray* levelArchive;
@property (nonatomic, assign) int unlockStars;
@property (nonatomic, assign) int maxLevels;

+(id)modeArchive;

-(VZLevelArchive*)levelArchiveAtIndex:(int)index;

-(void)setLevelArchive:(VZLevelArchive*)archive AtIndex:(int)index;

-(BOOL)checkForUnLockWithStars:(int)stars;

@end
