//
//  VZActionSpread.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-17.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "CCActionInterval.h"

typedef NS_ENUM(NSInteger, VZActionSpreadDirection)
{
    VZActionSpreadDirectionHorizontal,

    VZActionSpreadDirectionVertical,

    VZActionSpreadDirectionAllRound,
};

@interface VZSpreadForSprite : CCActionInterval <NSCopying>
{
    VZActionSpreadDirection     _direction;
    CGRect                      _originalRect;
}

+ (id)actionWithDuration:(CCTime)duration direction:(VZActionSpreadDirection)direction;

- (id)initWithDuration:(CCTime)duration direction:(VZActionSpreadDirection)direction;

@end
