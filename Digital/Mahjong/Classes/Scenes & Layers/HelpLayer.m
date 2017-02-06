//
//  HelpLayer.m
//  Mahjong
//
//  Created by 穆暮 on 14-6-12.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "HelpLayer.h"
#import "VZSoundSwitch.h"
#import "VZButton.h"
#import "VZCommonDefine.h"

@implementation HelpLayer

+(HelpLayer*)layer
{
    return [[self alloc] init];
}

-(id)init
{
    CCColor* color = [CCColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    if(self = [super initWithColor:color])
    {
        
        CGPoint PosManualIcon       = [self APFP:ccp(-170,  122)];
        CGPoint PosManualTitle      = [self APFP:ccp(-111,  148)];
        float   FontSizeManualTitle = [self AFFF:20];
        CGPoint PosManualDetail     = [self APFP:ccp(-111,   102)];
        CGSize  SizeManualDetail    = [self ASFS:CGSizeMake(320, 74)];
        float   FontSizeManualDetail= [self AFFF:14];
        
        CGPoint PosFlowerIcon       = [self APFP:ccp(-170,  47)];
        CGPoint PosFlowerTitle      = [self APFP:ccp(-111,  62)];
        float   FontSizeFlowerTitle = [self AFFF:18];
        CGPoint PosFlowerDetail     = [self APFP:ccp(-111,   38)];
        CGSize  SizeFlowerDetail    = [self ASFS:CGSizeMake(320, 30)];
        float   FontSizeFlowerDetail= [self AFFF:14];
        
        CGPoint PosSeasonIcon       = [self APFP:ccp(-170,  -13)];
        CGPoint PosSeasonTitle      = [self APFP:ccp(-111,  2)];
        float   FontSizeSeasonTitle = [self AFFF:18];
        CGPoint PosSeasonDetail     = [self APFP:ccp(-111,   -22)];
        CGSize  SizeSeasonDetail    = [self ASFS:CGSizeMake(320, 30)];
        float   FontSizeSeasonDetail= [self AFFF:14];
        
        CGPoint PosLightIcon        = [self APFP:ccp(-220,  -68)];
        CGPoint PosLightTitle       = [self APFP:ccp(-197,  -56)];
        float   FontSizeLightTitle  = [self AFFF:18];
        CGPoint PosLightDetail      = [self APFP:ccp(-197,  -105)];
        CGSize  SizeLightDetail     = [self ASFS:CGSizeMake(120, 80)];
        float   FontSizeLightDetail = [self AFFF:14];
        
        CGPoint PosHintIcon         = [self APFP:ccp(-60,  -68)];
        CGPoint PosHintTitle        = [self APFP:ccp(-37,  -56)];
        float   FontSizeHintTitle   = [self AFFF:18];
        CGPoint PosHintDetail       = [self APFP:ccp(-37,   -105)];
        CGSize  SizeHintDetail      = [self ASFS:CGSizeMake(120, 80)];
        float   FontSizeHintDetail  = [self AFFF:14];
        
        CGPoint PosShuffleIcon      = [self APFP:ccp(100, -68)];
        CGPoint PosShuffleTitle     = [self APFP:ccp(123, -56)];
        float   FontSizeShuffleTitle= [self AFFF:18];
        CGPoint PosShuffleDetail    = [self APFP:ccp(123, -105)];
        CGSize  SizeShuffleDetail   = [self ASFS:CGSizeMake(120, 80)];
        float   FontSizeShuffleDetail=[self AFFF:14];
        
        CGPoint PosTerminate        = ccp(225, 145);
        
        VZButton* btTerminate = [VZButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bt_terminate.png"]];
        btTerminate.position = PosTerminate;
        [btTerminate setTarget:self selector:@selector(onTerminate:)];
        [self.window addChild:btTerminate];
        
    
        
        CCSprite* manualIcon = [CCSprite spriteWithImageNamed:@"lb_manual.png"];
        manualIcon.position = PosManualIcon;
        [self.window addChild:manualIcon];
       
        CCLabelTTF* manualTitle = [CCLabelTTF labelWithString:NSLocalizedString(@"[Manual]", nil)
                                                     fontName:SYSTEM_FONT
                                                     fontSize:FontSizeManualTitle];
        manualTitle.position = PosManualTitle;
        manualTitle.anchorPoint = ccp(0, 0.5);
        manualTitle.color = [CCColor colorWithRed:0 green:0.9296875 blue:0.98828125 alpha:1.0];
        [self.window addChild:manualTitle];
        

        CCLabelTTF* manualDetail = [CCLabelTTF labelWithString:NSLocalizedString(@"Match tile pairs until all of the titles are gone. Tap pairs of identical tiles to remove them. If a tile is beneath another tile. Or it has a tile on each side. That tile is locked, And cannot be remove yet.", nil)
                                                      fontName:SYSTEM_FONT
                                                      fontSize:FontSizeManualDetail
                                                    dimensions:SizeManualDetail];
        manualDetail.position = PosManualDetail;
        manualDetail.anchorPoint = ccp(0, 0.5);
        [self.window addChild:manualDetail];
        
        
        
        CCSprite* flowerIcon = [CCSprite spriteWithImageNamed:@"lb_help_0.png"];
        flowerIcon.position = PosFlowerIcon;
        [self.window addChild:flowerIcon];
        
        CCLabelTTF* flowerTitle = [CCLabelTTF labelWithString:NSLocalizedString(@"[Flower]", nil)
                                                     fontName:SYSTEM_FONT
                                                     fontSize:FontSizeFlowerTitle];
        flowerTitle.position = PosFlowerTitle;
        flowerTitle.anchorPoint = ccp(0, 0.5);
        flowerTitle.color = [CCColor colorWithRed:0 green:0.9296875 blue:0.98828125 alpha:1.0];
        [self.window addChild:flowerTitle];
        
        CCLabelTTF* flowerDetail = [CCLabelTTF labelWithString:NSLocalizedString(@"Flower tiles can match any flower tile.", nil)
                                                      fontName:SYSTEM_FONT
                                                      fontSize:FontSizeFlowerDetail
                                                    dimensions:SizeFlowerDetail];
        flowerDetail.position = PosFlowerDetail;
        flowerDetail.anchorPoint = ccp(0, 0.5);
        [self.window addChild:flowerDetail];
        
        
        
        CCSprite* seasonIcon = [CCSprite spriteWithImageNamed:@"lb_help_1.png"];
        seasonIcon.position = PosSeasonIcon;
        [self.window addChild:seasonIcon];
        
        CCLabelTTF* seasonTitle = [CCLabelTTF labelWithString:NSLocalizedString(@"[Season]", nil)
                                                     fontName:SYSTEM_FONT
                                                     fontSize:FontSizeSeasonTitle];
        seasonTitle.position = PosSeasonTitle;
        seasonTitle.anchorPoint = ccp(0, 0.5);
        seasonTitle.color = [CCColor colorWithRed:0 green:0.9296875 blue:0.98828125 alpha:1.0];
        [self.window addChild:seasonTitle];
        
        CCLabelTTF* seasonDetail = [CCLabelTTF labelWithString:NSLocalizedString(@"Season tiles can match any season tile.", nil)
                                                      fontName:SYSTEM_FONT
                                                      fontSize:FontSizeSeasonDetail
                                                    dimensions:SizeSeasonDetail];
        seasonDetail.position = PosSeasonDetail;
        seasonDetail.anchorPoint = ccp(0, 0.5);
        [self.window addChild:seasonDetail];
        
        
        
        CCSprite* lightIcon = [CCSprite spriteWithImageNamed:@"bt_sun.png"];
        lightIcon.position = PosLightIcon;
        [self.window addChild:lightIcon];

        CCLabelTTF* lightTitle = [CCLabelTTF labelWithString:NSLocalizedString(@"[Holy Light]", nil)
                                                    fontName:SYSTEM_FONT
                                                    fontSize:FontSizeLightTitle];
        lightTitle.position = PosLightTitle;
        lightTitle.anchorPoint = ccp(0, 0.5);
        lightTitle.color = [CCColor colorWithRed:0 green:0.9296875 blue:0.98828125 alpha:1.0];
        [self.window addChild:lightTitle];

        CCLabelTTF* lightDetail = [CCLabelTTF labelWithString:NSLocalizedString(@"Make all tiles selectable until a matching pairs is cleared.", nil)
                                                     fontName:SYSTEM_FONT
                                                     fontSize:FontSizeLightDetail
                                                   dimensions:SizeLightDetail];
        lightDetail.position = PosLightDetail;
        lightDetail.anchorPoint = ccp(0, 0.5);
        [self.window addChild:lightDetail];

        
        
        CCSprite* hintIcon = [CCSprite spriteWithImageNamed:@"bt_search.png"];
        hintIcon.position = PosHintIcon;
        [self.window addChild:hintIcon];

        CCLabelTTF* hintTitle = [CCLabelTTF labelWithString:NSLocalizedString(@"[Hint]", nil)
                                                   fontName:SYSTEM_FONT
                                                   fontSize:FontSizeHintTitle];
        hintTitle.position = PosHintTitle;
        hintTitle.anchorPoint = ccp(0, 0.5);
        hintTitle.color = [CCColor colorWithRed:0 green:0.9296875 blue:0.98828125 alpha:1.0];
        [self.window addChild:hintTitle];

        CCLabelTTF* hintDetail = [CCLabelTTF labelWithString:NSLocalizedString(@"Show you a pair of matchable tiles.", nil)
                                                    fontName:SYSTEM_FONT
                                                    fontSize:FontSizeHintDetail
                                                  dimensions:SizeHintDetail];
        hintDetail.position = PosHintDetail;
        hintDetail.anchorPoint = ccp(0, 0.5);
        [self.window addChild:hintDetail];
        
        
        CCSprite* shuffleIcon = [CCSprite spriteWithImageNamed:@"bt_reorder.png"];
        shuffleIcon.position = PosShuffleIcon;
        [self.window addChild:shuffleIcon];

        CCLabelTTF* shuffleTitle = [CCLabelTTF labelWithString:NSLocalizedString(@"[Shuffle]", nil)
                                                      fontName:SYSTEM_FONT
                                                      fontSize:FontSizeShuffleTitle];
        shuffleTitle.position = PosShuffleTitle;
        shuffleTitle.anchorPoint = ccp(0, 0.5);
        shuffleTitle.color = [CCColor colorWithRed:0 green:0.9296875 blue:0.98828125 alpha:1.0];
        [self.window addChild:shuffleTitle];

        CCLabelTTF* shuffleDetail = [CCLabelTTF labelWithString:NSLocalizedString(@"Refresh the rest of all tiles.", nil)
                                                       fontName:SYSTEM_FONT
                                                       fontSize:FontSizeShuffleDetail
                                                     dimensions:SizeShuffleDetail];
        shuffleDetail.position = PosShuffleDetail;
        shuffleDetail.anchorPoint = ccp(0, 0.5);
        [self.window addChild:shuffleDetail];

    }
    return self;
}


- (void)onTerminate:(id)sender
{
    [self removeFromParent];
}

@end
