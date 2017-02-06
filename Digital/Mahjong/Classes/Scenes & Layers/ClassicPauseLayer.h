//
//  PauseLayer.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-16.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZAlertLayer.h"

@interface ClassicPauseLayer : VZAlertLayer
{
    CCLabelTTF* _levelLabel;
    int         _season;
}

@property (nonatomic, readonly)int level;

+(ClassicPauseLayer*)layerWithSeason:(int)season Level:(int)level;
@end
