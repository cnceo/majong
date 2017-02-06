//
//  VZScrollNumberForLabel.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-26.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "CCActionInterval.h"

@interface VZScrollNumberForLabel : CCActionInterval <NSCopying>
{
    NSString* _prefixString;
    float _startNumber;
    float _endNumber;
}


+ (id)actionWithDuration:(CCTime)duration StartNumber:(float)start EndNumber:(float)end PrefixString:(NSString*)string;

- (id)initWithDuration:(CCTime)duration StartNumber:(float)start EndNumber:(float)end PrefixString:(NSString*)string;

@end
