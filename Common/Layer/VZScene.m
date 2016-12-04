//
//  VZScene.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-12.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZScene.h"

@implementation VZScene

- (CGPoint)APFP:(CGPoint)point
{
    CGPoint convertPoint;

    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        convertPoint = ccp(point.x / 320 * self.contentSize.width, point.y / 480 * self.contentSize.height);
    }
    else
    {
        convertPoint = ccp(point.x / 480 * self.contentSize.width, point.y / 320 * self.contentSize.height);
    }
    
    return convertPoint;
}

- (CGSize)ASFS:(CGSize)size
{
    CGSize adjustSize;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        adjustSize = CGSizeMake(size.width / 320 * self.contentSize.width, size.height / 480 * self.contentSize.height);
    }
    else
    {
        adjustSize = CGSizeMake(size.width / 480 * self.contentSize.width, size.height / 320 * self.contentSize.height);
    }
    return adjustSize;
}

@end
