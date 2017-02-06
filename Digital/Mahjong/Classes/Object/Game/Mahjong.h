//
//  Mahjong.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-17.
//  Copyright 2014年 穆暮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define MAX_MAHJONG_KINDS 7
#define MAX_MAHJONG_BOARDS 42


typedef NS_ENUM(NSInteger, MahjongKind)
{
    MahjongKindBamboo = 0,
    
    MahjongKindCharacter,
    
    MahjongKindCircle,
    
    MahjongKindWind,
    
    MahjongKindDragon,
    
    MahjongKindSeason,
    
    MahjongKindFlower,
};


typedef NS_ENUM(NSInteger, MahjongState)
{
    MahjongStateDefault = 0,
    MahjongStateExplore,
    MahjongStateReorder,
};



struct MahjongBoardInfo
{
    MahjongKind kind;
    int         point;
};
typedef struct MahjongBoardInfo MahjongBoardInfo;

struct MahjongPositionInfo
{
    int         layer;
    int         row;
    int         column;
};
typedef struct MahjongPositionInfo MahjongPositionInfo;


@interface Mahjong : CCSprite
{
    CCSprite* _face;
}

@property (nonatomic, assign)MahjongKind kind;
@property (nonatomic, assign)int point;
@property (nonatomic, assign)int layer;
@property (nonatomic, assign)int row;
@property (nonatomic, assign)int column;
@property (nonatomic, assign)BOOL enable;
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, assign)MahjongState state;


+(Mahjong*) mahjongWithKind:(MahjongKind)kind Point:(int)point;

+(int)kinds;
+(int)pointsForKind:(MahjongKind)kind;

-(BOOL) isMatchWithMahjong:(Mahjong*)mahjong;
-(BOOL) isMatchWithMahjongBoardInfo:(MahjongBoardInfo)info;

-(BOOL) isSamePositionWithMahjong:(Mahjong*)mahjong;
-(BOOL) isSamePositionWithMahjongPositionInfo:(MahjongPositionInfo)info;

-(void)setEnable:(BOOL)enable Animated:(BOOL)animated;

-(void)shake;
-(void)zoom;

@end
