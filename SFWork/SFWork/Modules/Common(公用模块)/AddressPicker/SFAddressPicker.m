//
//  SFAddressPicker.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAddressPicker.h"

#define kScreenBounds [UIScreen mainScreen].bounds
static CGFloat pickerViewHeight = 214.f;
static CGFloat titleViewHeight = 45.f;
static CGFloat titleViewOnButtonWidth = 80.f;

@interface SFAddressPicker()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView *basicLevelView;//弹出的pickerView+titleView的范围高度 基层 Height = addressPickerView.Height + titleView.Height
@property (nonatomic, strong) UIView *bottomView;//iphoneX的机型  底部增加固定 bottomViewHeight 高度的空白view  颜色与pickerView的背景色一致
@property (nonatomic, assign) CGFloat bottomViewHeight;//默认 self.bottomViewHeight

@property (nonatomic, strong) UIView *titleView;//titleView（取消／完成按钮）包含：背景色，边框颜色，边框宽度
@property (nonatomic ,strong) UIButton * cancelBtn;//取消按钮
@property (nonatomic, strong) UIButton * completeBtn;//完成按钮

@property (nonatomic, strong) UIPickerView *addressPickerView;//PickerView

@property (nonatomic, strong) NSMutableArray *provinceArray;//数据源（全局）

@property (nonatomic, assign) NSInteger currentProvinceIndex;//当明确省份时 点击弹出PickerView时显示当前省份
@property (nonatomic, assign) NSInteger currentCityIndex;//当明确城市时 点击弹出PickerView时显示当前城市
@property (nonatomic, assign) NSInteger currentAreaIndex;//当明确地区时 点击弹出PickerView时显示当前地区


@end

@implementation SFAddressPicker

- (NSMutableArray*)provinceArray{
    
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = kScreenBounds;
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self initSubViews];
    }
    return self;
}

- (UIView *)basicLevelView{
    if ((!_basicLevelView)) {
        _basicLevelView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, pickerViewHeight + titleViewHeight)];
        if (IsIPhoneX) {
            _basicLevelView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, pickerViewHeight + titleViewHeight + self.bottomViewHeight)];
        }
        
    }
    return _basicLevelView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.basicLevelView.bounds.size.height - self.bottomViewHeight, kWidth, self.bottomViewHeight)];
        _bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    }
    return _bottomView;
}

- (UIView *)titleView{
    if ((!_titleView)) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(-10, 0, kWidth+20, titleViewHeight)];
        _titleView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _titleView.layer.borderColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0].CGColor;
        _titleView.layer.borderWidth = 0.5;
    }
    return _titleView;
}

- (UIPickerView *)addressPickerView{
    if (!_addressPickerView) {
        _addressPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, _titleView.frame.size.height,kWidth, pickerViewHeight)];
        _addressPickerView.dataSource = self;
        _addressPickerView.delegate = self;
        _addressPickerView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    }
    return _addressPickerView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:
                      CGRectMake(10, 0, titleViewOnButtonWidth, self.titleView.frame.size.height)];
        [_cancelBtn setTitle:@"取消"
                    forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:self.cancelBtnColor
                         forState:UIControlStateNormal];
        [_cancelBtn addTarget:self
                       action:@selector(cancelOnClick:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)completeBtn{
    if (!_completeBtn) {
        _completeBtn = [[UIButton alloc]initWithFrame:
                        CGRectMake(self.titleView.frame.size.width - titleViewOnButtonWidth - 10, 0, titleViewOnButtonWidth, self.titleView.frame.size.height)];
        [_completeBtn setTitle:@"完成"
                      forState:UIControlStateNormal];
        [_completeBtn setTitleColor:self.completeBtnColor
                           forState:UIControlStateNormal];
        [_completeBtn addTarget:self
                         action:@selector(completeOnClick:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}

#pragma mark - 布局
- (void)initSubViews{
    
    self.bottomViewHeight = 88;
    self.hidden = YES;
    self.backgroundColor = [UIColor blackColor];
    self.backGroundViewAplha = 0.3;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    self.cancelBtnColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
    self.completeBtnColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
    
    [self.basicLevelView addSubview:self.titleView];
    [self.titleView addSubview:self.cancelBtn];
    [self.titleView addSubview:self.completeBtn];
    [self.basicLevelView addSubview:self.addressPickerView];
    [self addSubview:self.basicLevelView];
    
    if (IsIPhoneX) {
        [self.basicLevelView addSubview:self.bottomView];
    }
}


- (void)loadRequestData:(NSArray <AddressModel *>*)arrayCityList{
    
    [self.provinceArray removeAllObjects];
    [self.provinceArray addObjectsFromArray:arrayCityList];
    [self.addressPickerView reloadAllComponents];
}

#pragma mark - UIPickerDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.provinceArray.count == 0?0: 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArray.count;
    }
    else if (component == 1) {
        NSInteger selectPIndex = [pickerView selectedRowInComponent:0];
        AddressModel * province = self.provinceArray[selectPIndex];
        return province.children.count;

    }
    else if (component == 2) {
        NSInteger selectPIndex = [pickerView selectedRowInComponent:0];
        NSInteger selectCIndex = [pickerView selectedRowInComponent:1];
        AddressModel * province = self.provinceArray[selectPIndex];
        AddressModel * city = province.children[selectCIndex];
        return city.children.count;
    }else{
        return 0;
    }
}

#pragma mark - UIPickerViewDelegate
#pragma mark - 填充文字
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        AddressModel *province = self.provinceArray[row];
        return province.label;
    }
    else if (component == 1){
        NSInteger selectPIndex = [pickerView selectedRowInComponent:0];
        AddressModel *province = self.provinceArray[selectPIndex];
        AddressModel * city = province.children[row];
        
        return city.label;
    }
    else if (component == 2){
        NSInteger selectPIndex = [pickerView selectedRowInComponent:0];
        NSInteger selectCIndex = [pickerView selectedRowInComponent:1];
        AddressModel *province = self.provinceArray[selectPIndex];
        AddressModel * city = province.children[selectCIndex];
        AddressModel * address = city.children[row];
        
        return address.label;
    }else{
        return nil;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadComponent:2];
    }else if (component == 1){
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
}
#pragma mark - PickerView内 文字颜色／font／位置
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = [UIColor colorWithRed:51.0/255
                                                green:51.0/255
                                                 blue:51.0/255
                                                alpha:1.0];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:25]];
    }
    
    pickerLabel.text = [self pickerView:pickerView
                            titleForRow:row
                           forComponent:component];
    return pickerLabel;
}

- (void)setIsCurrentLocation:(BOOL)isCurrentLocation{
    
    _isCurrentLocation = isCurrentLocation;
    
    __block NSInteger indexP = 0;
    __block NSInteger indexC = 0;
    __block NSInteger indexA = 0;
    
    if (isCurrentLocation) {
        if (_currentProvince) {
            [self.provinceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                AddressModel *provinceModel = obj;
                if ([provinceModel.label isEqualToString:_currentProvince]) {
                    indexP = idx;
                    *stop = YES;
                }
            }];
        }
        if (_currentCity) {
            AddressModel *provinceModel = self.provinceArray[indexP];
            [provinceModel.children enumerateObjectsUsingBlock:^(AddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                AddressModel *cityModel = obj;
                if ([cityModel.label isEqualToString:_currentCity]) {
                    indexC = idx;
                    *stop = YES;
                }
            }];
        }
        if (_currentArea) {
            AddressModel *provinceModel = self.provinceArray[indexP];
            AddressModel *cityModel = provinceModel.children[indexC];
            [cityModel.children enumerateObjectsUsingBlock:^(AddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.label isEqualToString:_currentArea]) {
                    indexA = idx;
                }
            }];
        }
        
        _currentProvinceIndex = indexP;
        _currentCityIndex = indexC;
        _currentAreaIndex = indexA;
        
        [self.addressPickerView selectRow:indexP inComponent:0 animated:YES];
        [self.addressPickerView reloadComponent:1];
        [self.addressPickerView selectRow:indexC inComponent:1 animated:YES];
        [self.addressPickerView reloadComponent:2];
        [self.addressPickerView selectRow:indexA inComponent:2 animated:YES];
    }
    
}

- (void)setCancelBtnColor:(UIColor *)cancelBtnColor{
    [self.cancelBtn setTitleColor:cancelBtnColor forState:UIControlStateNormal];
}

- (void)setCompleteBtnColor:(UIColor *)completeBtnColor{
    [self.completeBtn setTitleColor:completeBtnColor forState:UIControlStateNormal];
}

- (void)setBackGroundViewColor:(UIColor *)backGroundViewColor{
    _backGroundViewColor = backGroundViewColor;
    self.backgroundColor = [backGroundViewColor colorWithAlphaComponent:self.backGroundViewAplha];
}

- (void)setBackGroundViewAplha:(CGFloat)backGroundViewAplha{
    _backGroundViewAplha = backGroundViewAplha;
    self.backgroundColor = [self.backGroundViewColor colorWithAlphaComponent:backGroundViewAplha];
}

- (void)setPickerViewBackGroundColor:(UIColor *)pickerViewBackGroundColor{
    _pickerViewBackGroundColor = pickerViewBackGroundColor;
    self.addressPickerView.backgroundColor = pickerViewBackGroundColor;
    if (IsIPhoneX) {
        self.bottomView.backgroundColor = pickerViewBackGroundColor;
    }
}

- (void)cancelOnClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(cancelOnclick)]) {
        [self.delegate cancelOnclick];
    }
    //    [self hide];
}

- (void)completeOnClick:(id)sender{
    
    NSInteger provinceIndex = [self.addressPickerView selectedRowInComponent:0];
    NSInteger cityIndex = [self.addressPickerView selectedRowInComponent:1];
    NSInteger areaIndex = [self.addressPickerView selectedRowInComponent:2];
    
    AddressModel *province = self.provinceArray[provinceIndex];
    AddressModel *city = province.children[cityIndex];
    AddressModel *area = city.children[areaIndex];
    
    if ([self.delegate respondsToSelector:@selector(completingTheSelection:city:area:)]) {
        [self.delegate completingTheSelection:province city:city area:area];
    }
    self.isComplete = YES;
    [self hide:YES];
    
    if (_isCurrentLocation) {
        _isCurrentLocation = NO;
    }
}

- (void)show{
    [self show:YES];
}

- (void)hide{
    [self hide:YES];
}

- (void)show:(BOOL)animation{
    
    self.hidden = NO;
    if (animation) {
        [UIView animateWithDuration:0.5 animations:^{
            self.basicLevelView.frame = CGRectMake(0, kScreenHeight - pickerViewHeight - titleViewHeight, kScreenWidth, pickerViewHeight + titleViewHeight);
            if (IsIPhoneX) {
                self.basicLevelView.frame = CGRectMake(0, kScreenHeight - pickerViewHeight - titleViewHeight - self.bottomViewHeight, kScreenWidth, pickerViewHeight + titleViewHeight + self.bottomViewHeight);
            }
        }];
    }else{
        self.basicLevelView.frame = CGRectMake(0, kScreenHeight - pickerViewHeight - titleViewHeight, kScreenWidth, pickerViewHeight + titleViewHeight);
        
        if (IsIPhoneX) {
            self.basicLevelView.frame = CGRectMake(0, kScreenHeight - pickerViewHeight - titleViewHeight - self.bottomViewHeight, kScreenWidth, pickerViewHeight + titleViewHeight + self.bottomViewHeight);
        }
    }
}

- (void)hide:(BOOL)animation{
    
//    if ([self.delegate respondsToSelector:@selector(viewDisappearance)]) {
//        [self.delegate viewDisappearance];
//    }
    
    if (animation) {
        [UIView animateWithDuration:0.5 animations:^{
            self.basicLevelView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, pickerViewHeight + titleViewHeight);
            if (IsIPhoneX) {
                self.basicLevelView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, pickerViewHeight + titleViewHeight + self.bottomViewHeight);
            }
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }else{
        self.basicLevelView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, pickerViewHeight + titleViewHeight);
        if (IsIPhoneX) {
            self.basicLevelView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, pickerViewHeight + titleViewHeight + self.bottomViewHeight);
        }
        self.hidden = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hide:YES];
}

@end

@implementation AddressModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children" : [AddressModel class]};
}

@end

