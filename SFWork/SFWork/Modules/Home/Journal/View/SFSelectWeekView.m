//
//  SFSelectWeekView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelectWeekView.h"

static NSString * const SFSelectWeekCellID = @"SFSelectWeekCellID";

@interface SFSelectWeekView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutBottomY;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation SFSelectWeekView


- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

+ (instancetype)shareSFSelectWeekView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFSelectWeekView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.tableView.separatorStyle = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SFSelectWeekCell class] forCellReuseIdentifier:SFSelectWeekCellID];
    
    @weakify(self)
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self hideView];
    }];
    
    [[self.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self sure];
    }];
}

- (void)showView{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.viewLayoutBottomY.constant = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideView{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.viewLayoutBottomY.constant = -300;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sure{
    
    NSMutableArray * varray = [NSMutableArray array];
    NSMutableArray * tarray = [NSMutableArray array];
    for (SFSelectWeekModel * model in self.dataArray) {
        
        if (model.isClick) {
            
            [varray addObject:model.value];
            [tarray addObject:model.title];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectWeekValueArr:withTitleArr:)]) {
        [self.delegate selectWeekValueArr:varray withTitleArr:tarray];
    }
    [self hideView];
}
- (void)setData:(NSArray *)data{
    _data = data;
    [self.dataArray addObjectsFromArray:data];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFSelectWeekCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSelectWeekCellID forIndexPath:indexPath];
    SFSelectWeekModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFSelectWeekModel * model = self.dataArray[indexPath.row];
    model.isClick = !model.isClick ;
    [self.tableView reloadData];
}

@end

@interface SFSelectWeekCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation SFSelectWeekCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setDrawUI];
    }
    return self;
}

- (void)setModel:(SFSelectWeekModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.selectButton.selected = model.isClick;

}

- (void)setDrawUI {
    
    [self addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(60);
        make.width.height.offset(20);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectButton.mas_right).offset(15);
        make.centerY.equalTo(self);
    }];
}


- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:16] withColor:Color(@"#333333")];
    }
    return _titleLabel;
}

- (UIButton *)selectButton{
    
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"btn_tick_green"] forState:UIControlStateSelected];
        [_selectButton setImage:[UIImage imageNamed:@"btn_tick_empty_gray"] forState:UIControlStateNormal];
    }
    return _selectButton;
}

@end

@implementation SFSelectWeekModel

+ (NSArray *)manageSelectWeekModel{
    
    SFSelectWeekModel * model1 = [SFSelectWeekModel manageTitle:@"周一" withIcon:@"btn_tick_green" withValue:@"1" withClick:NO];
    SFSelectWeekModel * model2 = [SFSelectWeekModel manageTitle:@"周二" withIcon:@"btn_tick_green" withValue:@"2" withClick:NO];
    SFSelectWeekModel * model3 = [SFSelectWeekModel manageTitle:@"周三" withIcon:@"btn_tick_green" withValue:@"3" withClick:NO];
    SFSelectWeekModel * model4 = [SFSelectWeekModel manageTitle:@"周四" withIcon:@"btn_tick_green" withValue:@"4" withClick:NO];
    SFSelectWeekModel * model5 = [SFSelectWeekModel manageTitle:@"周五" withIcon:@"btn_tick_green" withValue:@"5" withClick:NO];
    SFSelectWeekModel * model6 = [SFSelectWeekModel manageTitle:@"周六" withIcon:@"btn_tick_green" withValue:@"6" withClick:NO];
    SFSelectWeekModel * model7 = [SFSelectWeekModel manageTitle:@"周日" withIcon:@"btn_tick_green" withValue:@"7" withClick:NO];
    
    return @[model1,model2,model3,model4,model5,model6,model7];
}

+ (SFSelectWeekModel *)manageTitle:(NSString *)title withIcon:(NSString *)icon withValue:(NSString *)value withClick:(BOOL)isClick{
    
    SFSelectWeekModel * model = [[SFSelectWeekModel alloc] init];
    model.title = title;
    model.icon = icon;
    model.value = value;
    model.isClick = isClick;
    return model;
}

@end
