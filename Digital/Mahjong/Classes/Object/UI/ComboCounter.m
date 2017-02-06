//
//  ComboCounter.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-28.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "ComboCounter.h"
#import "VZCommonDefine.h"

#define ACTION_TAG_NUMBER_CHANGE 1
@implementation ComboCounter

+(ComboCounter*)comboCounter
{
    return [[self alloc] init];
}

-(id)init
{
    if(self = [super initWithImageNamed:@"lb_clock_1.png"])
    {
        
        _timer = [CCProgressNode progressWithSprite:[CCSprite spriteWithImageNamed:@"lb_clock_0.png"]];
		_timer.type = CCProgressNodeTypeRadial;
		_timer.positionType = CCPositionTypeNormalized;
		_timer.position = ccp(0.5, 0.5);
        _timer.percentage = 0;
        _timer.reverseDirection = YES;
		[self addChild:_timer];
        
        _label = [CCLabelTTF labelWithString:@"" fontName:SYSTEM_FONT fontSize:self.contentSize.height * 0.75];
        _label.positionType = CCPositionTypeNormalized;
        _label.dimensions = CGSizeMake(_timer.contentSize.width * 0.75, _timer.contentSize.height * 0.75);
        _label.adjustsFontSizeToFit = YES;
        _label.position = ccp(0.52, 0.525);
        _label.horizontalAlignment = CCTextAlignmentCenter;
        _label.verticalAlignment = CCVerticalTextAlignmentCenter;
        [self addChild:_label];
        
        self.count = 0;
        self.maxDuration = 5;
        
        self.startColor = [CCColor whiteColor];
        self.endColor = [CCColor whiteColor];
    }
    return self;
}

-(void)update:(CCTime)delta
{
    if(_leftDuration > 0 )
    {
        _leftDuration -= delta;
        if(_leftDuration <= 0)
        {
            _leftDuration = 0;
            self.count = 0;
            
            if(self.delegate && [self.delegate respondsToSelector:self.lostComboCallBack])
            {
                VZSuppressPerformSelectorLeakWarning([self.delegate performSelector:self.lostComboCallBack withObject:self]);
            }
        }
    }
    
    _timer.percentage = (_leftDuration / _maxDuration) * 100;
    
    float red   = self.startColor.red * _timer.percentage / 100.0f + self.endColor.red * (1 - _timer.percentage/ 100.0f);
    float green = self.startColor.green * _timer.percentage / 100.0f + self.endColor.green * (1 - _timer.percentage/ 100.0f);
    float blue  = self.startColor.blue * _timer.percentage / 100.0f + self.endColor.blue * (1 - _timer.percentage/ 100.0f);
    float alpha = self.startColor.alpha * _timer.percentage / 100.0f + self.endColor.alpha * (1 - _timer.percentage/ 100.0f);
    
    _label.color = [CCColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}

-(void)setCount:(int)count
{
    _count = count;
    if(_count <= 1)
    {
        _leftDuration = 0;
        self.visible = NO;
    }
    else
    {
        _leftDuration = self.maxDuration;
        self.visible = YES;
        
        _label.string = [NSString stringWithFormat:@"%d",_count - 1];
        _timer.percentage = 100;
        
        if(_count >= 2)
        {
            [_label stopActionByTag:ACTION_TAG_NUMBER_CHANGE];
            
            _label.scale = 1.0;
            CCActionSequence* sequence = [CCActionSequence actions:
                                          [CCActionEaseIn actionWithAction:[CCActionScaleTo actionWithDuration:0.3 scale:1.4] rate:1.4],
                                          [CCActionEaseOut actionWithAction:[CCActionScaleTo actionWithDuration:0.3 scale:1.0] rate:1.4],
                                          nil];
            sequence.tag = ACTION_TAG_NUMBER_CHANGE;
            [_label runAction:sequence];
        }
        
        if(self.delegate && [self.delegate respondsToSelector:self.getComboCallBack])
        {
            VZSuppressPerformSelectorLeakWarning([self.delegate performSelector:self.getComboCallBack withObject:self]);
        }
    }
    
}


@end
