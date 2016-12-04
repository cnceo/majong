//
//  BasicGameScene.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-17.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZScene.h"



@interface BasicGameScene : VZScene
{
    
}

@property (nonatomic, readonly)int season;
@property (nonatomic, readonly)int level;
@property (nonatomic, assign)float score;
@property (nonatomic, assign)int stars;



+ (BasicGameScene *)sceneWithSeason:(int)season Level:(int)level;

-(id)initWithSeason:(int)season Level:(int)level;



@end
