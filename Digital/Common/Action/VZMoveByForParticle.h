//
//  VZMoveByForParticle.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-25.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "CCActionInterval.h"

@interface VZMoveByForParticle : CCActionInterval <NSCopying>
{
    CGPoint _positionDelta;
	CGPoint _startPos;
	CGPoint _previousPos;
}

+ (id)actionWithDuration: (CCTime)duration position:(CGPoint)deltaPosition;

- (id)initWithDuration: (CCTime)duration position:(CGPoint)deltaPosition;

@end
