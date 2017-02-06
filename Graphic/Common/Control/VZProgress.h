//
//  VZProgress.h
//  Mahjong
//
//  Created by 穆暮 on 14-7-5.
//  Copyright 2014年 穆暮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface VZProgress : CCProgressNode
{
    BOOL            _neverFull;
}

@property (nonatomic, assign)float min;
@property (nonatomic, assign)float max;
@property (nonatomic, assign)float value;
@property (nonatomic, assign)id delegate;
@property (nonatomic, assign)SEL fullCallBackFunc;

@end
