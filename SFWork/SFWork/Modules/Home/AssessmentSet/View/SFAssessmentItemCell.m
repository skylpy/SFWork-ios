//
//  SFAssessmentItemCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAssessmentItemCell.h"
#import "SFAssessItemCell.h"
#import "SFWorkAssessHttpModel.h"
#import "SFAssessmentListCell.h"
#import "SFAssessmentSetListCell.h"

static NSString * const SFAssessItemCellID = @"SFAssessItemCellID";
static NSString * const SFAssessmentSetListCellID = @"SFAssessmentSetListCellID";

@interface SFAssessmentItemCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@property (nonatomic, assign) NSInteger number;

@end

@implementation SFAssessmentItemCell

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.selectView.layer.cornerRadius = 3;
    self.selectView.clipsToBounds = YES;
    self.selectView.layer.borderWidth = 1;
    self.selectView.layer.borderColor = Color(@"#D8D8D8").CGColor;
    self.leftView.backgroundColor = Color(@"#D8D8D8");
    self.rightView.backgroundColor = Color(@"#D8D8D8");
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SFAssessItemCell" bundle:nil] forCellReuseIdentifier:SFAssessItemCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFAssessmentSetListCell" bundle:nil] forCellReuseIdentifier:SFAssessmentSetListCellID];
    
    RACChannelTo(self, self.model.mod.itemNum) = RACChannelTo(self.numberTextField, text);
    RACChannelTo(self, self.model.value) = RACChannelTo(self.numberTextField, text);
    @weakify(self)
    [[self.numberTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.model.mod.itemNum = x;
        self.model.value = x;
    }];
    
    [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        if (self.number < 10000) {
            self.number ++;
            self.numberTextField.text = [NSString stringWithFormat:@"%ld",self.number];
        }
        
    }];
    [[self.reduceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.number > 0) {
            self.number --;
            self.numberTextField.text = [NSString stringWithFormat:@"%ld",self.number];
        }
    }];
    
    [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.deleteClick?:self.deleteClick(self.model);
    }];
}

- (void)setModel:(SFAssessmentSetModel *)model{
    _model = model;
   
    if (![model.value isEqualToString:@""]&& model.value != nil) {
        
        self.number = [model.value integerValue];
        self.numberTextField.text = model.value;
        self.selectView.hidden = NO;
    }else{
        self.selectView.hidden = YES;
    }
    self.titleLabel.text = model.title;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:model.mod.itemSubList];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemSubListModel * model = self.dataArray[indexPath.row];
    if (model.period) {
        SFAssessmentSetListCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAssessmentSetListCellID forIndexPath:indexPath];
        cell.smodel = model;
        
        return cell;
    }
    SFAssessItemCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAssessItemCellID forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ItemSubListModel * model = self.dataArray[indexPath.row];
    !self.selectClick?:self.selectClick(model);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
