//
//  CCLayerWithXIB.m
//  KeyboardDemo
//
//  Created by 张朴军 on 13-9-29.
//  Copyright (c) 2013年 张朴军. All rights reserved.
//

#import "VZLayerWithXIB.h"
#import "cocos2d.h"
@implementation VZLayerWithXIB

+(id)layerWithXibFile:(NSString *)file
{
    return [[self alloc] initWithXibFile:file];
}

-(id)initWithXibFile:(NSString *)file
{
    if(self == [super init])
    {
        NSAssert(file != nil, @"File Name is Null.");
        NSString* name = nil;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            name = [file stringByAppendingString:@"_iPad"];
        }
        else
        {
            name = [file stringByAppendingString:@"_iPhone"];
        }
        
        if([[NSBundle mainBundle] pathForResource:name ofType:@"nib"])
        {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
            [[[CCDirector sharedDirector] view] insertSubview:[views objectAtIndex:0] atIndex:0];
        }
        else
        {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:file owner:self options:nil];
            [[[CCDirector sharedDirector] view] insertSubview:[views objectAtIndex:0] atIndex:0];
        }
        
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

-(void)dealloc
{
    [self.view removeFromSuperview];
    self.view = nil;
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return;
}

@end
