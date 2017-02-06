//
//  VZPageControl.h
//  Mahjong
//
//  Created by 穆暮 on 14-7-1.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//
#import "cocos2d.h"
#import "CCNode.h"

@interface VZPageControl : CCNode
{
    int _maxPage;
}

+(VZPageControl*)pageControlWithMaxPage:(int)maxPage;


@property(nonatomic, assign)int page;

@end
