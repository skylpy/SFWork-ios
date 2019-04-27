//
//  SFTabBarViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTabBarViewController.h"
#import "SFNavigationViewController.h"
#import "SFStatisticsViewController.h"
#import "SFHomeViewController.h"
#import "SFMassageViewController.h"
#import "SFMineViewController.h"
#import "SFTabBarModel.h"
#import "SFTrackManager.h"
#import <AMapTrackKit/AMapTrackKit.h>



@interface SFTabBarViewController ()<UITabBarControllerDelegate,AMapTrackManagerDelegate>{
    
    BOOL _serviceStarted;
    BOOL _gatherStarted;
    BOOL _createTrackID;
}
@property (nonatomic, strong) NSMutableArray *viewControllers;  // 子控制器个数；
@property (nonatomic, strong) NSDate *lastDate;

@property (nonatomic, strong) AMapTrackManager *trackManager;

@end

@implementation SFTabBarViewController
@synthesize viewControllers;

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self initTrackManager];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*** 子控制器数组初始化 ***/
    self.viewControllers = [NSMutableArray arrayWithCapacity:4];
    
    /*** 设置子控制器 ***/
    [self setupControllers];
    
    /*** 设置tabBar ***/
    [self setupTabBar];
    
    [self setupItemTitleTextAttributes];
    
    /*** 添加子控件 ***/
    [self addChildController];
    self.delegate = self;
//    _createTrackID = YES;
    
    [self getNotiCenter];

}


- (void)getNotiCenter {
    
    @weakify(self)
    #ifdef DEBUG
    #else
    AppLocal(12)
    #endif
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:LogoutNotificationSuccess object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self stopTrackService];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:LoginNotificationSuccess object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        
        _createTrackID = YES;
    }];

}


- (void)initTrackManager {
    if ([kAMapTrackServiceID length] <= 0 || [kAMapTrackTerminalID length] <= 0) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您需要指定ServiceID和TerminalID才可以使用轨迹服务"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //Service ID 需要根据需要进行修改
    AMapTrackManagerOptions *option = [[AMapTrackManagerOptions alloc] init];
    option.serviceID = kAMapTrackServiceID;
    
    //初始化AMapTrackManager
    self.trackManager = [[AMapTrackManager alloc] initWithOptions:option];
    self.trackManager.delegate = self;
    [self.trackManager setLocalCacheMaxSize:50];
    self.trackManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //配置定位属性
    [self.trackManager setAllowsBackgroundLocationUpdates:YES];
    [self.trackManager setPausesLocationUpdatesAutomatically:NO];
    
    [self startTrackService:nil];
}

#pragma mark - Actions

- (void)startTrackService:(UIButton *)button {
    if (self.trackManager == nil) {
        return;
    }
    
    AMapTrackManagerServiceOption *serviceOption = [[AMapTrackManagerServiceOption alloc] init];
    serviceOption.terminalID = kAMapTrackTerminalID;
    
    [self.trackManager startServiceWithOptions:serviceOption];
}

- (void)startTrackGather:(UIButton *)button {
    if (self.trackManager == nil) {
        return;
    }
    
    if ([self.trackManager.terminalID length] <= 0) {
        NSLog(@"您需要先开始轨迹服务，才可以开始轨迹采集。");
        return;
    }
    
    [self doCreateTrackName];
}


#pragma mark - Helper

- (void)doCreateTrackName {
    if (self.trackManager == nil) {
        return;
    }
    
    AMapTrackAddTrackRequest *request = [[AMapTrackAddTrackRequest alloc] init];
    request.serviceID = self.trackManager.serviceID;
    request.terminalID = self.trackManager.terminalID;
    
    [self.trackManager AMapTrackAddTrack:request];
}

#pragma mark - AMapTrackManagerDelegate

- (void)didFailWithError:(NSError *)error associatedRequest:(id)request {
    if ([request isKindOfClass:[AMapTrackAddTrackRequest class]]) {
        
    }
    
    NSLog(@"didFailWithError:%@; --- associatedRequest:%@;", error, request);
}

- (void)onStartService:(AMapTrackErrorCode)errorCode {
    if (errorCode == AMapTrackErrorOK) {
        //开始服务成功
        
        [self startTrackGather:nil];
    } else {
        //开始服务失败
        
    }
    
    NSLog(@"onStartService:%ld", (long)errorCode);
}

- (void)onStopService:(AMapTrackErrorCode)errorCode {
    
    
    NSLog(@"onStopService:%ld", (long)errorCode);
}

- (void)onStartGatherAndPack:(AMapTrackErrorCode)errorCode {
    if (errorCode == AMapTrackErrorOK) {
        //开始采集成功
        
    } else {
        //开始采集失败
        
    }
    
    NSLog(@"onStartGatherAndPack:%ld", (long)errorCode);
}

- (void)onStopGatherAndPack:(AMapTrackErrorCode)errorCode {
    
    
    NSLog(@"onStopGatherAndPack:%ld", (long)errorCode);
}

- (void)onStopGatherAndPack:(AMapTrackErrorCode)errorCode errorMessage:(NSString *)errorMessage {
    NSLog(@"onStopGatherAndPack:%ld errorMessage:%@", (long)errorCode,errorMessage);
}

- (void)onAddTrackDone:(AMapTrackAddTrackRequest *)request response:(AMapTrackAddTrackResponse *)response
{
    NSLog(@"onAddTrackDone%@", response.formattedDescription);
    
    if (response.code == AMapTrackErrorOK) {
        //创建trackID成功，开始采集
        self.trackManager.trackID = response.trackID;
        [self.trackManager startGatherAndPack];
        [self saveTrackId:response.trackID];
    } else {
        //创建trackID失败
        
        NSLog(@"创建trackID失败");
    }
}

//保存轨迹ID
- (void)saveTrackId:(NSString *)tid{
    
    [SFTabModel gaodeSaveTrids:tid success:^{
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (NSDictionary *)trackManagerGetCustomDictionary {
    return @{@"item_1":@"test properties",@"item_2":@"i am a test"};
}

/**
 *  设置子控制器
 */
- (void)setupControllers {
    
    SFNavigationViewController *navOne = [[SFNavigationViewController alloc] initWithRootViewController:[SFHomeViewController new]];
    SFNavigationViewController *navTwo = [[SFNavigationViewController alloc] initWithRootViewController:[[SFMassageViewController alloc] init]];
    SFStatisticsViewController * statisticsVc = [[UIStoryboard storyboardWithName:@"SFStatistics" bundle:nil] instantiateViewControllerWithIdentifier:@"SFStatisticsView"];
    SFNavigationViewController *navThree = [[SFNavigationViewController alloc] initWithRootViewController:statisticsVc];
    SFNavigationViewController *navFour = [[SFNavigationViewController alloc] initWithRootViewController:[[SFMineViewController alloc] init]];
    
    [self.viewControllers addObjectsFromArray:@[navOne,navTwo,navThree,navFour]];
}

/**
 *  设置所有UITabBarItem的文字属性
 */
- (void)setupItemTitleTextAttributes {
    
    // 普通状态下的文字属性
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Color(@"#A8A8A8"), NSForegroundColorAttributeName,[UIFont fontWithName:kRegFont size:11],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    // 选中状态下的文字属性
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Color(@"#01B38B"), NSForegroundColorAttributeName, [UIFont fontWithName:kRegFont size:11],NSFontAttributeName, nil] forState:UIControlStateSelected];
}

/**
 *  设置所有UITabBar
 */
- (void)setupTabBar {
    
    //tabbar backgroundColor
    //    [[UITabBar appearance] setBarTintColor:ColorA(204, 208, 225, 0.2)];
    //tabbar的分割线的颜色
    //    [UITabBar appearance] set;
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setTranslucent:NO];
    [self dropShadowWithOffset:CGSizeMake(0, -2.5)
                        radius:6
                         color:COLOR(204, 204, 204)
                       opacity:0.2];
}

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.tabBar.clipsToBounds = NO;
}

/**
 *  添加子控件
 */
- (void)addChildController {
    NSArray *arr = [SFTabBarModel shareManage];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFTabBarModel *model = (SFTabBarModel *)obj;
        UIViewController *vc = self.viewControllers[idx];
        // 添加子控件，初始化items
        [self addController:vc title:model.title normolImageName:model.normalImageName selectImageName:model.selectImageName];
    }];
}

/**
 *  添加子控制器，初始化tabbarItem
 */
- (void)addController:(UIViewController *)viewController title:(NSString *)title normolImageName:(NSString *)normalImageName selectImageName:(NSString *)selectImageName {
    viewController.tabBarItem.title = title;
    
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.image = normalImage;
    
    UIImage *selectedImage = [UIImage imageNamed:selectImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = selectedImage;
    // tabbar文字上移
    viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -1);
    
    [self addChildViewController:viewController];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[SFHomeViewController class]]) {
//        [Analytics event:EventTabbarHome];
    }else if ([viewController isKindOfClass:[SFMassageViewController class]]){
//        [Analytics event:EventTabbarStudy];
    }else{
//        [Analytics event:EventTabbarMine];
    }
    if ([self doubleClick]) {
        UINavigationController *navigation =(UINavigationController *)viewController;
        if ([navigation.topViewController respondsToSelector:@selector(tabbarDoubleClick)]) {
            [navigation.topViewController performSelector:@selector(tabbarDoubleClick)];
        }
        
    }
}

/*判断是否是双击(因为系统并没有提供双击的方法, 可以通过点击的时间间隔来判断)*/
- (BOOL)doubleClick {
    NSDate *date = [NSDate date];
    
    if (date.timeIntervalSince1970 - self.lastDate.timeIntervalSince1970 < 0.5) {
        //完成一次双击后，重置第一次单击的时间，区分3次或多次的单击
        self.lastDate = [NSDate dateWithTimeIntervalSince1970:0];
        
        return YES;
    }
    
    self.lastDate = date;
    return NO;
    
}

- (void)stopTrackService {
    
    [self.trackManager stopService];
    self.trackManager.delegate = nil;
    self.trackManager = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

@implementation SFTabModel

/**
 * des:SFTabModel保存轨迹ID
 * author:SkyWork
 */
+(void)gaodeSaveTrids:(NSString *)Id
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(gaodeSaveTrid),Id];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
       
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

@end
