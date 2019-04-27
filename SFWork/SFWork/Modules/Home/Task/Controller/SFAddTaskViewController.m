//
//  SFAddTaskViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAddTaskViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"
#import "SFSetTypeModel.h"
#import "SFTaskHttpModel.h"
#import "SFTaskModel.h"
#import "PickerTool.h"
#import "SFPickerView.h"


static NSString * const SFAddTaskCellID = @"SFAddTaskCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";

@interface SFAddTaskViewController ()<UITableViewDelegate,UITableViewDataSource,SFPhotoSelectCellDelegate,PickerToolDelegate,SFPickerViewDelegate,DateTimePickerViewDelegate,SFSuperSuborViewControllerDelagete>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *taskArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic,strong) PickerTool *pick;
@property (nonatomic, strong) SFTaskModel * model;
@property (nonatomic, strong) DateTimePickerView *timePickerView;
@property (nonatomic, strong) NSMutableArray *adminArray;
@property (nonatomic, strong) NSMutableArray *empArray;
@end

@implementation SFAddTaskViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)adminArray{
    
    if (!_adminArray) {
        _adminArray = [NSMutableArray array];
    }
    return _adminArray;
}

- (NSMutableArray *)empArray{
    
    if (!_empArray) {
        _empArray = [NSMutableArray array];
    }
    return _empArray;
}

- (NSMutableArray *)taskArray{
    
    if (!_taskArray) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}

- (NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增任务";
    [self setDrawUI];
    [self getData];
    [self initData];
}

- (void)getData {
    
    [self.dataArray addObjectsFromArray:[SFTaskModel shareAddTaskModel:self.isSelf]];
    [self.tableView reloadData];
    
}

- (void)initData{
    
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    [SFSetTypeModel getCompanySetting:@"TASK_TYPE" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.taskArray removeAllObjects];
        [self.taskArray addObjectsFromArray:list];
        
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)setDrawUI {
    
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
    SFTaskModel * model = self.dataArray[indexPath.row];
    if (model.type == 8) {
        
        return 203;
    }
    if (model.type == 9) {
        
        return 120;
    }
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFTaskModel * model = self.dataArray[indexPath.row];
    if (model.type == 8) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type == 9) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:NO withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    SFAddTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddTaskCellID forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFTaskModel * model = self.dataArray[indexPath.row];
    self.model = model;
    switch (model.type) {
        case 2:
        {
            //客户类型
            NSMutableArray * array = [NSMutableArray array];
            for (SFSetTypeModel * model in self.taskArray) {
                [array addObject:model.name];
            }
            [self customArr:array withRow:indexPath.row];
        }
            break;
        case 3:
            [self selectTime:DatePickerViewDateTimeMode];
            break;
        case 4:
            [self customArr:@[@"非常紧急",@"紧急",@"普通"] withRow:indexPath.row];
            break;
        
        case 6:
        {
            SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
            vc.isSubor = NO;
            vc.delagete = self;
            vc.type = multipleType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            if (self.isSelf) return;
            SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
            vc.isSubor = YES;
            vc.delagete = self;
            vc.type = multipleType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}

//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    
}
//多选
- (void)multiplesSelectEmoloyee:(NSArray <SFEmployeesModel *> *)employees{
    
    NSLog(@"%ld",employees.count);
    
    for (int i = 0; i < employees.count; i ++) {
        SFEmployeesModel * model = employees[i];
        if (self.model.type == 6) {
            [self.adminArray removeAllObjects];
            [self.adminArray addObject:model._id];
        }
        if (self.model.type == 7) {
            [self.empArray removeAllObjects];
            [self.empArray addObject:model._id];
        }
        if (i == 0) {
            self.model.destitle = model.name;
        }else{
            self.model.destitle = [NSString stringWithFormat:@"%@,%@",self.model.destitle,model.name];
        }
    }
    
    [self.tableView reloadData];
}

//添加回调
- (void)cellClickUpload:(NSArray *)imageArr{
    
    [self.imageArray removeAllObjects];
    [self.imageArray addObjectsFromArray:imageArr];
    self.pick = [[PickerTool alloc]initWithMaxCount:1 selectedAssets:nil];
    self.pick.delegate = self;
    [self presentViewController:self.pick.imagePickerVcC animated:YES completion:nil];
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

- (void)customArr:(NSArray *)array withRow:(NSInteger)row{
    
    SFPickerView *picker = [[SFPickerView alloc] initWithFrame:self.view.bounds];
    picker.delegate = self ;
    picker.row = row;
    picker.customArr = array;
    [LSKeyWindow addSubview:picker];
}
#pragma mark- SFPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text withRow:(NSInteger)row withSelectIndex:(NSInteger)selectIndex{
    
    self.model.destitle = text;
    NSInteger index = [pickerView selectedRowInComponent:0];
    if (self.model.type == 2) {
        SFSetTypeModel * model = self.taskArray[row];
        self.model.value = model._id;
    }
    [self.tableView reloadData];
}

- (void)selectTime:(DatePickerViewMode)type{
    
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    self.timePickerView = pickerView;
    pickerView.delegate = self;
    pickerView.pickerViewMode = type;
    [LSKeyWindow addSubview:pickerView];
    [pickerView showDateTimePickerView];
}
#pragma mark - delegate

- (void)didClickFinishDateTimePickerView:(NSString *)date{
    NSLog(@"%@",date);
    self.model.destitle = date;
//    self.qCreateTime = date;
    if (self.model.type == 2) {
        //        self.smodel.startTime = date;
    }
    if (self.model.type == 3) {
        //        self.smodel.endTime = date;
    }
    [self.tableView reloadData];
    
//    [self getSearchDailyLists];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerClass:[SFAddTaskCell class] forCellReuseIdentifier:SFAddTaskCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
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
            [self addTask];
        }];
    }
    return _saveButton;
}

- (void)addTask{
    NSMutableDictionary * dict = [SFTaskModel pramAddTaskJson:self.dataArray];
    [dict setObject:self.imageArray forKey:@"photos"];
    [dict setObject:self.adminArray forKey:@"auditUserListIds"];
    if (self.isSelf) {
        [dict setObject:[SFInstance shareInstance].userInfo._id forKey:@"executorId"];
    }else{
        if (self.empArray.count>0) {
            [dict setObject:self.empArray[0] forKey:@"executorId"];
        }
        
    }
    
    [dict setValue:@(self.isSelf) forKey:@"isSelf"];
    
    NSLog(@"==%@",dict);
    [MBProgressHUD showActivityMessageInWindow:@"正在提交.."];
    [SFTaskHttpModel autoCreateAddTask:dict success:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"任务添加成功" completionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:@"任务添加失败"];
    }];
}

@end


@interface SFAddTaskCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * startLabel;
@property (nonatomic, strong) UITextField * desTextField;

@end

@implementation SFAddTaskCell


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
    //双向绑定
    //    if (self.model) {
    //
    //    }else{
    //
    //    }
    
}

- (void)setModel:(SFTaskModel *)model{
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
