//
//  MahjongTable.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-19.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "MahjongTable.h"
#import "VZButton.h"

#import "ClassicPauseLayer.h"
#import "ClassicCompleteLayer.h"
#import "Mahjong.h"
#import "VZMoveByForParticle.h"
#import "VZCommonDefine.h"
#import "VZAudioManager.h"
@implementation MahjongTable


+ (MahjongTable *)mahjongTableWithSeason:(int)season Level:(int)level;
{
    return [[self alloc] initWithSeason:season Level:level];
}

-(id)initWithSeason:(int)season Level:(int)level
{
    if (self = [super init])
    {
        
        [self initMahjongSizeInfo];
        
        
        _hints = [NSMutableArray arrayWithCapacity:MAX_HINTS];
        _allEnable = NO;
        
        [self initAvailableBoards];
        [self loadTMXFile:[NSString stringWithFormat:@"level%d-%02d.tmx",season + 1, level + 1]];
        //[self loadTestData];
        
        
        _selectedParticle = [CCParticleSystem particleWithFile:@"par_selected.plist"];
        _selectedParticle.position = ccp(0, 0);
        _selectedParticle.visible = NO;
        [self addChild:_selectedParticle z:ZORDER_TOP];
        
        
    
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

-(void)initMahjongSizeInfo
{
    _sizeMahjong    = CGSizeMake(30, 40);
    
    
    _spaceMahjong   = CGSizeMake(_sizeMahjong.width * 0.42307692307692, -_sizeMahjong.height * 0.41176470588235);
    _offsetMahjong  = CGSizeMake(-_sizeMahjong.width * 0.07692307692308, _sizeMahjong.height * 0.11764705882353);
    
    
    CGSize  totalSize = CGSizeMake(MAX_COLUMN * _spaceMahjong.width - _offsetMahjong.width * (MAX_LAYER - 1),
                                    - MAX_ROW * _spaceMahjong.height + _offsetMahjong.height *  (MAX_LAYER - 1));
    
    
    
    _posMahjong     = ccp((480 - totalSize.width) / 2 + 24,
                          (320 - totalSize.height) / 2 - (MAX_ROW * _spaceMahjong.height) +  15);
    
    _touchArea      = CGRectMake(0.04 - 0.5, 0.18181818181818 - 0.5, 0.78846153846154, 0.81818181818182);
    _maxLayer       = MAX_LAYER;
    
    
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _posMahjong = ccp(_posMahjong.x * self.contentSize.width / 480 + 10,
                          _posMahjong.y * self.contentSize.height / 320 - 25);
    }
    else
    {
        if(self.contentSize.width == 568)
        {
            _posMahjong     = ccpAdd(_posMahjong, ccp(44, 0));
        }
    }
    
}

-(void)initAvailableBoards
{
    int kinds = [Mahjong kinds];
    
    int index = 0;
    for (int i = 0; i < kinds; i++)
    {
        int points = [Mahjong pointsForKind:i];
        
        for (int j = 0; j < points; j++)
        {
            _availableBoards[index].kind = i;
            _availableBoards[index].point = j;
            index++;
        }
    }
    
    for (int i = 0; i < MAX_MAHJONG_BOARDS * 2; i++)
    {
        int a = arc4random() % MAX_MAHJONG_BOARDS;
        int b = arc4random() % MAX_MAHJONG_BOARDS;
        if(a != b)
        {
            MahjongBoardInfo temp = _availableBoards[a];
            _availableBoards[a] = _availableBoards[b];
            _availableBoards[b] = temp;
        }
    }
}

-(CGPoint)randomPositionOutOfScreen
{
    float radius = ccpDistance(ccp(0,0), ccp(self.contentSize.width, self.contentSize.height)) / 2 * 1.2;
    CGPoint origin = ccp(self.contentSize.width * 0.5, self.contentSize.height * 0.5);
    
    float angle = (arc4random() % 360) / 180.0 * M_PI;
    
    CGPoint position = ccp(origin.x + radius * cosf(angle), origin.y + radius * sinf(angle));
    
    return position;
}

-(CGPoint)positionFromLayer:(int)layer Row:(int)row Column:(int)column
{
    if(layer < 0 || layer >= MAX_LAYER || row < 0 || row >= MAX_ROW || column < 0 || column >= MAX_COLUMN)
    {
        //CCLOG(@"Invalid Index ---- Layer:%d Row:%d Column:%d",layer, row, column);
        return ccp(0, 0);
    }
    return ccp(_posMahjong.x + _spaceMahjong.width * column + _offsetMahjong.width * layer,
               _posMahjong.y + _spaceMahjong.height * row + _offsetMahjong.height * layer);
}

-(CGRect)rectFromLayer:(int)layer Row:(int)row Column:(int)column
{
    if(layer < 0 || layer >= MAX_LAYER || row < 0 || row >= MAX_ROW || column < 0 || column >= MAX_COLUMN)
    {
        //CCLOG(@"Invalid Index ---- Layer:%d Row:%d Column:%d",layer, row, column);
        return CGRectZero;
    }
    
    CGRect rect;
    
    CGPoint position = [self positionFromLayer:layer Row:row Column:column];
    
    rect.origin.y   = position.y + _sizeMahjong.height * _touchArea.origin.y;
    rect.origin.x   = position.x + _sizeMahjong.width * _touchArea.origin.x;
    rect.size.width = _sizeMahjong.width * _touchArea.size.width;
    rect.size.height= _sizeMahjong.height * _touchArea.size.height;
    return rect;
}

-(CGRect)touchAreaWithLayer:(int)layer
{
    CGPoint leftTop = ccp(_posMahjong.x + _offsetMahjong.width * layer + _sizeMahjong.width * _touchArea.origin.x,
                          _posMahjong.y + _offsetMahjong.height * layer + _sizeMahjong.height * (_touchArea.origin.y + _touchArea.size.height));
    
    CGRect rect = CGRectMake(leftTop.x,
                             leftTop.y + _spaceMahjong.height * MAX_ROW + _spaceMahjong.height,
                             _spaceMahjong.width * MAX_COLUMN,
                             -_spaceMahjong.height * MAX_ROW);
    return rect;
}

-(int)rowFromPoint:(CGPoint)point Layer:(int)layer
{
    int row = 0;
    
    CGPoint leftTop = ccp(_posMahjong.x + _offsetMahjong.width * layer + _sizeMahjong.width * _touchArea.origin.x,
                          _posMahjong.y + _offsetMahjong.height * layer + _sizeMahjong.height * (_touchArea.origin.y + _touchArea.size.height));
    
    row = (point.y - leftTop.y) / _spaceMahjong.height;
    
    return row;
}

-(int)columnFromPoint:(CGPoint)point Layer:(int)layer
{
    int column = 0;
    
    CGPoint leftTop = ccp(_posMahjong.x + _offsetMahjong.width * layer + _sizeMahjong.width * _touchArea.origin.x,
                          _posMahjong.y + _offsetMahjong.height * layer + _sizeMahjong.height * (_touchArea.origin.y + _touchArea.size.height));
    
    column = (point.x - leftTop.x) / _spaceMahjong.width;
    
    return column;
}



-(NSInteger)zOrderFromLayer:(int)layer Row:(int)row Column:(int)column
{
    if(layer < 0 || layer >= MAX_LAYER || row < 0 || row >= MAX_ROW || column < 0 || column >= MAX_COLUMN)
    {
        //CCLOG(@"Invalid Index ---- Layer:%d Row:%d Column:%d",layer, row, column);
        return 0;
    }
    NSInteger zOrder = 0;
    zOrder = ZORDER_MAHJONG_ORIGIN + layer * MAX_ROW * MAX_COLUMN + row + column;
    return zOrder;
}

-(Mahjong*)tryGetMahjongWithLayer:(int)layer Row:(int)row Column:(int)column
{
    for (int i = 0; i < 4; i++)
    {
        int tempRow     = row;
        int tempColumn  = column;
        switch (i)
        {
            case 0:
            {
                tempRow     = row;
                tempColumn  = column;
            }
                break;
            case 1:
            {
                tempRow     = row - 1;
                tempColumn  = column;
            }
                
                break;
            case 2:
            {
                tempRow     = row;
                tempColumn  = column - 1;
            }
                break;
            case 3:
            {
                tempRow     = row - 1;
                tempColumn  = column - 1;
            }
                break;
        }
        
        if(tempRow >=0 && tempRow < MAX_ROW && tempColumn >= 0 && tempColumn < MAX_COLUMN)
        {
            Mahjong* mahjong = [self mahjongWithLayer:layer Row:tempRow Column:tempColumn];
            if(mahjong)
            {
                return mahjong;
            }
        }
    }
    return nil;
}

-(void)setMahjong:(Mahjong*)mahjong Layer:(int)layer Row:(int)row Column:(int)column
{
    if(layer < 0 || layer >= MAX_LAYER || row < 0 || row >= MAX_ROW || column < 0 || column >= MAX_COLUMN)
    {
        //CCLOG(@"Invalid Index ---- Layer:%d Row:%d Column:%d",layer, row, column);
        return;
    }
    _mahjongs[layer][row][column] = mahjong;
}

-(Mahjong*)mahjongWithLayer:(int)layer Row:(int)row Column:(int)column
{
    if(layer < 0 || layer >= MAX_LAYER || row < 0 || row >= MAX_ROW || column < 0 || column >= MAX_COLUMN)
    {
        //CCLOG(@"Invalid Index ---- Layer:%d Row:%d Column:%d",layer, row, column);
        return nil;
    }
    return _mahjongs[layer][row][column];
}


-(CCActionSequence*)flyInActionWithMahjong:(Mahjong*)mahjong
{
    
    int xDelta,yDelta;
    
    if(mahjong.column <= 15)
    {
        xDelta = abs(mahjong.column - 15);
    }
    else
    {
        xDelta = abs(mahjong.column - 16);
    }
    
    if(mahjong.row <= 8)
    {
        yDelta = abs(mahjong.row - 8);
    }
    else
    {
        yDelta = abs(mahjong.row - 9);
    }
    
    float interval = (xDelta * xDelta + yDelta *yDelta) / 1000.f;
    
    CCActionSequence* sequecne = [CCActionSequence actions:
                                  [CCActionDelay actionWithDuration:mahjong.layer * 0.71 + interval],
                                  [CCActionEaseOut actionWithAction:[CCActionMoveTo actionWithDuration:1.0 position:[self positionFromLayer:mahjong.layer Row:mahjong.row Column:mahjong.column]] rate:1.4],
                                  [CCActionCallBlock actionWithBlock:^{[self isAvailableWithMahjong:mahjong Animated:YES];}],
                                  nil];
    return sequecne;
}

-(CCActionSequence*)flyOutActionWithMahjong:(Mahjong*)mahjong
{
    CCActionSequence* sequecne = [CCActionSequence actions:
                                  [CCActionCallBlock actionWithBlock:^{mahjong.enable = YES;}],
                                  [CCActionEaseIn actionWithAction:[CCActionMoveTo actionWithDuration:1.0 position:[self randomPositionOutOfScreen]] rate:1.4],
                                  nil];
    return sequecne;
}


-(void)shakeAllAffectMahjongWithMahjong:(Mahjong*)mahjong
{
    if(!mahjong)
        return;
    
    int layer   = mahjong.layer;
    int row     = mahjong.row;
    int column  = mahjong.column;
    
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:6];
    
    Mahjong* leftTop = [self mahjongWithLayer:layer Row:row - 1 Column:column - 2];
    if(leftTop)
        [array addObject:leftTop];
    
    
    Mahjong* rightTop = [self mahjongWithLayer:layer Row:row - 1 Column:column + 2];
    if(rightTop)
        [array addObject:rightTop];
    
    
    Mahjong* leftMiddle = [self mahjongWithLayer:layer Row:row Column:column - 2];
    if(leftMiddle)
        [array addObject:leftMiddle];
    
    
    Mahjong* rightMiddle = [self mahjongWithLayer:layer Row:row Column:column + 2];
    if(rightMiddle)
        [array addObject:rightMiddle];
    
    
    Mahjong* leftBottom = [self mahjongWithLayer:layer Row:row + 1 Column:column - 2];
    if(leftBottom)
        [array addObject:leftBottom];
    
    
    Mahjong* rightBottom = [self mahjongWithLayer:layer Row:row + 1 Column:column + 2];
    if(rightBottom)
        [array addObject:rightBottom];
    
    
    BOOL bothNeighbor = (leftTop || leftMiddle || leftBottom) && (rightTop || rightMiddle || rightBottom);
    
    if(bothNeighbor)
    {
        for (Mahjong* temp in array)
        {
            [temp shake];
        }
    }
    
    
    
    Mahjong* upLayerLeftTop     = [self mahjongWithLayer:layer + 1 Row:row - 1 Column:column - 1];
    if(upLayerLeftTop)
    {
        [upLayerLeftTop shake];
    }
    
    Mahjong* upLayerRightTop    = [self mahjongWithLayer:layer + 1 Row:row - 1 Column:column + 1];
    if(upLayerRightTop)
    {
        [upLayerRightTop shake];
    }
    
    Mahjong* upLayerLeftBottom  = [self mahjongWithLayer:layer + 1 Row:row + 1 Column:column - 1];
    if(upLayerLeftBottom)
    {
        [upLayerLeftBottom shake];
    }
    
    Mahjong* upLayerRightBottom = [self mahjongWithLayer:layer + 1 Row:row + 1 Column:column + 1];
    if(upLayerRightBottom)
    {
        [upLayerRightBottom shake];
    }
    
    Mahjong* upLayerUp          = [self mahjongWithLayer:layer + 1 Row:row + 1 Column:column];
    if(upLayerUp)
    {
        [upLayerUp shake];
    }
    
    Mahjong* upLayerDown        = [self mahjongWithLayer:layer + 1 Row:row - 1 Column:column];
    if(upLayerDown)
    {
        [upLayerDown shake];
    }
    
    Mahjong* upLayerLeft        = [self mahjongWithLayer:layer + 1 Row:row  Column:column - 1];
    if(upLayerLeft)
    {
        [upLayerLeft shake];
    }
    
    Mahjong* upLayerRight       = [self mahjongWithLayer:layer + 1 Row:row  Column:column + 1];
    if(upLayerRight)
    {
        [upLayerRight shake];
    }
    
    
    Mahjong* upLayer            = [self mahjongWithLayer:layer + 1 Row:row Column:column];
    if(upLayer)
    {
        [upLayer shake];
    }
    
    [mahjong shake];
    
    [[VZAudioManager sharedVZAudioManager] playEffect:@"unavailable.mp3"];
}

-(BOOL)isAvailableWithMahjong:(Mahjong*)mahjong Animated:(BOOL)animated
{
    if(!mahjong)
        return YES;
    
    int layer   = mahjong.layer;
    int row     = mahjong.row;
    int column  = mahjong.column;
    
    Mahjong* leftTop = [self mahjongWithLayer:layer Row:row - 1 Column:column - 2];
    Mahjong* rightTop = [self mahjongWithLayer:layer Row:row - 1 Column:column + 2];
    
    Mahjong* leftMiddle = [self mahjongWithLayer:layer Row:row Column:column - 2];
    Mahjong* rightMiddle = [self mahjongWithLayer:layer Row:row Column:column + 2];
    
    Mahjong* leftBottom = [self mahjongWithLayer:layer Row:row + 1 Column:column - 2];
    Mahjong* rightBottom = [self mahjongWithLayer:layer Row:row + 1 Column:column + 2];
    
    BOOL bothNeighbor = (leftTop || leftMiddle || leftBottom) && (rightTop || rightMiddle || rightBottom);
    
    
    
    Mahjong* upLayerLeftTop     = [self mahjongWithLayer:layer + 1 Row:row - 1 Column:column - 1];
    Mahjong* upLayerRightTop    = [self mahjongWithLayer:layer + 1 Row:row - 1 Column:column + 1];
    Mahjong* upLayerLeftBottom  = [self mahjongWithLayer:layer + 1 Row:row + 1 Column:column - 1];
    Mahjong* upLayerRightBottom = [self mahjongWithLayer:layer + 1 Row:row + 1 Column:column + 1];
    
    Mahjong* upLayerUp          = [self mahjongWithLayer:layer + 1 Row:row + 1 Column:column];
    Mahjong* upLayerDown        = [self mahjongWithLayer:layer + 1 Row:row - 1 Column:column];
    Mahjong* upLayerLeft        = [self mahjongWithLayer:layer + 1 Row:row  Column:column - 1];
    Mahjong* upLayerRight       = [self mahjongWithLayer:layer + 1 Row:row  Column:column + 1];
    
    Mahjong* upLayer            = [self mahjongWithLayer:layer + 1 Row:row Column:column];
    
    BOOL hasUpFloor = (upLayerLeftTop || upLayerRightTop || upLayerLeftBottom ||upLayerRightBottom || upLayerUp || upLayerDown || upLayerLeft || upLayerRight || upLayer );
    
    if(bothNeighbor || hasUpFloor)
    {
        [mahjong setEnable:NO Animated:animated];
        return NO;
    }
    else
    {
        [mahjong setEnable:YES Animated:animated];
        return YES;
    }
}

-(void)updateSelfAffectWithMahjong:(Mahjong*)mahjong
{
    if(!mahjong)
        return;
    int layer   = mahjong.layer;
    int row     = mahjong.row;
    int column  = mahjong.column;
    
    Mahjong* leftTop = [self mahjongWithLayer:layer Row:row - 1 Column:column - 2];
    [self isAvailableWithMahjong:leftTop Animated:YES];
    
    Mahjong* rightTop = [self mahjongWithLayer:layer Row:row - 1 Column:column + 2];
    [self isAvailableWithMahjong:rightTop Animated:YES];
    
    Mahjong* leftMiddle = [self mahjongWithLayer:layer Row:row Column:column - 2];
    [self isAvailableWithMahjong:leftMiddle Animated:YES];
    
    Mahjong* rightMiddle = [self mahjongWithLayer:layer Row:row Column:column + 2];
    [self isAvailableWithMahjong:rightMiddle Animated:YES];
    
    Mahjong* leftBottom = [self mahjongWithLayer:layer Row:row + 1 Column:column - 2];
    [self isAvailableWithMahjong:leftBottom Animated:YES];
    
    Mahjong* rightBottom = [self mahjongWithLayer:layer Row:row + 1 Column:column + 2];
    [self isAvailableWithMahjong:rightBottom Animated:YES];
    
    
    
    Mahjong* downLayerLeftTop     = [self mahjongWithLayer:layer - 1 Row:row - 1 Column:column - 1];
    [self isAvailableWithMahjong:downLayerLeftTop Animated:YES];
    
    Mahjong* downLayerRightTop    = [self mahjongWithLayer:layer - 1 Row:row - 1 Column:column + 1];
    [self isAvailableWithMahjong:downLayerRightTop Animated:YES];
    
    Mahjong* downLayerLeftBottom  = [self mahjongWithLayer:layer - 1 Row:row + 1 Column:column - 1];
    [self isAvailableWithMahjong:downLayerLeftBottom Animated:YES];
    
    Mahjong* downLayerRightBottom = [self mahjongWithLayer:layer - 1 Row:row + 1 Column:column + 1];
    [self isAvailableWithMahjong:downLayerRightBottom Animated:YES];
    
    
    Mahjong* downLayerUp          = [self mahjongWithLayer:layer - 1 Row:row + 1 Column:column];
    [self isAvailableWithMahjong:downLayerUp Animated:YES];
    
    Mahjong* downLayerDown        = [self mahjongWithLayer:layer - 1 Row:row - 1 Column:column];
    [self isAvailableWithMahjong:downLayerDown Animated:YES];
    
    Mahjong* downLayerLeft        = [self mahjongWithLayer:layer - 1 Row:row  Column:column - 1];
    [self isAvailableWithMahjong:downLayerLeft Animated:YES];
    
    Mahjong* downLayerRight       = [self mahjongWithLayer:layer - 1 Row:row  Column:column + 1];
    [self isAvailableWithMahjong:downLayerRight Animated:YES];
    
    Mahjong* downLayer            = [self mahjongWithLayer:layer - 1 Row:row Column:column];
    [self isAvailableWithMahjong:downLayer Animated:YES];
    
}

-(void)loadTestData
{
    for (int k = 0; k < MAX_LAYER; k++)
    {
        for (int i = 0; i < MAX_ROW; i+=2)
        {
            for (int j = 1; j < MAX_COLUMN; j+=2)
            {
                
                Mahjong* mahjong = [Mahjong mahjongWithKind:MahjongKindBamboo Point:0];
                mahjong.position = [self randomPositionOutOfScreen];
                mahjong.layer = k;
                mahjong.row = i;
                mahjong.column = j;
                [self addChild:mahjong z:[self zOrderFromLayer:k Row:i Column:j]];
                [self setMahjong:mahjong Layer:k Row:i Column:j];
            }
        }
    }
    
    [self reorderMahjongOnlyFlyIn:YES];
}

-(void)loadTMXFile:(NSString*)file
{
    if (![[CCFileUtils sharedFileUtils] fullPathForFilename:file])
    {
        CCLOG(@"Invalid File ---- FileName:%@",file);
        return;
    }
    
    CCTiledMap* map = [CCTiledMap tiledMapWithFile:file];
    CCLOG(@"MapSize:%@",NSStringFromCGSize(map.mapSize));
    
    
    NSDictionary* property = map.properties;
    
    
    NSString* kinds = [property valueForKey:@"species"];
    if(kinds)
    {
        _availableKinds = [kinds intValue];
        if(_availableKinds > MAX_MAHJONG_BOARDS)
            _availableKinds = MAX_MAHJONG_BOARDS;
    }
    else
        _availableKinds = MAX_MAHJONG_BOARDS;
    
    
    
    int MaxRow      = map.mapSize.height;
    int MaxColumn   = map.mapSize.width;
    
    
    int  count = 0;
    
    float left = MAX_COLUMN - 1;
    float top = MAX_ROW - 1;
    float right = 0;
    float bottom = 0;
    
    self.leftMahjongs = 0;
    for (int k = 0; k < MAX_LAYER; k++)
    {
        CCTiledMapLayer* blockInfo = [map layerNamed:[NSString stringWithFormat:@"layer%d",k + 1]];
        if(blockInfo)
        {
            CCTiledMapTilesetInfo *info = blockInfo.tileset;
            if(info)
            {
                for (int i = 0 ; i < MaxRow; i++)
                {
                    for (int j = 0; j < MaxColumn; j++)
                    {
                        BOOL isBlock = [blockInfo tileGIDAt:ccp(j, i)];
                        
                        if (isBlock)
                        {
                            MahjongBoardInfo boardInfo = _availableBoards[count / 2];
                            
                            Mahjong* mahjong = [Mahjong mahjongWithKind:boardInfo.kind Point:boardInfo.point];
                            mahjong.position = [self randomPositionOutOfScreen];
                            mahjong.layer = k;
                            mahjong.row = i;
                            mahjong.column = j;
                            [self addChild:mahjong z:[self zOrderFromLayer:k Row:i Column:j]];
                            [self setMahjong:mahjong Layer:k Row:i Column:j];
                            count = ((count + 1) % (_availableKinds * 2));
                            self.leftMahjongs++;
                            
                            if(mahjong.column < left)
                                left = mahjong.column;
                            
                            if(mahjong.column > right)
                                right = mahjong.column;
                            
                            if(mahjong.row < top)
                                top = mahjong.row;
                            
                            if(mahjong.row > bottom)
                                bottom = mahjong.row;
                            
                        }
                    }
                }
                _maxLayer = k + 1;
            }
        }
    }

    if(self.leftMahjongs % 2 == 1)
    {
        CCLOG(@"INVALID TOTAL TILES:%d",self.leftMahjongs);
    }
    
    
    for (int k = 0; k < _maxLayer; k++)
    {
        for (int i = 0 ; i < MAX_ROW; i++)
        {
            for (int j = 0; j < MAX_COLUMN; j++)
            {
                Mahjong* mahjong = [self mahjongWithLayer:k Row:i Column:j];
                if(mahjong)
                {
                    [self isAvailableWithMahjong:mahjong Animated:NO];
                }
            }
        }
    }
    
    
    
    [self reorderMahjongOnlyFlyIn:YES];
    
    
    
//    牌桌自动缩放功能
//    float scaleX = (float)MAX_COLUMN / (right + 1 - left + 1);
//    float scaleY = (float)MAX_ROW /(bottom - (top - 1) + 1);
//    self.scale = MIN(scaleX, scaleY);
}


-(BOOL)findOnePair
{
    [_hints removeAllObjects];
    
    
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:MAX_ROW * MAX_COLUMN * MAX_LAYER];
    
    for (int k = 0; k < _maxLayer; k++)
    {
        for (int i = 0 ; i < MAX_ROW; i++)
        {
            for (int j = 0; j < MAX_COLUMN; j++)
            {
                Mahjong* mahjong = [self mahjongWithLayer:k Row:i Column:j];
                if(mahjong)
                {
                    [array addObject:mahjong];
                }
            }
        }
    }
    
    
    if(array.count > 0)
    {
        Mahjong* matchA = nil;
        Mahjong* matchB = nil;
        
        int startA = arc4random() % array.count;
        
        for (int i = 0; i < array.count; i++)
        {
            Mahjong* tempA = [array objectAtIndex:(startA + i) % array.count];
            if(tempA.enable)
            {
                int startB = arc4random() % array.count;
                for (int j = 0; j < array.count; j++)
                {
                    Mahjong* tempB = [array objectAtIndex:(startB + j) % array.count];
                    if(tempB != tempA && tempB.enable && [tempB isMatchWithMahjong:tempA])
                    {
                        matchA = tempA;
                        matchB = tempB;
                    }
                }
            }
        }
        
        
        if (matchA && matchB)
        {
            [_hints addObject:matchA];
            [_hints addObject:matchB];
            return YES;
        }
        else
        {
            if(self.delegate && [self.delegate respondsToSelector:self.noMatchCallBackFunc])
            {
                VZSuppressPerformSelectorLeakWarning([self.delegate performSelector:self.noMatchCallBackFunc withObject:self]);
            }
            return NO;
        }
    }
    return NO;
}

-(void)hint
{
    if(self.state == MahjongTableState_Wait || self.state == MahjongTableState_Explore)
    {
        
        if(_hints.count >= 2)
        {
            [self clearSelect];
            
#ifdef DEBUG_MODE
            
            Mahjong* matchA = [_hints objectAtIndex:0];
            Mahjong* matchB = [_hints objectAtIndex:1];
            
            [self matchMahjongA:matchA MahjongB:matchB];
            [_hints removeAllObjects];
#else
            Mahjong* matchA = [_hints objectAtIndex:0];
            Mahjong* matchB = [_hints objectAtIndex:1];
            
            [matchA zoom];
            [matchB zoom];
            
            if(self.delegate && [self.delegate respondsToSelector:self.hintCallBackFunc])
            {
                VZSuppressPerformSelectorLeakWarning([self.delegate performSelector:self.hintCallBackFunc withObject:self]);
            }
            
            [[VZAudioManager sharedVZAudioManager] playEffect:@"hint.mp3"];
#endif
            
        }
        else
        {
#ifdef DEBUG_MODE
            
#else
            if(self.delegate && [self.delegate respondsToSelector:self.noHintCallBackFunc])
            {
                VZSuppressPerformSelectorLeakWarning([self.delegate performSelector:self.noHintCallBackFunc withObject:self]);
            }
#endif
        }
    }
}

-(void)enableAll
{
    if((self.state == MahjongTableState_Wait || self.state == MahjongTableState_Explore) && _allEnable == NO)
    {
        _allEnable = YES;
        for (int k = 0; k < _maxLayer; k++)
        {
            for (int i = 0 ; i < MAX_ROW; i++)
            {
                for (int j = 0; j < MAX_COLUMN; j++)
                {
                    Mahjong* mahjong = [self mahjongWithLayer:k Row:i Column:j];
                    if(mahjong)
                    {
                        [mahjong setEnable:YES Animated:YES];
                    }
                }
            }
        }
        
        CCParticleSystem* parA = [CCParticleSystem particleWithFile:@"par_sun.plist"];
        
        CCSprite* holyLight = [CCSprite spriteWithImageNamed:@"lb_holyLight.png"];
        holyLight.position = ccp(self.contentSize.width * 0.5, self.contentSize.height * 0.5);
        holyLight.scale = 0.01;
        [self addChild:holyLight z:ZORDER_TOP];
        
        
        CCActionSequence* sequence = [CCActionSequence actions:
                                      [CCActionScaleTo actionWithDuration:parA.life scale:1.4],
                                      [CCActionCallFunc actionWithTarget:holyLight selector:@selector(removeFromParent)],
                                      nil];
        [holyLight runAction:sequence];
        
        parA.position = ccp(self.contentSize.width * 0.5, self.contentSize.height * 0.5);
        parA.autoRemoveOnFinish = YES;
        [self addChild:parA z:ZORDER_TOP];
        
#ifdef DEBUG_MODE
        
#else
        if(self.delegate && [self.delegate respondsToSelector:self.lightCallBackFunc])
        {
            VZSuppressPerformSelectorLeakWarning([self.delegate performSelector:self.lightCallBackFunc withObject:self]);
        }
#endif
        [self findOnePair];
        [[VZAudioManager sharedVZAudioManager] playEffect:@"holyLight.mp3"];
    }
}

-(MahjongPositionInfo)findAvialablePositionWithInvalid:(MahjongPositionInfo)invalid
{
    MahjongPositionInfo result;
    
    result.layer = -1;
    result.row = -1;
    result.column = -1;
    
    for (int k = _maxLayer - 1; k >= 0; k--)
    {
        int startRow = arc4random() % MAX_ROW;
        int startColumn = arc4random() % MAX_COLUMN;
        
        
        for (int i = 0 ; i < MAX_ROW; i++)
        {
            for (int j = 0; j < MAX_COLUMN; j++)
            {
                int searchRow = (startRow + i) % MAX_ROW;
                int searchColumn = (startColumn + j) % MAX_COLUMN;
                
                Mahjong* mahjong = [self mahjongWithLayer:k Row:searchRow Column:searchColumn];
                if(mahjong && mahjong.enable)
                {
                    if(!(mahjong.layer == invalid.layer && mahjong.row == invalid.row && mahjong.column == invalid.column))
                    {
                        
                        result.layer = mahjong.layer;
                        result.row = mahjong.row;
                        result.column = mahjong.column;
                        return result;
                    }
                }
            }
        }
    }
    return result;
}

-(Mahjong*)randomFindMahjong
{
    for (int k = 0; k < _maxLayer; k++)
    {
        int startRow = arc4random() % MAX_ROW;
        int startColumn = arc4random() % MAX_COLUMN;
        
        for (int i = 0 ; i < MAX_ROW; i++)
        {
            for (int j = 0; j < MAX_COLUMN; j++)
            {
                int searchRow = (startRow + i) % MAX_ROW;
                int searchColumn = (startColumn + j) % MAX_COLUMN;
                
                Mahjong* mahjong = [self mahjongWithLayer:k Row:searchRow Column:searchColumn];
                if(mahjong)
                {
                    return mahjong;
                }
            }
        }
    }
    return nil;
}

-(Mahjong*)findMahjongWithInfo:(MahjongBoardInfo)info Invaliad:(Mahjong*)invaliad
{
    
    for (int k = 0; k < _maxLayer; k++)
    {
        int startRow = arc4random() % MAX_ROW;
        int startColumn = arc4random() % MAX_COLUMN;
        
        
        for (int i = 0 ; i < MAX_ROW; i++)
        {
            for (int j = 0; j < MAX_COLUMN; j++)
            {
                int searchRow = (startRow + i) % MAX_ROW;
                int searchColumn = (startColumn + j) % MAX_COLUMN;
                
                Mahjong* mahjong = [self mahjongWithLayer:k Row:searchRow Column:searchColumn];
                if(mahjong && [mahjong isMatchWithMahjongBoardInfo:info] && mahjong != invaliad)
                {
                    return mahjong;
                }
            }
        }
    }
    return nil;
}

- (void)reorderMahjongOnlyFlyIn:(BOOL)isOnlyFlyIn
{
    if(!(self.state == MahjongTableState_Wait || self.state == MahjongTableState_Explore))
        return;
    
    [self clearSelect];
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:MAX_ROW * MAX_COLUMN * MAX_LAYER];
    
    for (int k = 0; k < _maxLayer; k++)
    {
        for (int i = 0 ; i < MAX_ROW; i++)
        {
            for (int j = 0; j < MAX_COLUMN; j++)
            {
                Mahjong* mahjong = [self mahjongWithLayer:k Row:i Column:j];
                if(mahjong)
                {
                    [array addObject:mahjong];
                }
            }
        }
    }
    
    MahjongPositionInfo avialableNone;
    avialableNone.layer = -1;
    avialableNone.row = -1;
    avialableNone.column = -1;
    
    
    MahjongPositionInfo avialableA = [self findAvialablePositionWithInvalid:avialableNone];
    MahjongPositionInfo avialableB = [self findAvialablePositionWithInvalid:avialableA];
    
    if(avialableA.layer != -1 && avialableB.layer != -1)
    {
        Mahjong* matchA = [self randomFindMahjong];
        Mahjong* matchB = nil;
        if(matchA != nil)
        {
            MahjongBoardInfo matchTemp;
            matchTemp.kind  = -1;
            matchTemp.point = -1;
            
            matchTemp.kind = matchA.kind;
            matchTemp.point = matchA.point;
            matchB = [self findMahjongWithInfo:matchTemp Invaliad:matchA];
        }
        
        
        if(matchA != nil || matchB != nil)
        {
            for (int i = 0; i < array.count * 2; i++)
            {
                int a = arc4random() % array.count;
                int b = arc4random() % array.count;
                
                if(a != b)
                {
                    Mahjong* tempA = [array objectAtIndex:a];
                    Mahjong* tempB = [array objectAtIndex:b];
                    
                    int tempLayer   = tempA.layer;
                    int tempRow     = tempA.row;
                    int tempColumn  = tempA.column;
                    
                    tempA.layer     = tempB.layer;
                    tempA.row       = tempB.row;
                    tempA.column    = tempB.column;
                    
                    tempB.layer     = tempLayer;
                    tempB.row       = tempRow;
                    tempB.column    = tempColumn;
                }
            }
            
            for (Mahjong* exchangeA in array)
            {
                if([exchangeA isSamePositionWithMahjongPositionInfo:avialableA])
                {
                    if(exchangeA != matchA)
                    {
                        int tempLayer   = exchangeA.layer;
                        int tempRow     = exchangeA.row;
                        int tempColumn  = exchangeA.column;
                        
                        exchangeA.layer     = matchA.layer;
                        exchangeA.row       = matchA.row;
                        exchangeA.column    = matchA.column;
                        
                        matchA.layer     = tempLayer;
                        matchA.row       = tempRow;
                        matchA.column    = tempColumn;
                    }
                    else
                    {
                        //no need to exchange
                    }
                    break;
                }
            }
            
            
            for (Mahjong* exchangeB in array)
            {
                if([exchangeB isSamePositionWithMahjongPositionInfo:avialableB])
                {
                    if(exchangeB != matchB)
                    {
                        int tempLayer   = exchangeB.layer;
                        int tempRow     = exchangeB.row;
                        int tempColumn  = exchangeB.column;
                        
                        exchangeB.layer     = matchB.layer;
                        exchangeB.row       = matchB.row;
                        exchangeB.column    = matchB.column;
                        
                        matchB.layer     = tempLayer;
                        matchB.row       = tempRow;
                        matchB.column    = tempColumn;
                    }
                    else
                    {
                        //no need exchange
                    }
                    break;
                }
            }
            
            
            for (int k = 0; k < _maxLayer; k++)
            {
                for (int i = 0 ; i < MAX_ROW; i++)
                {
                    for (int j = 0; j < MAX_COLUMN; j++)
                    {
                        [self setMahjong:nil Layer:k Row:i Column:j];
                    }
                }
            }
            
            
            CCLOG(@"MahjongA %@ could match with MahjongB:%@",matchA, matchB);
        }
        else
        {
            if(matchA == nil)
            {
                CCLOG(@"Can't Complete:No Mahjong");
            }
            else
            {
                CCLOG(@"Can't Complete:Mahjong %@ can't match",matchA);
            }
        }
    }
    else
    {
        CCLOG(@"Can't Complete: Not enough avilable Position");
    }
    
    self.state = MahjongTableState_Reorder;
    _finishedCount += (int)array.count;
    
    for (Mahjong* mahjong in array)
    {
        
        [self setMahjong:mahjong Layer:mahjong.layer Row:mahjong.row Column:mahjong.column];
        if(isOnlyFlyIn)
        {
            [mahjong setEnable:YES Animated:NO];
            mahjong.zOrder = [self zOrderFromLayer:mahjong.layer Row:mahjong.row Column:mahjong.column];
            CCActionSequence* sequecne = [CCActionSequence actions:
                                          [self flyInActionWithMahjong:mahjong],
                                          [CCActionCallFunc actionWithTarget:self selector:@selector(updateState)],
                                          nil];
            [mahjong runAction:sequecne];
            
        }
        else
        {
            CCActionSequence* sequecne = [CCActionSequence actions:
                                          [self flyOutActionWithMahjong:mahjong],
                                          [CCActionCallBlock actionWithBlock:^{mahjong.zOrder = [self zOrderFromLayer:mahjong.layer Row:mahjong.row Column:mahjong.column];}],
                                          [self flyInActionWithMahjong:mahjong],
                                          [CCActionCallFunc actionWithTarget:self selector:@selector(updateState)],
                                          nil];
            [mahjong runAction:sequecne];
        }
    }
    
    
#ifdef DEBUG_MODE
    
#else
    if(self.delegate && [self.delegate respondsToSelector:self.reorderCallBackFunc])
    {
        VZSuppressPerformSelectorLeakWarning([self.delegate performSelector:self.reorderCallBackFunc withObject:self]);
    }
#endif
    
    if(!isOnlyFlyIn)
    {
        [[VZAudioManager sharedVZAudioManager] playEffect:@"shuffle.mp3"];
    }
}


-(void)setState:(MahjongTableState)state
{
    switch (state)
    {
        case MahjongTableState_Wait:
        {
            _state = state;
            
        }
            break;
        case MahjongTableState_Explore:
        {
            _state = state;
        }
            break;
        case MahjongTableState_Reorder:
        {
            _state = state;
        }
            break;
        case MahjongTableState_Compelte:
        {
            _state = state;
        }
            break;
    }
}

-(void)updateAvailableForAll
{
    if(_allEnable)
    {
        _allEnable = NO;
        for (int k = 0; k < _maxLayer; k++)
        {
            for (int i = 0 ; i < MAX_ROW; i++)
            {
                for (int j = 0; j < MAX_COLUMN; j++)
                {
                    Mahjong* mahjong = [self mahjongWithLayer:k Row:i Column:j];
                    if(mahjong)
                    {
                        [self isAvailableWithMahjong:mahjong Animated:YES];
                    }
                }
            }
        }
    }
}


-(void)updateState
{
    switch (_state)
    {
        case MahjongTableState_Wait:
        {
            
        }
            break;
        case MahjongTableState_Explore:
        {
            _finishedCount--;
            if(_finishedCount <= 0)
            {
                CCLOG(@"Current State:%d FinishedCount:%d LeftCount:%d",(int)self.state, _finishedCount, self.leftMahjongs);
                if (self.leftMahjongs == 0)
                {
                    if(self.delegate && [self.delegate respondsToSelector:self.finishCallBackFunc])
                    {
                        VZSuppressPerformSelectorLeakWarning([self.delegate performSelector:self.finishCallBackFunc withObject:self]);
                    }
                    self.state = MahjongTableState_Compelte;
                }
                else
                {
                    [self updateAvailableForAll];
                    [self findOnePair];
                    self.state = MahjongTableState_Wait;
                    CCLOG(@"Next State:%d",(int)self.state);
                }
            }
        }
            break;
        case MahjongTableState_Reorder:
        {
            _finishedCount--;
            if(_finishedCount <= 0)
            {
                [self updateAvailableForAll];
                [self findOnePair];
                self.state = MahjongTableState_Wait;
                CCLOG(@"Next State:%d",(int)self.state);
                
                if(self.delegate && [self.delegate respondsToSelector:self.didReorderCallBackFunc])
                {
                    VZSuppressPerformSelectorLeakWarning([self.delegate performSelector:self.didReorderCallBackFunc withObject:self]);
                }
            }
        }
            break;
        case MahjongTableState_Compelte:
            break;
    }
}

-(void)matchMahjongA:(Mahjong*)mahjongA MahjongB:(Mahjong*)mahjongB
{
    if(mahjongA && mahjongB)
    {
        
        [self clearSelect];
        
        self.state = MahjongTableState_Explore;
        _finishedCount += 2;
        
        self.leftMahjongs -= 2;
        
        [self setMahjong:nil Layer:mahjongA.layer Row:mahjongA.row Column:mahjongA.column];
        [self setMahjong:nil Layer:mahjongB.layer Row:mahjongB.row Column:mahjongB.column];
        
        
        
        
        CCParticleSystem* line = [CCParticleSystem particleWithFile:@"par_line.plist"];
        line.position = ccp(0, 0);
        line.autoRemoveOnFinish = YES;
        [self addChild:line z:ZORDER_TOP];
        
        line.sourcePosition = mahjongA.position;
        CCActionEaseIn* fly = [CCActionEaseIn actionWithAction:[VZMoveByForParticle actionWithDuration:line.duration position:ccpSub(mahjongB.position, mahjongA.position)] rate:1.3];
        [line runAction:fly];
        
        
        
        
        CCParticleSystem* parA = [CCParticleSystem particleWithFile:@"par_explore_0.plist"];
        parA.position = mahjongA.position;
        parA.autoRemoveOnFinish = YES;
        [self addChild:parA z:mahjongA.zOrder + 1];
        
        CCActionSequence* sequenceA = [CCActionSequence actions:
                                       [CCActionDelay actionWithDuration:line.duration],
                                       [CCActionCallBlock actionWithBlock:^{[[VZAudioManager sharedVZAudioManager] playEffect:@"match.mp3"];}],
                                       [CCActionFadeOut actionWithDuration:parA.life],
                                       [CCActionCallBlock actionWithBlock:^{[self updateSelfAffectWithMahjong:mahjongA];}],
                                       [CCActionCallBlock actionWithBlock:^{
                                            CCParticleSystem* parA = [CCParticleSystem particleWithFile:@"par_explore_1.plist"];
                                            parA.position = mahjongA.position;
                                            parA.autoRemoveOnFinish = YES;
                                            [self addChild:parA z:mahjongA.zOrder + 1];
                                        }],
                                       [CCActionCallFunc actionWithTarget:mahjongA selector:@selector(removeFromParent)],
                                       [CCActionCallFunc actionWithTarget:self selector:@selector(updateState)],
                                       nil];
        [mahjongA runAction:sequenceA];
        
        
        
        CCParticleSystem* parB = [CCParticleSystem particleWithFile:@"par_explore_0.plist"];
        parB.position = mahjongB.position;
        parB.autoRemoveOnFinish = YES;
        [self addChild:parB z:mahjongB.zOrder + 1];
        
        CCActionSequence* sequenceB = [CCActionSequence actions:
                                       [CCActionDelay actionWithDuration:line.duration],
                                       [CCActionFadeOut actionWithDuration:parB.life],
                                       [CCActionCallBlock actionWithBlock:^{[self updateSelfAffectWithMahjong:mahjongB];}],
                                       [CCActionCallBlock actionWithBlock:^{
                                            CCParticleSystem* parB = [CCParticleSystem particleWithFile:@"par_explore_1.plist"];
                                            parB.position = mahjongB.position;
                                            parB.autoRemoveOnFinish = YES;
                                            [self addChild:parB z:mahjongB.zOrder + 1];
                                        }],
                                       [CCActionCallFunc actionWithTarget:mahjongB selector:@selector(removeFromParent)],
                                       [CCActionCallFunc actionWithTarget:self selector:@selector(updateState)],
                                       
                                       nil];
        [mahjongB runAction:sequenceB];
        
        
        
       
        
        
        if(self.delegate && [self.delegate respondsToSelector:self.matchCallBackFunc])
        {
            VZSuppressPerformSelectorLeakWarning([self.delegate performSelector:self.matchCallBackFunc withObject:self]);
        }
        
        
        
    }
}

-(void)clearSelect
{
    if(_firstSelected)
    {
        _firstSelected.selected = NO;
        _firstSelected = nil;
    }
    
    if (_secondSelected)
    {
        _secondSelected.selected = NO;
        _secondSelected = nil;
    }
    
    [self selectedMahjong:nil];
}

-(void)selectedMahjong:(Mahjong*)mahjong
{
    if(mahjong == nil)
    {
        _selectedParticle.visible = NO;
        [_selectedParticle stopActionByTag:ACTION_TAG_SELECTED];
        [_selectedParticle stopSystem];
    }
    else
    {
        
        [_selectedParticle stopActionByTag:ACTION_TAG_SELECTED];
        _selectedParticle.visible = YES;
        [_selectedParticle resetSystem];
        
        CGRect rect = [self rectFromLayer:mahjong.layer Row:mahjong.row Column:mahjong.column];
        _selectedParticle.sourcePosition = ccp(rect.origin.x , rect.origin.y );
        
        float width = rect.size.width - _selectedParticle.startSize * 0.25;
        float height = rect.size.height - _selectedParticle.startSize * 0.5;
        
        
        float length = (width + height) * 2;
        float speed = length / _selectedParticle.life;
        
        
        CCActionSequence* sequence = [CCActionSequence actions:
                                      [VZMoveByForParticle actionWithDuration:height / speed
                                                                position:ccp(0, height)],
                                      
                                      [VZMoveByForParticle actionWithDuration:width / speed
                                                                position:ccp(width, 0)],
                                      
                                      [VZMoveByForParticle actionWithDuration:height / speed
                                                                position:ccp(0, -height)],
                                      
                                      [VZMoveByForParticle actionWithDuration:width / speed
                                                                position:ccp(-width, 0)],
                                      nil];
        CCActionRepeatForever* repeat = [CCActionRepeatForever actionWithAction:sequence];
        repeat.tag = ACTION_TAG_SELECTED;
        [_selectedParticle runAction:repeat];
        _selectedParticle.zOrder = mahjong.zOrder + 1;
        
        _firstSelected = mahjong;
        _firstSelected.selected = YES;
        
        [[VZAudioManager sharedVZAudioManager] playEffect:@"select.mp3"];
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(self.state == MahjongTableState_Wait || self.state == MahjongTableState_Explore)
    {
        CGPoint touchLoc = [touch locationInNode:self];
        for (int layer = _maxLayer - 1; layer >= 0; layer--)
            //for (int layer = 0; layer >= 0; layer--)
        {
            CGRect rect = [self touchAreaWithLayer:layer];
            
            if(CGRectContainsPoint(rect, touchLoc))
            {
                int row = [self rowFromPoint:touchLoc Layer:layer];
                int column = [self columnFromPoint:touchLoc Layer:layer];
                
                Mahjong* mahjong = [self tryGetMahjongWithLayer:layer Row:row Column:column];
                if (mahjong)
                {
                    if(mahjong.enable)
                    {
                        if(_firstSelected == nil)
                        {
                            [self selectedMahjong:mahjong];
                        }
                        else
                        {
                            if(_firstSelected == mahjong)
                            {
                                if(_firstSelected.layer > 0)
                                {
                                    Mahjong* down = [self mahjongWithLayer:_firstSelected.layer - 1 Row:_firstSelected.row Column:_firstSelected.column];
                                    if(down && down.enable)
                                    {
                                        _secondSelected = down;
                                        if([_firstSelected isMatchWithMahjong:_secondSelected])
                                        {
                                            
                                            _firstSelected.selected = NO;
                                            _secondSelected.selected = NO;
                                            
                                            [self matchMahjongA:_firstSelected MahjongB:_secondSelected];
                                            
                                            _firstSelected = nil;
                                            _secondSelected = nil;
                                        }
                                    }
                                }
                                
                            }
                            else
                            {
                                _secondSelected = mahjong;
                                if([_firstSelected isMatchWithMahjong:_secondSelected])
                                {
                                    
                                    _firstSelected.selected = NO;
                                    _secondSelected.selected = NO;
                                    
                                    [self matchMahjongA:_firstSelected MahjongB:_secondSelected];
                                    
                                    _firstSelected = nil;
                                    _secondSelected = nil;
                                }
                                else
                                {
                                    [self clearSelect];
                                    [self selectedMahjong:mahjong];
                                    
                                }
                            }
                        }
                    }
                    else
                    {
                        [self shakeAllAffectMahjongWithMahjong:mahjong];
                    }
                    
                    CCLOG(@"Layer:%d Row:%d Column:%d",mahjong.layer, mahjong.row, mahjong.column);
                    break;
                }
            }
            else
            {
                CCLOG(@"Touch point:%@ is  not in touch area:%@",NSStringFromCGPoint(touchLoc), NSStringFromCGRect(rect));
            }
        }
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self touchEnded:touch withEvent:event];
}

@end
