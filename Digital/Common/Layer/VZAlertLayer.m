//
//  VZAlertLayer.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-11.
//  Copyright 2014年 穆暮. All rights reserved.
//

#import "VZAlertLayer.h"


@implementation VZAlertLayer

-(id)initWithColor:(CCColor *)color width:(GLfloat)w height:(GLfloat)h
{
    if(self = [super initWithColor:color width:w height:h])
    {
        self.userInteractionEnabled = YES;
        
        
        self.window = [CCNode node];
        self.window.position = ccp(w * 0.5, h * 0.5);
        [self addChild:self.window];
    }
    return self;
}

-(void)dealloc
{
    self.window = nil;
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return;
}

- (CGPoint)APFP:(CGPoint)point
{
    CGPoint convertPoint;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        convertPoint = ccpMult(point, 1);
    }
    else
    {
        convertPoint = point;
    }

    return convertPoint;
}

- (CGSize)ASFS:(CGSize)size
{
    CGSize adjustSize;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        adjustSize = CGSizeMake(size.width * 1, size.height * 1);
    }
    else
    {
        adjustSize = size;
    }
    
    return adjustSize;
}

- (float)AFFF:(float)value
{
    float adjustValue;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        adjustValue = value * 1;
    }
    else
    {
        adjustValue = value;
    }
    return adjustValue;
}

@end
