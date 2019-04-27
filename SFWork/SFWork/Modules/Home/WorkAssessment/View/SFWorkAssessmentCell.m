//
//  SFWorkAssessmentCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFWorkAssessmentCell.h"
#import "SFAssessmentsCell.h"

static NSString * const SFAssessmentsCellID = @"SFAssessmentsCellID";

@interface SFWorkAssessmentCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFWorkAssessmentCell

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"SFAssessmentsCell" bundle:nil] forCellReuseIdentifier:SFAssessmentsCellID];
}

- (void)setModel:(SocreDetailModel *)model{
    _model = model;
    self.titleLabel.text = model.moduleName;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:model.dataList];
    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFAssessmentsCell * cell = [tableView dequeueReusableCellWithIdentifier:SFAssessmentsCellID forIndexPath:indexPath];
    ScoreListModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    if (indexPath.row == 0) {
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ScoreListModel * model = self.dataArray[indexPath.row];
    !self.selectSocreClick?:self.selectSocreClick(model);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
