//
//  HKAudioUtils.h
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

#import <Foundation/Foundation.h>

typedef void (^HKTimeDidChange)(NSTimeInterval currentTime);//时间变化

typedef void (^HKPowerDidChange)(float left, float right);//音量变化

typedef void (^HKRecordingDidFinish)(NSTimeInterval duration);//录音结束

typedef void (^HKPlayingDidFinish)();//播放结束

typedef void (^HKAudioErrorDidOccur)(NSError * error);//出现错误

/**
 *  音频播放助手类
 */
@interface HKAudioUtils : NSObject

@property (nonatomic, strong) NSString *                    audioFilePath; //要播放的音频或要录制的音频文件路径

@property (nonatomic, assign) NSTimeInterval                maxDuration; //录音最大时长

@property (nonatomic, assign) BOOL                          meteringEnabled; //实时采集音量

@property (nonatomic, strong) HKTimeDidChange               recorderTimeDidChange; //录音时间改变

@property (nonatomic, strong) HKTimeDidChange               playerTimeDidChange; //播放时间改变

@property (nonatomic, strong) HKPowerDidChange              powerDidChange;//音量发生了变化（只在录音时有用）

@property (nonatomic, strong) HKRecordingDidFinish          recordingDidFinish; //录音结束

@property (nonatomic, strong) HKPlayingDidFinish            playingDidFinish; //播放结束

@property (nonatomic, strong) HKAudioErrorDidOccur          errorDidOccur; //发生了错误

@property (nonatomic, readonly) BOOL                        isRecording; //是否正在录音（可观察）

@property (nonatomic, readonly) BOOL                        isPlaying;//是否正在播放（可观察）

/**
 *  获取实例
 *
 */
+ (instancetype)sharedInstance;

/**
 *  开始录音
 */
- (void)startRecording;

/**
 *  停止录音
 */
- (void)stopRecording;

/**
 *  开始播放
 */
- (void)startPlaying;

/**
 *  停止播放
 */
- (void)stopPlaying;

/**
 *  删除录音文件
 */
- (void)deleteRecording;

@end
