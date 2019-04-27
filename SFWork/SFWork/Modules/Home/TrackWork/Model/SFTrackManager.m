//
//  SFTrackManager.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/15.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTrackManager.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapTrackKit/AMapTrackKit.h>

static SFTrackManager * instance;
#define kAMapTrackServiceID  @"31615"
#define kAMapTrackTerminalID @"60804792"
@interface SFTrackManager ()<AMapTrackManagerDelegate>{
    
    BOOL _serviceStarted;
    BOOL _gatherStarted;
    BOOL _createTrackID;
}

@property (nonatomic, strong) AMapTrackManager *trackManager;

@end

@implementation SFTrackManager

#pragma mark- onceToken  初始化
+ (instancetype) shareTrackManager{
    @synchronized (self) {
        if (instance == nil) {
            return [[self alloc] init];
        }
    }
    return instance;
}

- (AMapTrackManager *)trackManager{
    
    if (!_trackManager) {
        //Service ID 需要根据需要进行修改
        AMapTrackManagerOptions *option = [[AMapTrackManagerOptions alloc] init];
        option.serviceID = kAMapTrackServiceID;
        //初始化AMapTrackManager
        _trackManager = [[AMapTrackManager alloc] initWithOptions:option];
        _trackManager.delegate = self;
        
        //配置定位属性
        [_trackManager setAllowsBackgroundLocationUpdates:YES];
        [_trackManager setPausesLocationUpdatesAutomatically:NO];
    }
    return _trackManager;
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
    
   
    
    [self startTrackService];
}

#pragma mark - Actions

- (void)startTrackService {
    if (self.trackManager == nil) {
        return;
    }
    
    if (_serviceStarted == NO) {
        //开始服务
        AMapTrackManagerServiceOption *serviceOption = [[AMapTrackManagerServiceOption alloc] init];
        serviceOption.terminalID = kAMapTrackTerminalID;
        
        [self.trackManager startServiceWithOptions:serviceOption];
    } else {
        [self.trackManager stopService];
    }
}


- (void)startTrackGather{
    if (self.trackManager == nil) {
        return;
    }
    
    if ([self.trackManager.terminalID length] <= 0) {
        NSLog(@"您需要先开始轨迹服务，才可以开始轨迹采集。");
        return;
    }
    
    if (_gatherStarted == NO) {
        if (_createTrackID == YES) {
            //需要创建trackID，创建成功后开始采集
            
            [self doCreateTrackName];
        } else {
            //不需要创建trackID，则直接开始采集
            
            [self.trackManager startGatherAndPack];
        }
    } else {
        [self.trackManager stopGaterAndPack];
    }
}

- (void)stopTrackService {
    
    [self.trackManager stopService];
    self.trackManager.delegate = nil;
    self.trackManager = nil;
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
        _serviceStarted = YES;
        [self startTrackGather];
    } else {
        //开始服务失败
        _serviceStarted = NO;
        
    }
    
    NSLog(@"onStartService:%ld", (long)errorCode);
}

- (void)onStopService:(AMapTrackErrorCode)errorCode {
    _serviceStarted = NO;
    _gatherStarted = NO;
    
    
    NSLog(@"onStopService:%ld", (long)errorCode);
}

- (void)onStartGatherAndPack:(AMapTrackErrorCode)errorCode {
    if (errorCode == AMapTrackErrorOK) {
        //开始采集成功
        _gatherStarted = YES;
        
    } else {
        //开始采集失败
        _gatherStarted = NO;
        
    }
    
    NSLog(@"onStartGatherAndPack:%ld", (long)errorCode);
}

- (void)onStopGatherAndPack:(AMapTrackErrorCode)errorCode {
    _gatherStarted = NO;
    
    
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
    } else {
        //创建trackID失败
        
        NSLog(@"创建trackID失败");
    }
}

- (NSDictionary *)trackManagerGetCustomDictionary {
    return @{@"item_1":@"test properties",@"item_2":@"i am a test"};
}

- (void)queryTrackInfoAction {
    //查询Track信息
    AMapTrackQueryTrackInfoRequest *request = [[AMapTrackQueryTrackInfoRequest alloc] init];
    request.serviceID = self.trackManager.serviceID;
    request.terminalID = kAMapTrackTerminalID;
    request.startTime = ([[NSDate date] timeIntervalSince1970] - 12*60*60) * 1000;
    request.endTime = [[NSDate date] timeIntervalSince1970] * 1000;
   
    
    [self.trackManager AMapTrackQueryTrackInfo:request];
}

- (void)queryTrackHisAction {
    //查询历史轨迹和距离
    AMapTrackQueryTrackHistoryAndDistanceRequest *request = [[AMapTrackQueryTrackHistoryAndDistanceRequest alloc] init];
    request.serviceID = self.trackManager.serviceID;
    request.terminalID = kAMapTrackTerminalID;
    request.startTime = ([[NSDate date] timeIntervalSince1970] - 12*60*60) * 1000;
    request.endTime = [[NSDate date] timeIntervalSince1970] * 1000;
   
    request.recoupMode = AMapTrackRecoupModeNone;
    
    [self.trackManager AMapTrackQueryTrackHistoryAndDistance:request];
}

#pragma mark - Helper

- (void)showPolylineWithTrackPoints:(NSArray<AMapTrackPoint *> *)points {
    int pointCount = (int)[points count];
    
    CLLocationCoordinate2D *allCoordinates = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < pointCount; i++) {
        allCoordinates[i].latitude = [[points objectAtIndex:i] coordinate].latitude;
        allCoordinates[i].longitude = [[points objectAtIndex:i] coordinate].longitude;
    }
    
    
    
    if (allCoordinates) {
        free(allCoordinates);
        allCoordinates = NULL;
    }
}

#pragma mark - AMapTrackManagerDelegate


- (void)onQueryTrackHistoryAndDistanceDone:(AMapTrackQueryTrackHistoryAndDistanceRequest *)request response:(AMapTrackQueryTrackHistoryAndDistanceResponse *)response {
    NSLog(@"onQueryTrackHistoryAndDistanceDone%@", response.formattedDescription);
    
    if ([[response points] count] > 0) {
       
    }
}

- (void)onQueryTrackInfoDone:(AMapTrackQueryTrackInfoRequest *)request response:(AMapTrackQueryTrackInfoResponse *)response {
    NSLog(@"onQueryTrackInfoDone%@", response.formattedDescription);
    
    
    for (AMapTrackBasicTrack *track in response.tracks) {
        if ([[track points] count] > 0) {
            [self showPolylineWithTrackPoints:[track points]];
        }
    }
    
}

#pragma mark - MapView Delegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        
        MAPolylineRenderer * polylineRenderer = [[MAPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRenderer.lineWidth = 12.f;
        polylineRenderer.lineJoinType = kMALineJoinMiter;
        polylineRenderer.lineCapType = kMALineCapSquare;
        polylineRenderer.fillColor = [UIColor redColor];
        //        polylineRenderer.lineDashType = kMALineDashTypeDot;
        return polylineRenderer;
    }
    
    return nil;
}

@end
