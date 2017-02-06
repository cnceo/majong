//
//  LevelManager.h
//  unblock
//
//  Created by 张朴军 on 12-12-25.
//  Copyright (c) 2012年 张朴军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZCommonDefine.h"
#import "VZModeArchive.h"
#import "VZLevelArchive.h"

#define MAX_MODES 16
#define MAX_LEVELS 20

@interface VZArchiveManager : NSObject
{
    
}

@property (nonatomic, strong)NSMutableDictionary* dictionary;
@property (nonatomic, assign)int modes;
@property (nonatomic, assign)int accomplishedDailyZen;
@property (nonatomic, assign)int maxCombos;

VZ_DECLARE_SINGLETON_FOR_CLASS(VZArchiveManager)

-(void)load;
-(void)save;

-(VZModeArchive*)modeArchiveAtIndex:(int)index;
-(void)setModeArchive:(VZModeArchive*)archive AtIndex:(int)index;

-(void)setHighScore:(float)score Season:(int)season Level:(int)level;
-(float)highScoreWithSeason:(int)season Level:(int)level;

-(void)setStars:(int)stars Season:(int)season Level:(int)level;
-(int)starsWithSeason:(int)season Level:(int)level;

-(void)setLocked:(BOOL)islocked Season:(int)season Level:(int)level;
-(BOOL)lockedWithSeason:(int)season Level:(int)level;

-(void)setLocked:(BOOL)islocked Season:(int)season;
-(BOOL)lockedWithSeason:(int)season;

-(BOOL)checkUnlockForSeason:(int)season;

-(int)totalStars;

-(int)AccomplishedLevels;

-(BOOL)canDaily;
-(void)recordDaily;

@end
