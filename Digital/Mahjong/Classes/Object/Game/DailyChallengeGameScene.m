//
//  GameScene.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-17.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "DailyChallengeGameScene.h"
#import "VZButton.h"
#import "DailyChallengePauseLayer.h"
#import "DailyChallengeCompleteLayer.h"
#import "Mahjong.h"
#import "VZCommonDefine.h"
#import "VZAudioManager.h"
#import "VZScrollNumberForLabel.h"
#import "VZProgress.h"
#import "VZCommodityManager.h"
#import "ShopLayer.h"

#import "VZArchiveManager.h"
#import "VZArchievementManager.h"
@implementation DailyChallengeGameScene

+ (DailyChallengeGameScene *)scene
{
    return [[self alloc] init];
}

-(id)init
{
    int season = arc4random() % MAX_MODES;
    int level = arc4random() % MAX_LEVELS;
    
    if (self = [super initWithSeason:season Level:level])
    {
        CGPoint PosBG       = [self APFP:ccp(240, 160)];
        CGPoint PosReorder  = [self APFP:ccp(462, 147)];
        CGPoint PosSun      = [self APFP:ccp(462, 115)];
        CGPoint PosHint     = [self APFP:ccp(462, 83)];
        CGPoint PosPause    = [self APFP:ccp(462, 51)];

        CGPoint PosLeftL    = [self APFP:ccp(20, 304)];
        CGPoint PosLeft     = [self APFP:ccp(20, 289)];
        
        CGPoint PosComboL    = [self APFP:ccp(20, 270)];
        CGPoint PosCombo     = [self APFP:ccp(20, 248)];
        
        
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
        
        
        _table = [MahjongTable mahjongTableWithSeason:season Level:level];
        _table.position = ccp((self.contentSize.width - _table.contentSize.width * _table.scale) * 0.5,
                              (self.contentSize.height - _table.contentSize.height * _table.scale) * 0.5);
        _table.delegate = self;
        _table.finishCallBackFunc = @selector(onComplete);
        _table.matchCallBackFunc = @selector(onMatch);
        _table.reorderCallBackFunc = @selector(onReorder);
        _table.lightCallBackFunc = @selector(onLight);
        _table.hintCallBackFunc = @selector(onHint);
        _table.noHintCallBackFunc = @selector(onNoHint);
        _table.noMatchCallBackFunc = @selector(onNoMatch);
        _table.didReorderCallBackFunc = @selector(onDidReorder);
        [self addChild:_table];
        
        CCLOG(@"Size%@", NSStringFromCGSize(_table.contentSize));
        
        
        
        _btReorder = [VZButton buttonWithTitle:[NSString stringWithFormat:@"%d",self.reoreders] spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_reorder.png"]];
        _btReorder.position = PosReorder;
        _btReorder.label.fontSize = _btReorder.contentSize.height * 0.3;
        _btReorder.labelPosition = ccp(0.85, 0.95);
        _btReorder.label.fontName = SYSTEM_FONT;
        _btReorder.label.color = [CCColor whiteColor];
        _btReorder.label.outlineWidth = 0.5;
        _btReorder.label.outlineColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        [self addChild:_btReorder];
        [_btReorder setTarget:self selector:@selector(onReorder:)];
        
        _btSun = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_sun.png"]];
        _btSun.position = PosSun;
        _btSun.label.fontSize = _btReorder.contentSize.height * 0.3;
        _btSun.labelPosition = ccp(0.85, 0.95);
        _btSun.label.fontName = SYSTEM_FONT;
        _btSun.label.color = [CCColor whiteColor];
        _btSun.label.outlineWidth = 0.5;
        _btSun.label.outlineColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        [self addChild:_btSun];
        [_btSun setTarget:self selector:@selector(onSun:)];
        
        _btHint = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_search.png"]];
        _btHint.position = PosHint;
        _btHint.label.fontSize = _btReorder.contentSize.height * 0.3;
        _btHint.labelPosition = ccp(0.85, 0.95);
        _btHint.label.fontName = SYSTEM_FONT;
        _btHint.label.color = [CCColor whiteColor];
        _btHint.label.outlineWidth = 0.5;
        _btHint.label.outlineColor = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        [self addChild:_btHint];
        [_btHint setTarget:self selector:@selector(onHint:)];
        
        VZButton* btPause = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_pause.png"]];
        btPause.position = PosPause;
        [self addChild:btPause];
        [btPause setTarget:self selector:@selector(onPause:)];
        
        [self updatePropsCount];
        
        [[VZAudioManager sharedVZAudioManager] playBGM:@"bgm_menu.mp3" loop:YES];
        

        CCLabelTTF* leftLabel = [CCLabelTTF labelWithString:NSLocalizedString(@"Left", nil) fontName:SYSTEM_FONT fontSize:12];
        leftLabel.position = PosLeftL;
        [self addChild:leftLabel];
        
        CCSprite* leftBG = [CCSprite spriteWithImageNamed:@"lb_bg_score_1.png"];
        leftBG.position = PosLeft;
        [self addChild:leftBG];
        
        _leftLabel = [CCLabelTTF labelWithString:@"" fontName:SYSTEM_FONT fontSize:10];
        _leftLabel.position = PosLeft;
        _leftLabel.color = [CCColor colorWithRed:1.0 green:0.84705882352941 blue:0.34509803921569 alpha:1.0];
        [self addChild:_leftLabel];
        
        _comboLabel = [CCLabelTTF labelWithString:NSLocalizedString(@"Combo", nil) fontName:SYSTEM_FONT fontSize:12];
        _comboLabel.position = PosComboL;
        _comboLabel.visible = NO;
        [self addChild:_comboLabel];
        
        _comboCounter = [ComboCounter comboCounter];
        _comboCounter.position = PosCombo;
        _comboCounter.delegate = self;
        _comboCounter.lostComboCallBack = @selector(onLostCombo);
        _comboCounter.getComboCallBack = @selector(onGetCombo);
        _comboCounter.startColor = [CCColor colorWithRed:1.0 green:0.84705882352941 blue:0.34509803921569 alpha:1.0];
        _comboCounter.endColor = [CCColor redColor];
        [self addChild:_comboCounter];
        
        self.score = 0;
        self.left = _table.leftMahjongs;
        
        _totalPairs = _table.leftMahjongs / 2;
        

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePropsCount) name:kCommodityManagerNeedUpdate object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)updatePropsCount
{
    self.hints = [VZCommodityManager sharedVZCommodityManager].hint;
    self.reoreders = [VZCommodityManager sharedVZCommodityManager].shuffle;
    self.lights =[VZCommodityManager sharedVZCommodityManager].sunshine;
}

-(void)setScore:(float)score
{
    [super setScore:score];
}

-(void)setLeft:(int)left
{
    _left = left;
    _leftLabel.string = [NSString stringWithFormat:@"%d",_left];
}

-(int)reoreders
{
    return [VZCommodityManager sharedVZCommodityManager].shuffle;
}

-(void)setReoreders:(int)reoreders
{
    reoreders = [VZCommodityManager sharedVZCommodityManager].shuffle;
    _btReorder.label.string = [NSString stringWithFormat:@"%d",reoreders];
}

-(int)hints
{
    return [VZCommodityManager sharedVZCommodityManager].hint;
}

-(void)setHints:(int)hints
{
    hints = [VZCommodityManager sharedVZCommodityManager].hint;
    _btHint.label.string = [NSString stringWithFormat:@"%d",hints];
}

-(int)lights
{
    return [VZCommodityManager sharedVZCommodityManager].sunshine;
}

-(void)setLights:(int)lights
{
    lights = [VZCommodityManager sharedVZCommodityManager].sunshine;;
    _btSun.label.string = [NSString stringWithFormat:@"%d",lights];
}

- (void)onReorder:(id)sender
{
    if(self.reoreders > 0)
    {
        _comboCounter.paused = YES;
        [_table reorderMahjongOnlyFlyIn:NO];
        _comboCounter.count = _comboCounter.count;
    }
    else
    {
        self.paused = YES;
        ShopLayer* layer = [ShopLayer layer];
        [self addChild:layer];
    }
}

-(void)onDidReorder
{
    _comboCounter.paused = NO;
}

- (void)onSun:(id)sender
{
    if(self.lights > 0)
    {
        [_table enableAll];
        _comboCounter.count = _comboCounter.count;
    }
    else
    {
        self.paused = YES;
        ShopLayer* layer = [ShopLayer layer];
        [self addChild:layer];
    }
}

- (void)onHint:(id)sender
{
    if(self.hints > 0)
    {
        [_table hint];
        _comboCounter.count = _comboCounter.count;
    }
    else
    {
        self.paused = YES;
        ShopLayer* layer = [ShopLayer layer];
        [self addChild:layer];
    }
}

- (void)onPause:(id)sender
{
    self.paused = YES;
    
    DailyChallengePauseLayer* layer = [DailyChallengePauseLayer layerWithSeason:self.season Level:self.level];
    [self addChild:layer];
}

-(void)onComplete
{
    self.stars = 1;
    
    if(self.score >= STAR_THREE(_totalPairs))
    {
        self.stars = 3;
    }
    else if(self.score > STAR_TWO(_totalPairs))
    {
        self.stars = 2;
    }
    else
    {
        self.stars = 1;
    }
    
    CCActionSequence* sequence = [CCActionSequence actions:
                                  [CCActionDelay actionWithDuration:1.0],
                                  [CCActionCallBlock actionWithBlock:^{
                                    _comboCounter.paused = YES;
                                    DailyChallengeCompleteLayer* layer = [DailyChallengeCompleteLayer layerWithSeason:self.season Level:self.level Score:self.score Stars:self.stars];
                                    [self addChild:layer];
                                    }],
                                  nil];
    [self runAction:sequence];
    
    
    CCParticleSystem* confetti = [CCParticleSystem particleWithFile:@"par_confetti.plist"];
    confetti.positionType = CCPositionTypeNormalized;
    confetti.position = ccp(0.5,1.1);
    [self addChild:confetti z:2];
    confetti.autoRemoveOnFinish = YES;
    
    if (_maxCombo > [VZArchiveManager sharedVZArchiveManager].maxCombos)
    {
        [VZArchiveManager sharedVZArchiveManager].maxCombos = _maxCombo;
    }
    
   
}

-(void)onMatch
{
    self.left = _table.leftMahjongs;
    _comboCounter.count = _comboCounter.count + 1;
    
    if(_comboCounter.count - 1 > _maxCombo)
        _maxCombo = _comboCounter.count - 1;
    
    
}

-(void)onReorder
{
    [VZCommodityManager sharedVZCommodityManager].shuffle = [VZCommodityManager sharedVZCommodityManager].shuffle - 1;
}

-(void)onLight
{
    [VZCommodityManager sharedVZCommodityManager].sunshine = [VZCommodityManager sharedVZCommodityManager].sunshine - 1;
}

-(void)onHint
{
    [VZCommodityManager sharedVZCommodityManager].hint = [VZCommodityManager sharedVZCommodityManager].hint - 1;
}

-(void)onGetStar:(id)sender
{
    
}

-(void)noMatch
{
    CCSprite* bg = [CCSprite spriteWithImageNamed:@"lb_bg_best.png"];
    bg.position = ccp(self.contentSize.width * 0.5, self.contentSize.height - bg.contentSize.height);
    [self addChild:bg];
    CCActionRepeat * repeat = [CCActionRepeat actionWithAction:
                               [CCActionSequence actions:
                                [CCActionEaseOut actionWithAction:[CCActionFadeTo actionWithDuration:0.5 opacity:1.0] rate:1.3],
                                [CCActionEaseIn actionWithAction:[CCActionFadeTo actionWithDuration:0.5 opacity:0.1] rate:1.3],
                                nil]
                                                         times:3];
    
    CCActionSequence* sequence = [CCActionSequence actions:
                                  repeat,
                                  [CCActionCallFunc actionWithTarget:bg selector:@selector(removeFromParent)],
                                  nil];
    
    [bg runAction:sequence];
    
    
    CCLabelTTF* noMatch = [CCLabelTTF labelWithString:NSLocalizedString(@"No mahjon can match.Please tap Shuffle Button or Holy Light Button.", nil)  fontName:SYSTEM_FONT fontSize:bg.contentSize.height * 0.4];
    noMatch.position = bg.position;
    [self addChild:noMatch];
    noMatch.opacity = 0.1;
    CCActionRepeat * repeat2 = [CCActionRepeat actionWithAction:
                               [CCActionSequence actions:
                                [CCActionEaseOut actionWithAction:[CCActionFadeTo actionWithDuration:0.5 opacity:1.0] rate:1.3],
                                [CCActionEaseIn actionWithAction:[CCActionFadeTo actionWithDuration:0.5 opacity:0.1] rate:1.3],
                                nil]
                                                         times:3];
    
    CCActionSequence* sequence2 = [CCActionSequence actions:
                                  repeat2,
                                  [CCActionCallFunc actionWithTarget:noMatch selector:@selector(removeFromParent)],
                                  nil];
    [noMatch runAction:sequence2];
    
    
    CCSprite* arrow1 = [CCSprite spriteWithImageNamed:@"lb_arrow.png"];
    arrow1.position = ccp(_btReorder.position.x - arrow1.contentSize.width * 0.76923076923077, _btReorder.position.y + arrow1.contentSize.height * 0.38235294117647);
    
    [self addChild:arrow1];
    
    CCActionRepeat * repeat3 = [CCActionRepeat actionWithAction:
                                [CCActionSequence actions:
                                 [CCActionEaseOut actionWithAction:[CCActionFadeTo actionWithDuration:0.5 opacity:1.0] rate:1.3],
                                 [CCActionEaseIn actionWithAction:[CCActionFadeTo actionWithDuration:0.5 opacity:0.1] rate:1.3],
                                 nil]
                                                          times:3];
    
    CCActionSequence* sequence3 = [CCActionSequence actions:
                                   repeat3,
                                   [CCActionCallFunc actionWithTarget:arrow1 selector:@selector(removeFromParent)],
                                   nil];
    [arrow1 runAction:sequence3];
    
    
    
    
    CCSprite* arrow2 = [CCSprite spriteWithImageNamed:@"lb_arrow.png"];
    arrow2.position = ccp(_btSun.position.x - arrow1.contentSize.width * 0.76923076923077, _btSun.position.y + arrow1.contentSize.height * 0.38235294117647);
    
    [self addChild:arrow2];
    
    CCActionRepeat * repeat4 = [CCActionRepeat actionWithAction:
                                [CCActionSequence actions:
                                 [CCActionEaseOut actionWithAction:[CCActionFadeTo actionWithDuration:0.5 opacity:1.0] rate:1.3],
                                 [CCActionEaseIn actionWithAction:[CCActionFadeTo actionWithDuration:0.5 opacity:0.1] rate:1.3],
                                 nil]
                                                          times:3];
    
    CCActionSequence* sequence4 = [CCActionSequence actions:
                                   repeat4,
                                   [CCActionCallFunc actionWithTarget:arrow2 selector:@selector(removeFromParent)],
                                   nil];
    [arrow2 runAction:sequence4];
    
}

-(void)onNoHint
{
    [self noMatch];
}

-(void)onNoMatch
{
    [self noMatch];
}


-(void)onLostCombo
{
    _comboLabel.visible = NO;
}

-(void)onGetCombo
{
    _comboLabel.visible = YES;
}

@end
