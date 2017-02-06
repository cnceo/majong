//
//  LevelButton.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-16.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "LevelButton.h"
#import "CCControlSubclass.h"
@implementation LevelButton

- (id) initWithTitle:(NSString*) title spriteFrame:(CCSpriteFrame*) spriteFrame
{
    if (self = [super initWithTitle:title spriteFrame:spriteFrame])
    {
        _starColors = [NSMutableDictionary dictionary];
        _starOpacities = [NSMutableDictionary dictionary];
        _starSprites = [NSMutableArray array];
        
        [self setStarColor:[CCColor colorWithWhite:0.7 alpha:1] forState:CCControlStateDisabled];
        [self setStarOpacity:0.7f forState:CCControlStateHighlighted];
    }
    return self;
}

-(void)setLevel:(int)level
{
    _level = level;
    self.label.string = [NSString stringWithFormat:@"%d",_level];
}

-(void)setStars:(int)stars
{
    _stars = stars;
    for (int i = 0; i < _starSprites.count; i++)
    {
        CCSprite* sprite = [_starSprites objectAtIndex:i];
        if(i < stars)
        {
            sprite.color = [CCColor whiteColor];
        }
        else
        {
            sprite.color = [CCColor grayColor];
        }
    }
}

- (void) setStarColor:(CCColor*) color forState:(CCControlState) state
{
    [_starColors setObject:color forKey:[NSNumber numberWithInt:state]];
    [self stateChanged];
}
- (CCColor*) starColorForState:(CCControlState)state
{
    CCColor* color = [_starColors objectForKey:[NSNumber numberWithInt:state]];
    if (!color) color = [CCColor whiteColor];
    return color;
}
- (void) setStarOpacity:(CGFloat) opacity forState:(CCControlState) state
{
    [_starOpacities setObject:[NSNumber numberWithFloat:opacity] forKey:[NSNumber numberWithInt:state]];
    [self stateChanged];
}
- (CGFloat) starOpacityForState:(CCControlState)state
{
    NSNumber* val = [_starOpacities objectForKey:[NSNumber numberWithInt:state]];
    if (!val) return 1;
    return [val floatValue];
}

-(void) setStarSprite:(CCSprite *)frame AtIndex:(int)index
{
    if (frame)
    {
        if(_starSprites.count > index)
            [self removeChild:[_starSprites objectAtIndex:index]];
        [_starSprites setObject:frame atIndexedSubscript:index];
        [self addChild:frame z:2];
    }
    else
    {
        if(_starSprites.count > index)
            [self removeChild:[_starSprites objectAtIndex:index]];
        
        [_starSprites removeObjectAtIndex:index];
    }
    [self stateChanged];
}

-(CCSprite*)starSpriteAtIndex:(int)index;
{
    return [_starSprites objectAtIndex:index];
}

- (void) updateStarsPropertiesForState:(CCControlState)state
{
    
    for (CCSprite* star in _starSprites)
    {
        // Update background
        star.color = [self backgroundColorForState:state];
        star.opacity = [self backgroundOpacityForState:state];
    }
    
    for (int i = 0; i < _starSprites.count; i++)
    {
        CCSprite* sprite = [_starSprites objectAtIndex:i];
        if(i < _stars)
        {
            sprite.color = [CCColor whiteColor];
        }
        else
        {
            sprite.color = [CCColor grayColor];
        }
    }
}

-(void)stateChanged
{
    [super stateChanged];
    
    if (self.enabled)
    {
        // Button is enabled
        if (self.highlighted)
        {
            [self updateStarsPropertiesForState:CCControlStateHighlighted];
        }
        else
        {
            if (self.selected)
            {
                [self updateStarsPropertiesForState:CCControlStateSelected];
            }
            else
            {
                [self updateStarsPropertiesForState:CCControlStateNormal];
            }
        }
    }
    else
    {
        [self updateStarsPropertiesForState:CCControlStateDisabled];
    }
}

@end
