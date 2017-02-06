//
//  SeasonScene.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-13.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "SeasonScene.h"
#import "VZButton.h"
#import "VZArchiveManager.h"
#import "TitleScene.h"
#import "LevelScene.h"
#import "VZAudioManager.h"
#import "VZRateManager.h"
#import "Appirater.h"
@implementation SeasonScene

+ (SeasonScene *)sceneWithSeason:(int)season
{
    return [[self alloc] initWithSeason:season];
}

- (id)initWithSeason:(int)season
{
    self = [super init];
    if (!self) return(nil);
    
    _season = season;
    
    CGPoint PosBG       = [self APFP:ccp(240, 160)];
    CGPoint PosReturn   = [self APFP:ccp(20,  54)];
    CGPoint PosStar     = [self APFP:ccp(240, 303)];
    CGPoint PosPageDot  = [self APFP:ccp(240, 55)];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        PosStar    = ccp(PosStar.x,     self.contentSize.height * 0.9);
        PosPageDot = ccp(PosPageDot.x,  self.contentSize.height * 0.225);
    }
    
    CCSprite* bg = [CCSprite spriteWithImageNamed:@"bg_title.png"];
    bg.position = PosBG;
    [self addChild:bg];
    
    
    CCSprite* starBG = [CCSprite spriteWithImageNamed:@"lb_bg_score_0.png"];
    starBG.position = PosStar;
    [self addChild:starBG];
    
    CCSprite* star = [CCSprite spriteWithImageNamed:@"lb_starLevel.png"];
    star.positionType = CCPositionTypeNormalized;
    star.position = ccp(0.18918918918919, 0.5);
    [starBG addChild:star];
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:
                         [NSString stringWithFormat:@"%d", [[VZArchiveManager sharedVZArchiveManager] totalStars]]
                                           fontName:SYSTEM_FONT
                                           fontSize:star.contentSize.height];
    label.positionType = CCPositionTypeNormalized;
    label.position = ccp(0.65, 0.54);
    label.color = [CCColor colorWithRed:1.0 green:0.84705882352941 blue:0.34509803921569 alpha:1.0];
    label.outlineColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    label.outlineWidth = 1;
    [starBG addChild:label];
   
    
    CCScrollView* scrollView = [[CCScrollView alloc] initWithContentNode:[self createScrollContent]];
    scrollView.flipYCoordinates = NO;
    scrollView.pagingEnabled = YES;
    scrollView.verticalScrollEnabled = NO;
    scrollView.horizontalScrollEnabled = YES;
    scrollView.delegate = self;
    [self addChild:scrollView];
    scrollView.horizontalPage = _season / 4;
    
    

    VZButton* btReturn = [VZButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_return.png"]];
    btReturn.position = PosReturn;
    [btReturn setTarget:self selector:@selector(onReturn:)];
    [self addChild:btReturn z:1];
    
//    _pageControl = [VZPageControl pageControlWithMaxPage:MAX_MODES / 4 + 1];
//    _pageControl.position = PosPageDot;
//    _pageControl.page = scrollView.horizontalPage;
//    [self addChild:_pageControl];
    
    
    
    
    [[VZAudioManager sharedVZAudioManager] playBGM:@"bgm_menu.mp3" loop:YES];
    
    
    
	return self;
}

-(void)dealloc
{
   
}

-(void)onEnter
{
    [super onEnter];
    
    CCSprite* leftBamboo = [CCSprite spriteWithImageNamed:@"lb_bamboo_0.png"];
    leftBamboo.anchorPoint = ccp(0, 0);
    leftBamboo.position = ccp(-leftBamboo.contentSize.width * 0.1, self.contentSize.height - leftBamboo.contentSize.height);
    [self addChild:leftBamboo];
    
    
    leftBamboo.rotation = -8;
    CCActionSequence* leftSequence = [CCActionSequence actions:
                                      [CCActionEaseOut actionWithAction:[CCActionRotateBy actionWithDuration:2.4 angle:8] rate:1.3],
                                      [CCActionCallBlock actionWithBlock:^{[self addAcitonToLeftBamboo:leftBamboo];}],
                                      nil];
    [leftBamboo runAction:leftSequence];
    
    
    
    CCSprite* rightBamboo = [CCSprite spriteWithImageNamed:@"lb_bamboo_1.png"];
    rightBamboo.anchorPoint = ccp(1, 0);
    rightBamboo.position = ccp(self.contentSize.width, self.contentSize.height - leftBamboo.contentSize.height);
    [self addChild:rightBamboo];
    
    
    rightBamboo.rotation = 6;
    CCActionSequence* rightSequence = [CCActionSequence actions:
                                       [CCActionEaseOut actionWithAction:[CCActionRotateBy actionWithDuration:2.4 angle:-6] rate:1.3],
                                       [CCActionCallBlock actionWithBlock:^{[self addAcitonToRightBamboo:rightBamboo];}],
                                       nil];
    [rightBamboo runAction:rightSequence];
    
    
}

-(void)addAcitonToLeftBamboo:(CCSprite*)bamboo
{
    
    float angle = (arc4random() % 5) + 6;
    float inDuration = (arc4random() % 500) / 1000.0f + 1.5 * 2;
    float outDuration = inDuration * 1.5;
    
    CCActionSequence* leftSqeuence = [CCActionSequence actions:
                                      [CCActionRotateBy actionWithDuration:inDuration angle:-angle],
                                      [CCActionRotateBy actionWithDuration:outDuration angle:angle],
                                      [CCActionCallBlock actionWithBlock:^{
        [self addAcitonToLeftBamboo:bamboo];
    }]
                                      , nil];
    
    [bamboo runAction:leftSqeuence];
}

-(void)addAcitonToRightBamboo:(CCSprite*)bamboo
{
    
    float angle = (arc4random() % 3) + 3;
    float inDuration = (arc4random() % 500) / 1000.0f + 2 * 2;
    float outDuration = inDuration * 2;
    
    CCActionSequence* leftSqeuence = [CCActionSequence actions:
                                      [CCActionRotateBy actionWithDuration:inDuration angle:angle],
                                      [CCActionRotateBy actionWithDuration:outDuration angle:-angle],
                                      [CCActionCallBlock actionWithBlock:^{
        [self addAcitonToRightBamboo:bamboo];
    }]
                                      , nil];
    
    [bamboo runAction:leftSqeuence];
}


- (CCNode*) createScrollContent
{
    
    CGPoint pos[4];
    
    pos[0] = ccp(0.70000000000000, 0.13392857142857);
    pos[1] = ccp(0.75000000000000, 0.35044642857143);
    pos[2] = ccp(0.36979166666667, 0.13169642857143);
    pos[3] = ccp(0.73437500000000, 0.18526785714286);
    
    CCNode* node = [CCNode node];
    
    float w = MAX_MODES / 4 + 1;
    float h = 1;
    float gap = (1.0 / w) / 5;
    float start = ((1 / w) - 4 * gap) / 2 + gap / 2;
    
    
    // Make it 3 times the width and height of the parents container
    node.contentSizeType = CCSizeTypeNormalized;
    node.contentSize = CGSizeMake(w, h);
    
    for (int i = 0; i < MAX_MODES; i++)
    {
        [[VZArchiveManager sharedVZArchiveManager] checkUnlockForSeason:i];
    }

    int maxRow = 1;
    int maxColumn = 4;
    int cellsOnePage = maxRow * maxColumn;
    int maxPage = MAX_MODES / cellsOnePage;
    

    for (int page = 0; page < maxPage + 1; page++)
    {
        for (int row = 0; row < maxRow; row++)
        {
            for (int column = 0; column < maxColumn; column++)
            {
                
                if(page < maxPage)
                {
                    NSString* file = [NSString stringWithFormat:@"bt_season_%d.png",column + page * cellsOnePage + row * maxColumn];
                    
                    int modeIndex = column + page * cellsOnePage + row * maxColumn;
                    
                    VZModeArchive* modeArchive = [[VZArchiveManager sharedVZArchiveManager] modeArchiveAtIndex:modeIndex];
                    if(modeArchive.isLocked)
                    {
                        CCSprite* button = [CCSprite spriteWithImageNamed:file];
                        button.color = [CCColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
                        button.positionType = CCPositionTypeNormalized;
                        button.position = ccp(start + gap * column + page / w, 0.55);
                        [node addChild:button];
                        button.name = [NSString stringWithFormat:@"%d",column + page * cellsOnePage + row * maxColumn];

                        CCSprite* lock = [CCSprite spriteWithImageNamed:@"bt_lock.png"];
                        lock.positionType = CCPositionTypeNormalized;
                        lock.position = ccp(0.5, 0.65178571428571);
                        [button addChild:lock];
                        
                        CCSprite* star = [CCSprite spriteWithImageNamed:@"lb_star_unlock.png"];
                        star.positionType = CCPositionTypeNormalized;
                        star.position = ccp(0.30, 0.46428571428571);
                        [button addChild:star];

                        CCLabelTTF* label = [CCLabelTTF labelWithString:
                                             [NSString stringWithFormat:@"%d", modeArchive.unlockStars]
                                                               fontName:SYSTEM_FONT
                                                               fontSize:star.contentSize.height];
                        label.positionType = CCPositionTypeNormalized;
                        label.position = ccp(0.63541666666667, 0.46428571428571);
                        label.shadowColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.7];
                        label.shadowBlurRadius = 2;
                        label.outlineColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                        label.outlineWidth = 1;
                        [button addChild:label];
                        
                        
                        CCLabelTTF* unlock = [CCLabelTTF labelWithString:NSLocalizedString(@"To Unlock", nil)
                                                                fontName:SYSTEM_FONT
                                                                fontSize:star.contentSize.height * 0.64];
                        unlock.positionType = CCPositionTypeNormalized;
                        unlock.position = ccp(0.5, 0.36160714285714);
                        unlock.shadowColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.7];
                        unlock.shadowBlurRadius = 2;
                        unlock.outlineColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                        unlock.outlineWidth = 1;
                        [button addChild:unlock];
                    }
                    else
                    {
                        VZButton* button = [VZButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:file]];
                        button.positionType = CCPositionTypeNormalized;
                        button.position = ccp(start + gap * column + page / w, 0.55);
                        [node addChild:button];
                        button.name = [NSString stringWithFormat:@"%d",column + page * cellsOnePage + row * maxColumn];
                        [button setTarget:self selector:@selector(onPlay:)];
                        
                        
                        
                        CCSprite* star = [CCSprite spriteWithImageNamed:@"lb_starLevel.png"];
                        star.positionType = CCPositionTypeNormalized;
                        star.position = ccp(0.29166666666667, 0.07142857142857);
                        [button addChild:star];
                        
                        int stars = 0;
                        
                        for (int i = 0 ; i < MAX_LEVELS; i++)
                        {
                            stars += [[VZArchiveManager sharedVZArchiveManager] starsWithSeason:column + page * cellsOnePage + row * maxColumn Level:i];
                        }
                        
                        CCLabelTTF* label = [CCLabelTTF labelWithString:
                                             [NSString stringWithFormat:@"%d / %d",stars, MAX_LEVELS * 3]
                                                               fontName:SYSTEM_FONT
                                                               fontSize:star.contentSize.height];
                        label.positionType = CCPositionTypeNormalized;
                        label.position = ccp(0.60416666666667, 0.076);
                        label.shadowColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.7];
                        label.shadowBlurRadius = 2;
                        label.outlineColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                        label.outlineWidth = 1;
                        [button addChild:label];
                    }
                }
                else
                {
                    NSString* file = [NSString stringWithFormat:@"bt_season_%d.png",column + page * 4];
                    CCSprite* button = [CCSprite spriteWithImageNamed:file];
                    button.positionType = CCPositionTypeNormalized;
                    button.position = ccp(start + gap * column + page / w, 0.55);
                    [node addChild:button];
                    
                    CCSprite* word = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"lb_characters_%d.png",column]];
                    word.position = ccp(button.contentSize.width * pos[column].x, button.contentSize.height * pos[column].y);
                    [button addChild:word z:1];
                    
                }
                
            }
        }
    }
    return node;
}

- (void)onPlay:(id)sender
{
    VZButton* button = (VZButton*)sender;
    int mode = [button.name intValue];
    CCLOG(@"Play %d",mode);
    
    [[CCDirector sharedDirector] replaceScene:[LevelScene sceneWithSeason:mode Level:0] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

- (void)onReturn:(id)sender
{
    CCLOG(@"Return");
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

- (void)scrollViewDidScroll:(CCScrollView *)scrollView
{
    
}
- (void)scrollViewWillBeginDragging:(CCScrollView *)scrollView
{
    
}
- (void)scrollViewDidEndDragging:(CCScrollView * )scrollView willDecelerate:(BOOL)decelerate
{
    
}
- (void)scrollViewWillBeginDecelerating:(CCScrollView *)scrollView
{
    
}
- (void)scrollViewDidEndDecelerating:(CCScrollView *)scrollView
{
    //_pageControl.page = scrollView.horizontalPage;
}

@end
