//
//  VZScrollNumberForLabel.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-26.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZScrollNumberForLabel.h"
#import "CCLabelTTF.h"
@implementation VZScrollNumberForLabel

+(id) actionWithDuration:(CCTime)duration StartNumber:(float)start EndNumber:(float)end PrefixString:(NSString*)string
{
	return [(VZScrollNumberForLabel*)[ self alloc] initWithDuration:duration StartNumber:start EndNumber:end PrefixString:string];
}

- (id)initWithDuration:(CCTime)duration StartNumber:(float)start EndNumber:(float)end PrefixString:(NSString*)string
{
	if((self=[super initWithDuration:duration]))
    {
        _startNumber = start;
        _endNumber = end;
        _prefixString = [string copy];
    }
    
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [(VZScrollNumberForLabel*)[[self class] allocWithZone: zone] initWithDuration:self.duration StartNumber:_startNumber EndNumber:_endNumber PrefixString:_prefixString];
	return copy;
}

-(void) startWithTarget:(CCNode*)aTarget
{
	[super startWithTarget:aTarget];
    
	CCLabelTTF* tn = (CCLabelTTF*) _target;
    tn.string = [NSString stringWithFormat:@"%@%.0f",(NSLocalizedString(_prefixString, nil)) ,_startNumber];
}

-(void) update: (CCTime) t
{
	CCLabelTTF* tn = (CCLabelTTF*) _target;
    tn.string = [NSString stringWithFormat:@"%@%.0f",(NSLocalizedString(_prefixString, nil)),_startNumber + (_endNumber - _startNumber) * t];
}


@end
