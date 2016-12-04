//
//  VZScene.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-12.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "CCScene.h"
@interface VZScene : CCScene
{
    
}

// AdjustPointFromPoint
- (CGPoint)APFP:(CGPoint)point;

// AdjustSizeFromSzie
- (CGSize)ASFS:(CGSize)size;

@end
