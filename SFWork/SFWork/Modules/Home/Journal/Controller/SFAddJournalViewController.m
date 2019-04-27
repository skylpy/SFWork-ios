//
//  SFAddJournalViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAddJournalViewController.h"
#import "SFSuperSuborViewController.h"
#import "SFProfileTableCell.h"
#import "SFPhotoSelectCell.h"
#import "SFJournalHttpModel.h"
#import "SFJournalModel.h"
#import "SFTextViewCell.h"
#import "PickerTool.h"
#import "SFPickerView.h"

static NSString * const SFAddJournalCellID = @"SFAddJournalCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";

@interface SFAddJournalViewController ()<UITableViewDelegate,UITableViewDataSource,SFPhotoSelectCellDelegate,PickerToolDelegate,SFPickerViewDelegate,SFSuperSuborViewControllerDelagete>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic,strong) PickerTool *pick;
@property (nonatomic, strong) SFJournalModel * model;
@property (nonatomic,strong) UIButton * saveButton;

@end

@implementation SFAddJournalViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)userArray{
    
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

- (NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
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
            [self upload];
        }];
    }
    return _saveButton;
}

- (void)upload {
    
    NSMutableDictionary * dict = [SFJournalModel pramJournalJson:self.dataArray];
    [dict setObject:self.imageArray forKey:@"photos"];
    [dict setObject:self.userArray forKey:@"auditUserListIds"];
    
    NSLog(@"%@",dict);
    
    [SFJournalHttpModel addCompanyJournal:dict success:^{
        
        [MBProgressHUD showSuccessMessage:@"提交成功" completionBlock:^{
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showErrorMessage:@"提交失败"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增日报";
    
    [self setDrawUI];
    [self getData];
}


- (void)getData {
    
    [self.dataArray addObjectsFromArray:[SFJournalModel shareJournalModel]];
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
    SFJournalModel * model = self.dataArray[indexPath.row];
    if (model.type == 3) {
        
        return 203;
    }
    if (model.type == 4) {
        
        return 120;
    }
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFJournalModel * model = self.dataArray[indexPath.row];
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
    SFAddJournalCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddJournalCellID forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFJournalModel * model = self.dataArray[indexPath.row];
    self.model = model;
    if (model.type == 1) {
        
        SFSuperSuborViewController * vc = [NSClassFromString(@"SFSuperSuborViewController") new];
        vc.isSubor = NO;
        vc.delagete = self;
        vc.type = multipleType;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (model.type == 2) {
        //日报类型
        [self customArr:@[@"日报",@"周报",@"年报"] withRow:indexPath.row];
    }
    
}

//多选
- (void)multiplesSelectEmoloyee:(NSArray <SFEmployeesModel *> *)employees{
    
    NSLog(@"%ld",employees.count);
    for (int i = 0; i < employees.count; i ++) {
        SFEmployeesModel * model = employees[i];
        [self.userArray addObject:model._id];
        if (i == 0) {
            self.model.destitle = model.name;
        }else{
            self.model.destitle = [NSString stringWithFormat:@"%@,%@",self.model.destitle,model.name];
        }
    }
    
    [self.tableView reloadData];
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
    
    self.model.destitle = text;
    self.model.value = [text isEqualToString:@"日报"]?@"DAILY":[text isEqualToString:@"周报"]?@"WEEKLY":@"MONTHLY";
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
#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        [_tableView registerClass:[SFAddJournalCell class] forCellReuseIdentifier:SFAddJournalCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
    }
    return _tableView;
}

@end

@interface SFAddJournalCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * startLabel;
@property (nonatomic, strong) UITextField * desTextField;

@end

@implementation SFAddJournalCell


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

- (void)setModel:(SFJournalModel *)model{
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
