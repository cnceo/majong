//
//  VZRotate3D.m
//  Pirate
//
//  Created by 穆暮 on 14-8-29.
//  Copyright 2014年 穆暮. All rights reserved.
//

#import "VZRotate3D.h"


@implementation VZRotate3D

+(id)actionWithDuration:(CCTime)duration Roll:(float)roll Pitch:(float)pitch Yaw:(float)yaw
{
    return [[self alloc] initWithDuration:duration Roll:roll Pitch:pitch Yaw:yaw];
}

-(id)initWithDuration:(CCTime)duration Roll:(float)roll Pitch:(float)pitch Yaw:(float)yaw
{
    if(self =[super initWithDuration: duration])
    {
        _rollDelta = roll;
        _pitchDelta = pitch;
        _yawDelta = yaw;
    }
    return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	return [[[self class] allocWithZone: zone] initWithDuration:self.duration Roll:_rollDelta Pitch:_pitchDelta Yaw:_yawDelta];
}


-(void) startWithTarget:(CCNode *)target
{
	[super startWithTarget:target];
    
    CCTransformationNode* tn = (CCTransformationNode*) _target;
    
	_previousRoll = tn.roll;
    _previousPitch = tn.pitch;
    _previousYaw = tn.yaw;
}


-(void) update: (CCTime) t
{
	CCTransformationNode* tn = (CCTransformationNode*) _target;
    
    tn.roll = _previousRoll + _rollDelta * t;
    tn.pitch = _previousPitch + _pitchDelta * t;
    tn.yaw = _previousYaw + _yawDelta * t;
    
}

@end
