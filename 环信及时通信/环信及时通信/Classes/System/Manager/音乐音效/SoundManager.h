//
//  SoundManager.h
//  BMProject
//
//  Created by MengHuan on 15/4/19.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SingletonTemplate.h"

@interface SoundManager : NSObject <AVAudioPlayerDelegate>
{
    AVAudioPlayer *musicPlayer;
    AVAudioPlayer *soundPlayer;
    NSString *musicNextLoopName;
}

singleton_for_header(SoundManager)

@property (nonatomic, retain) NSString *musicName;
@property (nonatomic) BOOL musicOff;
/**
 *  recordUrl
 */
@property (nonatomic,strong)NSURL* recordUrl;


@property (nonatomic) BOOL soundOff;
/**
 *  canPlaySound
 */
@property(nonatomic,assign)BOOL canPlaySound;

- (void)hackDelay;

- (void)musicPlay;
- (void)musicPlayByName:(NSString *)name;
- (void)musicStop;
- (void)musicPlayFirst:(NSString *)firstName thenLoop:(NSString *)loopName;

- (void)soundPlay:(NSString *)name;
- (void)soundLoopsPlay:(NSString *)name;
- (void)soundStop;

/// 开始录音
- (void)startRecord;
/// 停止录音
-(void)finishRecord;

@end
