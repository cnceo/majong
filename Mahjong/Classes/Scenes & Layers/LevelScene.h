//
//  LevelScene.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-16.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZScene.h"
#import "VZArchiveManager.h"
#define MAX_LEVELSCENE_PAGE     (MAX_LEVELS / MAX_LEVELSCENE_ROW / MAX_LEVELSCENE_COLUMN)
#define MAX_LEVELSCENE_ROW      4
#define MAX_LEVELSCENE_COLUMN   5

@interface LevelScene : VZScene
{
    
}

@property (nonatomic, assign)int season;
@property (nonatomic, assign)int level;

+ (LevelScene *)sceneWithSeason:(int)season Level:(int)level;

@end
