//
//  IntroScene.m
//  Mahjong
//
//  Created by 穆暮 on 14-9-7.
//  Copyright 穆暮 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "TitleScene.h"
// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // done
	return self;
}

-(void)onEnter
{
    [super onEnter];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]];
}

// -----------------------------------------------------------------------
@end
