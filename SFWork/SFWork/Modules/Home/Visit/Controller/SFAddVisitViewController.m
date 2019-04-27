//
//  SFAddVisitViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAddVisitViewController.h"
#import "SFSelCustomerViewController.h"
#import "SFSuperSuborViewController.h"
#import "DateTimePickerView.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"
#import "SFVisitHttpModel.h"
#import "SFVisitModel.h"
#import "SFSetTypeModel.h"
#import "SFPickerView.h"
#import "PickerTool.h"

static NSString * const SFAddVisitCellID = @"SFAddVisitCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";

@interface SFAddVisitViewController ()<UITableViewDelegate,UITableViewDataSource,SFPhotoSelectCellDelegate,SFPickerViewDelegate,DateTimePickerViewDelegate,SFSuperSuborViewControllerDelagete,PickerToolDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIButton * saveButton;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *visitArray;
@property (nonatomic, strong) DateTimePickerView *timePickerView;
@property (nonatomic,strong) PickerTool *pick;
//客户model
@property (nonatomic, strong) SFClientModel *cmodel;

@property (nonatomic, strong) SFVisitModel * model;
@property (nonatomic, strong) NSMutableArray *visitorArray;
@end

@implementation SFAddVisitViewController

- (NSMutableArray *)visitorArray{
    
    if (!_visitorArray) {
        _visitorArray = [NSMutableArray array];
    }
    return _visitorArray;
}

- (NSMutableArray *)visitArray{
    
    if (!_visitArray) {
        _visitArray = [NSMutableArray array];
    }
    return _visitArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增客户拜访";
    [self setDrawUI];
    [self getData];
    [self initData];
}


- (void)getData {
    
    [self.dataArray addObjectsFromArray:[SFVisitModel shareAddVisitModel:self.isBusiness]];
    [self.tableView reloadData];
    
}

- (void)initData{
    
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    [SFSetTypeModel getCompanySetting:@"TASK_TYPE" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {

        [MBProgressHUD hideHUD];
        [self.visitArray removeAllObjects];
        [self.visitArray addObjectsFromArray:list];


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
    SFVisitModel * model = self.dataArray[indexPath.row];
    if (model.type == 7) {

        return 203;
    }
    if (model.type == 8) {

        return 120;
    }
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFVisitModel * model = self.dataArray[indexPath.row];
    if (model.type == 7) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type == 8) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:NO withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    SFAddVisitCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddVisitCellID forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFVisitModel * model = self.dataArray[indexPath.row];
    self.model = model;
    
    switch (model.type) {
        case 1:
        {
            SFSelCustomerViewController * vc = [NSClassFromString(@"SFSelCustomerViewController") new];
            @weakify(self)
            [vc setSelCustomerClick:^(SFClientModel * _Nonnull cmodel) {
                @strongify(self)
                self.cmodel = cmodel;
                model.destitle = cmodel.name;
                model.value = cmodel._id;
                SFVisitModel * vmodel = self.dataArray[1];
                ClientLinkModel * clmodel = cmodel.clientLinkmanDTOList[0];
                
                vmodel.destitle =clmodel.name;
                vmodel.value = clmodel._id;
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
           
        }
            break;
        case 3:
        {
            //客户类型
            NSMutableArray * array = [NSMutableArray array];
            for (SFSetTypeModel * model in self.visitArray) {
                [array addObject:model.name];
            }
            [self customArr:array withRow:indexPath.row];
        }
            break;
            
        case 4:
            [self customArr:@[@"电话拜访",@"走访"] withRow:indexPath.row];
            break;
        case 5:
            [self selectTime:DatePickerViewDateTimeMode];
            break;
        case 6:
        {
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
//
}

#pragma SFPhotoSelectCellDelegate
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

//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee{
    
//    self.model.destitle = employee.name;
//    [self.tableView reloadData];
}

- (void)multiplesSelectEmoloyee:(NSArray<SFEmployeesModel *> *)employees{

    for (int i = 0; i < employees.count; i ++) {
        SFEmployeesModel * model = employees[i];
        if (self.model.type == 6) {
            [self.visitorArray removeAllObjects];
            [self.visitorArray addObject:model._id];
        }
        
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
#pragma mark- SFPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text withRow:(NSInteger)row withSelectIndex:(NSInteger)selectIndex{
    
    self.model.destitle = text;
    NSInteger index = [pickerView selectedRowInComponent:0];
    if (self.model.type == 2) {
        SFSetTypeModel * model = self.visitArray[row];
        self.model.value = model._id;
    }
    if (self.model.type == 4) {
        //拜访方式
        self.model.value = [text isEqualToString:@"走访"]?@"INTERVIEW":@"TEL";
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
        [_tableView registerClass:[SFAddVisitCell class] forCellReuseIdentifier:SFAddVisitCellID];
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
            [self addVisit];
        }];
    }
    return _saveButton;
}

- (void)addVisit{
    NSMutableDictionary * dict = [SFVisitModel pramAddVisitJson:self.dataArray];
    [dict setObject:self.imageArray forKey:@"visitingPhotos"];
    [dict setObject:self.visitorArray forKey:@"visitors"];
    NSString * type = self.isBusiness ? @"MERCHANT":@"CLIENT";
    [dict setValue:type forKey:@"clientGroup"];

    NSLog(@"==%@",dict);
    
    [MBProgressHUD showActivityMessageInWindow:@"正在提交.."];
    [SFVisitHttpModel addClientVisit:dict success:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccessMessage:@"拜访添加成功" completionBlock:^{
            !self.addCompleteClick?:self.addCompleteClick();
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:@"拜访添加失败"];
    }];

}

@end


@interface SFAddVisitCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * startLabel;
@property (nonatomic, strong) UITextField * desTextField;

@end

@implementation SFAddVisitCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self drawUI];
    }
    return self;
}

- (void)setModel:(SFVisitModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.startLabel.text = model.stars;
    self.desTextField.text = model.destitle ;
    self.desTextField.placeholder = model.placeholder;
    self.desTextField.enabled = model.isClick ;
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