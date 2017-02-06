//
//  VZAlertLayer.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-11.
//  Copyright 2014年 穆暮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface VZAlertLayer : CCNodeColor
{
    
}

@property (nonatomic, strong)CCNode* window;

// AdjustPointFromPoint
- (CGPoint)APFP:(CGPoint)point;

// AdjustSizeFromSzie
- (CGSize)ASFS:(CGSize)size;

// AdjustFloatFromFloat
- (float)AFFF:(float)value;


@end
