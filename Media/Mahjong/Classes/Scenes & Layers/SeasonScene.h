//
//  SeasonScene.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-13.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZScene.h"
#import "VZPageControl.h"
@interface SeasonScene : VZScene <CCScrollViewDelegate>
{
    VZPageControl* _pageControl;
    int            _season;

}
+ (SeasonScene *)sceneWithSeason:(int)season;


@end
