//
//  SFAddressPicker.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AddressModel;
@protocol AddressViewDelegate <NSObject>

- (void)cancelOnclick;//取消选择

- (void)viewDisappearance;//视图隐藏（包括点击取消按钮和点击空白处收起PickerView）

- (void)completingTheSelection:(AddressModel *)province city:(AddressModel *)city area:(AddressModel *)area;//完成选择

@end
@interface SFAddressPicker : UIView

@property (nonatomic ,strong) id<AddressViewDelegate>delegate;

@property (nonatomic ,assign) BOOL isComplete;//是否完成选择
//viewControler2  演示此信息 （viewController选择完地址  然后跳到VC2，点击选择地址）
@property (nonatomic ,assign) BOOL isCurrentLocation;//AddressPickView是否显示输入框内地址
@property (nonatomic ,strong) NSString *currentProvince;//当前输入框内“省”
@property (nonatomic ,strong) NSString *currentCity;//当前输入框内“市”
@property (nonatomic ,strong) NSString *currentArea;//当前输入框内“区”

@property (nonatomic ,strong) UIColor *backGroundViewColor;//背景灰色阴影的色值（默认黑色）
@property (nonatomic ,assign) CGFloat backGroundViewAplha;//背景灰色阴影透明度（默认透明度0.3）

@property (nonatomic ,strong) UIColor *cancelBtnColor;//取消按钮色值 (默认#444444)
@property (nonatomic ,strong) UIColor *completeBtnColor;//完成按钮色值 (默认#444444)

@property (nonatomic ,strong) UIColor *pickerViewBackGroundColor;//弹出的addressPickerView的PickerView背景色 （默认）

//绑定数据
- (void)loadRequestData:(NSArray <AddressModel *>*)arrayCityList;

- (void)show;//默认有动画
- (void)show:(BOOL)animation;

- (void)hide;//默认有动画
- (void)hide:(BOOL)animation;

@end

@interface AddressModel : NSObject

@property (nonatomic, strong) NSArray <AddressModel *> *children;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *value;

@end

NS_ASSUME_NONNULL_END
