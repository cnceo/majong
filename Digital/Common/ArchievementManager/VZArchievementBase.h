//
//  VZArchievementCheker.h
//  Mahjong
//
//  Created by 穆暮 on 14-9-10.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZArchiveManager.h"
//#import "VZGameCenter.h"
@interface VZArchievementBase : NSObject
{
    
}

@property (nonatomic, copy)NSString* archievementID;

+(id)archievementChekerWithID:(NSString*)archievementID;
-(id)initWithID:(NSString *)archievementID;

-(void)check;

@end
