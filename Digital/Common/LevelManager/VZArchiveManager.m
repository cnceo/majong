//
//  LevelManager.m
//  unblock
//
//  Created by 张朴军 on 12-12-25.
//  Copyright (c) 2012年 张朴军. All rights reserved.
//

#import "VZArchiveManager.h"
#import "cocos2d.h"
#import "VZUserDefault.h"

@implementation VZArchiveManager

const int unlockStar[MAX_MODES] = {0,20,65,120,155,200,240,300,360,420,480,540,600,660,720,800};

VZ_SYNTHESIZE_SINGLETON_FOR_CLASS(VZArchiveManager)

-(id)init
{
    if(self = [super init])
    {
        self.modes = MAX_MODES;
        
        if(![[VZUserDefault sharedVZUserDefault] objectForKey:@"ArchiveData"])
        {
            NSMutableDictionary* InitialDictionary = [NSMutableDictionary dictionary];

            BOOL needLock = YES;
#ifdef DEBUG_MODE
            needLock = NO;
#endif
            for (int mode = 0; mode < self.modes; mode++)
            {
                VZModeArchive* modAarchive = [VZModeArchive modeArchive];
                
                modAarchive.isLocked = needLock;
                modAarchive.unlockStars = unlockStar[mode];
        
                [modAarchive.levelArchive removeAllObjects];
                
                for (int level = 0; level < MAX_LEVELS; level ++)
                {
                    VZLevelArchive* levelArchive = [VZLevelArchive levelArchive];
                    if(level == 0)
                    {
                        levelArchive.isLocked = NO;
                    }
                    else
                    {
                        levelArchive.isLocked = needLock;
                    }
                    
                    [modAarchive.levelArchive addObject:levelArchive];
                }
                [InitialDictionary setObject:modAarchive forKey:[NSString stringWithFormat:@"ArchiveMode%d",mode]];
            }
            
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
            [InitialDictionary setObject:version forKey:@"ArchiveDataVersion"];
            
            
            NSNumber* lastDailyDate = [NSNumber numberWithDouble:0];
            [InitialDictionary setObject:lastDailyDate forKey:@"ArchiveLastDaily"];
            
            NSNumber* dailyZen = [NSNumber numberWithInt:0];
            [InitialDictionary setObject:dailyZen forKey:@"ArchiveDailyZenCount"];
            
            NSNumber* combo = [NSNumber numberWithInt:0];
            [InitialDictionary setObject:combo forKey:@"ArchiveMaxCombos"];
            
            [[VZUserDefault sharedVZUserDefault] setObject:InitialDictionary forKey:@"ArchiveData"];

        }
        else
        {
            NSMutableDictionary* dictionary = [[VZUserDefault sharedVZUserDefault] objectForKey:@"ArchiveData"];
            
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
            NSString* string = [dictionary objectForKey:@"ArchiveDataVersion"];
            
            if(!(string && [string isEqualToString:version]))
            {
                NSMutableDictionary* InitialDictionary = [NSMutableDictionary dictionary];
                
                BOOL needLock = YES;
#ifdef DEBUG_MODE
                needLock = NO;
#endif
                for (int mode = 0; mode < self.modes; mode++)
                {
                    VZModeArchive* modAarchive = [dictionary objectForKey:[NSString stringWithFormat:@"ArchiveMode%d",mode]];
                    
                    if(modAarchive)
                    {
                        [InitialDictionary setObject:modAarchive forKey:[NSString stringWithFormat:@"ArchiveMode%d",mode]];
                    }
                    else
                    {
                        VZModeArchive* modAarchive = [VZModeArchive modeArchive];
                        
                        modAarchive.isLocked = needLock;
                        modAarchive.unlockStars = unlockStar[mode];
                        
                        [modAarchive.levelArchive removeAllObjects];
                        
                        for (int level = 0; level < MAX_LEVELS; level ++)
                        {
                            VZLevelArchive* levelArchive = [VZLevelArchive levelArchive];
                            if(level == 0)
                            {
                                levelArchive.isLocked = NO;
                            }
                            else
                            {
                                levelArchive.isLocked = needLock;
                            }
                            
                            [modAarchive.levelArchive addObject:levelArchive];
                        }
                        [InitialDictionary setObject:modAarchive forKey:[NSString stringWithFormat:@"ArchiveMode%d",mode]];
                    }
                }
                NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
                [InitialDictionary setObject:version forKey:@"ArchiveDataVersion"];
                
                NSNumber* lastDailyDate = [dictionary objectForKey:@"ArchiveLastDaily"];
                [InitialDictionary setObject:lastDailyDate forKey:@"ArchiveLastDaily"];
                
                NSNumber* dailyZen = [dictionary objectForKey:@"ArchiveDailyZenCount"];
                [InitialDictionary setObject:dailyZen forKey:@"ArchiveDailyZenCount"];
                
                NSNumber* combo = [dictionary objectForKey:@"ArchiveMaxCombos"];
                [InitialDictionary setObject:combo forKey:@"ArchiveMaxCombos"];
                
                [[VZUserDefault sharedVZUserDefault] setObject:InitialDictionary forKey:@"ArchiveData"];
            }
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        [self load];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setHighScore:(float)score Season:(int)season Level:(int)level
{
    if(!(season >= 0 && season < MAX_MODES && level >=0 && level < MAX_LEVELS))
        return;
    
    VZModeArchive*  modeArchive = [self modeArchiveAtIndex:season];
    VZLevelArchive* levelArchive = [modeArchive levelArchiveAtIndex:level];
    levelArchive.highscore = score;
    
    [modeArchive setLevelArchive:levelArchive AtIndex:level];
    [self setModeArchive:modeArchive AtIndex:season];
}

-(float)highScoreWithSeason:(int)season Level:(int)level
{
    if(!(season >= 0 && season < MAX_MODES && level >=0 && level < MAX_LEVELS))
        return 0;
    
    VZModeArchive*  modeArchive = [self modeArchiveAtIndex:season];
    VZLevelArchive* levelArchive = [modeArchive levelArchiveAtIndex:level];
    return levelArchive.highscore;
}

-(void)setStars:(int)stars Season:(int)season Level:(int)level
{
    if(!(season >= 0 && season < MAX_MODES && level >=0 && level < MAX_LEVELS))
        return;
    
    VZModeArchive*  modeArchive = [self modeArchiveAtIndex:season];
    VZLevelArchive* levelArchive = [modeArchive levelArchiveAtIndex:level];
    levelArchive.stars = stars;
    
    [modeArchive setLevelArchive:levelArchive AtIndex:level];
    [self setModeArchive:modeArchive AtIndex:season];
}

-(int)starsWithSeason:(int)season Level:(int)level
{
    if(!(season >= 0 && season < MAX_MODES && level >=0 && level < MAX_LEVELS))
        return 0;
    
    VZModeArchive*  modeArchive = [self modeArchiveAtIndex:season];
    VZLevelArchive* levelArchive = [modeArchive levelArchiveAtIndex:level];
    return levelArchive.stars;
}

-(void)setLocked:(BOOL)islocked Season:(int)season Level:(int)level
{
    if(!(season >= 0 && season < MAX_MODES && level >=0 && level < MAX_LEVELS))
        return;
    
    VZModeArchive*  modeArchive = [self modeArchiveAtIndex:season];
    VZLevelArchive* levelArchive = [modeArchive levelArchiveAtIndex:level];
    levelArchive.isLocked = islocked;
    
    [modeArchive setLevelArchive:levelArchive AtIndex:level];
    [self setModeArchive:modeArchive AtIndex:season];
}

-(BOOL)lockedWithSeason:(int)season Level:(int)level;
{
    if(!(season >= 0 && season < MAX_MODES && level >=0 && level < MAX_LEVELS))
        return NO;
    
    VZModeArchive*  modeArchive = [self modeArchiveAtIndex:season];
    VZLevelArchive* levelArchive = [modeArchive levelArchiveAtIndex:level];
    return levelArchive.isLocked;
}

-(void)setLocked:(BOOL)islocked Season:(int)season
{
    if(!(season >= 0 && season < MAX_MODES))
        return;
    
    VZModeArchive*  modeArchive = [self modeArchiveAtIndex:season];
    modeArchive.isLocked = islocked;
    [self setModeArchive:modeArchive AtIndex:season];
}

-(BOOL)lockedWithSeason:(int)season
{
    if(!(season >= 0 && season < MAX_MODES))
        return YES;
    
    VZModeArchive*  modeArchive = [self modeArchiveAtIndex:season];
    return modeArchive.isLocked;
}

-(BOOL)checkUnlockForSeason:(int)season
{
    if(!(season >= 0 && season < MAX_MODES))
        return NO;
    
    VZModeArchive*  modeArchive = [self modeArchiveAtIndex:season];
    return [modeArchive checkForUnLockWithStars:[self totalStars]];
}

-(int)totalStars
{
    int totalStars = 0;
    for (int i = 0; i < MAX_MODES; i++)
    {
        for (int j = 0; j < MAX_LEVELS; j++)
        {
            totalStars += [self starsWithSeason:i Level:j];
        }
    }
    return totalStars;
}

-(int)AccomplishedLevels
{
    int totalLevels = 0;
    for (int i = 0; i < MAX_MODES; i++)
    {
        for (int j = 0; j < MAX_LEVELS; j++)
        {
            if([self starsWithSeason:i Level:j] > 0)
                totalLevels++;
        }
    }
    return totalLevels;
}

-(void)load
{
    self.dictionary = [[VZUserDefault sharedVZUserDefault] objectForKey:@"ArchiveData"];
}

-(void)save
{
    [[VZUserDefault sharedVZUserDefault] setObject:self.dictionary forKey:@"ArchiveData"];
    [[VZUserDefault sharedVZUserDefault] synchronize];
}

-(VZModeArchive*)modeArchiveAtIndex:(int)index
{
    if(!(index >= 0 && index < MAX_MODES))
        return nil;
    
    return [self.dictionary objectForKey:[NSString stringWithFormat:@"ArchiveMode%d",index]];
}

-(void)setModeArchive:(VZModeArchive*)archive AtIndex:(int)index
{
    if(!(index >= 0 && index < MAX_MODES))
        return;
    
    [self.dictionary setObject:archive forKey:[NSString stringWithFormat:@"ArchiveMode%d",index]];
}

-(int)accomplishedDailyZen
{
    NSNumber* accomplishedDailyZen = [self.dictionary objectForKey:@"ArchiveDailyZenCount"];
    return accomplishedDailyZen.intValue;
}

-(void)setAccomplishedDailyZen:(int)accomplishedDailyZen
{
    NSNumber* number = [NSNumber numberWithInt:accomplishedDailyZen];
    [self.dictionary setObject:number forKey:@"ArchiveDailyZenCount"];
}

-(int)maxCombos
{
    NSNumber* maxCombo = [self.dictionary objectForKey:@"ArchiveMaxCombos"];
    return maxCombo.intValue;
}

-(void)setMaxCombos:(int)maxCombos
{
    NSNumber* number = [NSNumber numberWithInt:maxCombos];
    [self.dictionary setObject:number forKey:@"ArchiveMaxCombos"];
}

-(BOOL)canDaily
{
    NSNumber* lastDailyInterval = [self.dictionary objectForKey:@"ArchiveLastDaily"];
    NSTimeInterval last = lastDailyInterval.floatValue;
    
   
    NSTimeInterval current = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    
    if(current - last > 24*60*60)
    {
        return YES;
    }
    return NO;
}
-(void)recordDaily
{
    NSTimeInterval current = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    NSNumber* lastDailyDate = [NSNumber numberWithDouble:current];
    [self.dictionary setObject:lastDailyDate forKey:@"ArchiveLastDaily"];
    
    self.accomplishedDailyZen = self.accomplishedDailyZen + 1;
}
@end
