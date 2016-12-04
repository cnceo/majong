//
//  CCLayerWithXIB.h
//  KeyboardDemo
//
//  Created by 张朴军 on 13-9-29.
//  Copyright (c) 2013年 张朴军. All rights reserved.
//

#import "cocos2d.h"
@interface VZLayerWithXIB : CCNodeColor
{
    
}
@property (nonatomic, retain)IBOutlet UIView*       view;

+(id)layerWithXibFile:(NSString*)file;

-(id)initWithXibFile:(NSString *)file;

@end
