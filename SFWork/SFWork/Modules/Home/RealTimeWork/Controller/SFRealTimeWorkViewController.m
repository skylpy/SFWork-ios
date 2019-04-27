//
//  SFRealTimeWorkViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFRealTimeWorkViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SFRealTimeListViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFMyAnnotationView.h"
#import "SFRealTimeView.h"
#import <AMapTrackKit/AMapTrackKit.h>
#import "SFPointAnnotation.h"
#import "SFTrackButtonView.h"
#import "UIImage+LSCompression.h"
#import "SFAnnotationView.h"

@interface SFRealTimeWorkViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,AMapTrackManagerDelegate,SFSuperSuborViewControllerDelagete>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) SFRealTimeView *selectEmpView;
@property (strong,nonatomic)AMapSearchAPI *search;
@property (nonatomic, strong) SFMyAnnotationView*annotationView;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) AMapTrackManager *trackManager;
@property (nonatomic, copy) NSString *serviceID;
@property (nonatomic, copy) NSString *terminalID;
@property (nonatomic, assign) NSInteger siteNumber;
@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) SFTrackButtonView *trackButtonView;
@property (nonatomic, strong) NSMutableArray *pointsArray;

@property (nonatomic, strong) NSMutableArray * employeesArray;

@end

@implementation SFRealTimeWorkViewController

- (NSMutableArray *)employeesArray{
    
    if (!_employeesArray) {
        _employeesArray = [NSMutableArray array];
    }
    return _employeesArray;
}

- (NSMutableArray *)pointsArray{
    
    if (!_pointsArray) {
        _pointsArray = [NSMutableArray array];
    }
    return _pointsArray;
}

- (NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (SFTrackButtonView *)trackButtonView{
    
    if (!_trackButtonView) {
        _trackButtonView = [SFTrackButtonView shareSFTrackButtonView];
    }
    return _trackButtonView;
}

- (MAMapView *)mapView{
    
    if (!_mapView) {
        ///初始化地图
        MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
        mapView.delegate = self;
        mapView.zoomLevel = 18;
        _mapView = mapView;
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
//        mapView.showsUserLocation = YES;
//        mapView.userTrackingMode = MAUserTrackingModeFollow;

    }
    return _mapView;
}

- (SFRealTimeView *)selectEmpView{
    
    if (!_selectEmpView) {
        _selectEmpView = [SFRealTimeView shareSFRealTimeView];
        
    }
    return _selectEmpView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实时查岗";
    [self setDrawUI];
    
    [self initTrackManager];
}

- (UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 40, 30);
        _rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
        [_rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"统计" forState:UIControlStateNormal];
        @weakify(self)
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            SFRealTimeListViewController * vc = [NSClassFromString(@"SFRealTimeListViewController") new];
            vc.data = self.employeesArray;
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
    }
    return _rightButton;
}

- (void)setDrawUI {
    
    //搜索对象，逆地理编码
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    self.selectEmpView.nameLabel.text = [SFInstance shareInstance].userInfo.name;
    
    
    
    self.siteNumber = 1;
    ///把地图添加至view
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.selectEmpView];
    [self.selectEmpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.offset(40);
    }];
    
    [self.view addSubview:self.trackButtonView];
    [self.trackButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-88);
        make.height.offset(132);
        make.width.offset(44);
    }];
    
    SFEmployeesModel * emp = [[SFEmployeesModel alloc] init];
    emp.smallAvatar = [SFInstance shareInstance].userInfo.smallAvatar;
    emp.name = [SFInstance shareInstance].userInfo.name;
    emp.sid = kAMapTrackServiceID;
    emp.terminalId = kAMapTrackTerminalID;
    
    [self.employeesArray addObject:emp];
    [self requestTrackHisAction];
    
    self.serviceID = kAMapTrackServiceID;
    self.terminalID = kAMapTrackTerminalID;
    
    @weakify(self)
    [self.trackButtonView setSelectTag:^(NSInteger tag) {
        @strongify(self)
        
        switch (tag) {
            case 0:
            {
                [self requestTrackHisAction];
            }
                break;
            case 1:
            {
                if (self. mapView.zoomLevel < 20 && self. mapView.zoomLevel > 0) {
                    
                    self. mapView.zoomLevel ++;
                }
            }
                break;
            case 2:
            {
                if (self. mapView.zoomLevel < 20 && self. mapView.zoomLevel > 0) {
                    
                    self. mapView.zoomLevel --;
                }
            }
                break;
            default:
                break;
        }
    }];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSLog(@"%@ === %@",[SFInstance shareInstance].userInfo.terminalId,[SFInstance shareInstance].userInfo.sid);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
   
    [self.selectEmpView addGestureRecognizer:tap];
}

- (void)tapClick{
    self.siteNumber = 1;
    SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
    vc.delagete = self;
    vc.type = multipleType;
    vc.isSubor = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//多选
- (void)multiplesSelectEmoloyee:(NSArray <SFEmployeesModel *> *)employees{
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    self.annotationView.selected = NO;
    
    [self.pointsArray removeAllObjects];
    [self.employeesArray removeAllObjects];
    [self.employeesArray addObjectsFromArray:employees];
    
    [self requestTrackHisAction];
}

- (void)requestTrackHisAction{
    
    for (int i = 0;i < self.employeesArray.count ;i ++) {
        SFEmployeesModel * emp = self.employeesArray[i];
        SFPointAnnotation *startpointAnnotation = [[SFPointAnnotation alloc] init];
        UIImage * image = [UIImage imageFromURLString:emp.smallAvatar];
        image = [image scaleToSize:image size:CGSizeMake(30, 30)];
        image = [image imageWithCornerRadius:15];
        image = [image borderImage:image];
        startpointAnnotation.iconImage = image;
        startpointAnnotation.name = emp.name;
        
        startpointAnnotation.siteNumber = i;
        [self.pointsArray addObject:startpointAnnotation];
    }
    NSString * title = @"";
    for (int i = 0;i < self.employeesArray.count ;i ++) {
        SFEmployeesModel * emp = self.employeesArray[i];
        if (i == 0) {
            title = emp.name;
        }else{
            title = [NSString stringWithFormat:@"%@ %@",title,emp.name];
        }
        self.serviceID = emp.sid;
        self.terminalID = emp.terminalId;
        [self queryTrackHisAction];
    }
    self.selectEmpView.nameLabel.text = title;
}

- (void)initTrackManager {
    if ([self.serviceID length] <= 0 || [self.terminalID length] <= 0) {
        
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
    option.serviceID = self.serviceID;
    
    //初始化AMapTrackManager
    self.trackManager = [[AMapTrackManager alloc] initWithOptions:option];
    self.trackManager.delegate = self;
    
    //配置定位属性
    [self.trackManager setAllowsBackgroundLocationUpdates:YES];
    [self.trackManager setPausesLocationUpdatesAutomatically:NO];
    
    [self queryTrackHisAction];
}

- (void)queryTrackHisAction{
    
    AMapTrackQueryLastPointRequest *request = [[AMapTrackQueryLastPointRequest alloc] init];
    request.serviceID = self.serviceID;
    request.terminalID = self.terminalID;
    [MBProgressHUD showActivityMessageInView:@"加载中.."];
    [self.trackManager AMapTrackQueryLastPoint:request];
}


- (void)onQueryLastPointDone:(AMapTrackQueryLastPointRequest *)request response:(AMapTrackQueryLastPointResponse *)response
{
    [MBProgressHUD hideHUD];

    //查询成功
    NSLog(@"onQueryLastPointDone%@", response.formattedDescription);
    
    NSLog(@"response.lastPoint.coordinate.latitude%f", response.lastPoint.coordinate.latitude);
    
    if (self.pointsArray.count > 0) {
        SFPointAnnotation *startpointAnnotation = self.pointsArray[self.siteNumber-1];
        startpointAnnotation.coordinate = CLLocationCoordinate2DMake(response.lastPoint.coordinate.latitude, response.lastPoint.coordinate.longitude);
        
        [self.mapView addAnnotation:startpointAnnotation];
        
        [self.mapView selectAnnotation:startpointAnnotation animated:YES];
    }else{
        SFPointAnnotation *startpointAnnotation = [[SFPointAnnotation alloc] init];
        startpointAnnotation.coordinate = CLLocationCoordinate2DMake(response.lastPoint.coordinate.latitude, response.lastPoint.coordinate.longitude);
        UIImage * image = [UIImage imageFromURLString:[SFInstance shareInstance].userInfo.smallAvatar];
        image = [image scaleToSize:image size:CGSizeMake(30, 30)];
        image = [image imageWithCornerRadius:15];
        image = [image borderImage:image];
        startpointAnnotation.iconImage = image;
        startpointAnnotation.name = [SFInstance shareInstance].userInfo.name;
        [self.mapView addAnnotation:startpointAnnotation];
        
        [self.mapView selectAnnotation:startpointAnnotation animated:YES];
    }
    self.siteNumber ++;
}

// 选中大头针
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"选中大头针  %@",view);
    
//    self.annotationView.calltitle = self.titleArray[0];
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
    MAAnnotationView *view = views[0];
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
        r.showsAccuracyRing = false;///精度圈是否显示，默认YES
        [mapView updateUserLocationRepresentation:r];
    }
}

- (void)didFailWithError:(NSError *)error associatedRequest:(id)request {
    
    [MBProgressHUD hideHUD];
    [MBProgressHUD showTipMessageInWindow:@"请检查您的网络"];
    if ([request isKindOfClass:[AMapTrackQueryLastPointRequest class]]) {
        //查询失败
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    NSLog(@"=====%@",annotation.title)
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        SFAnnotationView*annotationView = (SFAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[SFAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//            self.annotationView = annotationView;
        }
        SFPointAnnotation * an = annotation;
//        self.annotationView = annotationView;
        annotationView.enabled = YES;
        annotationView.selected = YES;
//        annotationView.calloutView.hidden = YES;
        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO]
        annotationView.image = [UIImage imageNamed:@"icon_positioning_map_red"];
        annotationView.calltitle = an.name;
//        [annotationView.imageView setImageWithURL:[NSURL URLWithString:@""] placeholder:[UIImage imageNamed:@"icon_positioning_map_red"]];
//        annotationView.calltitle = annotation.title;
        
        return annotationView;
    }
    return nil;
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        
        [self.titleArray removeAllObjects];
        NSLog(@"%@",response.regeocode.formattedAddress)
        //解析response获取地址描述，具体解析见 Demo
        NSString *strAddress = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",response.regeocode.addressComponent.province,response.regeocode.addressComponent.city,response.regeocode.addressComponent.district,response.regeocode.addressComponent.township,response.regeocode.addressComponent.neighborhood];
        NSLog(@"%@",strAddress);
        [self.titleArray addObject:response.regeocode.formattedAddress];
        
//        self.annotationView.calltitle = response.regeocode.formattedAddress;
        
    }
}

- (void)dealloc {
    
    NSLog(@"释放 ====== trackManager");
    [self.trackManager stopService];
    self.trackManager.delegate = nil;
    self.trackManager = nil;
    
}

@end
