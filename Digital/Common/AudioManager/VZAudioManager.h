//
//  AudioManager.h
//  CommonTest
//
//  Created by 张朴军 on 13-6-3.
//  Copyright (c) 2013年 张朴军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZCommonDefine.h"
#import "OALSimpleAudio.h"



@interface VZAudioManager : NSObject
{
    NSString* _currentBGM;

}

VZ_DECLARE_SINGLETON_FOR_CLASS(VZAudioManager)

@property (nonatomic, assign)float sound;
@property (nonatomic, assign)float music;

-(BOOL)isSoundEnable;
-(BOOL)isMusicEnable;


- (BOOL) playBGM:(NSString*) filePath loop:(bool) loop;
- (void) stopBGM;

- (id<ALSoundSource>) playEffect:(NSString*) filePath;
- (id<ALSoundSource>) playEffect:(NSString*) filePath Loop:(bool)loop;
- (void) stopAllEffects;

-(void)pause;
-(void)resume;

@end
