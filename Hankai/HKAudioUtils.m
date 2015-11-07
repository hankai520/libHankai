//
//  HKAudioUtils.m
//  Hankai
//
//  Created by 韩凯 on 3/24/14.
//  Copyright (c) 2014 Hankai. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "HKAudioUtils.h"
#import <AVFoundation/AVFoundation.h>

@interface HKAudioUtils () <AVAudioPlayerDelegate> {
    AVAudioRecorder *       _recorder;
    AVAudioPlayer *         _player;
    NSTimer *               _durationTimer; //用于在录音的时候更新录音时长
    NSTimer *               _meteringTimer; //用于检测音量
}

@end

@implementation HKAudioUtils

- (void)initRecorder {
    NSError * error = nil;
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (error != nil) {
        [self riseError:error];
    } else {
        NSURL * url = [NSURL fileURLWithPath:self.audioFilePath];
        
        NSDictionary * settings = @{
                                    AVFormatIDKey:              [NSNumber numberWithInt:kAudioFormatLinearPCM],
                                    AVSampleRateKey:            [NSNumber numberWithFloat:8000.0],
                                    AVNumberOfChannelsKey:      [NSNumber numberWithInt:1],
                                    AVLinearPCMBitDepthKey:     [NSNumber numberWithInt:8],
                                    AVLinearPCMIsBigEndianKey:  [NSNumber numberWithBool:NO],
                                    AVLinearPCMIsFloatKey:      [NSNumber numberWithBool:NO]
                                    };
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
        
        if (error != nil) {
            [self riseError:error];
        } else {
            _recorder.meteringEnabled = YES;
        }
    }
}

- (void)doTimeUpdate:(NSTimer *)timer {
    BOOL isPlay = [timer.userInfo[@"IsPlay"] boolValue];
    if (!isPlay) {
        self.recorderTimeDidChange(_recorder.currentTime);
        if (_recorder.currentTime > self.maxDuration) {
            [self stopRecording];
        }
    } else {
        self.playerTimeDidChange(_player.currentTime);
    }
}

//isPlay 表示播放或录音（播放时间和录音时间来源不一样）
- (void)startUpdatingTime:(BOOL)isPlay {
    HKTimeDidChange timeDidChange = nil;
    
    if (isPlay) {
        timeDidChange = self.recorderTimeDidChange;
    } else {
        timeDidChange = self.playerTimeDidChange;
    }
    
    if (timeDidChange != nil) {
        _durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f
                                                          target:self
                                                        selector:@selector(doTimeUpdate:)
                                                        userInfo:@{@"IsPlay": [NSNumber numberWithBool:isPlay]}
                                                         repeats:YES];
        [_durationTimer fire];
    }
}

- (void)doMetering:(NSTimer *)timer {
    [_recorder updateMeters];
    self.powerDidChange([_recorder averagePowerForChannel:0], [_recorder averagePowerForChannel:1]);
}

- (void)startMetering {
    if (self.meteringEnabled && self.powerDidChange != nil) {
        _meteringTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                          target:self
                                                        selector:@selector(doMetering:)
                                                        userInfo:nil
                                                         repeats:YES];
        [_meteringTimer fire];
    }
}

- (void)stopMetering {
    [_meteringTimer invalidate];
    _meteringTimer = nil;
    
    //隐藏音量指示
    
}

- (BOOL)isRecording {
    return _recorder.isRecording;
}

- (BOOL)isPlaying {
    return _player.isPlaying;
}

- (void)setAudioFilePath:(NSString *)value {
    _audioFilePath = value;
    
    if (_audioFilePath != nil) {
        [self initRecorder];
    }
}

- (void)riseError:(NSError *)error {
    if (self.errorDidOccur != nil) {
        self.errorDidOccur(error);
    }
}

#pragma mark - Public

+ (id)sharedInstance {
    static HKAudioUtils * utils = nil;
    
    if (utils == nil) {
        utils = [[HKAudioUtils alloc] init];
    }
    
    return utils;
}

- (void)startRecording {
    NSError * error = nil;
    if ([[AVAudioSession sharedInstance] setActive:YES error:&error]) {
        [_recorder stop];
        if ([_recorder prepareToRecord]) {
            [self willChangeValueForKey:@"isRecording"];
            if ([_recorder record]) {
                [self didChangeValueForKey:@"isRecording"];
                [self startMetering];
                [self startUpdatingTime:NO];
            }
        }
    } else {
        [self riseError:error];
    }
}

- (void)stopRecording {
    if (_recorder.isRecording) {
        [self willChangeValueForKey:@"isRecording"];
        [_recorder pause];
        [self didChangeValueForKey:@"isRecording"];
        [_durationTimer invalidate];
        [self stopMetering];
        
        if (self.recordingDidFinish != nil) {
            self.recordingDidFinish(_recorder.currentTime);
        }
        
        [_recorder stop];
    }
}

- (void)startPlaying {
    NSError * error = nil;
    NSData * data = [NSData dataWithContentsOfFile:self.audioFilePath];
    _player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    _player.volume = 1.0f;
    _player.delegate = self;
    if ([_player prepareToPlay]) {
        [self willChangeValueForKey:@"isPlaying"];
        if ([_player play]) {
            [self didChangeValueForKey:@"isPlaying"];
            [self startUpdatingTime:YES];
        }
    }
}

- (void)stopPlaying {
    if (_player.isPlaying) {
        [self willChangeValueForKey:@"isPlaying"];
        [_player stop];
        [_durationTimer invalidate];
        [self didChangeValueForKey:@"isPlaying"];
        
        if (self.playingDidFinish != nil) {
            self.playingDidFinish();
        }
    }
}

- (void)deleteRecording {
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.audioFilePath isDirectory:&isDir] && !isDir) {
        NSError * error = nil;
        if (![[NSFileManager defaultManager] removeItemAtPath:self.audioFilePath error:&error]) {
            [self riseError:error];
        }
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self willChangeValueForKey:@"isPlaying"];
    [_durationTimer invalidate];
    [self didChangeValueForKey:@"isPlaying"];
    if (self.playingDidFinish != nil) {
        self.playingDidFinish();
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [self willChangeValueForKey:@"isPlaying"];
    [_durationTimer invalidate];
    [self didChangeValueForKey:@"isPlaying"];
    [self riseError:error];
    if (self.playingDidFinish != nil) {
        self.playingDidFinish();
    }
}

@end
