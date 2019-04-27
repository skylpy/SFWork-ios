//
//  SFSelectItemView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelectItemView.h"
#import "SFSelectTableCell.h"
#import "SFHeaderView.h"

static NSString * const SFSelectTableCellID = @"SFSelectTableCellID";

@interface SFSelectItemView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SFHeaderView *headerView;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) NSString *titles;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popupViewHeight;

@end

@implementation SFSelectItemView

- (SFHeaderView *)headerView{
    
    if (!_headerView) {
        _headerView = [SFHeaderView shareSFHeaderView];
    }
    return _headerView;
}

+ (instancetype)shareSFSelectItemView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFSelectItemView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.popupView.layer.cornerRadius = 10;
    self.popupView.clipsToBounds = YES;
    
    self.tableView.separatorStyle = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SFSelectTableCell" bundle:nil] forCellReuseIdentifier:SFSelectTableCellID];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewClisk)];
    [self.bgView addGestureRecognizer:tap];
}

- (void)showFromView:(UIView *)superView withTitle:(NSString *)title withData:(NSArray *)dataSource selectClick:(void (^)(NSString * type))selectClick{
    
    self.selectClick = selectClick;
    self.dataSource = dataSource;
    self.titles = title;
    self.headerView.titleLabel.text = title;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.bgView.alpha = 0.35;
    }];
    self.frame = superView.bounds;
    self.popupViewHeight.constant = dataSource.count * 50+75;
    [self layoutIfNeeded];
    
    [superView addSubview:self];
    
    //刷新数据，获取contentSize
    [self.tableView reloadData];
}


- (void)bgViewClisk{
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.bgView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFSelectTableCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSelectTableCellID forIndexPath:indexPath];
    cell.titleLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self bgViewClisk];
    !self.selectClick?:self.selectClick(self.dataSource[indexPath.row]);
}

@end
