//
//  ShopLayer.h
//  Mahjong
//
//  Created by 穆暮 on 14-9-8.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZAlertLayer.h"

@interface ShopLayer : VZAlertLayer
{
    CCLabelTTF* _hint;
    CCLabelTTF* _shuffle;
    CCLabelTTF* _sunshine;
    
    CCNode*     _productNode;
    
    CCNode*     _loadingNode;
    
    VZAlertLayer* _lockLayer;
    
    UIActivityIndicatorView*    _activityIndicator;
    
    BOOL        _hasFailed;
}

+(ShopLayer*)layer;
@end
