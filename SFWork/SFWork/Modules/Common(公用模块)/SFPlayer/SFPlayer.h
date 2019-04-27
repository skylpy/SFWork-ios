//
//  SFPlayer.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MediaLoadState)
{
    MediaLoadStateUnknow,
    MediaLoadStatePlaythroughOK,
    MediaLoadStateStalled
};

typedef NS_ENUM(NSUInteger, MediaPlaybackState)
{
    MediaPlaybackStateStopped,//未开始
    MediaPlaybackStateReadyToPlay,
    MediaPlaybackStatePlaying,
    MediaPlaybackStatePaused,
    MediaPlaybackStateInterrupted,
    MediaPlaybackStateSeeking
};

@interface SFPlayer : NSObject

- (void)play;

- (void)pause;

- (void)shutdown;

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void(^)(BOOL finish))handeler;

- (void)initPlayerWith:(NSURL *)url;

//是否自动播放
@property (nonatomic,assign) BOOL shouldAutoplay;
//是否循环播放
@property (nonatomic,assign) BOOL shouldPlayLoop;

//当shouldAutoplay为YES有效
@property(nonatomic, assign) NSTimeInterval seekTime;

@property(nonatomic, readonly)  UIView *view;

@property(nonatomic, readonly)  NSTimeInterval currentTime;

@property(nonatomic, readonly)  NSTimeInterval duration;

@property(nonatomic, readonly)  NSTimeInterval playableDuration;

//加载状态
@property(nonatomic, readonly)  MediaLoadState loadState;

//播放状态
@property(nonatomic, readonly)  MediaPlaybackState playbackState;

@end

extern NSString *const MediaPlaybackStatusFailedNotification;
extern NSString *const MediaPlayerLoadStateDidChangeNotification;
extern NSString *const MediaPlayerPlaybackDidFinishNotification;
extern NSString *const MediaPlayerPlaybackStatusDidChangeNotification;


NS_ASSUME_NONNULL_END
