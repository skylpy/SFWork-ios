//
//  SFAddAnnounceViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAddAnnounceViewController.h"
#import "SFAnnounceModel.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"
#import "SFAnnounceHttpModel.h"
#import "SFSelectItemView.h"
#import "SFSuperSuborViewController.h"
#import "PickerTool.h"

static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFAnnounceTitleCellID = @"SFAnnounceTitleCellID";

@interface SFAddAnnounceViewController ()<UITableViewDelegate,UITableViewDataSource,SFPhotoSelectCellDelegate,PickerToolDelegate,SFSuperSuborViewControllerDelagete,DateTimePickerViewDelegate>

@property (nonatomic,strong) PickerTool *pick;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, strong) SFSelectItemView *selectItemView;
@property (nonatomic, strong) NSMutableArray *persons;
@property (nonatomic, copy) NSString *publishType;
@property (nonatomic, assign) BOOL publish;

@property (nonatomic, strong) SFAnnounceModel * model;

@end

@implementation SFAddAnnounceViewController

- (NSMutableArray *)persons{
    
    if (!_persons) {
        _persons = [NSMutableArray array];
    }
    return _persons;
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

- (SFSelectItemView *)selectItemView {
    
    if (!_selectItemView) {
        _selectItemView = [SFSelectItemView shareSFSelectItemView];
    }
    return _selectItemView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"创建通知公告";
    [self initData];
    [self setDrawUI];
}

- (void)initData {
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[SFAnnounceModel shareAddAnnounceModel]];
    [self.tableView reloadData];
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
    
    SFAnnounceModel * model = self.dataArray[indexPath.row];
    if (model.type == 4) {
        
        return 135;
    }
    if (model.type == 5) {
        
        return 120;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SFAnnounceModel * model = self.dataArray[indexPath.row];
    if (model.type == 4) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type ==5) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:NO withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    
    
    SFAnnounceTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAnnounceTitleCellID forIndexPath:indexPath];
    
    cell.model = model;
    
    @weakify(self)
    [cell setInputChacneClick:^(NSString * _Nonnull value) {
        @strongify(self)
        
       
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SFAnnounceModel * model = self.dataArray[indexPath.row];
    self.model = model;
    if (model.type == 2) {
        [self.selectItemView showFromView:LSKeyWindow withTitle:@"请选择发布时间" withData:@[@"选择发布时间",@"立即发布",@"暂时不发布",@"取消"] selectClick:^(NSString * _Nonnull type) {
            
            if ([type isEqualToString:@"选择发布时间"]) {
                
                self.publishType = @"IMMEDIATELY";
                self.publish = NO;
                [self selectTime:DatePickerViewDateTimeMode];
            }
            if ([type isEqualToString:@"立即发布"]) {
                
                self.publishType = @"TIMING";
                self.publish = YES;
            }
            if ([type isEqualToString:@"暂时不发布"]) {
                
                self.publishType = @"NOTYET";
                self.publish = NO;
            }
        }];
    }
    if (model.type == 3) {
        SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
        vc.delagete = self;
        vc.type = multipleType;
        vc.isSubor = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)selectTime:(DatePickerViewMode)type{
    
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    
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

//多选
- (void)multiplesSelectEmoloyee:(NSArray <SFEmployeesModel *> *)employees{
    
    [self.persons removeAllObjects];
    NSString * title = @"";
    for (int i = 0; i < employees.count; i ++) {
        SFEmployeesModel * mod = employees[i];
        if (i == 0) {
            title = mod.name;
        }else{
            title = [NSString stringWithFormat:@"%@ %@",title,mod.name];
        }
        [self.persons addObject:mod._id];
    }
    self.model.destitle = title;
    [self.tableView reloadData];
}


- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerClass:[SFAnnounceTitleCell class] forCellReuseIdentifier:SFAnnounceTitleCellID];
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
           
            [self saveData];
        }];
    }
    return _saveButton;
}

- (void)saveData {
    
    NSMutableDictionary * dict = [SFAnnounceModel pramMyAnnounceJson:self.dataArray];
    
    [dict setValue:@(self.publish) forKey:@"publish"];
    [dict setValue:self.publishType forKey:@"publishType"];
    [dict setValue:self.imageArray forKey:@"photos"];
    [dict setValue:self.persons forKey:@"informationUserIds"];
    
    [MBProgressHUD showActivityMessageInWindow:@""];
    [SFAnnounceHttpModel submitInformation:dict success:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"提交成功" completionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:@"失败"];
    }];
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

@end

@interface SFAnnounceTitleCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * startLabel;
@property (nonatomic, strong) UITextField * desTextField;

@end

@implementation SFAnnounceTitleCell


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
    
    [[self.desTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        
        if (self.model.type == 1) {
            
            !self.inputChacneClick?:self.inputChacneClick(x);
        }
    }];
    
}

- (void)setModel:(SFAnnounceModel *)model{
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
