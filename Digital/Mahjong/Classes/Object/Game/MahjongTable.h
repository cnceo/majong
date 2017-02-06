//
//  MahjongTable.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-19.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "CCNode.h"

#import "Mahjong.h"

#define MAX_LAYER   5
#define MAX_ROW     16
#define MAX_COLUMN  32

#define ZORDER_MAHJONG_ORIGIN 100

#define ZORDER_TOP 5000

#define MAX_HINTS 2

#define ACTION_TAG_SELECTED 1

#define DEBUG_FLAG 1

typedef NS_ENUM(NSInteger, MahjongTableState)
{
    MahjongTableState_Wait = 0,
    MahjongTableState_Explore,
    MahjongTableState_Reorder,
    MahjongTableState_Compelte
};


@interface MahjongTable : CCNodeColor
{
    CGPoint _posMahjong;
    CGSize  _spaceMahjong;
    CGSize  _offsetMahjong;
    CGSize  _sizeMahjong;
    
    CGRect  _touchArea;
    int     _maxLayer;
    
    Mahjong* _mahjongs[MAX_LAYER][MAX_ROW][MAX_COLUMN];
    
    MahjongBoardInfo _availableBoards[MAX_MAHJONG_BOARDS];
    int              _availableKinds;
    
    Mahjong* _firstSelected;
    Mahjong* _secondSelected;
    
    CCNode* _scaleLayer;
    
    NSMutableArray* _hints;
    
    int     _finishedCount;
    
    CCParticleSystem* _selectedParticle;
    
    BOOL    _allEnable;
}

@property (nonatomic, assign)int leftMahjongs;

@property (nonatomic, assign)id delegate;

@property (nonatomic, assign)SEL finishCallBackFunc;
@property (nonatomic, assign)SEL matchCallBackFunc;
@property (nonatomic, assign)SEL reorderCallBackFunc;
@property (nonatomic, assign)SEL didReorderCallBackFunc;
@property (nonatomic, assign)SEL hintCallBackFunc;
@property (nonatomic, assign)SEL lightCallBackFunc;
@property (nonatomic, assign)SEL noHintCallBackFunc;
@property (nonatomic, assign)SEL noMatchCallBackFunc;



@property (nonatomic, assign)MahjongTableState state;


+ (MahjongTable *)mahjongTableWithSeason:(int)season Level:(int)level;

-(CGPoint)positionFromLayer:(int)layer Row:(int)row Column:(int)column;
-(CGRect)rectFromLayer:(int)layer Row:(int)row Column:(int)column;
-(NSInteger)zOrderFromLayer:(int)layer Row:(int)row Column:(int)column;

-(void)setMahjong:(Mahjong*)mahjong Layer:(int)layer Row:(int)row Column:(int)column;
-(Mahjong*)mahjongWithLayer:(int)layer Row:(int)row Column:(int)column;

-(void)reorderMahjongOnlyFlyIn:(BOOL)isOnlyFlyIn;

-(void)hint;

-(void)enableAll;



@end
