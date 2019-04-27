//
//  SFTallyTypeSelectView.m
//  SFWork
//
//  Created by fox on 2019/4/21.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFTallyTypeSelectView.h"

@interface SFTallyTypeSelectView()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSString * _currTitle;
}
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) UIPickerView * selectView;
@property (strong, nonatomic) NSArray * titltArray;
@end

@implementation SFTallyTypeSelectView

- (void)awakeFromNib{
    [super awakeFromNib];
    _currTitle = @"";
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _selectView = [[UIPickerView alloc]initWithFrame:CGRectZero];
    _selectView.delegate = self;
    [self.mainView addSubview:_selectView];
    [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(38);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self requestData];
}

- (void)requestData{
    [SFBaseModel BGET:BASE_URL(@"/finace/bill/chargetype") parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        self.titltArray = model.result;
        _currTitle = [SFCommon getNULLString:[self.titltArray firstObject][@"name"]];
        [self.selectView reloadAllComponents];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)sureAction:(id)sender {
    if (self.sureBlock) {
        self.sureBlock(_currTitle);
    }
    [self removeFromSuperview];
}

- (IBAction)addAction:(id)sender {
    [self removeFromSuperview];
    if (self.addBlock) {
        self.addBlock();
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _titltArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [SFCommon getNULLString:_titltArray[row][@"name"]];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        pickerLabel.textColor = [UIColor colorWithRed:12.f/255.f green:14.f/255.f blue:14.f/255.f alpha:1];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    [self changeSpearatorLineColor];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _currTitle = [SFCommon getNULLString:_titltArray[row][@"name"]];
}

#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor
{
    for(UIView *speartorView in _selectView.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];//隐藏分割线
        }
    }
    
}

@end
