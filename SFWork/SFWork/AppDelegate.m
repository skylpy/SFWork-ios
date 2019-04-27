//
//  AppDelegate.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/1/21.
//  Copyright © 2019年 sanfanwork. All rights reserved.
//

#import "AppDelegate.h"
#import "SFJPushManager.h"
#import "SFTabBarViewController.h"
#import "SFLoginViewController.h"
#import "SFFilesMgrModel.h"
#import <AdSupport/AdSupport.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "SFSystemMessageModel.h"

static NSString *appKey = @"642b9b54cb8f646a952b91f4";

static NSString *channel = nil;
static BOOL isProduction = NO;


@interface AppDelegate ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMReceiveMessageDelegate,AMapLocationManagerDelegate>


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //初始化融云SDK
    [self initSDK];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[SFJPushManager shareJPushManager] setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:advertisingId];
    
    [[SFJPushManager shareJPushManager] getRegisterIDCallBack:^(NSString *registerID) {
        
        NSLog(@"registerID----%@",registerID);
    }];
    
    [[SFJPushManager shareJPushManager] setBadge:0];
    
    [self buildKeyWindow];
    [self setNaviBar];
    [self setMapGaoDe];
    return YES;
}

- (void)setMapGaoDe{
    
    //高德地图
    [AMapServices sharedServices].apiKey = @"3074e419e2ec93134f90dcfa91d4752a";
    
    [[AMapServices sharedServices] setEnableHTTPS:YES];
   
}


- (void)setNaviBar{
    
    AMapLocationManager *locationManager = [[AMapLocationManager alloc]init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //   定位超时时间，最低2s，此处设置为10s
    locationManager.locationTimeout =10;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    locationManager.reGeocodeTimeout = 10;
    locationManager.delegate = self;
    [locationManager setLocatingWithReGeocode:YES];
    [locationManager startUpdatingLocation];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = DefaultTitleAColor;
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:kRegFont size:18];
    [[UINavigationBar appearance] setTitleTextAttributes:textAttrs];
}



- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    
    NSLog(@"定位了");
}

#pragma mark - --- 登陆功能 ---
- (void)buildKeyWindow{
    SFInstance * inst = [SFInstance shareInstance];
    NSLog(@"%@",inst);
    if ([SFInstance shareInstance].token) {
        //获取OSS token
        [SFFilesMgrModel setupOSSClient];
        // 主界面
        //设置用户信息源和群组信息源
        
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        [[RCIM sharedRCIM] setGroupInfoDataSource:self];
        self.window.rootViewController = [SFTabBarViewController new];
        NSLog(@"token ======= >>>>>> %@",[SFInstance shareInstance].rongCloud);
        [[RCIM sharedRCIM] connectWithToken:[SFInstance shareInstance].rongCloud success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@,%@", userId,[SFInstance shareInstance].userInfo.name);
            
            RCUserInfo *_currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:[SFInstance shareInstance].userInfo.name portrait:[SFInstance shareInstance].userInfo.smallAvatar];
//            [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
            [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
            
            // 设置消息体内是否携带用户信息
            [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
            [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
        } error:^(RCConnectErrorCode status) {
            
            NSLog(@"登陆的错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
        }];
    }else{
        // 登录
        UIViewController * vc = [[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil] instantiateViewControllerWithIdentifier:@"SFLogin"];
        SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nvs;
    }
}

//实现代理方法，以个人信息为例：
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    NSLog(@"======%@",userId);
    if ([userId isEqualToString:[SFInstance shareInstance].userInfo.rongCloudId]) {
        return completion([[RCUserInfo alloc] initWithUserId:userId name:[SFInstance shareInstance].userInfo.name portrait:[SFInstance shareInstance].userInfo.smallAvatar]);
    }else
    {
        //根据存储联系人信息的模型，通过 userId 来取得对应的name和头像url，进行以下设置（此处因为项目接口尚未实现，所以就只能这样给大家说说，请见谅）
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [SFSystemMessageModel getNameAndAvatarList:userId success:^(UserInfoModel * _Nonnull mode) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    return completion([[RCUserInfo alloc] initWithUserId:mode._id name:mode.name portrait:mode.avatar]);
                });
            } failure:nil];
        });
    }
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *groupInfo))completion{
    
    //根据存储联系人信息的模型，通过 userId 来取得对应的name和头像url，进行以下设置（此处因为项目接口尚未实现，所以就只能这样给大家说说，请见谅）
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SFSystemMessageModel getGroudNameAndAvatarList:groupId success:^(UserInfoModel * _Nonnull mode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                return completion([[RCGroup alloc] initWithGroupId:groupId groupName:mode.name portraitUri:mode.avatar]);
            });
        } failure:nil];
    });
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[SFJPushManager shareJPushManager] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [[SFJPushManager shareJPushManager] handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [[SFJPushManager shareJPushManager] handleRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     NSLog(@"sdfsdfdsf");
//    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotificationSuccess object:nil];
}

- (void)initSDK{
    //ID = 124  pxEJuJoqIzBHkkP9O3n3J38DOrmF3aPcmASD6KZXFQGUB2vcWpgwn7mZpc4ufTmJZPuBcydbmDHQhWC9Lyb3DQ==
    //ID = 123  mZm2Aj1beJH/tdZOrOKhYlwh3ddTnkaURjMGFkO2rygZ7YoVe1B6jrJAgRGllMH5Aa79D/vEKWE=
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    [[RCIM sharedRCIM] initWithAppKey:@"lmxuhwagl50cd"];
    //开启发送已读回执
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList =
    @[ @(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_GROUP) ];
    //开启多端未读状态同步
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    //开启消息撤回功能
    [RCIM sharedRCIM].enableMessageRecall = YES;
    
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    message.readReceiptInfo.isReceiptRequestMessage = YES;
    NSLog(@"接受到消息======>>>>>%@",message);
    
}

@end
