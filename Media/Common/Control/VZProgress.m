//
//  VZProgress.m
//  Mahjong
//
//  Created by 穆暮 on 14-7-5.
//  Copyright 2014年 穆暮. All rights reserved.
//

#import "VZProgress.h"

#import "VZCommonDefine.h"
@implementation VZProgress

-(id)initWithSprite:(CCSprite *)sprite
{
    if(self = [super initWithSprite:sprite])
    {
        _min = 0;
        _max = 100;
        _value = 0;
        _neverFull = YES;
    }
    return self;
}

-(void)setMin:(float)min
{
    if(min >= _max)
        return;
    
    _min = min;
    _value = clampf(_value, _min, _max);
    _neverFull = YES;
    [self updateSelf];
}

-(void)setMax:(float)max
{
    if(max <= _min)
        return;
    
    _max = max;
    _value = clampf(_value, _min, _max);
    _neverFull = YES;
    [self updateSelf];
}

-(void)setValue:(float)value
{
    _value = clampf(value, _min, _max);
    [self updateSelf];
    
}

-(void)updateSelf
{
    self.percentage = (_value - _min) / (_max - _min) * 100;
    
    if(_neverFull && _value == _max)
    {
        _neverFull = NO;
        
        if(self.delegate && [self.delegate respondsToSelector:self.fullCallBackFunc])
        {
            VZSuppressPerformSelectorLeakWarning([self.delegate performSelector:self.fullCallBackFunc withObject:self]);
        }
    }
}

@end
