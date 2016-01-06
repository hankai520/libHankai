//
//  HKAudioStreaming.h
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

@import Foundation;

@class HKAudioStreaming, HKAudioStreamingJob;

/**
 * 音频流播放器接口
 */
@protocol HKAudioStreamingDelegate <NSObject>

- (void)audioStreaming:(HKAudioStreaming *)as didStartJob:(HKAudioStreamingJob *)job;

- (void)audioStreaming:(HKAudioStreaming *)as didEndJob:(HKAudioStreamingJob *)job;

- (void)audioStreaming:(HKAudioStreaming *)as didSuspendJob:(HKAudioStreamingJob *)job;

- (void)audioStreaming:(HKAudioStreaming *)as didResumeJob:(HKAudioStreamingJob *)job;

@end


/**
 * 音频流播放任务
 */
@interface HKAudioStreamingJob : NSObject

@property (nonatomic, strong) NSString * source; //音频源 URL，目前仅支持 http 协议

@end


/**
 *  流式音频播放
 */
@interface HKAudioStreaming : NSObject

@property (nonatomic, strong) id<HKAudioStreamingDelegate> delegate;

@end
