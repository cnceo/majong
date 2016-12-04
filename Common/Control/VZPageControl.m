//
//  VZPageControl.m
//  Mahjong
//
//  Created by 穆暮 on 14-7-1.
//  Copyright (c) 2014年 穆暮. All rights reserved.
//

#import "VZPageControl.h"

@implementation VZPageControl

+(VZPageControl *)pageControlWithMaxPage:(int)maxPage
{
    return [[self alloc] initWithMaxPage:maxPage];
}

-(id)initWithMaxPage:(int)maxPage
{
    if(self = [super init])
    {
        _maxPage = maxPage;
        
        CGSize size = CGSizeMake(5, 0);
        
        
        
        
        CGPoint start = ccp(self.contentSize.width * 0.5 - size.width * maxPage * 0.5, self.contentSize.height * 0.5);
        
        for (int i = 0; i < maxPage; i++)
        {
            CCDrawNode *draw = [CCDrawNode node];
            draw.position = ccp(start.x + size.width * i, start.y + size.height * i);
            [self addChild:draw];
        }
        
        self.page = 0;
    }
    return self;
}

-(void)setPage:(int)page
{
    _page = clampf(page, 0, _maxPage);
    
    float radius = 3;
        
    
    for (int i = 0; i < _maxPage; i++)
    {
        CCDrawNode* node = [self.children objectAtIndex:i];
        [node clear];
        
        if(i == _page)
        {
            [node drawDot:node.position radius:radius color:[CCColor colorWithWhite:1.0 alpha:1.0]];
        }
        else
        {
            [node drawDot:node.position radius:radius color:[CCColor colorWithWhite:1.0 alpha:0.5]];
        }
    }
}

@end
