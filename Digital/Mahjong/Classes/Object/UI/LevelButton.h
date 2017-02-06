//
//  LevelButton.h
//  Mahjong
//
//  Created by 穆暮 on 14-6-16.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZButton.h"

@interface LevelButton : VZButton
{
    NSMutableDictionary* _starColors;
    NSMutableDictionary* _starOpacities;
    NSMutableArray*      _starSprites;
}

@property (nonatomic, assign)int level;
@property (nonatomic, assign)int stars;


- (void) setStarColor:(CCColor*) color forState:(CCControlState) state;
- (CCColor*) starColorForState:(CCControlState)state;
- (void) setStarOpacity:(CGFloat) opacity forState:(CCControlState) state;
- (CGFloat) starOpacityForState:(CCControlState)state;

-(void) setStarSprite:(CCSprite*)frame AtIndex:(int)index;
-(CCSprite*)starSpriteAtIndex:(int)index;
@end
