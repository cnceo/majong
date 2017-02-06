//
//  VZRotate3D.h
//  Pirate
//
//  Created by 穆暮 on 14-8-29.
//  Copyright 2014年 穆暮. All rights reserved.
//
#import "CCTransformationNode.h"
#import "CCActionInterval.h"

@interface VZRotate3D : CCActionInterval <NSCopying>
{
    float _rollDelta;
    float _previousRoll;
    float _pitchDelta;
    float _previousPitch;
    float _yawDelta;
    float _previousYaw;
}

+ (id)actionWithDuration: (CCTime)duration Roll:(float)roll Pitch:(float)pitch Yaw:(float)yaw;

@end
