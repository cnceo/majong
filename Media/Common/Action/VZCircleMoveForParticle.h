//
//  VZCircleMove.h
//  Mahjong
//
//  Created by 穆暮 on 14-9-17.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "CCActionInterval.h"

@interface VZCircleMoveForParticle : CCActionInterval <NSCopying>
{
    CGPoint _orgin;
    float   _radius;
    float   _start;
    float   _end;
    BOOL    _rotate;
}

+ (id)actionWithDuration: (CCTime)duration Origin:(CGPoint)origin Radius:(float)radius StartAngle:(float)start_angel EndAngle:(float)end_angle Rotate:(BOOL)rotate;

@end
