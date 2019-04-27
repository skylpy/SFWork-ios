//
//  SFBusinessListViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBusinessListViewController.h"
#import "SFCustomerHttpModel.h"
#import "SFSelectItemView.h"
#import "SFCustomerCell.h"

static NSString * const SFCustomerCellID = @"SFCustomerCellID";
@interface SFBusinessListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *depButton;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLayoutX;
@property (weak, nonatomic) IBOutlet UIView *selectView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * depArray;
@property (nonatomic,strong) NSMutableArray * myArray;
@property (nonatomic,strong) UIButton * addFileButton;

@property (nonatomic, strong) SFSelectItemView *selectItemView;

@property (nonatomic, assign) BOOL isDev;

@end

@implementation SFBusinessListViewController

- (NSMutableArray *)depArray {
    
    if (!_depArray) {
        
        _depArray = [NSMutableArray array];
    }
    return _depArray;
}

- (NSMutableArray *)myArray {
    
    if (!_myArray) {
        
        _myArray = [NSMutableArray array];
    }
    return _myArray;
}

- (SFSelectItemView *)selectItemView {
    
    if (!_selectItemView) {
        _selectItemView = [SFSelectItemView shareSFSelectItemView];
    }
    return _selectItemView;
}

- (UIButton *)addFileButton{
    
    if (!_addFileButton) {
        
        _addFileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addFileButton setImage:[UIImage imageNamed:@"btn_oval_add_green"] forState:UIControlStateNormal];
    }
    return _addFileButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
    [self requestData];
}


- (void)requestData {
    
//    [MBProgressHUD showActivityMessageInView:@"加载信息..."];
    
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:@"MERCHANT" forKey:@"clientGroup"];
        
        [SFCustomerHttpModel getDepCompanyClient:dict success:^(NSArray<SFClientModel *> * _Nonnull list) {
            
            [self.depArray addObjectsFromArray:list];
            [subscriber sendNext:@"1"];
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
        }];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:@"MERCHANT" forKey:@"clientGroup"];
        
        [SFCustomerHttpModel getMyCompanyClient:dic success:^(NSArray<SFClientModel *> * _Nonnull list) {
            [self.myArray addObjectsFromArray:list];
            [subscriber sendNext:@"1"];
        } failure:^(NSError * _Nonnull error) {
            [subscriber sendNext:@"2"];
        }];
        
        return nil;
    }];
    [self rac_liftSelector:@selector(completedRequest1:request2:) withSignalsFromArray:@[signal1, signal2]];
}

- (void)completedRequest1:(NSString *)signal1 request2:(NSString *)signal2 {
    
    if ([signal1 isEqualToString:@"1"] && [signal2 isEqualToString:@"1"] ) {
        
//        [MBProgressHUD hideHUD];
        [self.tableView reloadData];
    }else{
        [MBProgressHUD showErrorMessage:@"加载失败,请重新加载!"];
//        [MBProgressHUD hideHUD];
    }
}

- (void)setDrawUI {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.isDev = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = bgColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"SFCustomerCell" bundle:nil] forCellReuseIdentifier:SFCustomerCellID];
    
    [self.view addSubview:self.addFileButton];
    [self.addFileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(55);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-52);
    }];
    
    @weakify(self)
    [[self.addFileButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.selectItemView showFromView:LSKeyWindow withTitle:@"请问您要新增哪一项？" withData:@[@"客户资料",@"商家资料",@"取消"] selectClick:^(NSString * _Nonnull type) {
            
            if (![type isEqualToString:@"取消"]) {
                UIViewController * vc = [[UIStoryboard storyboardWithName:@"CustomerMgr" bundle:nil] instantiateViewControllerWithIdentifier:@"SFAddData"];
                NSInteger index = [type isEqualToString:@"客户资料"]?0:1;
                [vc setValue:@(index) forKey:@"type"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }];
    }];
    
    [[self.depButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        self.isDev = YES;
        [self selectButton:x];
        self.lineViewLayoutX.constant = 0;
    }];
    
    [[self.myButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.isDev = NO;
        [self selectButton:x];
        self.lineViewLayoutX.constant = kWidth/2;
    }];
}

- (void)selectButton:(UIButton *)sender{
    
    for (int i = 1000; i < 1002; i ++) {
        
        UIButton * button = [self.selectView viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.isDev ? self.depArray.count : self.myArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFCustomerCell * cell = [tableView dequeueReusableCellWithIdentifier:SFCustomerCellID forIndexPath:indexPath];
    SFClientModel * model = self.isDev ? self.depArray[indexPath.row] : self.myArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFClientModel * model = self.isDev ? self.depArray[indexPath.row] : self.myArray[indexPath.row];
    UIViewController * vc = [NSClassFromString(@"SFCBDateilViewController") new];
    [vc setValue:model forKey:@"model"];
    [vc setValue:@(1) forKey:@"type"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
