//
//  Mahjong.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-17.
//  Copyright 2014年 穆暮. All rights reserved.
//

#import "Mahjong.h"
#import "CCTexture_Private.h"
#define ACTION_TAG_MAHJONG_ENABLE   1
#define ACTION_TAG_MAHJONG_SELECT   2
#define ACTION_TAG_MAHJONG_SHAKE    3
#define ACTION_TAG_MAHJONG_ZOOM     4
@implementation Mahjong

+(int)kinds
{
    return MAX_MAHJONG_KINDS;
}

+(int)pointsForKind:(MahjongKind)kind
{
    if(kind >= 0 && kind < MAX_MAHJONG_KINDS)
    {
        switch (kind)
        {
            case MahjongKindBamboo:
            case MahjongKindCharacter:
            case MahjongKindCircle:
                return 9;
                break;
            case MahjongKindWind:
            case MahjongKindSeason:
            case MahjongKindFlower:
                return 4;
                break;
            case MahjongKindDragon:
                return 3;
                break;
        }
        return 0;
    }
    else
    {
        return 0;
    }
}

+(Mahjong*) mahjongWithKind:(MahjongKind)kind Point:(int)point
{
    return [[self alloc] initWithKind:kind Point:point];
}

-(id)initWithKind:(MahjongKind)kind Point:(int)point
{
    if(self = [super init])
    {
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"mahjong.plist"];
        
        
        _face = [CCSprite node];
        
        [self addChild:_face z:1];
        
        [self updateSelf];
        
        self.kind = kind;
        self.point = point;
        self.enable = YES;
        self.selected = NO;
        self.state = MahjongStateDefault;
        
    }
    return self;
}

-(void)setKind:(MahjongKind)kind
{
    if (_kind != kind)
    {
        if(kind >=0 && kind < MAX_MAHJONG_KINDS)
        {
            _kind = kind;
            [self updateSelf];
        }
    }
}

-(void)setPoint:(int)point
{
    if(_point != point)
    {
        switch (_kind)
        {
            case MahjongKindBamboo:
            case MahjongKindCharacter:
            case MahjongKindCircle:
            {
                if(_point >= 0 && point < 9)
                    _point = point;
            }
                break;
            case MahjongKindWind:
            case MahjongKindSeason:
            case MahjongKindFlower:
            {
                if(_point >= 0 && point < 4)
                    _point = point;
            }
                break;
            case MahjongKindDragon:
            {
                if(_point >= 0 && point < 3)
                    _point = point;
            }
                break;
            default:
                break;
        }
        
        [self updateSelf];
    }
}

-(void)setEnable:(BOOL)enable
{
    _enable = enable;
    if(_enable)
    {
        [self stopActionByTag:ACTION_TAG_MAHJONG_ENABLE];
        self.color = [CCColor whiteColor];
    }
    else
    {
        [self stopActionByTag:ACTION_TAG_MAHJONG_ENABLE];
        self.color = [CCColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.75];
    }
}

-(void)setEnable:(BOOL)enable Animated:(BOOL)animated
{
    if(animated)
    {
        _enable = enable;
        if(_enable)
        {
            [self stopActionByTag:ACTION_TAG_MAHJONG_ENABLE];
            CCActionTintTo* tintTo = [CCActionTintTo actionWithDuration:0.25 color:[CCColor whiteColor]];
            tintTo.tag = ACTION_TAG_MAHJONG_ENABLE;
            [self runAction:tintTo];
        }
        else
        {
            [self stopActionByTag:ACTION_TAG_MAHJONG_ENABLE];
            CCActionTintTo* tintTo = [CCActionTintTo actionWithDuration:0.25 color:[CCColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.75]];
            tintTo.tag = ACTION_TAG_MAHJONG_ENABLE;
            [self runAction:tintTo];
        }
    }
    else
    {
        self.enable = enable;
    }
}

-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self updateSelf];
}

-(void)setState:(MahjongState)state
{
    switch (state)
    {
        case MahjongStateDefault:
        {
            _state = state;
        }
            break;
        case MahjongStateExplore:
        {
            _state = state;
        }
            break;
        case MahjongStateReorder:
        {
            _state = state;
        }
            break;
    }
}

- (void)updateSelf
{
    NSString* filename = nil;
    switch (_kind)
    {
        case MahjongKindBamboo:
            filename = @"bamboo";
            break;
        case MahjongKindCharacter:
            filename = @"character";
            break;
        case MahjongKindCircle:
            filename = @"circle";
            break;
        case MahjongKindWind:
            filename = @"wind";
            break;
        case MahjongKindDragon:
            filename = @"dragon";
            break;
        case MahjongKindSeason:
            filename = @"season";
            break;
        case MahjongKindFlower:
            filename = @"flower";
            break;
        default:
            break;
    }
    filename = [filename stringByAppendingString:[NSString stringWithFormat:@"_%d.png",_point + 1]];
    _face.spriteFrame = [CCSpriteFrame frameWithImageNamed:filename];
    
    
    if(_selected)
    {
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"back_selected.png"];
    }
    else
    {
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"back_0.png"];
    }
    
    _face.position = ccp(self.contentSize.width * 0.5, self.contentSize.height * 0.5);
    
    [self.texture setAliasTexParameters];
    
    [_face.texture setAliasTexParameters];
}

-(BOOL) isMatchWithMahjong:(Mahjong*)mahjong
{
    switch (_kind)
    {
        case MahjongKindBamboo:
        case MahjongKindCharacter:
        case MahjongKindCircle:
        case MahjongKindWind:
        case MahjongKindDragon:
        {
            if(mahjong.kind == _kind)
                return _point == mahjong.point;
        }
            break;
           
        case MahjongKindSeason:
        case MahjongKindFlower:
        {
            return _kind == mahjong.kind;
        }
            break;
        default:
            break;
    }
    return NO;
}

-(BOOL) isMatchWithMahjongBoardInfo:(MahjongBoardInfo)info
{
    switch (_kind)
    {
        case MahjongKindBamboo:
        case MahjongKindCharacter:
        case MahjongKindCircle:
        case MahjongKindWind:
        case MahjongKindDragon:
        {
            if(info.kind == _kind)
                return _point == info.point;
        }
            break;
            
        case MahjongKindSeason:
        case MahjongKindFlower:
        {
            return _kind == info.kind;
        }
            break;
        default:
            break;
    }
    return NO;
}

-(void)setOpacity:(CGFloat)opacity
{
    [super setOpacity:opacity];
    [_face setOpacity:opacity];
}

-(void)setColor:(CCColor *)color
{
    [super setColor:color];
    [_face setColor:color];
}

-(BOOL) isSamePositionWithMahjong:(Mahjong*)mahjong
{
    if(self.layer == mahjong.layer && self.row == mahjong.row && self.column == mahjong.column)
        return YES;
    
    return NO;
}
-(BOOL) isSamePositionWithMahjongPositionInfo:(MahjongPositionInfo)info
{
    if(self.layer == info.layer && self.row == info.row && self.column == info.column)
        return YES;
    return NO;
}

-(void)shake
{
    [self stopActionByTag:ACTION_TAG_MAHJONG_SHAKE];
    
    self.rotation = 0;
    
    CCActionSequence* sequence = [CCActionSequence actions:
                                  [CCActionEaseOut actionWithAction:[CCActionRotateBy actionWithDuration:0.075 angle:8] rate:1.2],
                                  [CCActionEaseIn actionWithAction:[CCActionRotateBy actionWithDuration:0.075 angle:-8] rate:1.2],
                                  [CCActionEaseOut actionWithAction:[CCActionRotateBy actionWithDuration:0.075 angle:-8] rate:1.2],
                                  [CCActionEaseIn actionWithAction:[CCActionRotateBy actionWithDuration:0.075 angle:8] rate:1.2],
                               nil];
    CCActionRepeat* shake = [CCActionRepeat actionWithAction:sequence times:3];
    shake.tag = ACTION_TAG_MAHJONG_SHAKE;
    [self runAction:shake];
}

-(void)zoom
{
    [self stopActionByTag:ACTION_TAG_MAHJONG_ZOOM];
    self.scale = 1.0;
    CCActionSequence* sequence = [CCActionSequence actions:
                                  [CCActionEaseOut actionWithAction:[CCActionScaleTo actionWithDuration:0.2 scale:1.2] rate:1.2],
                                  [CCActionEaseIn actionWithAction:[CCActionScaleTo actionWithDuration:0.2 scale:1.0] rate:1.2],
                                  nil];
    CCActionRepeat* shake = [CCActionRepeat actionWithAction:sequence times:5];
    shake.tag = ACTION_TAG_MAHJONG_ZOOM;
    [self runAction:shake];
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"Kind:%d Point:%d Layer:%d Row:%d Column:%d",(int)_kind, _point, _layer, _row, _column];
}

@end
