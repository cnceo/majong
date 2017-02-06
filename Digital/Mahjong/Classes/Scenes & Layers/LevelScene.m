//
//  LevelScene.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-16.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "LevelScene.h"
#import "VZButton.h"
#import "LevelButton.h"
#import "SeasonScene.h"
#import "ClassicGameScene.h"
#import "VZArchiveManager.h"
#import "VZAudioManager.h"
@implementation LevelScene

+ (LevelScene *)sceneWithSeason:(int)season Level:(int)level
{
    return [[self alloc] initWithSeason:season Level:level];
}

-(id)initWithSeason:(int)season Level:(int)level
{
    if(self = [super init])
    {
        
        self.season = season;
        self.level = level;
        
        CGPoint PosBG       = [self APFP:ccp(240, 160)];
        CGPoint PosReturn   = [self APFP:ccp(20, 54)];
        
        
        CCSprite* bg0 = [CCSprite spriteWithImageNamed:@"bg_game.png"];
        bg0.position = PosBG;
        [self addChild:bg0];
        
        CCColor* color = [CCColor whiteColor];
        switch (self.season)
        {
            case 0:
                color = [CCColor colorWithRed:149.0f / 255.0f green:75.0f / 255.0f blue:138.0f / 255.0f alpha:1.0];
                break;
            case 1:
                color = [CCColor colorWithRed:7.0f / 255.0f green:162.0f / 255.0f blue:190.0f / 255.0f alpha:1.0];
                break;
            case 2:
                color = [CCColor colorWithRed:20.0f / 255.0f green:211.0f / 255.0f blue:159.0f / 255.0f alpha:1.0];
                break;
            case 3:
                color = [CCColor colorWithRed:173.0f / 255.0f green:99.0f / 255.0f blue:33.0f / 255.0f alpha:1.0];
                break;
            case 4:
                color = [CCColor colorWithRed:57.0f / 255.0f green:126.0f / 255.0f blue:75.0f / 255.0f alpha:1.0];
                break;
            case 5:
                color = [CCColor colorWithRed:141.0f / 255.0f green:84.0f / 255.0f blue:77.0f / 255.0f alpha:1.0];
                break;
            case 6:
                color = [CCColor colorWithRed:131.0f / 255.0f green:132.0f / 255.0f blue:31.0f / 255.0f alpha:1.0];
                break;
            case 7:
                color = [CCColor colorWithRed:77.0f / 255.0f green:121.0f / 255.0f blue:120.0f / 255.0f alpha:1.0];
                break;
            case 8:
                color = [CCColor colorWithRed:40.0f / 255.0f green:134.0f / 255.0f blue:105.0f / 255.0f alpha:1.0];
                break;
            case 9:
                color = [CCColor colorWithRed:148.0f / 255.0f green:126.0f / 255.0f blue:56.0f / 255.0f alpha:1.0];
                break;
            case 10:
                color = [CCColor colorWithRed:63.0f / 255.0f green:151.0f / 255.0f blue:139.0f / 255.0f alpha:1.0];
                break;
            case 11:
                color = [CCColor colorWithRed:108.0f / 255.0f green:72.0f / 255.0f blue:121.0f / 255.0f alpha:1.0];
                break;
            case 12:
                color = [CCColor colorWithRed:255.0f / 255.0f green:210.0f / 255.0f blue:102.0f / 255.0f alpha:1.0];
                break;
            case 13:
                color = [CCColor colorWithRed:49.0f / 255.0f green:151.0f / 255.0f blue:241.0f / 255.0f alpha:1.0];
                break;
            case 14:
                color = [CCColor colorWithRed:255.0f / 255.0f green:142.0f / 255.0f blue:150.0f / 255.0f alpha:1.0];
                break;
            case 15:
                color = [CCColor colorWithRed:26.0f / 255.0f green:80.0f / 255.0f blue:164.0f / 255.0f alpha:1.0];
                break;
        }
        bg0.color = color;

        CCSprite* bg = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"bg_game_%d.png",self.season]];
        bg.position = PosBG;
        [self addChild:bg];
        
        CCScrollView* scrollView = [[CCScrollView alloc] initWithContentNode:[self createScrollContent]];
        scrollView.flipYCoordinates = NO;
        scrollView.pagingEnabled = YES;
        scrollView.verticalScrollEnabled = NO;
        scrollView.horizontalScrollEnabled = NO;
        [self addChild:scrollView];
        
        VZButton* btReturn = [VZButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_return.png"]];
        btReturn.position = PosReturn;
        [btReturn setTarget:self selector:@selector(onReturn:)];
        [self addChild:btReturn];
        
        scrollView.horizontalPage = level / (MAX_LEVELSCENE_ROW * MAX_LEVELSCENE_COLUMN);
        
        
        [[VZAudioManager sharedVZAudioManager] playBGM:@"bgm_menu.mp3" loop:YES];
    }
    
    
    return self;
}


- (CCNode*) createScrollContent
{
    CCNode* node = [CCNode node];
    
    float w = 2;
    float h = 1;
    
    // Make it 3 times the width and height of the parents container
    node.contentSizeType = CCSizeTypeNormalized;
    node.contentSize = CGSizeMake(w, h);
    
    for (int page = 0; page < MAX_LEVELSCENE_PAGE; page++)
    {
        for (int row = 0; row < MAX_LEVELSCENE_ROW; row++)
        {
            for (int column = 0; column < MAX_LEVELSCENE_COLUMN; column++)
            {
                int level = row * MAX_LEVELSCENE_COLUMN + column + page * MAX_LEVELSCENE_ROW * MAX_LEVELSCENE_COLUMN;
                
                if([[VZArchiveManager sharedVZArchiveManager] lockedWithSeason:self.season Level:level])
                {
                    CCSprite* button = [CCSprite spriteWithImageNamed:@"bt_level_unlock.png"];
                    button.positionType = CCPositionTypeNormalized;
                    button.position = ccp(0.10 + 0.075 * (column) + page * 0.5, 0.85 - 0.2 * row);
                    [node addChild:button];
                    button.name = [NSString stringWithFormat:@"%d",row * MAX_LEVELSCENE_COLUMN + column + page * MAX_LEVELSCENE_ROW * MAX_LEVELSCENE_COLUMN];
                }
                else
                {
                    LevelButton* button = [LevelButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_level.png"]];
                    button.positionType = CCPositionTypeNormalized;
                    button.position = ccp(0.10 + 0.075 * (column) + page * 0.5, 0.85 - 0.2 * row);
                    button.label.fontName = SYSTEM_FONT;
                    button.label.shadowColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.7];
                    button.label.shadowBlurRadius = 2;
                    button.label.outlineColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                    button.label.outlineWidth = 1;
                    button.labelPosition = ccp(0.5, 0.55);
                    button.label.fontSize = button.contentSize.height * 0.4;
                    button.level = row * MAX_LEVELSCENE_COLUMN + column + page * MAX_LEVELSCENE_ROW * MAX_LEVELSCENE_COLUMN + 1;
                    [node addChild:button];
                    button.name = [NSString stringWithFormat:@"%d",row * MAX_LEVELSCENE_COLUMN + column + page * MAX_LEVELSCENE_ROW * MAX_LEVELSCENE_COLUMN];
                    
                    for (int i = 0; i < 3; i++)
                    {
                        CCSprite* sprite = [CCSprite spriteWithImageNamed:@"lb_starLevel.png"];
                        sprite.position = ccp(button.contentSize.width * 0.5 + ((i - 1) * sprite.contentSize.width * 1.2), button.contentSize.height * 0.1);
                        [button setStarSprite:sprite AtIndex:i];
                    }
                    [button setTarget:self selector:@selector(onPlay:)];
                    button.stars = [[VZArchiveManager sharedVZArchiveManager] starsWithSeason:self.season Level:level];
                }
                
                
                
                
                
                
            }
        }
    }
    
    return node;
}

-(void)onReturn:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[SeasonScene sceneWithSeason:_season] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

- (void)onPlay:(id)sender
{
    VZButton* button = (VZButton*)sender;
    int level = [button.name intValue];
    CCLOG(@"Play %d",level);
    
    [[CCDirector sharedDirector] replaceScene:[ClassicGameScene sceneWithSeason:self.season Level:level] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}
@end
