//
//  VZCircleMove.m
//  Mahjong
//
//  Created by 穆暮 on 14-9-17.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZCircleMoveForParticle.h"
#import "VZCommonDefine.h"
#import "CCParticleSystem.h"
@implementation VZCircleMoveForParticle

+ (id)actionWithDuration: (CCTime)duration Origin:(CGPoint)origin Radius:(float)radius StartAngle:(float)start_angel EndAngle:(float)end_angle Rotate:(BOOL)rotate
{
	return [[self alloc] initWithDuration:duration Origin:origin Radius:radius StartAngle:start_angel EndAngle:end_angle Rotate:rotate ];
}

-(id) initWithDuration: (CCTime)duration Origin:(CGPoint)origin Radius:(float)radius StartAngle:(float)start_angel EndAngle:(float)end_angle Rotate:(BOOL)rotate
{
	if( (self=[super initWithDuration: duration]) )
    {
        _orgin = origin;
        _radius = radius;
        _start = start_angel;
        _end = end_angle;
        _rotate = rotate;
    }
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	return [[[self class] allocWithZone: zone] initWithDuration:self.duration Origin:_orgin Radius:_radius StartAngle:_start EndAngle:_end Rotate:_rotate];
}

-(void) startWithTarget:(CCNode *)target
{
	[super startWithTarget:target];
    CCParticleSystem *node = (CCParticleSystem*)_target;
    
    [node setSourcePosition:ccp(_orgin.x + _radius * cos(_start), _orgin.y + _radius * sin(_start))];
    if(_rotate)
        node.rotation = RADIANS_TO_DEGREES(-_start);
}

-(void) update: (CCTime) t
{
	CCParticleSystem *node = (CCParticleSystem*)_target;
    float angleDelta = (_end - _start) * t;
    [node setSourcePosition:ccp(_orgin.x + _radius * cos(_start + angleDelta), _orgin.y + _radius * sin(_start + angleDelta))];
    if(_rotate)
        node.rotation = RADIANS_TO_DEGREES(-_start - angleDelta);
}

@end
