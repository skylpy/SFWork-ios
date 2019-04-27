//
//  SFBusinessPlanCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBusinessPlanCell.h"
#import "SFBusinessCell.h"

static NSString * const SFBusinessCellID = @"SFBusinessCellID";

@interface SFBusinessPlanCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFBusinessPlanCell

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
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SFBusinessCell" bundle:nil] forCellReuseIdentifier:SFBusinessCellID];
}

- (void)setModel:(SFBusinessPlanModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:model.companyLifeList];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFBusinessCell * cell = [tableView dequeueReusableCellWithIdentifier:SFBusinessCellID forIndexPath:indexPath];
    CompanyLifeModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
