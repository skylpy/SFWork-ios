//
//  SFVideoViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVideoViewController.h"
#import "SFPlayer.h"

@interface SFVideoViewController ()
@property (nonatomic,strong) UIImageView *coverView;
@property (nonatomic,strong) SFPlayer *player;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *playOrPauseButton;
@property (nonatomic, strong) NSURL *URLString;
@property (nonatomic, strong) UISlider *sliderBar;
@property (strong, nonatomic) UILabel *timeLabel;
@end

@implementation SFVideoViewController

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [UILabel createALabelText:@"--:--" withFont:[UIFont fontWithName:kRegFont size:12] withColor:[UIColor whiteColor]];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UISlider *)sliderBar{
    
    if (!_sliderBar) {
        // 创建一个UISlider
        _sliderBar = [[UISlider alloc] init];

        [_sliderBar setThumbImage:[UIImage imageNamed:@"video_white-circle"] forState:UIControlStateNormal];
        // 定义UISlider的样式
        _sliderBar.minimumTrackTintColor = [UIColor whiteColor];
        _sliderBar.maximumTrackTintColor = [UIColor grayColor];

    }
    return _sliderBar;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.player shutdown];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //隐藏=YES,显示=NO; Animation:动画效果
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
}

//退出时显示
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //隐藏=YES,显示=NO; Animation:动画效果
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self buildSubviews];
    [self registNotis];
    [self refreshMediaControl];
}

- (void)buildSubviews {
    
    [self.view addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
        make.width.offset(80);
    }];
    
    [self.view addSubview:self.sliderBar];
    [self.sliderBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.timeLabel.mas_left).offset(-10);
        make.height.offset(10);
        make.centerY.equalTo(self.timeLabel);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back"] forState:UIControlStateNormal];
    
    @weakify(self)
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(20);
    }];
    
    UILabel *titleLabel = [UILabel new];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_lessThanOrEqualTo(kScreenWidth-150);
        make.centerY.equalTo(backButton);
    }];
    
    UIImageView *coverView = [UIImageView new];
    self.coverView = coverView;
    coverView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view insertSubview:coverView atIndex:0];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.indicatorView sizeToFit];
    self.indicatorView.hidesWhenStopped = YES;
    self.indicatorView.hidden = YES;
    
    //设置显示位置
    [self.view addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    
    UIButton *playOrPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playOrPauseButton = playOrPauseButton;
    [playOrPauseButton setImage:[UIImage imageNamed:@"recommend-play"] forState:UIControlStateNormal];
    [playOrPauseButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    
    [self.view addSubview:playOrPauseButton];
    [playOrPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [[playOrPauseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self initPlayerWithURL:self.URLString];
    }];
    
}

- (void)initPlayerWithURL:(NSURL *)url {
    
    _URLString = url;
    if (self.player) {
        [self.player.view removeFromSuperview];
        [self.player shutdown];
    }
    
    SFPlayer *player = [SFPlayer new];
    self.player = player;
    player.view.frame = self.view.bounds;
    player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    player.shouldAutoplay = YES;
    [player initPlayerWith:url];
    [self.view insertSubview:player.view aboveSubview:self.coverView];
}


- (void)registNotis {
    
    @weakify(self)
    //播放结束通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:MediaPlayerPlaybackDidFinishNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:MediaPlayerPlaybackStatusDidChangeNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        
        
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:MediaPlayerLoadStateDidChangeNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIDeviceOrientationDidChangeNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
        switch (interfaceOrientation) {
            case UIInterfaceOrientationPortraitUpsideDown:{
                NSLog(@"电池栏在下");
            }
                break;
            case UIInterfaceOrientationPortrait:{
                NSLog(@"电池栏在上");
                [self setNeedsStatusBarAppearanceUpdate];
                [self toOrientationsPortrait:interfaceOrientation];
            }
                break;
            case UIInterfaceOrientationLandscapeLeft:{
                NSLog(@"电池栏在左");
                [self setNeedsStatusBarAppearanceUpdate];
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
                break;
            case UIInterfaceOrientationLandscapeRight:{
                NSLog(@"电池栏在右");
                [self setNeedsStatusBarAppearanceUpdate];
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
                break;
            default:
                break;
        }
    }];
}

//横屏播放
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    }else{
        
        self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
    }
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.player.view.frame =  CGRectMake(0,0, kScreenHeight,kScreenWidth);
    
    
}

//竖屏播放
- (void)toOrientationsPortrait:(UIInterfaceOrientation)orientation {
    
    self.player.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformIdentity;
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.player.view.frame =  CGRectMake(0,0, kScreenWidth,kScreenHeight);
    
}

- (void)refreshMediaControl {
    //     duration
    NSTimeInterval intDuration = self.player.duration + 0.5;
    
    // position
    NSTimeInterval intPosition = self.player.currentTime + 0.5;
    
    if (intDuration > 0) {
        self.sliderBar.maximumValue = intDuration;
        NSInteger delta = intDuration-intPosition;
        self.timeLabel.text = [NSString stringWithFormat:@"-%02d:%02d:%02d", (int)(delta / 3600), (int)(delta / 60), (int)(delta % 60)];
    } else {
        self.timeLabel.text = @"--:--:--";
        self.sliderBar.maximumValue = 1.0f;
    }
    
    if (intDuration > 0) {
        self.sliderBar.value = intPosition;
    } else {
        self.sliderBar.value = 0.0f;
    }
    
//    BOOL isPlaying = self.player.playbackState == MediaPlaybackStatePlaying;
//    self.playButton.selected = isPlaying;
    
//    if (!self.showMenusView) return;
    
    [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
}

@end
