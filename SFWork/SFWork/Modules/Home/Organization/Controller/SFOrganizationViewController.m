//
//  SFOrganizationViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFOrganizationViewController.h"
#import "SFSelectEmployeeViewController.h"
#import "SFDepViewController.h"
#import "SFProfileViewController.h"
#import "SFDepSetViewController.h"
#import "SFPublicSearchView.h"
#import "SFPublicSelectView.h"
#import "SFOrgBottomView.h"
#import "SFOrganizationModel.h"
#import "SFTableViewCell.h"

static NSString * const SFOrganizationCellID = @"SFOrganizationCellID";
static NSString * const SFEmployeesCellID = @"SFEmployeesCellID";

@interface SFOrganizationViewController ()<UITableViewDelegate,UITableViewDataSource,SFOrgBottomViewDelegate,SFTableViewCellDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * searchArray;
@property (nonatomic,strong) NSMutableArray * dataCopyArray;
@property (nonatomic,strong) NSMutableArray * titArray;
@property (nonatomic,strong) SFPublicSearchView * headerView;
@property (nonatomic,strong) SFPublicSelectView * selectView;

@property (nonatomic, strong) SFOrgBottomView * bottomView;
//当前架构model
@property (nonatomic, strong) SFOrgListModel *currentModel;
//批量操作
@property (nonatomic, strong) UIButton *operation;

@property (nonatomic, strong) UIView * header;

@end

@implementation SFOrganizationViewController

- (NSMutableArray *)dataCopyArray{
    
    if (!_dataCopyArray) {
        _dataCopyArray = [NSMutableArray array];
    }
    return _dataCopyArray;
}

- (NSMutableArray *)searchArray{
    
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)titArray{
    
    if (!_titArray) {
        _titArray = [NSMutableArray array];
    }
    return _titArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"组织架构";
    
    [self initDrawUI];
    
    [self requestData];
}


-(void)initDrawUI {
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(43);
        make.top.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(45);
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    
    
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(50);
        make.bottom.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.selectView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.operation];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    @weakify(self)
    [self.selectView setDidSelectClick:^(NSInteger row,NSArray * array) {
        @strongify(self)

        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        NSInteger reduce = array.count - row -1;
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-reduce]animated:YES];
    }];
    
    [[self.operation rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self moreOperation];
    }];
}

//批量操作
- (void)moreOperation {
    
    ModelComfirm *item1 = [ModelComfirm comfirmModelWith:@"批量移动员工" titleColor:Color(@"#0B0B0B") fontSize:16];
    ModelComfirm *item2 = [ModelComfirm comfirmModelWith:@"批量删除成员" titleColor:Color(@"#0B0B0B") fontSize:16];
    ModelComfirm *cancelItem = [ModelComfirm comfirmModelWith:@"取消" titleColor:Color(@"#0B0B0B") fontSize:16];
    [ComfirmView showInView:LSKeyWindow cancelItemWith:cancelItem dataSource:@[ item1 ,item2] actionBlock:^(ComfirmView *view, NSInteger index) {
        
        NSLog(@"======%ld",index);
        SFSelectEmployeeViewController * vc = [NSClassFromString(@"SFSelectEmployeeViewController") new];
        [vc setValue:self.currentModel forKey:@"model"];
        [vc setValue:@(index) forKey:@"type"];
        @weakify(self)
        [vc setDidSaveClick:^{
            @strongify(self)
            [self requestData];
        }];
        SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nvs animated:YES completion:nil];
    }];
}


- (void)requestData {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.departmentId forKey:@"departmentId"];
    
    [MBProgressHUD showActivityMessageInView:@""];
    [SFOrganizationModel getOrganizationList:dict success:^(SFOrgListModel * _Nonnull model) {
        
        [MBProgressHUD hideHUD];
        [self dealWithData:model];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
    }];
}

- (void)dealWithData:(SFOrgListModel *)model{
    
    self.currentModel = model;
    [self.titArray removeAllObjects];
    [self.titArray addObjectsFromArray:self.nameArray];
    [self.titArray addObject:model.name];
    self.selectView.nameArray = self.titArray;
    [self.selectView.collectionView reloadData];
    
    [self.dataArray removeAllObjects];
    NSMutableArray * dep = [NSMutableArray array];
    [dep addObjectsFromArray:model.children];
    [self.dataArray addObject:dep];
    NSMutableArray * eps = [NSMutableArray array];
    [eps addObjectsFromArray:model.employees];
    [self.dataArray addObject:eps];
    [self.dataCopyArray removeAllObjects];
    [self.dataCopyArray addObject:dep];
    [self.dataCopyArray addObject:eps];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
  
    return section == 0 ? self.currentModel.admins.count > 0 ? 10:self.currentModel.root == NO ? 60:10:10 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0 && self.currentModel.admins.count == 0 && self.currentModel.root == NO) {
       
        return self.header;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * array = self.dataArray[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * array = self.dataArray[indexPath.section];
    if (indexPath.section == 0) {
        
        SFOrganizationCell * cell = [tableView dequeueReusableCellWithIdentifier:SFOrganizationCellID forIndexPath:indexPath];
        SFOrgListModel * model = array[indexPath.row];
        cell.model = model;
        return cell;
    }
    
    SFTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SFEmployeesCellID forIndexPath:indexPath];
    SFEmployeesModel * model = array[indexPath.row];
    cell.delegate = self;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * array = self.dataArray[indexPath.section];
    if (indexPath.section == 0) {
        SFOrgListModel * model = array[indexPath.row];
        
        SFOrganizationViewController * vc = [SFOrganizationViewController new];
        vc.departmentId = model._id;
        vc.departName = model.name;
        vc.parentModel = self.currentModel;
        vc.nameArray = self.titArray;
        @weakify(self)
        [vc setDidDeleteClick:^{
            @strongify(self)
            [self requestData];
        }];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma SFOrgBottomView

- (void)orgBottomVuewClick:(UIButton *)sender{
    
    if(sender.tag == 1000){

        //添加员工
        SFProfileViewController * vc = [NSClassFromString(@"SFProfileViewController") new];
        [vc setValue:@(YES) forKey:@"isOrg"];
        [vc setValue:self.currentModel.companyId  forKey:@"companyId"];
        [vc setValue:self.currentModel._id forKey:@"departmentId"];
        [vc setValue:self.currentModel.name forKey:@"departmentName"];
        @weakify(self)
        [vc setDidSaveClick:^{
            @strongify(self)
            [self requestData];
        }];
        SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nvs animated:YES completion:nil];
        
    }else if (sender.tag == 1001){
        
        //添加部门
        SFDepViewController * vc = [NSClassFromString(@"SFDepViewController") new];
        [vc setValue:self.currentModel._id  forKey:@"parentId"];
        [vc setValue:self.currentModel.name forKey:@"parentName"];
        @weakify(self)
        [vc setDidSaveClick:^{
            @strongify(self)
            [self requestData];
        }];
        SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nvs animated:YES completion:nil];
    }else{
        //设置部门
        SFDepSetViewController * vc = [NSClassFromString(@"SFDepSetViewController") new];
        [vc setValue:self.parentModel._id  forKey:@"parentId"];
        [vc setValue:self.parentModel.name forKey:@"parentName"];
        [vc setValue:self.currentModel forKey:@"model"];
        @weakify(self)
        [vc setDidSaveClick:^{
            @strongify(self)
            [self requestData];
        }];
        [vc setDidDeleteClick:^{
            @strongify(self)
            [MBProgressHUD showSuccessMessage:@"删除成功" completionBlock:^{
                !self.didDeleteClick?:self.didDeleteClick();
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
        SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nvs animated:YES completion:nil];
    }
    
}

//修改员工资料
- (void)edirtPersonModel:(SFEmployeesModel *)model{
    
    SFProfileViewController * vc = [NSClassFromString(@"SFProfileViewController") new];
    [vc setValue:@(YES) forKey:@"isOrg"];
    [vc setValue:model  forKey:@"employees"];
    [vc setValue:self.currentModel.name forKey:@"departmentName"];
    @weakify(self)
    [vc setDidSaveClick:^{
        @strongify(self)
        [self requestData];
    }];
    SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:vc];
    [self presentViewController:nvs animated:YES completion:nil];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerClass:[SFOrganizationCell class] forCellReuseIdentifier:SFOrganizationCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFTableViewCell" bundle:nil] forCellReuseIdentifier:SFEmployeesCellID];
    }
    return _tableView;
}

//设置管理员
- (void)mangerClick{
    
    SFSelectEmployeeViewController * vc = [NSClassFromString(@"SFSelectEmployeeViewController") new];
    [vc setValue:self.currentModel forKey:@"model"];
    [vc setValue:@(3) forKey:@"type"];
    @weakify(self)
    [vc setDidSaveClick:^{
        @strongify(self)
        [self requestData];
    }];
    SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:vc];
    [self presentViewController:nvs animated:YES completion:nil];
}

- (UIView *)header{
    
    if (!_header) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
        header.backgroundColor = [UIColor clearColor];
        _header = header;
        UIView * boby = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kWidth, 50)];
        boby.backgroundColor = Color(@"#FFF5E4");
        [header addSubview:boby];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mangerClick)];
        [boby addGestureRecognizer:tap];
        
        UILabel * titleLabel = [UILabel createALabelText:@"此部门还没设置管理员" withFont:[UIFont fontWithName:kRegFont size:14] withColor:Color(@"#F96A0E")];
        titleLabel.frame = CGRectMake(15, 5, 200, 15);
        [boby addSubview:titleLabel];
        
        UILabel * desLabel = [UILabel createALabelText:@"管理员是部门领导，负责底下员工的审批、查看和操作" withFont:[UIFont fontWithName:kRegFont size:11] withColor:Color(@"#F96A0E")];
        desLabel.numberOfLines = 2;
        [boby addSubview:desLabel];
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(boby.mas_left).offset(15);
            make.right.equalTo(boby.mas_right).offset(-90);
            make.top.equalTo(titleLabel.mas_bottom).offset(2);
            
        }];
        
        UIImageView * iconImage = [UIImageView new];
        iconImage.image = [UIImage imageNamed:@"arrow_right_middle_gray"];
        [boby addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(boby.mas_right).offset(-15);
            make.width.offset(7);
            make.height.offset(14);
            make.centerY.equalTo(boby);
        }];
        
    }
    return _header;
}

- (UIButton *)operation{
    
    if (!_operation) {
        
        _operation = [UIButton buttonWithType:UIButtonTypeCustom];
        _operation.frame = CGRectMake(0, 0, 70, 20);
        [_operation setTitle:@"批量操作" forState:UIControlStateNormal];
        [_operation setTitleColor:defaultColor forState:UIControlStateNormal];
        _operation.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
    }
    return _operation;
}

- (SFPublicSearchView *)headerView {
 
    if (!_headerView) {
        
        _headerView = [SFPublicSearchView shareSFPublicSearchView];
        _headerView.seachTextField.placeholder = @"请输入姓名";
        @weakify(self)
        [_headerView setSearchKeywordAction:^(NSString * _Nonnull keyword) {
            @strongify(self)
            [self searchKeyWord:keyword];
        }];
        [_headerView setTextSignalClick:^(NSString * _Nonnull keyword) {
            @strongify(self)
            [self searchKey:keyword];
        }];
    }
    return _headerView;
}

- (SFPublicSelectView *)selectView {
    
    if (!_selectView) {
        
        _selectView = [SFPublicSelectView loadNibView];
    }
    return _selectView;
}

- (SFOrgBottomView *)bottomView {
    
    if (!_bottomView) {
        
        if (!self.departmentId) {
            _bottomView = [SFOrgBottomView shareOrgBottomView];
        }else{
            _bottomView = [SFOrgBottomView shareSFOrgBottomView];
        }
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (void)searchKey:(NSString *)key{
    
    if ([key isEqualToString:@""]) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:self.dataCopyArray];
        [self.tableView reloadData];
    }
}

- (void)searchKeyWord:(NSString *)key{
    
    if ([key isEqualToString:@""]) {
        
        return;
    }
    [self.searchArray removeAllObjects];
    for (int i = 0; i < self.dataArray.count; i ++) {
        NSArray * array = self.dataArray[i];
        
        if (i == 0) {
            NSMutableArray * arr = [NSMutableArray array];
            for (SFOrgListModel * model in array) {
                
                if ([model.name rangeOfString: key].location != NSNotFound) {
                    
                    [arr addObject:model];
                }
            }
            
            [self.searchArray addObject:arr];
        }else{
            NSMutableArray * arr = [NSMutableArray array];
            for (SFEmployeesModel * model in array) {
                
                if ([model.name rangeOfString: key].location != NSNotFound) {
                    
                    [arr addObject:model];
                }
            }
            [self.searchArray addObject:arr];
        }
    }
    
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:self.searchArray];
    
    
    
    [self.tableView reloadData];
}

@end

@interface SFOrganizationCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation SFOrganizationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self drawUI];
    }
    return self;
}

- (void)setModel:(SFOrgListModel *)model{
    _model = model;
    
    self.titleLabel.text = model.name;
}

- (void)drawUI {
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.offset(8);
        make.height.offset(14);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        _titleLabel.text = @"技术部";
    }
    return _titleLabel;
}

- (UIImageView *)icon{
    
    if (!_icon) {
        
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"arrow_right_middle_gray"];
    }
    return _icon;
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 238 / 255.0, 238 / 255.0, 238 / 255.0, 1.0);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 1);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, kWidth ,0);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}

@end
