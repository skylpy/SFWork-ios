//
//  SFFolderViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFFolderViewController.h"
#import "SFFilesFolderCell.h"

static NSString * const SFFilesFolderCellID = @"SFFilesFolderCellID";

@interface SFFolderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic, strong) UIButton *letfButton;

@end

@implementation SFFolderViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDrawUI];
    [self requestData];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.letfButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}


- (void)requestData {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.type forKey:@"model"];
    [dict setValue:@"" forKey:@"parentId"];
    
    [SFFilesMgrModel getOfficeFolder:dict success:^(NSArray<SFFilesModel *> * _Nonnull lsit) {
        
        [self.dataArray removeAllObjects];
        
        for (SFFilesModel * model in lsit) {
            if (model.folder) {
                [self.dataArray addObject:model];
            }
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 72;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFFilesModel * model = self.dataArray[indexPath.row];
    SFFilesFolderCell * cell = [tableView dequeueReusableCellWithIdentifier:SFFilesFolderCellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFFilesModel * model = self.dataArray[indexPath.row];
    
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFFilesFolderCell" bundle:nil] forCellReuseIdentifier:SFFilesFolderCellID];
    }
    return _tableView;
}

- (UIButton *)letfButton{
    
    if (!_letfButton) {
        
        _letfButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _letfButton.frame = CGRectMake(0, 0, 12, 20);
        [_letfButton setImage:[UIImage imageNamed:@"arrow_return_gray"] forState:UIControlStateNormal];
        @weakify(self)
        [[_letfButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _letfButton;
}

@end
