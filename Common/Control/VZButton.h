//
//  VZButton.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-11.
//  Copyright 2014年 穆暮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCButton.h"
@interface VZButton : CCButton
{
    float   _opacityFactor;
}

@property (nonatomic, strong)NSString* effectFile;
@property (nonatomic, assign)CGPoint labelPosition;

@end
