//
//  CompleteLayer.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-17.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "DailyChallengeCompleteLayer.h"
#import "VZSpreadForSprite.h"
#import "VZButton.h"
#import "TitleScene.h"
#import "DailyChallengeGameScene.h"
#import "LevelScene.h"
#import "SeasonScene.h"
#import "VZArchiveManager.h"
#import "VZScrollNumberForLabel.h"
#import "VZAudioManager.h"
#import "VZIdentifyManager.h"

#import "VZInterstitialManager.h"
#import "Appirater.h"
#import "VZShareManager.h"
#import "TitleScene.h"
#import "VZCommodityManager.h"
#import "VZArchievementManager.h"
#import "VZSwitch.h"
#define SPREAD_DURATION 1.5

@implementation DailyChallengeCompleteLayer

+(DailyChallengeCompleteLayer*)layerWithSeason:(int)season Level:(int)level Score:(float)score Stars:(int)stars
{
    return [[self alloc] initWithSeason:season Level:level Score:score Stars:stars];
}

-(id)initWithSeason:(int)season Level:(int)level Score:(float)score Stars:(int)stars
{
    CCColor* color = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    if(self = [super initWithColor:color])
    {
        _season = season;
        _score = score;
        _level = level;
        _stars = stars;

        CGPoint PosBG       = ccp(0,    0);
        CGPoint PosTitle    = ccp(0,    116);
        CGPoint PosMenu     = ccp(0,    -75);
        CGPoint PosChest[3];
        PosChest[0]          = ccp(-120,  15);
        PosChest[1]          = ccp(0,    15);
        PosChest[2]          = ccp(120,   15);
        CGPoint PosFlash[3];
        PosFlash[0]          = ccp(-118, 120);
        PosFlash[1]          = ccp(-22,  96);
        PosFlash[2]          = ccp(41,   113);
        
        CCSprite* bg = [CCSprite spriteWithImageNamed:@"bg_result.png"];
        bg.position = PosBG;
        [self.window addChild:bg];
        
        VZSpreadForSprite* spread = [VZSpreadForSprite actionWithDuration:SPREAD_DURATION direction:VZActionSpreadDirectionHorizontal];
        CCActionEaseOut* easeIn = [CCActionEaseOut actionWithAction:spread rate:1.4];
        [bg runAction:easeIn];
        
        CCSprite* title = [CCSprite spriteWithImageNamed:@"lb_cleared.png"];
        title.position = PosTitle;
        [self.window addChild:title];
        [self AddEnterActionToNode:title WithDelay:0];
        
        for (int i = 0; i < 3; i++)
        {
            CCSprite* star = [CCSprite spriteWithImageNamed:@"lb_light.png"];
            star.position = PosFlash[i];
            [self.window addChild:star];
            [self AddEnterActionToNode:star WithDelay:0.25];
            
            float dutation = (arc4random() % 1000) / 1000.0f + 1.0;
            float scaleMin = (arc4random() % 250) / 1000.0f + 0.25;
            float scaleMax = (arc4random() % 250) / 1000.0f + 0.75;
            
            CCActionSequence* sequenceShine = [CCActionSequence actions:
                                               [CCActionEaseOut actionWithAction:[CCActionFadeTo actionWithDuration:dutation opacity:0.25] rate:1.3],
                                               [CCActionEaseIn actionWithAction:[CCActionFadeTo actionWithDuration:dutation opacity:1.0] rate:1.3],
                                               nil];
            CCActionRepeatForever* repeatShine = [CCActionRepeatForever actionWithAction:sequenceShine];
            [star runAction:repeatShine];
            
            
            CCActionSequence* sequenceZoom = [CCActionSequence actions:
                                              [CCActionEaseOut actionWithAction:[CCActionScaleTo actionWithDuration:dutation scale:scaleMin] rate:1.3],
                                              [CCActionEaseIn actionWithAction:[CCActionScaleTo actionWithDuration:dutation scale:scaleMax] rate:1.3],
                                              nil];
            CCActionRepeatForever* repeatZoom = [CCActionRepeatForever actionWithAction:sequenceZoom];
            [star runAction:repeatZoom];
            
            CCActionRepeatForever* rotate = [CCActionRepeatForever actionWithAction:[CCActionRotateBy actionWithDuration:dutation angle:360]];
            [star runAction:rotate];
        }
        
        for (int i = 0; i < 3; i++)
        {
            _chest[i] = [VZSwitch buttonWithTitle:@""
                                              spriteFrame:[CCSpriteFrame frameWithImageNamed:@"lb_treasure_close.png"]
                                   highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"lb_treasure_open.png"]
                                      disabledSpriteFrame:nil];
            
            
            _chest[i].position = PosChest[i];
            _chest[i].effectFile = nil;
            [_chest[i] setBackgroundColor:[CCColor colorWithWhite:1.0 alpha:1] forState:CCControlStateDisabled];
            [_chest[i] setLabelColor:[CCColor colorWithWhite:1.0 alpha:1] forState:CCControlStateDisabled];
            [_chest[i] setTarget:self selector:@selector(onOpenChest:)];
            [self.window addChild:_chest[i]];
            [self AddEnterActionToNode:_chest[i] WithDelay:0];
        }

        
        _productNode = [CCNode node];
        [self.window addChild:_productNode];
        
        _btMenu = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_yes.png"]];
        _btMenu.position = PosMenu;
        [self.window addChild:_btMenu];
        [_btMenu setTarget:self selector:@selector(onMenu:)];
        _btMenu.visible = NO;

        
        [[VZArchiveManager sharedVZArchiveManager] recordDaily];
        
        [[VZArchievementManager sharedVZArchievementManager] checkArchievemens];
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    [[VZAudioManager sharedVZAudioManager] playEffect:@"complete.mp3"];
    
}

-(void)onOpenChest:(id)sender
{
    for (int i = 0; i < 3; i++)
    {
        _chest[i].enabled = NO;
    }
   
    VZSwitch* chest = (VZSwitch*)sender;
    
    int earnProp = arc4random() % 3;
    NSString* propName = nil;
    int propCount = 0;
    switch (earnProp)
    {
        case 0:
        {
            propName = @"lb_reorder.png";
            propCount = arc4random() % 3 + 1;
            [VZCommodityManager sharedVZCommodityManager].shuffle = [VZCommodityManager sharedVZCommodityManager].shuffle + propCount;
        }
            break;
        case 1:
        {
            propName = @"lb_search.png";
            propCount = arc4random() % 3 + 3;
            [VZCommodityManager sharedVZCommodityManager].hint = [VZCommodityManager sharedVZCommodityManager].hint + propCount;
        }
            break;
        case 2:
        {
            propName = @"lb_sun.png";
            propCount = arc4random() % 2 + 1;
            [VZCommodityManager sharedVZCommodityManager].sunshine = [VZCommodityManager sharedVZCommodityManager].sunshine + propCount;
        }
            break;
            
        default:
            break;
    }
    
    CCSprite* props = [CCSprite spriteWithImageNamed:propName];
    props.position = ccp(props.contentSize.width * 0.5, props.contentSize.height * 0.5);
    [_productNode addChild:props];
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x %d",propCount] fontName:SYSTEM_FONT fontSize:30];
    label.position = ccp(props.contentSize.width + label.contentSize.width * 0.5, props.contentSize.height * 0.5);
    [_productNode addChild:label];
    _productNode.visible = NO;
    
    _productNode.position = chest.position;
    _productNode.visible = YES;
    _productNode.scale = 0.01;
    
    CCActionMoveBy* move = [CCActionEaseOut actionWithAction:[CCActionMoveBy actionWithDuration:1 position:ccp(0, 30)] rate:1.5];
    [_productNode runAction:move];
    
    CCActionScaleTo* scale = [CCActionEaseOut actionWithAction:[CCActionScaleTo actionWithDuration:1 scale:1.0] rate:1.5];
    [_productNode runAction:scale];
    
    _btMenu.visible = YES;
    
    [[VZAudioManager sharedVZAudioManager] playEffect:@"shuffle.mp3"];
}

-(void)AddEnterActionToNode:(CCNode*)node WithDelay:(float)delay
{
    node.opacity = 0;
    CCActionSequence* action = [CCActionSequence actions:
                                [CCActionDelay actionWithDuration:SPREAD_DURATION * 0.8 + delay],
                                [CCActionFadeIn actionWithDuration:0.5],
                                nil];
    [node runAction:action];
}

- (void)onMenu:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}


- (void)onShare:(id)sender
{
    [[VZShareManager sharedVZShareManager] shareWithScreenShot];
}



@end
