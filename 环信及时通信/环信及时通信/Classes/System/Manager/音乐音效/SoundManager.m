//
//  SoundManager.m
//  BMProject
//
//  Created by MengHuan on 15/4/19.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "SoundManager.h"
@interface SoundManager ()<AVAudioPlayerDelegate,AVAudioRecorderDelegate>

{
    NSString* mp3FilePath;
    NSURL* audioFileSavePath;
    AVAudioSession * audioSession;
}
@property (nonatomic,assign) BOOL recording;
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) AVAudioPlayer *player;
@property(nonatomic,copy)   NSString *tempPath;

@end
@implementation SoundManager

@synthesize musicName;
@synthesize musicOff;
@synthesize soundOff;

singleton_for_class(SoundManager)

- (void)setMusicName:(NSString *)m
{
    if (musicName != m) {
        musicName = m;
    }
    
    if (musicName) {
        // 音乐开启或换了一个音乐
        [self musicPlay];
        
    } else {
        // m为nil，将音乐关闭
        [self musicStop];
    }
}

- (void)setMusicOff:(BOOL)m
{
    musicOff = m;
    
    if (musicOff) {
        // 音乐关闭
        [self musicStop];
        
    } else {
        // 音乐开启
        [self musicPlay];
    }
}

- (void)hackDelay
{
    // 防止AVAudioPlayer第一次播放声音时卡住主线程
    if (soundPlayer) {
        [self soundStop];
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bgmusic" ofType:@"mp3"]];
    
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    [soundPlayer prepareToPlay];
}

- (void)musicPlay
{
    if (musicPlayer) {
        [self musicStop];
    }
    
    if (!self.canPlaySound)
    {
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:musicName ofType:@"car"]];
    
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    // 背景音乐无限循环，音量稍小一些
    musicPlayer.numberOfLoops = -1;
    musicPlayer.volume = 0.8;
    
    [musicPlayer play];
}

- (void)musicPlayByName:(NSString *)name
{
    if (musicPlayer) {
        [self musicStop];
    }
    
    if (self.canPlaySound == NO) {
        // 背景音乐被禁，什么都不干
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
    
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    // 背景音乐无限循环，音量稍小一些
    musicPlayer.numberOfLoops = 0;
    musicPlayer.volume = 0.8;
    
    [musicPlayer play];
}

- (void)musicStop
{
    if (!musicPlayer) {
        return;
    }
    
    if ([musicPlayer isPlaying]) {
        [musicPlayer stop];
    }
    
    musicPlayer = nil;
}

- (void)musicPlayFirst:(NSString *)firstName thenLoop:(NSString *)loopName
{
    if (musicPlayer) {
        [self musicStop];
    }
    
    if (musicOff) {
        // 背景音乐被禁，什么都不干
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:firstName ofType:@"mp3"]];
    
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    // 播放第一段背景音乐，不无限循环，设置delegate，音量稍小一些
    musicPlayer.delegate    = self;
    musicPlayer.volume      = 0.8;
    
    if (musicNextLoopName != loopName) {
        musicNextLoopName = loopName;
    }
    
    [musicPlayer play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    // 第一段背景音乐播放完成，现在播放第二段，重复
    if (musicOff
        || !flag
        || !musicNextLoopName
        ) {
        return;
    }
    
    if (musicPlayer) {
        [self musicStop];
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:musicNextLoopName ofType:@"mp3"]];
    
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    //播放第二段重复的背景音乐，无限循环，音量稍小一些
    musicPlayer.numberOfLoops   = -1;
    musicPlayer.volume          = 0.8;
    
    musicNextLoopName = nil;
    
    [musicPlayer play];
}


- (void)soundPlay:(NSString *)name
{
    if (soundPlayer) {
        [self soundStop];
    }
    
    if (soundOff) {
        // 音效被禁，什么都不干
        return;
    }
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
    NSURL *url      = path ? [NSURL fileURLWithPath:path] : nil;
    
    if (!url) {
        NSLog(@"！！！有声音文件名写错了：%@", name);
        
        return;
    }
    
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    [soundPlayer play];
}

- (void)soundLoopsPlay:(NSString *)name
{
    if (soundPlayer) {
        [self soundStop];
    }
    
    if (soundOff) {
        // 音效被禁，什么都不干
        return;
    }
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
    NSURL *url      = path ? [NSURL fileURLWithPath:path] : nil;
    
    if (!url) {
        NSLog(@"！！！有声音文件名写错了：%@", name);
        
        return;
    }
    
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    // 背景音乐无限循环，音量稍小一些
    musicPlayer.numberOfLoops = -1;
    musicPlayer.volume = 0.8;
    
    [soundPlayer play];
}

- (void)soundStop
{
    if (!soundPlayer) {
        return;
    }
    
    if ([soundPlayer isPlaying]) {
        [soundPlayer stop];
    }
    
    soundPlayer = nil;
}

- (void)setCanPlaySound:(BOOL)canPlaySound
{
    _canPlaySound   = canPlaySound;
}
/// 开始录音
- (void)startRecord
{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）, 采样率必须要设为11025才能使转化成mp3格式后不会失真
    [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    //录音通道数  1 或 2 ，要转换成mp3格式必须为双通道
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    //存储录音文件
    
    //判断原来的录音文件 删除
    NSFileManager * manager=[NSFileManager defaultManager];
      NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/selfRecord.caf"];
    if([manager fileExistsAtPath:filePath])
    {
        [manager removeItemAtPath:filePath error:nil];
    }else{
        NSError *error = nil;
      [manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        if (error)
        {
            NSLog(@"-----创建路径失败---%@",error);
        }
    }
  
    self.tempPath = filePath;
    _recordUrl = [NSURL URLWithString:self.tempPath];
    //初始化
    self.recorder = [[AVAudioRecorder alloc] initWithURL:_recordUrl settings:recordSetting error:nil];
    //开启音量检测
    self.recorder.meteringEnabled = YES;
    audioSession = [AVAudioSession sharedInstance];//得到AVAudioSession单例对象
    if (![self.recorder isRecording])
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//设置类别,表示该应用同时支持播放和录音
        [audioSession setActive:YES error:nil];//启动音频会话管理,此时会阻断后台音乐的播放.
        [self.recorder prepareToRecord];
        [self.recorder peakPowerForChannel:0.0];
        [self.recorder record];
    }
}
/// 停止录音
-(void)finishRecord
{
    [self.recorder stop];
    self.recorder = nil;
    //录音停止
    [audioSession setActive:NO error:nil]; //一定要在录音停止以后再关闭音频会话管理
    if ([soundPlayer isPlaying]) {
        [soundPlayer stop];
        soundPlayer = nil;
    }
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordUrl error:nil];
    [soundPlayer prepareToPlay];
    soundPlayer.volume  = 1;
    [soundPlayer play];
  
}
@end
