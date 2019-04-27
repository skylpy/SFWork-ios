//
//  SFAddExpenseViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAddExpenseViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFExpenseHttpModel.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"
#import "SFExpenseModel.h"
#import "SFSelectPersonCell.h"
#import "SFExpenseCell.h"
#import "PickerTool.h"

static NSString * const SFExpenseCellID = @"SFExpenseCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFSelectPersonCellID = @"SFSelectPersonCellID";
static NSString * const SFExpenseTitleCellID = @"SFExpenseTitleCellID";


@interface SFAddExpenseViewController ()<UITableViewDelegate,UITableViewDataSource,SFExpenseCellDelegate,SFSuperSuborViewControllerDelagete,SFPhotoSelectCellDelegate,PickerToolDelegate,SFSelectPersonCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic,strong) PickerTool *pick;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, assign) NSInteger allMoney;
@property (nonatomic, strong) SFApprpvalModel *appModel;
@property (nonatomic, strong) NSMutableArray *copyIdArray;
@property (nonatomic, strong) NSMutableArray *copyIconArray;

@property (nonatomic, assign) BOOL isBack;

@end

@implementation SFAddExpenseViewController

- (NSMutableArray *)copyIdArray{
    
    if (!_copyIdArray) {
        _copyIdArray = [NSMutableArray array];
    }
    return _copyIdArray;
}

- (NSMutableArray *)copyIconArray{
    
    if (!_copyIconArray) {
        _copyIconArray = [NSMutableArray array];
    }
    return _copyIconArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)imageArray {
    
    if (!_imageArray) {
        
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"费用报销";
    
    [self setDrawUI];
    [self initData];
}

- (BOOL)navigationShouldPopOnBackButton{
    
    [UIAlertController alertTitle:@"确定离开" mesasge:@"数据未提交哦，离开后数据会丢失" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *alertAction) {
        self.isBack = YES;
        [self.navigationController popViewControllerAnimated:YES];
    } cancleHandler:^(UIAlertAction *cancelAction) {
        
    } viewController:self];
    
    return self.isBack;
}


- (void)initData {
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[SFExpenseModel shareCostListModel]];
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    self.index = 1;
    self.allMoney = 0;
    self.isBack = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.top.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    SFExpenseModel * model = array[indexPath.row];
    if (model.type == 3) {
        
        return 160;
    }
    if (model.type == 4 || model.type == 6) {
        
        return 120;
    }
    
    if (model.type == 5) {
        
        return 90;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == self.index-1) {
        
        return 40;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section <= self.index) {
        
        return 30;
    }
 
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == self.index-1) {
        
        UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
        lineView.backgroundColor = Color(@"#D8D8D8");
        [footer addSubview:lineView];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 1, kWidth, 39);
        [button setImage:[UIImage imageNamed:@"btn_add_cross_green"] forState:UIControlStateNormal];
        [button setTitle:@"增加报销明细" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:kRegFont size:13];
        button.backgroundColor = Color(@"#FFFFFF");
        [button setTitleColor:defaultColor forState:UIControlStateNormal];
        [footer addSubview:button];
        @weakify(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            self.index ++;
            [self.dataArray insertObject:[SFExpenseModel shareAddCostModel] atIndex:self.index-1];
            [self.tableView reloadData];
        }];
        return footer;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section < self.index) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
        UILabel * titleLabel = [UILabel createALabelText:[NSString stringWithFormat:@"报销明细(%ld)",section+1] withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#999999")];
        
        [header addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header.mas_left).offset(15);
            make.centerY.equalTo(header);
        }];
        UIButton * delbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [delbutton setTitle:@"删除" forState:UIControlStateNormal];
        delbutton.titleLabel.font = [UIFont fontWithName:kRegFont size:13];
        [delbutton setTitleColor:Color(@"#FF715A") forState:UIControlStateNormal];
        if (self.index > 1) {
            [header addSubview:delbutton];
            [delbutton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(header.mas_right).offset(-15);
                make.centerY.equalTo(header);
                make.width.offset(40);
                make.height.offset(20);
            }];
        }
        @weakify(self)
        [[delbutton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            self.index --;
            [self.dataArray removeObjectAtIndex:section];
            [self calculatedAmount];
            [self.tableView reloadData];
        }];
        return header;
    }
    if (section == self.index) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
        UILabel * titleLabel = [UILabel createALabelText:[NSString stringWithFormat:@"总报销金额(元)：%ld",self.allMoney] withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#999999")];
        self.titleLabel = titleLabel;
        [header addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header.mas_left).offset(15);
            make.centerY.equalTo(header);
        }];
        
        return header;
    }
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
    SFExpenseModel * model = array[indexPath.row];
    if (model.type == 3) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type == 4) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:NO withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    
    if (model.type == 5) {
        SFExpenseCell * cell = [tableView dequeueReusableCellWithIdentifier:SFExpenseCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = model;
        return cell;
    }
    if (model.type == 6) {
        SFSelectPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSelectPersonCellID forIndexPath:indexPath];
        cell.delegate = self;
        [cell cellImageArr:self.copyIconArray withIsE:YES];
        
        return cell;
        
    }
    SFExpenseTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:SFExpenseTitleCellID forIndexPath:indexPath];
    
    cell.model = model;
    
   
    @weakify(self)
    [cell setInputChacneClick:^(NSString * _Nonnull value) {
        @strongify(self)
        
        [self calculatedAmount];
    }];
    return cell;
}
//添加回调
- (void)cellPersonClickUpload:(NSArray *)imageArr{
    
    SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
    vc.delagete = self;
    vc.type = multipleType;
    vc.isSubor = NO;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//添加回调
- (void)cellClickUpload:(NSArray *)imageArr{
    
    [self.imageArray removeAllObjects];
    [self.imageArray addObjectsFromArray:imageArr];
    self.pick = [[PickerTool alloc]initWithMaxCount:1 selectedAssets:nil];
    self.pick.delegate = self;
    [self presentViewController:self.pick.imagePickerVcC animated:YES completion:nil];
}

//多选
- (void)multiplesSelectEmoloyee:(NSArray <SFEmployeesModel *> *)employees{
    
    [self.copyIdArray removeAllObjects];
    [self.copyIconArray removeAllObjects];
    
    for (SFEmployeesModel * model in employees) {
        
        [self.copyIdArray addObject:model._id];
        [self.copyIconArray addObject:model.avatar];
    }
    
    [self.tableView reloadData];
}

#pragma mark- PickerToolDelegate
- (void)didPickedPhotos:(NSString *)fileName{
    
    if (self.pick.selectedPhotos.count > 0) {
        [[SFAliOSSManager sharedInstance] asyncUploadMultiImages:self.pick.selectedPhotos withFile:fileName withFolderName:@"Image" CompeleteBlock:^(NSArray *nameArray) {
            NSLog(@"nameArray is %@", nameArray);
            [self files:nameArray];
        } ErrowBlock:^(NSString *errrInfo) {
            
        }];
    }
}

- (void)files:(NSArray *)nameArr {
    
    NSDictionary * dic = nameArr[0];
    NSString *img = dic[@"Img"];
    
    [self.imageArray addObject:img];
    [self.tableView reloadData];
}

#pragma SFExpenseCell   选择人员
- (void)cellSelectModel:(SFApprpvalModel *)model{
    self.appModel = model;
    if ([model.value isEqualToString:[SFInstance shareInstance].userInfo._id]) return;
    SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
    vc.delagete = self;
    vc.type = singleType;
    vc.isSubor = NO;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    self.appModel.detitle = employee.name;
    self.appModel.value = employee._id;
    [self.tableView reloadData];
}

- (void)calculatedAmount {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        self.allMoney = 0;
        for (NSArray * arr in self.dataArray) {
            
            for (SFExpenseModel * mod  in arr) {
                
                if (mod.type == 1) {
                    
                    self.allMoney = [mod.destitle integerValue] + self.allMoney;
                }
            }
        }
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            NSLog(@"=== %ld",self.allMoney);
            self.titleLabel.text = [NSString stringWithFormat:@"总报销金额(元)：%ld",self.allMoney];
        });
        
    });
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerClass:[SFExpenseTitleCell class] forCellReuseIdentifier:SFExpenseTitleCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFSelectPersonCell" bundle:nil] forCellReuseIdentifier:SFSelectPersonCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFExpenseCell" bundle:nil] forCellReuseIdentifier:SFExpenseCellID];
    }
    return _tableView;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"提交" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.backgroundColor = Color(@"#01B38B");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self saveExpense];
        }];
    }
    return _saveButton;
}

- (void)saveExpense{
    
//    NSArray * array = self.dataArray;
//    NSArray * array = self.dataArray[indexPath.section];
//    SFExpenseModel * model = array[indexPath.row];
    NSMutableArray * arrays = [NSMutableArray array];
    NSMutableDictionary * dicts = [NSMutableDictionary dictionary];
    for (NSArray * array in self.dataArray) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        for (SFExpenseModel * model in array) {
            
            if (model.type == 1) {
                [dict setValue:model.destitle forKey:@"amount"];
            }
            if (model.type == 2) {
                [dict setValue:model.destitle forKey:@"category"];
            }
            if (model.type == 3) {
                [dict setValue:model.destitle forKey:@"detail"];
            }
            if (model.type == 5) {
                
                for (SFApprpvalModel * appmodel in model.persons) {
                    
                    if ([appmodel.title isEqualToString:@"审核人："]) {
                        [dicts setValue:appmodel.value forKey:@"checkerId"];
                    }
                    if ([appmodel.title isEqualToString:@"审批人："]) {
                        [dicts setValue:appmodel.value forKey:@"approverId"];
                    }
                    if ([appmodel.title isEqualToString:@"出纳人："]) {
                        [dicts setValue:appmodel.value forKey:@"cashierId"];
                    }
                }
            }
        }
        
        if (dict.count) {
            [arrays addObject:dict];
        }
    }
    
    [dicts setObject:arrays forKey:@"reimbursementItemDTOList"];
    [dicts setObject:self.copyIdArray forKey:@"copyToIds"];
    [dicts setObject:self.imageArray forKey:@"photoList"];
    NSLog(@" ======= %@>>>>",dicts);
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFExpenseHttpModel postAddExpense:dicts success:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"添加成功" completionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showWarnMessage:@"添加失败"];
    }];
}

@end


@interface SFExpenseTitleCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * startLabel;
@property (nonatomic, strong) UITextField * desTextField;

@end

@implementation SFExpenseTitleCell


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
//        make.width.offset(200);
        make.height.offset(30);
    }];
    RACChannelTo(self, self.model.destitle) = RACChannelTo(self.desTextField, text);
    
    [[self.desTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {

        if (self.model.type == 1) {
            
            !self.inputChacneClick?:self.inputChacneClick(x);
        }
    }];
    
    
    //双向绑定
    //    if (self.model) {
    //
    //    }else{
    //
    //    }
    
}

- (void)setModel:(SFExpenseModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.startLabel.text = model.stars;
    self.desTextField.text = model.destitle ;
    self.desTextField.placeholder = model.placeholder;
    self.desTextField.enabled = model.isClick ;
    if (model.type == 1) {
        
        self.desTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [UILabel creatLabelWithFontName:kRegFont TextColor:Color(@"#333333") FontSize:14 Text:@"头像"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
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
