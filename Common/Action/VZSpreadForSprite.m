//
//  VZActionSpread.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-17.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZSpreadForSprite.h"
#import "CCSprite.h"
@implementation VZSpreadForSprite

+(id) actionWithDuration:(CCTime)duration direction:(VZActionSpreadDirection)direction
{
	return [(VZSpreadForSprite*)[ self alloc] initWithDuration:duration direction:direction];
}

-(id) initWithDuration:(CCTime)t direction:(VZActionSpreadDirection)direction
{
	if( (self=[super initWithDuration:t] ) )
		_direction = direction;
    
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [(VZSpreadForSprite*)[[self class] allocWithZone: zone] initWithDuration:[self duration] direction:_direction];
	return copy;
}

-(void) startWithTarget:(CCNode*)aTarget
{
	[super startWithTarget:aTarget];
    
	CCSprite* tn = (CCSprite*) _target;
    switch (_direction)
    {
        case VZActionSpreadDirectionVertical:
        {
            _originalRect = tn.textureRect;
            tn.textureRect = CGRectMake(_originalRect.origin.x,
                                        _originalRect.origin.y + (_originalRect.size.height * 0.5),
                                        _originalRect.size.width,
                                        0);
        }
            break;
        case VZActionSpreadDirectionHorizontal:
        {
            _originalRect = tn.textureRect;
            tn.textureRect = CGRectMake(_originalRect.origin.x + (_originalRect.size.width * 0.5),
                                        _originalRect.origin.y,
                                        0,
                                        _originalRect.size.height);
        }
            break;
        case VZActionSpreadDirectionAllRound:
        {
            _originalRect = tn.textureRect;
            tn.textureRect = CGRectMake(_originalRect.origin.x + (_originalRect.size.width * 0.5),
                                         _originalRect.origin.y + (_originalRect.size.height * 0.5),
                                        0,
                                        0);
        }
            break;
    }
    
}

-(void) update: (CCTime) t
{
	CCSprite* tn = (CCSprite*) _target;
    switch (_direction)
    {
        case VZActionSpreadDirectionVertical:
        {
            tn.textureRect = CGRectMake(_originalRect.origin.x,
                                        _originalRect.origin.y + (_originalRect.size.height * 0.5) * (1 - t),
                                        _originalRect.size.width,
                                        _originalRect.size.height * t);
        }
            break;
        case VZActionSpreadDirectionHorizontal:
        {
            tn.textureRect = CGRectMake(_originalRect.origin.x + (_originalRect.size.width * 0.5) * (1 - t) ,
                                        _originalRect.origin.y,
                                        _originalRect.size.width * t,
                                        _originalRect.size.height);
        }
            break;
        case VZActionSpreadDirectionAllRound:
        {
            tn.textureRect = CGRectMake(_originalRect.origin.x + (_originalRect.size.width * 0.5) * (1 - t),
                                        _originalRect.origin.y + (_originalRect.size.height * 0.5) * (1 - t),
                                        _originalRect.size.width * t,
                                        _originalRect.size.height * t);
        }
            break;
    }
}

@end
