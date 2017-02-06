//
//  CompleteLayer.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-17.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZAlertLayer.h"
#import "VZSwitch.h"
#import "VZButton.h"
@interface DailyChallengeCompleteLayer : VZAlertLayer
{
    int         _season;
    int         _level;
    float       _score;
    int         _stars;
    
    CCLabelTTF* _scoreLabel;
    CCLabelTTF* _bestLable;
    
    BOOL        _canReplaceScene;
    
    VZSwitch*   _chest[3];
    CCNode*     _productNode;
    
    VZButton*   _btMenu;

}

+(DailyChallengeCompleteLayer*)layerWithSeason:(int)season Level:(int)level Score:(float)score Stars:(int)stars;

@end
