//
//  SFLeaveApplicationViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFLeaveApplicationViewController.h"
#import "SFAttenDateilViewController.h"
#import "SFAllManagerViewController.h"
#import "SFMyAttendanceModel.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"
#import "SFExpenseModel.h"
#import "SFSelectPersonCell.h"
#import "SFApprovalProCell.h"
#import "SFExpenseCell.h"
#import "PickerTool.h"
#import "SFSetTypeModel.h"
#import "SFPickerView.h"
#import "SFSelectAapprovalPersonCell.h"
#import "SFAttendanceSetHttpModel.h"
#import "SFAttendanceMgrHttpModel.h"

static NSString * const SFExpenseCellID = @"SFExpenseCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFSelectPersonCellID = @"SFSelectPersonCellID";
static NSString * const SFAttenApplicationCellID = @"SFAttenApplicationCellID";
static NSString * const SFSelectAapprovalPersonCellID = @"SFSelectAapprovalPersonCellID";
static NSString * const SFApplicationCellID = @"SFApplicationCellID";


@interface SFLeaveApplicationViewController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate,SFPhotoSelectCellDelegate,PickerToolDelegate,SFPickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DateTimePickerView *timePickerView;
@property (nonatomic, strong) SFMyAttendanceModel *model;
@property (nonatomic,strong) PickerTool *pick;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, strong) NSMutableArray *typeArray;

@property (nonatomic, strong) NSMutableArray * approvalArray;
@property (nonatomic, strong) NSMutableArray * copListArray;

@end

@implementation SFLeaveApplicationViewController

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


- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)typeArray {
    
    if (!_typeArray) {
        _typeArray = [NSMutableArray array];
    }
    return _typeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请假";
    [self setDrawUI];
    [self initData];
    [self getType];
}



- (void)getType{
    
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    [SFSetTypeModel getCompanySetting:@"LEAVE_TYPE" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
        
        [MBProgressHUD hideHUD];
        [self.typeArray removeAllObjects];
        [self.typeArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)initData {
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[SFMyAttendanceModel shareMyAttendanceLeaveModelModel]];
    
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
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
    SFAttendanceMgrModel * model = array[indexPath.row];
    
    
    if (model.type == 5) {
        
        return 160;
    }
    if (model.type == 6) {
        
        return 120;
    }
    if ( model.type == 7 || model.type == 8) {
        
        return 155;
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
    SFMyAttendanceModel * model = array[indexPath.row];
    if (model.type == 4) {
        
        SFApplicationCell * cell = [tableView dequeueReusableCellWithIdentifier:SFApplicationCellID forIndexPath:indexPath];
        
        cell.model =  model;
        
        return cell;
    }
    if (model.type == 5) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type == 6) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:NO withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    
    if (model.type == 7) {
        
        SFSelectAapprovalPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSelectAapprovalPersonCellID forIndexPath:indexPath];
        cell.model = model;
        cell.array = self.approvalArray;
        @weakify(self)
        [cell setAddPeopleClick:^{
            @strongify(self)
            SFAllManagerViewController * vc = [SFAllManagerViewController new];
            @weakify(self)
            [vc setSelectAllClick:^(NSArray * _Nonnull allArray) {
                @strongify(self)
                [self.approvalArray removeAllObjects];
                [self.approvalArray addObjectsFromArray:allArray];
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
    
    if (model.type == 8) {
        SFSelectAapprovalPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSelectAapprovalPersonCellID forIndexPath:indexPath];
        cell.model = model;
        cell.array = self.copListArray;
        @weakify(self)
        [cell setAddPeopleClick:^{
            @strongify(self)
            SFAllManagerViewController * vc = [SFAllManagerViewController new];
            @weakify(self)
            [vc setSelectAllClick:^(NSArray * _Nonnull allArray) {
                @strongify(self)
                [self.copListArray removeAllObjects];
                [self.copListArray addObjectsFromArray:allArray];
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        return cell;
    }
    SFAttenApplicationCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAttenApplicationCellID forIndexPath:indexPath];
    
    cell.model =  model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * array = self.dataArray[indexPath.section];
    SFMyAttendanceModel * model = array[indexPath.row];
    self.model = model;
    
    switch (model.type ) {
        case 1:
            {
                //客户类型
                NSMutableArray * array = [NSMutableArray array];
                for (SFSetTypeModel * model in self.typeArray) {
                    [array addObject:model.name];
                }
                [self customArr:array withRow:indexPath.row];
            }
            break;
        case 2:
            [self selectTime:DatePickerViewDateTimeMode];
            break;
        case 3:
            [self selectTime:DatePickerViewDateTimeMode];
            break;
        default:
            break;
    }
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
    SFSetTypeModel * model = self.typeArray[row];
    self.model.value = model._id;
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
    
    [self.tableView reloadData];
    
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
            
            NSMutableArray * appArray = [NSMutableArray array];
            NSInteger index = 1;
            for (ReportUserModel * model in self.approvalArray) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                [dic setValue:model.id forKey:@"auditUserId"];
                [dic setValue:@(index) forKey:@"approvalNum"];
                index ++;
                [appArray addObject:dic];
            }
            
            NSMutableArray * copyArray = [NSMutableArray array];
            
            for (ReportUserModel * model in self.copListArray) {
                
                [copyArray addObject:model.id];
            }
            
            NSMutableDictionary * dict = [SFMyAttendanceModel pramMyAttendanceJson:self.dataArray];
            [dict setValue:@"LEAVE" forKey:@"applicationType"];
            [dict setValue:appArray forKey:@"approvalProcessDTOS"];
            [dict setValue:copyArray forKey:@"copyToIds"];
            [dict setValue:self.imageArray forKey:@"photos"];
            
            NSLog(@"%@",dict);
            [self saveData:dict];
        }];
    }
    return _saveButton;
}

- (void)saveData:(NSDictionary *)dict {
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFAttendanceMgrHttpModel submitApproval:dict success:^{
        
        [MBProgressHUD hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerClass:[SFAttenApplicationCell class] forCellReuseIdentifier:SFAttenApplicationCellID];
         [_tableView registerClass:[SFApplicationCell class] forCellReuseIdentifier:SFApplicationCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFSelectPersonCell" bundle:nil] forCellReuseIdentifier:SFSelectPersonCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFExpenseCell" bundle:nil] forCellReuseIdentifier:SFExpenseCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFSelectPersonCell" bundle:nil] forCellReuseIdentifier:SFSelectPersonCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFSelectAapprovalPersonCell" bundle:nil] forCellReuseIdentifier:SFSelectAapprovalPersonCellID];
    }
    return _tableView;
}

@end


@interface SFAttenApplicationCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * startLabel;
@property (nonatomic, strong) UITextField * desTextField;
@property (nonatomic, strong) UIImageView *arrowIcon;
@end

@implementation SFAttenApplicationCell


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
    [self addSubview:self.arrowIcon];
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
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
        make.width.offset(7);
        make.height.offset(13);
    }];
    [self.desTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.arrowIcon.mas_left).offset(-5);
        make.centerY.equalTo(self);
        make.width.offset(200);
        make.height.offset(30);
    }];
    RACChannelTo(self, self.model.destitle) = RACChannelTo(self.desTextField, text);
    @weakify(self)
    [[self.desTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.model.destitle = x;
    }];
}



- (void)setModel:(SFMyAttendanceModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.startLabel.text = model.stars;
    self.desTextField.text = model.destitle ;
    self.desTextField.placeholder = model.placeholder;
    self.desTextField.enabled = model.isClick ;
    
}

- (UIImageView *)arrowIcon{
    
    if (!_arrowIcon) {
        
        _arrowIcon = [[UIImageView alloc] init];
        _arrowIcon.image = [UIImage imageNamed:@"arrow_right_middle_gray"];
    }
    return _arrowIcon;
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

@interface SFApplicationCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * startLabel;
@property (nonatomic, strong) UITextField * desTextField;
@property (nonatomic, strong) UILabel * dayLabel;
@end

@implementation SFApplicationCell


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
    [self addSubview:self.dayLabel];
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
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
        make.width.offset(15);
        make.height.offset(13);
    }];
    [self.desTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.dayLabel.mas_left).offset(-2);
        make.centerY.equalTo(self);
        make.width.offset(200);
        make.height.offset(30);
    }];
    RACChannelTo(self, self.model.destitle) = RACChannelTo(self.desTextField, text);
    
}



- (void)setModel:(SFMyAttendanceModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.startLabel.text = model.stars;
    self.desTextField.text = model.destitle ;
    self.desTextField.placeholder = model.placeholder;
    self.desTextField.enabled = model.isClick ;
    
}

- (UILabel *)dayLabel{
    
    if (!_dayLabel) {
        
        _dayLabel = [UILabel createALabelText:@"天" withFont:[UIFont fontWithName:kRegFont size:14] withColor:Color(@"#999999")];
    }
    return _dayLabel;
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
