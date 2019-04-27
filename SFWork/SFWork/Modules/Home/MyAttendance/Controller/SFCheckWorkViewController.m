//
//  SFCheckWorkViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFCheckWorkViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SFMyAnnotationView.h"
#import "DDPointAnnotation.h"
#import "SFMyAttendanceHttpModel.h"
#import "SFAttendancePopView.h"

@interface SFCheckWorkViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    MAMapView *_mapView;
}

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLayoutX;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong,nonatomic)AMapSearchAPI *search;
@property (nonatomic, copy) NSString *titles;
@property (nonatomic, strong) SFMyAnnotationView*annotationView;

@property (nonatomic, strong) UIButton *centerButton;

@property (weak, nonatomic) IBOutlet UIView *showView;

@property (nonatomic, copy) NSString *attendanceType;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, copy) NSString *photo;

@property (nonatomic, strong) MyAttendanceModel *attModel;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation SFCheckWorkViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"AttendanceRules" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        
        self.attModel = x.object;
        //构造圆
        for (MyAddressModel * address in self.attModel.addressDTOList) {
            MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(address.latitude, address.longitude) radius:[address.scope integerValue]];
            
            //在地图上添加圆
            [_mapView addOverlay: circle];
            
            //1.将两个经纬度点转成投影点
            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.latitude,self.longitude));
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(address.latitude,address.longitude));
            
            NSLog(@"%.2f ==== %.2f",self.latitude,self.longitude);
            NSLog(@"%.2f ==== %.2f",address.latitude,address.longitude);
            //2.计算距离
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            
            if (distance < [address.scope integerValue]) {
                
                if ([self.attModel.attendances isEqualToString:@"OFFDUTY"]) {
                    self.tipLabel.text = [NSString stringWithFormat:@"您已在打卡范围内，可打卡，请在%@之后打卡",self.attModel.attendanceDTOS.startTime];
                }else{
                    self.tipLabel.text = [NSString stringWithFormat:@"您已在打卡范围内，可打卡，请在%@之前打卡",self.attModel.attendanceDTOS.startTime];
                }
                
            }else{
                
                if ([self.attModel.attendances isEqualToString:@"OFFDUTY"]) {
                    self.tipLabel.text = [NSString stringWithFormat:@"您不在打卡范围内，请到达范围内并%@之后打卡",self.attModel.attendanceDTOS.startTime];
                }else{
                    self.tipLabel.text = [NSString stringWithFormat:@"您不在打卡范围内，请到达范围内并%@之前打卡",self.attModel.attendanceDTOS.startTime];
                }
                
            }
        }
        
    
        
        NSString * lateTime = [self.attModel.attendanceDTOS.beforeMinutes componentsSeparatedByString:@" "].lastObject;
        NSString * currTime = [NSDate stringFromDate:[NSDate getCurrentTime]];
        
        NSLog(@"%@",self.attModel.attendanceDTOS.timeNumber);
        
        [self centerBtn];
        
        if (self.attModel.attendanceDTOS == nil) {
            
            self.tipLabel.text = [NSString stringWithFormat:@"打卡还没有设置好，请去企业设置-考勤设置里设置"];
        }
//        NSLog(@"distance = %f",distance);
    }];
}

- (void)centerBtn {
    
    if ([self.attModel.attendances isEqualToString:@"OFFDUTY"]) {
        if (!self.attModel.photoCheck) {
            
            self.centerButton.titleLabel.attributedText = [NSMutableAttributedString setupAttributeString:@"下班打卡 " rangeText:@" " textFont:[UIFont fontWithName:kRegFont size:12] textColor:Color(@"#FFFFFF")];
        }else{
            self.centerButton.titleLabel.attributedText = [NSMutableAttributedString setupAttributeString:@"下班打卡\n（拍照打卡）" rangeText:@"（拍照打卡）" textFont:[UIFont fontWithName:kRegFont size:12] textColor:Color(@"#FFFFFF")];
        }
    }else if([self.attModel.attendances isEqualToString:@"GOTOWORK"]){
        if (!self.attModel.photoCheck) {
            
            self.centerButton.titleLabel.attributedText = [NSMutableAttributedString setupAttributeString:@"上班打卡 " rangeText:@" " textFont:[UIFont fontWithName:kRegFont size:12] textColor:Color(@"#FFFFFF")];
        }else{
            self.centerButton.titleLabel.attributedText = [NSMutableAttributedString setupAttributeString:@"上班打卡\n（拍照打卡）" rangeText:@"（拍照打卡）" textFont:[UIFont fontWithName:kRegFont size:12] textColor:Color(@"#FFFFFF")];
        }
    }else{
        
        if (!self.attModel.photoCheck) {
            
            self.centerButton.titleLabel.attributedText = [NSMutableAttributedString setupAttributeString:@"更新打卡 " rangeText:@" " textFont:[UIFont fontWithName:kRegFont size:12] textColor:Color(@"#FFFFFF")];
        }else{
            self.centerButton.titleLabel.attributedText = [NSMutableAttributedString setupAttributeString:@"更新打卡\n（拍照打卡）" rangeText:@"（拍照打卡）" textFont:[UIFont fontWithName:kRegFont size:12] textColor:Color(@"#FFFFFF")];
        }
    }
}

- (void)setDrawUI {
    
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
    mapView.delegate = self;
    mapView.zoomLevel = 18;
    mapView.showsCompass = NO;
    _mapView = mapView;
    ///把地图添加至view
    [self.view addSubview:mapView];
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MAUserTrackingModeFollow;

    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
   
    [self.view bringSubviewToFront:self.showView];
    [self.view addSubview:self.centerButton];
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.width.height.offset(120);
    }];
    
    //搜索对象，逆地理编码
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.attendanceType = @"IN";
    
    @weakify(self)
    [[self.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.attendanceType = @"IN";
        self.lineViewLayoutX.constant = 0;
        [self selectStatueBtn:x];
    }];
    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.attendanceType = @"OUT";
        self.lineViewLayoutX.constant = kWidth/2;
        [self selectStatueBtn:x];
    }];
    
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

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth    = 1.f;
        circleRenderer.strokeColor  = [UIColor colorWithRed:1/255.0 green:179/255.0 blue:139/255.0 alpha:0.8];
        circleRenderer.fillColor    = [UIColor colorWithRed:1/255.0 green:179/255.0 blue:139/255.0 alpha:0.3];
        return circleRenderer;
    }
    return nil;
}

/**
 * @brief 位置或者设备方向更新后，会调用此函数
 * @param mapView 地图View
 * @param userLocation 用户定位信息(包括位置与设备方向等数据)
 * @param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
 */
-(void)mapView:(MAMapView*)mapView didUpdateUserLocation: (MAUserLocation*)userLocation updatingLocation:(BOOL)updatingLocation{
    
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude, userLocation.location.horizontalAccuracy);
    
    if (updatingLocation) {
        
        self.longitude = userLocation.location.coordinate.longitude;
        self.latitude = userLocation.location.coordinate.latitude;
        
        
        //请求逆地理编码
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        
        regeo.location                    = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        regeo.requireExtension            = YES;
        
        [self.search AMapReGoecodeSearch:regeo];
    }
    
}

/**
 * @brief 定位失败后，会调用此函数
 * @param mapView 地图View
 * @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
}



- (void)selectStatueBtn:(UIButton *)sender{
    
    for (int i = 1000; i < 1002; i ++) {
        UIButton * button = [self.selectView viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    NSLog(@"=====%@",annotation.title)
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        SFMyAnnotationView*annotationView = (SFMyAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[SFMyAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            self.annotationView = annotationView;
        }
        self.annotationView = annotationView;
        annotationView.enabled = NO;
        annotationView.selected = YES;
        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        annotationView.image = [UIImage imageNamed:@"icon_positioning_map_red"];
        annotationView.calltitle = annotation.title;

        return annotationView;
    }
    return nil;
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        NSLog(@"%@",response.regeocode.formattedAddress)
        //解析response获取地址描述，具体解析见 Demo
        NSString *strAddress = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",response.regeocode.addressComponent.province,response.regeocode.addressComponent.city,response.regeocode.addressComponent.district,response.regeocode.addressComponent.township,response.regeocode.addressComponent.neighborhood];
        NSLog(@"%@",strAddress);
        self.titles =response.regeocode.formattedAddress;
        self.annotationView.calltitle = response.regeocode.formattedAddress;
        self.address = response.regeocode.formattedAddress;
    }
}

- (UIButton *)centerButton {
    
    if (!_centerButton) {
        
        _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerButton setBackgroundImage:[UIImage imageNamed:@"btn_oval_punch_card_red"] forState:UIControlStateNormal];
        [_centerButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        [_centerButton setTitle:@"上班打卡\n（拍照打卡）" forState:UIControlStateNormal];
        _centerButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _centerButton.titleLabel.numberOfLines = 2;
        _centerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _centerButton.titleLabel.font = [UIFont fontWithName:kMedFont size:16];
        _centerButton.titleLabel.attributedText = [NSMutableAttributedString setupAttributeString:@"上班打卡\n（拍照打卡）" rangeText:@"（拍照打卡）" textFont:[UIFont fontWithName:kRegFont size:12] textColor:Color(@"#FFFFFF")];
        @weakify(self)
        [[_centerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            
            if (self.attModel.attendanceDTOS == nil) {
                
                [UIAlertController alertTitle:@"温馨提示" mesasge:@"你还没加入任何考勤组" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
                    
                } viewController:self];
                return ;
            }
            
  
            if ([self.attModel.attendances isEqualToString:@"OFFDUTY"]) {
                if (self.attModel.photoCheck) {
                    [self pickUpCark];
                    
                }else{
                    [self pickUpCark];
                }
            }else if([self.attModel.attendances isEqualToString:@"GOTOWORK"]){
                if (self.attModel.photoCheck) {
                    [self showPicker];
                }else{
                    [self puckUpCark];
                }
            }else{
                
                if (self.attModel.photoCheck) {
                    [self pickUpCark];
                    
                }else{
                    [self pickUpCark];
                }
            }
            
            
        }];
    }
    return _centerButton;
}

- (void)pickUpCark{
    
    NSArray * arr = [[NSDate stringFromDate:[NSDate dateFromString:self.attModel.attendanceDTOS.startTime]] componentsSeparatedByString:@":"];
    NSArray * arr1 = [[NSDate stringFromDate:[NSDate new] withFormatter:@"hh:mm"] componentsSeparatedByString:@":"];
    if ([arr.firstObject integerValue] > [arr1.firstObject integerValue]) {
        
        [UIAlertController alertTitle:@"温馨提示" mesasge:@"你是否要打早退卡？" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *alertAction) {
            [self showPicker];
        } cancleHandler:^(UIAlertAction * alert) {
            
        } viewController:self];
        
    }else if ([arr.firstObject integerValue] == [arr1.firstObject integerValue]){
        
        if ([arr.lastObject integerValue] > [arr1.lastObject integerValue]){
            [UIAlertController alertTitle:@"温馨提示" mesasge:@"你是否要打早退卡？" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *alertAction) {
                [self showPicker];
            } cancleHandler:^(UIAlertAction * alert) {
                
            } viewController:self];
        }
    }else{
        [self showPicker];
    }
}

- (void)showPicker {
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (UIImagePickerController *)imagePicker{
    
    if (_imagePicker == nil) {
        
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;    //设置来源为摄像头
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear; //设置使用的摄像头为：后置摄像头
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto; //设置摄像头模式为拍照
        _imagePicker.delegate = self;
//        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}


- (void)puckUpCark{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.attendanceType forKey:@"attendanceType"];
    [dict setValue:@"NORMAL" forKey:@"positioningType"];
    [dict setValue:self.address forKey:@"address"];
    [dict setValue:@(self.longitude) forKey:@"longitude"];
    [dict setValue:@(self.latitude) forKey:@"latitude"];
    [dict setValue:self.photo forKey:@"photo"];
    [dict setValue:self.attModel.attendances forKey:@"attendances"];
    
//    [MBProgressHUD showActivityMessageInView:@""];
    [SFMyAttendanceHttpModel timeRecord:dict success:^(MyAttendanceGetRecord * _Nonnull mode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccessMessage:@"打卡成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"puckUpCarkSuccess" object:nil];
            
            if ([mode.attendanceStatus isEqualToString:@"NORMAL"]||[mode.attendanceStatus isEqualToString:@"EARLY"]) {
                
                [[SFAttendancePopView shareSFAttendancePopView] showInView:LSKeyWindow withModel:mode actionBlock:^{
                    
                }];
            }
            
        });
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccessMessage:@"打卡失败"];
            [self centerBtn];
        });
    }];

}

#pragma mark-
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    if (picker.allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage]; //允许编辑，获取编辑过的图片
    }
    else{
        image = [info objectForKey:UIImagePickerControllerOriginalImage]; //不允许编辑，获取原图片
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
//    dispatch_queue_t urls_queue = dispatch_queue_create("minggo.app.com", NULL);
//    dispatch_async(urls_queue, ^{
//        NSLog(@"---是否为主线程-%d",[NSThread isMainThread]);
//
//
//    });
    [self selectPickedPhotos:image];
}

#pragma mark- PickerToolDelegate
- (void)selectPickedPhotos:(UIImage *)image{
    [MBProgressHUD showActivityMessageInWindow:@""];
    [[SFAliOSSManager sharedInstance] asyncUploadMultiImages:@[image] withFile:@"image" withFolderName:@"Image" CompeleteBlock:^(NSArray *nameArray) {
        
        NSLog(@"nameArray is %@", nameArray);
        [self files:nameArray];
    } ErrowBlock:^(NSString *errrInfo) {
        
        [MBProgressHUD hideHUD];
    }];
    
}

- (void)files:(NSArray *)nameArr {
    
    NSDictionary * dic = nameArr[0];
    NSString *img = dic[@"Img"];
    
    self.photo = img;
    
    [self puckUpCark];
}

- (void)updateUpCark{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.attendanceType forKey:@"attendanceType"];
    [dict setValue:@"NORMAL" forKey:@"positioningType"];
    [dict setValue:self.address forKey:@"address"];
    [dict setValue:@(self.longitude) forKey:@"longitude"];
    [dict setValue:@(self.latitude) forKey:@"latitude"];
    [dict setValue:self.photo forKey:@"photo"];
    [dict setValue:self.attModel.attendances forKey:@"attendances"];
//    [MBProgressHUD showActivityMessageInView:@""];
    [SFMyAttendanceHttpModel updateTimeRecord:dict success:^(MyAttendanceGetRecord * _Nonnull mode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccessMessage:@"打卡成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"puckUpCarkSuccess" object:nil];
            if ([mode.attendanceStatus isEqualToString:@"NORMAL"]||[mode.attendanceStatus isEqualToString:@"LATE"]||[mode.attendanceStatus isEqualToString:@"MISSING"]||[mode.attendanceStatus isEqualToString:@"EARLY"]||[mode.attendanceStatus isEqualToString:@"ABSENTEEISM"]) {
                
                [[SFAttendancePopView shareSFAttendancePopView] showInView:LSKeyWindow withModel:mode actionBlock:^{
                    
                }];
            }
            
            
        });
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccessMessage:@"打卡失败"];
            [self centerBtn];
        });
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self centerBtn];
}


@end
