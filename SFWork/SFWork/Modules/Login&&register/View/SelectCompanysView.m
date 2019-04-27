
//
//  SFSelectCompanyView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SelectCompanysView.h"
#import "SFSelectCompanyCell.h"


static NSString * const SFSelectCompanyCellID = @"SFSelectCompanyCellID";

@interface SelectCompanysView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) void (^actionBlock)(BaseErrorModel * model);
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *cancelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutHeight;
@property (weak, nonatomic) IBOutlet UIView *popView;

@end

@implementation SelectCompanysView

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

+ (instancetype)shareSFSelectCompanyView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SelectCompanysView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.popView.layer.cornerRadius = 10;
    self.popView.clipsToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"SFSelectCompanyCell" bundle:nil] forCellReuseIdentifier:SFSelectCompanyCellID];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.cancelView addGestureRecognizer:tap];
}

- (void)tapClick{
    BaseErrorModel * model = [[BaseErrorModel alloc] init];
    !self.actionBlock?:self.actionBlock(model);
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)superView
        dataSource:(NSArray *)dataSource
       actionBlock:(void (^)(BaseErrorModel * model))actionBlock {
    
    self.actionBlock = actionBlock;
    [self.dataSource addObjectsFromArray: dataSource];
    
    self.frame = superView.bounds;
    
    self.viewLayoutHeight.constant = dataSource.count * 66 + 115;
    [superView addSubview:self];
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFSelectCompanyCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSelectCompanyCellID forIndexPath:indexPath];
    BaseErrorModel * model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseErrorModel * model = self.dataSource[indexPath.row];
    !self.actionBlock?:self.actionBlock(model);
    [self removeFromSuperview];
}


@end
