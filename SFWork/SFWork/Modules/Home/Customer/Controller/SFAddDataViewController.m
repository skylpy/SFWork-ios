//
//  SFAddDataViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAddDataViewController.h"
#import "SFAddContactsViewController.h"
#import "SFAllEmployeeViewController.h"
#import "SFProfileTableCell.h"
#import "SFPhotoSelectCell.h"
#import "SFTextViewCell.h"
#import "SFPickerView.h"
#import "SFSetTypeModel.h"
#import "SFRegisterModel.h"
#import "SFCustomerHttpModel.h"
#import "SFContactCell.h"
#import "PickerTool.h"

static NSString * const SFAddDataCellID = @"SFAddDataCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";
static NSString * const SFContactCellID = @"SFContactCellID";


@interface SFAddDataViewController ()<UITableViewDelegate,UITableViewDataSource,SFPickerViewDelegate,AddressViewDelegate,SFAddContactsViewControllerDelegate,SFPhotoSelectCellDelegate,PickerToolDelegate,SFAllEmployeeViewControllerDelagete>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UIButton * saveButton;

@property (nonatomic, strong) SFPickerView *pickerView;

@property (nonatomic, strong) SFCustomerModel * model;

@property (nonatomic, strong) NSMutableArray *clentTypeArr;
@property (nonatomic, strong) NSMutableArray *clentlevelArr;
@property (nonatomic, strong) NSMutableArray *intentionTypeArr;
@property (nonatomic, strong) SFAddressPicker *  addressPicker;
@property (nonatomic, strong) NSMutableArray *contactArr;
@property (nonatomic,strong) PickerTool *pick;

@end

@implementation SFAddDataViewController

- (NSMutableArray *)clentTypeArr{
    
    if (!_clentTypeArr) {
        _clentTypeArr = [NSMutableArray array];
    }
    return _clentTypeArr;
}

- (NSMutableArray *)clentlevelArr{
    
    if (!_clentlevelArr) {
        _clentlevelArr = [NSMutableArray array];
    }
    return _clentlevelArr;
}

- (NSMutableArray *)intentionTypeArr{
    
    if (!_intentionTypeArr) {
        _intentionTypeArr = [NSMutableArray array];
    }
    return _intentionTypeArr;
}

- (NSMutableArray *)contactArr{
    
    if (!_contactArr) {
        
        _contactArr = [NSMutableArray array];
    }
    return _contactArr;
}

- (NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (SFPickerView *)pickerView{
    
    if (!_pickerView) {
        SFPickerView *picker = [[SFPickerView alloc] initWithFrame:self.view.bounds];
        _pickerView = picker;
        picker.delegate = self ;
    }
    return _pickerView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.backgroundColor = Color(@"#01B38B");
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.cmodel) {
                [self updateData];
            }else{
                [self saveUpload];
            }
            
        }];
    }
    return _saveButton;
}

- (void)saveUpload{
    
    NSMutableDictionary * pram = [SFCustomerModel pramCustomerJson:self.dataArray];
    NSMutableArray * contacts = [NSString arrayOrDicWithObject:self.contactArr];
    [pram setObject:contacts forKey:@"clientLinkmanDTOList"];
    [pram setObject:self.imageArray forKey:@"photos"];
    NSString * clientGroup = self.type == businessType ? @"MERCHANT":@"CLIENT";
    [pram setValue:clientGroup forKey:@"clientGroup"];
    NSLog(@"%@",pram);
    
    if (self.contactArr.count == 0 ) {
        [UIAlertController alertTitle:@"温馨提示" mesasge:@"请选择联系人！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
            
        } viewController:self];
        return;
    }
    if ([pram[@"name"] isEqualToString:@""]||
        [pram[@"areaId"] isEqualToString:@""]||
        [pram[@"clientBelong"] isEqualToString:@""]||
        [pram[@"levelId"] isEqualToString:@""]||
        [pram[@"intentionId"] isEqualToString:@""]||
        [pram[@"typeId"] isEqualToString:@""]||
        [pram[@"address"] isEqualToString:@""]) {
        [UIAlertController alertTitle:@"温馨提示" mesasge:@"带星号的为必填，请填写完整！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
            
        } viewController:self];
        return;
    }
    [MBProgressHUD showActivityMessageInView:@"正在保存..."];
    [SFCustomerHttpModel addCompanyClient:pram success:^{
        
        [MBProgressHUD hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)updateData{
    
    NSMutableDictionary * pram = [SFCustomerModel pramCustomerJson:self.dataArray];
    NSMutableArray * contacts = [NSString arrayOrDicWithObject:self.contactArr];
    [pram setObject:contacts forKey:@"clientLinkmanDTOList"];
    [pram setObject:self.imageArray forKey:@"photos"];
    NSString * clientGroup = self.type == businessType ? @"MERCHANT":@"CLIENT";
    [pram setValue:clientGroup forKey:@"clientGroup"];
    [pram setValue:self.cmodel._id forKey:@"id"];
    NSLog(@"%@",pram);
    
    if (self.contactArr.count == 0 ) {
        [UIAlertController alertTitle:@"温馨提示" mesasge:@"请选择联系人！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
            
        } viewController:self];
        return;
    }
    if ([pram[@"name"] isEqualToString:@""]||
        [pram[@"areaId"] isEqualToString:@""]||
        [pram[@"clientBelong"] isEqualToString:@""]||
        [pram[@"levelId"] isEqualToString:@""]||
        [pram[@"intentionId"] isEqualToString:@""]||
        [pram[@"typeId"] isEqualToString:@""]||
        [pram[@"address"] isEqualToString:@""]) {
        [UIAlertController alertTitle:@"温馨提示" mesasge:@"带星号的为必填，请填写完整！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
            
        } viewController:self];
        return;
    }
    [MBProgressHUD showActivityMessageInView:@"正在保存..."];
    [SFCustomerHttpModel updateClients:pram success:^{
        
        [MBProgressHUD hideHUD];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.cmodel) {
        self.title = self.type == businessType ? @"编辑商家" : @"编辑客户";
    }else{
        self.title = self.type == businessType ? @"新增商家" : @"新增客户";
    }
    
    
    [self setDrawUI];
    [self requestData];
    [self requestTypeData];
    [self getCity];
}

- (void)getCity{
    
    [SFRegHttpModel getCityDataSuccess:^(NSArray<AddressModel *> * _Nonnull address) {
        
        [self.addressPicker loadRequestData:address];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD showErrorMessage:@"城市列表加载失败!"];
    }];
}

- (void)setDrawUI {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = bgColor;
    [self.tableView registerClass:[SFAddDataCell class] forCellReuseIdentifier:SFAddDataCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFContactCell" bundle:nil] forCellReuseIdentifier:SFContactCellID];
    
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
    }];
    
    self.addressPicker= [[SFAddressPicker alloc] init];
    [LSKeyWindow addSubview:self.addressPicker];
    self.addressPicker.delegate = self;
}

- (void)requestData {
    
    if (self.cmodel) {
        
        //编辑
        [self.dataArray addObjectsFromArray:[SFCustomerModel shareCustomerModel:self.cmodel withType:self.type]];
        [self.imageArray addObjectsFromArray:self.cmodel.photos];
        [self.contactArr addObjectsFromArray:self.cmodel.clientLinkmanDTOList];
        [self.tableView reloadData];
        
    }else{
        //新增
        [self.dataArray addObjectsFromArray:[SFCustomerModel shareCustomerModel:self.type]];
        [self.tableView reloadData];
    }
    
}

- (void)requestTypeData{
    
    [MBProgressHUD showActivityMessageInWindow:@"加载信息..."];
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [SFSetTypeModel getCompanySetting:@"CLIENT_TYPE" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
            
            [MBProgressHUD hideHUD];
            [self.clentTypeArr removeAllObjects];
            [self.clentTypeArr addObjectsFromArray:list];
            [subscriber sendNext:@"1"];
            
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
            [MBProgressHUD hideHUD];
        }];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [SFSetTypeModel getCompanySetting:@"CLIENT_LEVEL" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
            
            [MBProgressHUD hideHUD];
            [self.clentlevelArr removeAllObjects];
            [self.clentlevelArr addObjectsFromArray:list];
            [subscriber sendNext:@"1"];
            
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
            [MBProgressHUD hideHUD];
        }];
        
        return nil;
    }];
    RACSignal *signal3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [SFSetTypeModel getCompanySetting:@"INTENTION_TYPE" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
            
            [MBProgressHUD hideHUD];
            [self.intentionTypeArr removeAllObjects];
            [self.intentionTypeArr addObjectsFromArray:list];
            [subscriber sendNext:@"1"];
            
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
            [MBProgressHUD hideHUD];
        }];
        
        return nil;
    }];
    
    RACSignal *signal4 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [SFSetTypeModel getCompanySetting:@"CLIENT_LEVEL" success:^(NSArray<SFSetTypeModel *> * _Nonnull list) {
            
//            [MBProgressHUD hideHUD];
//            [self.clentArr removeAllObjects];
//            [self.clentArr addObjectsFromArray:list];
            [subscriber sendNext:@"1"];
            
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
            [MBProgressHUD hideHUD];
        }];
        
        return nil;
    }];
    
    [self rac_liftSelector:@selector(completedRequest1:request2:request3:request4:) withSignalsFromArray:@[signal1, signal2,signal3,signal4]];
    
}

- (void)completedRequest1:(NSString *)signal1 request2:(NSString *)signal2 request3:(NSString *)signal3 request4:(NSString *)signal4{
    
    if ([signal1 isEqualToString:@"1"] && [signal2 isEqualToString:@"1"]&& [signal3 isEqualToString:@"1"]&& [signal4 isEqualToString:@"1"] ) {
        
        [MBProgressHUD hideHUD];
    }else{
        [MBProgressHUD showErrorMessage:@"加载失败,请重新加载!"];
        [MBProgressHUD hideHUD];
    }
}


#pragma SFPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text withRow:(NSInteger)row withSelectIndex:(NSInteger)selectIndex{
    
    [self.tableView reloadData];
    self.model.destitle = text;
    NSInteger index = [pickerView selectedRowInComponent:0];
    switch (row) {
        case 2:
        {
            SFSetTypeModel * model = self.clentTypeArr[index];
            self.model.value = model._id;
        }
            break;
        case 3:
        {
            SFSetTypeModel * model = self.clentlevelArr[index];
            self.model.value = model._id;
        }
            break;
        
        case 5:
        {
            SFSetTypeModel * model = self.intentionTypeArr[index];
            self.model.value = model._id;
        }
            break;
        default:
            break;
    }
    NSLog(@"%@== %ld",text,[pickerView selectedRowInComponent:0]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return self.dataArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 2) {
        
        return self.contactArr.count;
    }
    NSArray * array = self.dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        
        return 45;
    }
    NSArray * array = self.dataArray[indexPath.section];
    SFCustomerModel * model = array[indexPath.row];
    if (model.type == 9) {
        
        return 120;
    }
    if (model.type == 10) {
        
        return 203;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        SFContactCell * cell = [tableView dequeueReusableCellWithIdentifier:SFContactCellID forIndexPath:indexPath];
        ClientLinkModel * model = self.contactArr[indexPath.row];
        cell.model = model;
        @weakify(self)
        [cell setDeleteClick:^(ClientLinkModel * _Nonnull cmodel) {
            @strongify(self)
            [self.contactArr removeObject:cmodel];
            [self.tableView reloadData];
        }];
        return cell;
    }
    NSArray * array = self.dataArray[indexPath.section];
    SFCustomerModel * model = array[indexPath.row];
    
    if (model.type == 9) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:model withIsEdit:NO withCmodel:nil withArr:self.imageArray];
//        [cell cellImage:model withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;

    }
    if (model.type == 10) {
        
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    SFAddDataCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddDataCellID forIndexPath:indexPath];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        
        return;
    }
    NSArray * array = self.dataArray[indexPath.section];
    SFCustomerModel * model = array[indexPath.row];
    self.model = model;
    switch (model.type) {
        case 1:
            //归属
            [self customArr:@[@"我的(私有)",@"部门(部门公有)"] withRow:indexPath.row];
            break;
        case 2:
        {
            //客户类型
            NSMutableArray * array = [NSMutableArray array];
            for (SFSetTypeModel * model in self.clentTypeArr) {
                [array addObject:model.name];
            }
            [self customArr:array withRow:indexPath.row];
        }
            break;
        case 3:
        {
            //客户等级
            NSMutableArray * array = [NSMutableArray array];
            for (SFSetTypeModel * model in self.clentlevelArr) {
                [array addObject:model.name];
            }
            [self customArr:array withRow:indexPath.row];
        }
            break;
        case 4:
        {
            [self.addressPicker show];
        }
            break;
        case 5:
        {
            //意向类型
            NSMutableArray * array = [NSMutableArray array];
            for (SFSetTypeModel * model in self.intentionTypeArr) {
                [array addObject:model.name];
            }
            [self customArr:array withRow:indexPath.row];
        }
            break;
        case 6:
        {
            SFAllEmployeeViewController * vc = [NSClassFromString(@"SFAllEmployeeViewController") new];
            vc.delagete = self;
            vc.type = singleType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 11:
        {
            
            SFAddContactsViewController * vc = [NSClassFromString(@"SFAddContactsViewController") new];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma SFAllEmployeeViewController
- (void)singleSelectEmoloyee:(SFEmployeesModel *)employee{
    
    self.model.destitle = employee.name;
    self.model.value = employee._id;
    
    [self.tableView reloadData];
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
#pragma SFAddContactsViewControllerDelegate
- (void)getContacts:(NSDictionary *)dic{
    ClientLinkModel * model = [ClientLinkModel modelWithJSON:dic];
    [self.contactArr addObject:model];
    
    [self.tableView reloadData];
}

- (void)customArr:(NSArray *)array withRow:(NSInteger)row{
    
    SFPickerView *picker = [[SFPickerView alloc] initWithFrame:self.view.bounds];
    picker.delegate = self ;
    picker.row = row;
    picker.customArr = array;
    [LSKeyWindow addSubview:picker];
}

#pragma mark - AddressViewDelegate
- (void)cancelOnclick{
    [self.addressPicker hide];
}

- (void)viewDisappearance{
    [self.addressPicker hide];
}

- (void)completingTheSelection:(AddressModel *)province city:(AddressModel *)city area:(AddressModel *)area;{
    [self.addressPicker hide];
//    self.addressModel.value = [NSString stringWithFormat:@"%@,%@,%@",province.label,city.label,area.label];
//    self.areaId = area.value;
    
    [self.tableView reloadData];
    NSLog(@"province:%@,city:%@,area:%@",province.label,city.label,area.label);
    self.model.destitle = [NSString stringWithFormat:@"%@,%@,%@",province.label,city.label,area.label];
    self.model.value = area.value;
}

@end

@interface SFAddDataCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * startLabel;
@property (nonatomic, strong) UITextField * desTextField;

@end

@implementation SFAddDataCell


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

- (void)setModel:(SFCustomerModel *)model{
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
