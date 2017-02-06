//
//  ComboCounter.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-28.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"
@interface ComboCounter : CCSprite
{
    CCProgressNode* _timer;
    CCLabelTTF*     _label;
    
    float           _leftDuration;
}

@property(nonatomic, assign)int count;
@property(nonatomic, assign)float maxDuration;
@property(nonatomic, strong)CCColor* startColor;
@property(nonatomic, strong)CCColor* endColor;

@property(nonatomic, assign)id delegate;
@property(nonatomic, assign)SEL lostComboCallBack;
@property(nonatomic, assign)SEL getComboCallBack;

+(ComboCounter*)comboCounter;

@end
