//
//  GameScene.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-17.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "BasicGameScene.h"
#import "MahjongTable.h"
#import "VZButton.h"
#import "ComboCounter.h"

#define BASIC_SCORE 100
#define COMBO_SCORE 10

#define STAR_ONE(x)     (x * BASIC_SCORE * 0.7)
#define STAR_TWO(x)     ((COMBO_SCORE * x * (x - 1) / 2 + x * BASIC_SCORE) * 0.4)
#define STAR_THREE(x)   ((COMBO_SCORE * x * (x - 1) / 2 + x * BASIC_SCORE) * 0.7)

@interface ClassicGameScene : BasicGameScene
{
    MahjongTable*   _table;
    ComboCounter*   _comboCounter;
    
    CCLabelTTF*     _scoreLabel;
    CCLabelTTF*     _leftLabel;
    CCLabelTTF*     _comboLabel;
    
    
    VZButton* _btReorder;
    VZButton* _btSun;
    VZButton* _btHint;
    
    int             _maxCombo;
    int             _totalPairs;
    
    
    NSMutableArray* _stars;
    
}

@property(nonatomic, assign)int left;

@property(nonatomic, assign)int reoreders;
@property(nonatomic, assign)int hints;
@property(nonatomic, assign)int lights;

+ (ClassicGameScene *)sceneWithSeason:(int)season Level:(int)level;

@end
