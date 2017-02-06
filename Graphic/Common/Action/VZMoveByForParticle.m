//
//  VZMoveByForParticle.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-25.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZMoveByForParticle.h"
#import "CCParticleSystem.h"
@implementation VZMoveByForParticle


+(id) actionWithDuration: (CCTime) t position: (CGPoint) p
{
	return [[self alloc] initWithDuration:t position:p ];
}

-(id) initWithDuration: (CCTime) t position: (CGPoint) p
{
	if( (self=[super initWithDuration: t]) )
		_positionDelta = p;
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	return [[[self class] allocWithZone: zone] initWithDuration:[self duration] position:_positionDelta];
}

-(void) startWithTarget:(CCNode *)target
{
	[super startWithTarget:target];
    
    CCParticleSystem* tn = (CCParticleSystem*) _target;
    
	_previousPos = _startPos = [tn sourcePosition];
}

-(CCActionInterval*) reverse
{
	return [[self class] actionWithDuration:_duration position:ccp( -_positionDelta.x, -_positionDelta.y)];
}

-(void) update: (CCTime) t
{
    
	CCParticleSystem *node = (CCParticleSystem*)_target;
    
#if CC_ENABLE_STACKABLE_ACTIONS
	CGPoint currentPos = [node sourcePosition];
	CGPoint diff = ccpSub(currentPos, _previousPos);
	_startPos = ccpAdd( _startPos, diff);
	CGPoint newPos =  ccpAdd( _startPos, ccpMult(_positionDelta, t) );
	[_target setSourcePosition:newPos];
	_previousPos = newPos;
#else
	[node setSourcePosition: ccpAdd( _startPos, ccpMult(_positionDelta, t))];
#endif // CC_ENABLE_STACKABLE_ACTIONS
}

@end
