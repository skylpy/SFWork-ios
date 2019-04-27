
//
//  SFAttendanceRulesViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAttendanceRulesViewController.h"
#import "SFPunchClockTimeViewController.h"
#import "SFPunchPositionViewController.h"
#import "SFLocationInforViewController.h"
#import "SFAllManagerViewController.h"
#import "SFEmployeeViewController.h"
#import "SFSpecialDateViewController.h"
#import "SFAddDataFooterView.h"
#import "SFAttendanceSetHttpModel.h"
#import "SFAttendanceSetModel.h"
#import "SFAllPowerCell.h"
#import "SFPickerView.h"

static NSString * const SFAttendanceRulesCellID = @"SFAttendanceRulesCellID";
static NSString * const SFAllPowerCellID = @"SFAllPowerCellID";

@interface SFAttendanceRulesViewController ()<UITableViewDelegate,UITableViewDataSource,DateTimePickerViewDelegate,SFPickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SFAddDataFooterView * footerView;
@property (nonatomic, strong) SFAttendanceSetModel * model;

@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *personnelArray;
@property (nonatomic, strong) NSMutableArray *specialArray;
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) NSMutableArray *reportArray;
@property (nonatomic, strong) NSMutableArray *magerArray;
@property (nonatomic, copy) NSArray *days;
@end

@implementation SFAttendanceRulesViewController

- (NSMutableArray *)magerArray{
    
    if (!_magerArray) {
        _magerArray = [NSMutableArray array];
    }
    
    return _magerArray;
}

- (NSMutableArray *)timeArray{
    
    if (!_timeArray) {
        _timeArray = [NSMutableArray array];
    }
    
    return _timeArray;
}

- (NSMutableArray *)personnelArray{
    
    if (!_personnelArray) {
        _personnelArray = [NSMutableArray array];
    }
    
    return _personnelArray;
}

- (NSMutableArray *)specialArray{
    
    if (!_specialArray) {
        _specialArray = [NSMutableArray array];
    }
    
    return _specialArray;
}

- (NSMutableArray *)addressArray{
    
    if (!_addressArray) {
        _addressArray = [NSMutableArray array];
    }
    
    return _addressArray;
}

- (NSMutableArray *)reportArray{
    
    if (!_reportArray) {
        _reportArray = [NSMutableArray array];
    }
    
    return _reportArray;
}

- (SFAddDataFooterView *)footerView {
    
    if (!_footerView) {
        
        _footerView = [SFAddDataFooterView shareSFAddDataFooterView];
        [_footerView.cancelButton setTitle:@"删除" forState:UIControlStateNormal];
        [_footerView.sureButton setTitle:@"保存" forState:UIControlStateNormal];
    }
    return _footerView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] initWithObjects:@"打卡位置如果不设置，就可以在任意地点进行打卡",@"可以接收和审批异常的考勤打卡记录",@"可以添加需要打卡的，和不用打卡的日期，灵活应变", nil];
    }
    
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"考勤组规则";
    [self initData];
    [self setDrawUI];
}


- (void)initData {
    
    if (self.smodel) {
        [MBProgressHUD showActivityMessageInWindow:@"加载中..."];
        [SFAttendanceSetHttpModel getTemplateDateil:self.smodel.id success:^(SFAttendanceModel * _Nonnull model) {
            
            [self.dataArray removeAllObjects];
            [self.timeArray removeAllObjects];
            [self.personnelArray removeAllObjects];
            [self.addressArray removeAllObjects];
            [self.specialArray removeAllObjects];
            [self.magerArray removeAllObjects];
            
            self.days = model.attendanceDateDTOList[0].days;
            [self.dataArray addObjectsFromArray:[SFAttendanceSetModel shareAttendanceSetModel:model]];
            
            [self.timeArray addObjectsFromArray:model.attendanceDateDTOList];
            [self.personnelArray addObjectsFromArray:model.attendancePersonnelDTOList];
            for (ReportUserModel * rum in model.reportUserList) {
                
                [self.magerArray addObject:rum.id];
            }
            
            [self.addressArray addObjectsFromArray:model.addressDTOList];
            [self.specialArray addObjectsFromArray:model.specialDateDTOList];
            [self.tableView reloadData];
            [MBProgressHUD hideHUD];
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
        }];
        
    }else{
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[SFAttendanceSetModel shareAttendanceSetModel]];
        
        [self.tableView reloadData];
    }
   
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.top.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
    
    @weakify(self)
    [self.footerView setSureClick:^(NSInteger index) {
        @strongify(self)
        if (index == 1) {
            
            NSArray * timeArr = [NSString arrayOrDicWithObject:self.timeArray];
            NSDictionary * dic = timeArr[0];
            NSMutableDictionary * d = dic.mutableCopy;
            [d setValue:self.days forKey:@"days"];
            NSArray * empArr = [NSString arrayOrDicWithObject:self.personnelArray];
            NSArray * addresArr = [NSString arrayOrDicWithObject:self.addressArray];
            NSArray * specialArr = [NSString arrayOrDicWithObject:self.specialArray];
            
            NSMutableDictionary * dict = [SFAttendanceSetModel pramJournalJson:self.dataArray];
            [dict setValue:@[d] forKey:@"attendanceDateDTOList"];
            [dict setValue:empArr forKey:@"attendancePersonnelDTOList"];
            [dict setValue:self.magerArray forKey:@"reportUserIds"];
            [dict setValue:addresArr forKey:@"addressDTOList"];
            [dict setValue:specialArr forKey:@"specialDateDTOList"];
        
            if (self.smodel) {
                [dict setValue:self.smodel.id forKey:@"id"];
            }
            
            NSLog(@"%@",dict);
            [self saveData:dict];
        }
    }];
}

- (void)saveData:(NSDictionary *)dict {
    
    [MBProgressHUD showActivityMessageInWindow:@"提交中..."];
    [SFAttendanceSetHttpModel saveTemplate:dict success:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"添加成功" completionBlock:^{
            !self.reduceClick?:self.reduceClick();
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0 || section == 1) {
        
        return 10;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0 || section == 1) {
        
        return [UIView new];
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    
    UILabel * titleLabel = [UILabel createALabelText:self.titleArray[section-2] withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#999999")];
    
    titleLabel.frame = CGRectMake(15, 10, kWidth-30, 15);
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
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
    SFAttendanceSetModel * model = array[indexPath.row];
    
    if (model.type == 8 || model.type == 9) {
        SFAllPowerCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAllPowerCellID forIndexPath:indexPath];;
        cell.model = model;
        [cell setSelectAllClick:^(BOOL isSelect) {
            
        }];
        return cell;
    }
    SFAttendanceRulesCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAttendanceRulesCellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray * array = self.dataArray[indexPath.section];
    SFAttendanceSetModel * model = array[indexPath.row];
    self.model = model;
    switch (model.type) {
        case 1:
            
            break;
        case 2:
        {
            SFPunchClockTimeViewController * vc = [SFPunchClockTimeViewController new];
            vc.array = self.smodel.attendanceDateDTOList;
            @weakify(self)
            [vc setSelectTimeClick:^(AttendanceDateModel * _Nonnull model) {
                @strongify(self)
                
                NSString * title = @" ";
                for (int i = 0; i < model.days.count; i ++) {
                    NSString * day = model.days[i];
                    switch ([day integerValue]) {
                        case 1:
                            title = [NSString stringWithFormat:@"%@ 星期一",title];
                            break;
                        case 2:
                            title = [NSString stringWithFormat:@"%@ 星期二",title];
                            break;
                        case 3:
                            title = [NSString stringWithFormat:@"%@ 星期三",title];
                            break;
                        case 4:
                            title = [NSString stringWithFormat:@"%@ 星期四",title];
                            break;
                        case 5:
                            title = [NSString stringWithFormat:@"%@ 星期五",title];
                            break;
                        case 6:
                            title = [NSString stringWithFormat:@"%@ 星期六",title];
                            break;
                        case 7:
                            title = [NSString stringWithFormat:@"%@ 星期日",title];
                            break;
                            
                        default:
                            break;
                    }
                }
                
                
                NSString * time = @" ";
                for (int i = 0; i < model.attendanceTimeDTOList.count; i ++) {
                    AttendanceTimeModel * mod = model.attendanceTimeDTOList[i];
                    
                    time = [NSString stringWithFormat:@"%@ %@ %@ ",time,mod.startTime,mod.endTime];
                }
                self.model.destitle = [NSString stringWithFormat:@"%@ %@",title,time];
                self.days = model.days;
                [self.timeArray addObject:model];
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            
            SFLocationInforViewController * vc = [SFLocationInforViewController new];
            vc.array = self.addressArray;
            @weakify(self)
            [vc setSelectTimeClick:^(NSArray * _Nonnull selectArr) {
                @strongify(self)
                [self.addressArray removeAllObjects];
                [self.addressArray addObjectsFromArray:selectArr];
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
        case 4:
        {
            SFEmployeeViewController * vc = [SFEmployeeViewController new];
            @weakify(self)
            [vc setSelectAllClick:^(NSArray * _Nonnull allArray) {
                @strongify(self)
                NSString * title = @" ";
                for (AttendancePersonnelModel * model  in allArray) {
                    title = [NSString stringWithFormat:@"%@ %@",title,model.targetName];
                }
                self.model.destitle = title;
                [self.personnelArray removeAllObjects];
                [self.personnelArray addObjectsFromArray:allArray];
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            SFAllManagerViewController * vc = [SFAllManagerViewController new];
            @weakify(self)
            [vc setSelectAllClick:^(NSArray * _Nonnull allArray) {
                @strongify(self)
                [self.magerArray removeAllObjects];
                NSString * title = @" ";
                for (ReportUserModel * model  in allArray) {
                    title = [NSString stringWithFormat:@"%@ %@",title,model.name];
                    [self.magerArray addObject:model.id];
                }
                self.model.destitle = title;
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            [self customArr:@[@"上班准点",@"上班提前5分钟",@"上班提前10分钟",@"上班提前15分钟"] withRow:indexPath.row];
        }
            break;
        case 7:
        {
            SFSpecialDateViewController * vc = [SFSpecialDateViewController new];
            vc.array = self.smodel.specialDateDTOList;
            @weakify(self)
            [vc setSelectAllClick:^(NSArray * _Nonnull allArray) {
                @strongify(self)
                NSString * title = @" ";
                for (SpecialDateModel * model  in allArray) {
                    title = [NSString stringWithFormat:@"%@ %@",title,model.specialDate];
                }
                self.model.destitle = title;
                [self.specialArray addObjectsFromArray:allArray];
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
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

#pragma SFPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text withRow:(NSInteger)row withSelectIndex:(NSInteger)selectIndex{
    
    [self.tableView reloadData];
    self.model.destitle = text;
    if ([text isEqualToString:@"上班准点"]) {
        self.model.value = @"0";
    }
    if ([text isEqualToString:@"上班提前10分钟"]) {
        self.model.value = @"10";
    }
    if ([text isEqualToString:@"上班提前15分钟"]) {
        self.model.value = @"15";
    }
    if ([text isEqualToString:@"上班提前5分钟"]) {
        self.model.value = @"5";
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerClass:[SFAttendanceRulesCell class] forCellReuseIdentifier:SFAttendanceRulesCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFAllPowerCell" bundle:nil] forCellReuseIdentifier:SFAllPowerCellID];
        
        
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
        UILabel * titleLabel = [UILabel createALabelText:@"员工打卡时必须拍照" withFont:[UIFont fontWithName:kRegFont size:13] withColor:Color(@"#999999")];
        
        titleLabel.frame = CGRectMake(15, 10, kWidth-30, 15);
        [footerView addSubview:titleLabel];
        
        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}

@end


@interface SFAttendanceRulesCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * startLabel;
@property (nonatomic, strong) UITextField * desTextField;


@end

@implementation SFAttendanceRulesCell


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
    [self addSubview:self.iconImage];
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
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
        make.width.offset(7);
        make.height.offset(13);
    }];
    
    [self.desTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.iconImage.mas_left).offset(-5);
        make.centerY.equalTo(self);
        make.width.offset(230);
        make.height.offset(30);
    }];
    RACChannelTo(self, self.model.destitle) = RACChannelTo(self.desTextField, text);
    self.titleLabel.textColor = Color(@"#666666");
}

- (void)setModel:(SFAttendanceSetModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.startLabel.text = model.stars;
    self.desTextField.text = model.destitle ;
    self.desTextField.placeholder = model.placeholder;
    self.desTextField.enabled = model.isClick ;
    
    if (model.type == 1) {
        self.iconImage.hidden = YES;
    }else{
        self.iconImage.hidden = NO;
    }
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

- (UIImageView *)iconImage{
    
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.image = [UIImage imageNamed:@"arrow_right_middle_gray"];
    }
    return _iconImage;
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

