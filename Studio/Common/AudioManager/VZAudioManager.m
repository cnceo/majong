//
//  AudioManager.m
//  CommonTest
//
//  Created by 张朴军 on 13-6-3.
//  Copyright (c) 2013年 张朴军. All rights reserved.
//

#import "VZAudioManager.h"
#import "VZUserDefault.h"
#import "OALSimpleAudio.h"
@implementation VZAudioManager

NSString * const kVZAudioManagerDataRootKey = @"kVZAudioManagerDataRootKey";
NSString * const kMusicKey = @"kMusicKey";
NSString * const kSoundKey = @"kSoundKey";

VZ_SYNTHESIZE_SINGLETON_FOR_CLASS(VZAudioManager)

-(id)init
{
    if(self = [super init])
    {
        @try {
            [OALSimpleAudio sharedInstance];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        [self setSound:[self sound]];
        [self setMusic:[self music]];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)objectForKey:(NSString *)defaultName;
{
    NSString* key = [defaultName stringByAppendingString:kVZAudioManagerDataRootKey];
    return [[VZUserDefault sharedVZUserDefault] objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)defaultName
{
    NSString* key = [defaultName stringByAppendingString:kVZAudioManagerDataRootKey];
    [[VZUserDefault sharedVZUserDefault] setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)defaultName
{
    NSString* key = [defaultName stringByAppendingString:kVZAudioManagerDataRootKey];
    [[VZUserDefault sharedVZUserDefault] removeObjectForKey:key];
}

-(BOOL)isSoundEnable
{
    if(self.sound > 0)
    {
        return YES;
    }
    return NO;
}
-(BOOL)isMusicEnable
{
    if(self.music > 0)
    {
        return YES;
    }
    return NO;
}

-(float)sound
{
    NSNumber* sound = [self objectForKey:kSoundKey];
    if(sound)
    {
        return [sound floatValue];
    }
    else
    {
        [self setSound:1.0f];
        return 1.0f;
    }
}

-(void)setSound:(float)sound
{
    NSNumber* soundNumber = [NSNumber numberWithFloat:sound];
    [self setObject:soundNumber forKey:kSoundKey];
    [OALSimpleAudio sharedInstance].effectsVolume = sound;
}

-(float)music
{
    NSNumber* music = [self objectForKey:kMusicKey];
    if(music)
    {
        return [music floatValue];
    }
    else
    {
        [self setMusic:1.0f];
        return 1.0f;
    }
}

-(void)setMusic:(float)music
{
    NSNumber* musicNumber = [NSNumber numberWithFloat:music];
    [self setObject:musicNumber forKey:kMusicKey];
    [OALSimpleAudio sharedInstance].bgVolume = music;
}

-(void)loadResource
{
 
}

- (BOOL) playBGM:(NSString*) filePath loop:(bool) loop
{
    if(filePath &&![_currentBGM isEqualToString:filePath])
    {
        _currentBGM = [filePath copy];
        return [[OALSimpleAudio sharedInstance] playBg:filePath loop:loop];
    }
    return NO;
}

-(void)stopBGM
{
    _currentBGM = nil;
    [[OALSimpleAudio sharedInstance] stopBg];
}

- (id<ALSoundSource>) playEffect:(NSString*) filePath
{
    return [[OALSimpleAudio sharedInstance] playEffect:filePath];
}

- (id<ALSoundSource>) playEffect:(NSString*) filePath Loop:(bool)loop
{
    return [[OALSimpleAudio sharedInstance] playEffect:filePath loop:loop];
}

- (void) stopAllEffects
{
    [[OALSimpleAudio sharedInstance] stopAllEffects];
}

-(void)pause
{
    [[OALSimpleAudio sharedInstance] setPaused:YES];
}

-(void)resume
{
    [[OALSimpleAudio sharedInstance] setPaused:NO];
}

@end
