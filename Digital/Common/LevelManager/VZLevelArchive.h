//
//  VZLevelArchive.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-13.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VZLevelArchive : NSObject <NSCoding>
{
    
}

@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) float highscore;
@property (nonatomic, assign) int  stars;


+(id)levelArchive;

@end
