//
//  SFVisitResultViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVisitResultViewController.h"
#import "SFAddVisitViewController.h"
#import "SFTextViewCell.h"
#import "SFPhotoSelectCell.h"
#import "SFVisitModel.h"
#import "PickerTool.h"

static NSString * const SFAddVisitCellID = @"SFAddVisitCellID";
static NSString * const SFPhotoSelectCellID = @"SFPhotoSelectCellID";
static NSString * const SFTextViewCellID = @"SFTextViewCellID";

@interface SFVisitResultViewController ()<UITableViewDelegate,UITableViewDataSource,SFPhotoSelectCellDelegate,DateTimePickerViewDelegate,PickerToolDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DateTimePickerView *timePickerView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) SFVisitListModel *model;
@property (nonatomic, strong) SFVisitModel * vmodel ;
@property (nonatomic,strong) PickerTool *pick;
@property (nonatomic, assign) BOOL isPhoto;
@end

@implementation SFVisitResultViewController


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
    
    [self setDrawUI];
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"VisitDataNot" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self getData:x.object];
    }];
}


- (void)getData:(SFVisitListModel * )model  {
    
    self.model = model;
    self.isPhoto = NO;
    [self.dataArray removeAllObjects];
    [self.imageArray removeAllObjects];
    if (model.phoneTime || model.location) {
        
        [self.dataArray addObjectsFromArray:[SFVisitModel shareVisitResultModel:model withType:self.type]];
        
        NSMutableArray * array = [NSMutableArray array];
        for (EmployeeModel * emp in model.visitorList) {
            [array addObject:emp._id];
        }
        if (!model.visitTime && [array containsObject:[SFInstance shareInstance].userInfo._id]) {
            
            UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 120)];
            UIButton * bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
            bottomButton.frame = CGRectMake(20, 10, kWidth-40, 45);
            bottomButton.layer.cornerRadius = 2;
            bottomButton.clipsToBounds = YES;
            bottomButton.backgroundColor = defaultColor;
            [bottomButton setTitle:@"保存" forState:UIControlStateNormal];
            [bottomButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
            bottomButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
            [bottomView addSubview:bottomButton];
            @weakify(self)
            [[bottomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self)
                
                [self completeVisited];
            }];
            self.tableView.tableFooterView = bottomView;
        }
    }
    
    [self.tableView reloadData];
}

- (void)completeVisited {
    
    NSMutableDictionary * dict = [SFVisitModel pramCompleteVisitJson:self.dataArray];
    [dict setValue:self.imageArray forKey:@"visitedPhotos"];
    [dict setValue:self.model._id forKey:@"id"];
    
    [SFVisitHttpModel completeVisits:dict success:^{
        
        [UIAlertController alertTitle:@"恭喜你！" mesasge:@"完成拜访！" preferredStyle:UIAlertControllerStyleAlert cancleHandler:^(UIAlertAction *alert) {
            
            [self.navigationController popViewControllerAnimated:YES];
        } viewController:self];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setDrawUI {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = bgColor;
    [self.tableView registerClass:[SFAddVisitCell class] forCellReuseIdentifier:SFAddVisitCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFPhotoSelectCell" bundle:nil] forCellReuseIdentifier:SFPhotoSelectCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SFTextViewCell" bundle:nil] forCellReuseIdentifier:SFTextViewCellID];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFVisitModel * model = self.dataArray[indexPath.row];
    if (model.type == 4) {
        
        return 203;
    }
    if (model.type == 3) {
        
        return 120;
    }
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFVisitModel * model = self.dataArray[indexPath.row];
    if (model.type == 4) {
        SFTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTextViewCellID forIndexPath:indexPath];
        cell.model = (SFCustomerModel *) model;
        return cell;
    }
    if (model.type == 3) {
        SFPhotoSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:SFPhotoSelectCellID forIndexPath:indexPath];
        [cell cellImage:nil withIsEdit:self.isPhoto withCmodel:nil withArr:self.imageArray];
        cell.delegate = self;
        return cell;
    }
    SFAddVisitCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAddVisitCellID forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFVisitModel * model = self.dataArray[indexPath.row];
    self.vmodel = model;
    switch (model.type) {
        case 1:
            [self selectTime:DatePickerViewDateTimeMode];
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        default:
            break;
    }
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
    self.vmodel.destitle = date;
    
    [self.tableView reloadData];
    
}

@end
