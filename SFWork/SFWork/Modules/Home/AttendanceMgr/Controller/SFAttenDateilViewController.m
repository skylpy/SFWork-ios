
//
//  SFAttenDateilViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAttenDateilViewController.h"
#import "SFAttendanceMgrModel.h"
#import "SFAttendanceMgrHttpModel.h"
#import "SFSelectAapprovalPersonCell.h"
#import "SFAddDataFooterView.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"
#import "SFExpenseModel.h"
#import "SFSelectPersonCell.h"
#import "SFApprovalProCell.h"

#import "SFExpenseCell.h"
static NSString * const SFExpenseCellID = @"SFExpenseCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFSelectPersonCellID = @"SFSelectPersonCellID";
static NSString * const SFAttenTitleCellID = @"SFAttenTitleCellID";
static NSString * const SFApprovalProCellID = @"SFApprovalProCellID";
static NSString * const SFSelectAapprovalPersonCellID = @"SFSelectAapprovalPersonCellID";


@interface SFAttenDateilViewController ()<UITableViewDelegate,UITableViewDataSource,SFPhotoSelectCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray * approvalArray;
@property (nonatomic, strong) NSMutableArray * copListArray;

@property (nonatomic, strong) SFAddDataFooterView *footerView;
@property (nonatomic,strong) UIButton * saveButton;

@end

@implementation SFAttenDateilViewController

- (SFAddDataFooterView *)footerView {
    
    if (!_footerView) {
        
        _footerView = [SFAddDataFooterView shareSFAddDataFooterView];
        [_footerView.cancelButton setTitle:@"驳回" forState:UIControlStateNormal];
        [_footerView.sureButton setTitle:@"通过" forState:UIControlStateNormal];
    }
    return _footerView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)approvalArray{
    
    if (!_approvalArray) {
        _approvalArray = [NSMutableArray array];
    }
    return _approvalArray;
}

- (NSMutableArray *)copListArray{
    
    if (!_copListArray) {
        _copListArray = [NSMutableArray array];
    }
    return _copListArray;
}

- (NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.atype == LEAVE?@"请假详情":self.atype == BUSINESS_TRAVEL?@"出差详情":@"加班详情";
    [self setDrawUI];
    [self initData];
}

- (void)initData {
    
    [SFAttendanceMgrHttpModel getApprovalDetails:self.model._id success:^(ApprovalDetailsModel * _Nonnull model) {
        
        [self.dataArray removeAllObjects];
        [self.imageArray removeAllObjects];
        [self.copListArray removeAllObjects];
        [self.approvalArray removeAllObjects];
        if (self.atype == LEAVE) {
            
            [self.dataArray addObjectsFromArray:[SFAttendanceMgrModel shareAttendanceMgrDateilModel:model]];
            
        }else if (self.atype == BUSINESS_TRAVEL){
            
            [self.dataArray addObjectsFromArray:[SFAttendanceMgrModel shareMyAttendanceTripModelModel:model]];
            
        }else{
            
            [self.dataArray addObjectsFromArray:[SFAttendanceMgrModel shareMyAttendanceOvertimeModelModel:model]];
        }
        
        [self.imageArray addObjectsFromArray:model.photos];
        [self.copListArray addObjectsFromArray:model.copToId];
        [self.approvalArray addObjectsFromArray:model.approvalProcessDTOS];
        [self.tableView reloadData];
        if ([model.createId isEqualToString:[SFInstance shareInstance].userInfo._id]&& [model.auditStatus isEqualToString:@"UNAUDITED"]&&self.type == MySend) {
            [self.view addSubview:self.saveButton];
            [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.offset(45);
            }];
        }
        NSMutableArray * arr = [NSMutableArray array];
        ApprovalProcessModel * mod1 = nil;
        for (ApprovalProcessModel * mod in self.approvalArray) {
            [arr addObject:mod.auditUserId];
            if ([[SFInstance shareInstance].userInfo._id isEqualToString:mod.auditUserId]) {
                mod1 = mod;
            }
        }
        if ([arr containsObject:[SFInstance shareInstance].userInfo._id]&& mod1 != nil && [mod1.applicationStatus isEqualToString:@"UNAUDITED"]&&self.type == Manager) {
            [self.view addSubview:self.footerView];
            [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.offset(50);
            }];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.top.left.right.equalTo(self.view);
    }];
    
    @weakify(self)
    [self.footerView setSureClick:^(NSInteger index) {
        @strongify(self)
        
        if (index == 0) {
            SFAlertInputView * alert=[[SFAlertInputView alloc] initWithTitle:@"驳回原因" PlaceholderText:@"请输入驳回原因" WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
                NSLog(@"-----%@",contents);
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setValue:contents forKey:@"result"];
                [dict setValue:self.model._id forKey:@"id"];
                [self approvalReject:dict];
            }];
            [alert show];
        }else{
            
            [self approvalSuccess];
        }
    }];
}

- (void)approvalSuccess{
    
    [SFAttendanceMgrHttpModel getApprovalAdopt:self.model._id success:^{
        
        [MBProgressHUD showSuccessMessage:@"已同意成功"];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showTipMessageInWindow:@"已同意失败"];
    }];
}
- (void)approvalReject:(NSDictionary *)dict{
    
    [SFAttendanceMgrHttpModel rejectApproval:dict success:^{
        [MBProgressHUD showSuccessMessage:@"已拒绝成功"];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showTipMessageInWindow:@"已拒绝失败"];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    SFAttendanceMgrModel * model = array[indexPath.row];
    
    
    if (model.type == 6) {
        
        return 120;
    }
    if (model.type == 5) {
        
        return 160;
    }
    if ( model.type == 7 || model.type == 8) {
        
        return 175;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    SFAttendanceMgrModel * model = array[indexPath.row];
    if (model.type == 5) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type == 6) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:YES withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    
    if (model.type == 7) {
        
        SFSelectAapprovalPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSelectAapprovalPersonCellID forIndexPath:indexPath];
        cell.model = (SFMyAttendanceModel *)model;
        [cell cellContent:self.approvalArray withType:NO withCopy:NO];
        
        return cell;
    }
    
    if (model.type == 8) {
        SFSelectAapprovalPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSelectAapprovalPersonCellID forIndexPath:indexPath];
        cell.model = (SFMyAttendanceModel *)model;
        [cell cellContent:self.copListArray withType:NO withCopy:YES];
       
        
        return cell;
    }
    SFAttenTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAttenTitleCellID forIndexPath:indexPath];
    
    cell.model = model;
    
    return cell;
}

//查看回调
- (void)openClickLook:(NSArray *)imageArr withRow:(NSInteger)row withView:(nonnull UIView *)superView{
    
    NSMutableArray<YYPhotoGroupItem *> *items = [NSMutableArray array];
    
    for (NSString * urlString in imageArr) {
        NSString * constrainURL = [NSString getAliOSSConstrainURL:urlString];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.largeImageURL = [NSURL URLWithString:constrainURL];
        
        [items addObject:item];
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    
    [v presentFromImageView:self.view toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerClass:[SFAttenTitleCell class] forCellReuseIdentifier:SFAttenTitleCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFSelectPersonCell" bundle:nil] forCellReuseIdentifier:SFSelectPersonCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFExpenseCell" bundle:nil] forCellReuseIdentifier:SFExpenseCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFApprovalProCell" bundle:nil] forCellReuseIdentifier:SFApprovalProCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFSelectAapprovalPersonCell" bundle:nil] forCellReuseIdentifier:SFSelectAapprovalPersonCellID];
    }
    return _tableView;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"撤回" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.backgroundColor = Color(@"#FF715A");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self recallApproval];
        }];
    }
    return _saveButton;
}

- (void)recallApproval{
    
    [SFAttendanceMgrHttpModel getApprovalRecalls:self.model._id success:^{
        [MBProgressHUD showSuccessMessage:@"撤回成功" completionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showTipMessageInWindow:@"撤回失败"];
    }];
}

@end


@interface SFAttenTitleCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * startLabel;
@property (nonatomic, strong) UITextField * desTextField;

@end

@implementation SFAttenTitleCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    
    [self addSubview:self.startLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.desTextField];
    
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.offset(7);
        make.left.equalTo(self.mas_left).offset(6);
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.startLabel.mas_right).offset(6);
        make.centerY.equalTo(self);
    }];
    
    [self.desTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
        make.width.offset(200);
        make.height.offset(30);
    }];
    RACChannelTo(self, self.model.destitle) = RACChannelTo(self.desTextField, text);

}

- (void)setModel:(SFAttendanceMgrModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.startLabel.text = model.stars;
    self.desTextField.text = model.destitle ;
    self.desTextField.placeholder = model.placeholder;
    self.desTextField.enabled = model.isClick ;
    
}


- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [UILabel creatLabelWithFontName:kRegFont TextColor:Color(@"#333333") FontSize:14 Text:@"头像"];
    }
    
    return _titleLabel;
}

- (UILabel *)startLabel{
    
    if (!_startLabel) {
        _startLabel = [UILabel creatLabelWithFontName:kRegFont TextColor:[UIColor redColor] FontSize:14 Text:@"*"];
    }
    
    return _startLabel;
}

- (UITextField *)desTextField{
    
    if (!_desTextField) {
        UITextField * textField = [[UITextField alloc] init];
        _desTextField = textField;
        textField.textAlignment = NSTextAlignmentRight;
        textField.tintColor = Color(@"#333333");
        textField.font = [UIFont fontWithName:kRegFont size:14];
    }
    
    return _desTextField;
}

@end

