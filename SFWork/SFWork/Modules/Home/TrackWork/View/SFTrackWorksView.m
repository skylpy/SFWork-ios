//
//  SFTrackWorkView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTrackWorksView.h"
#import "SFTrackWorkCell.h"

static NSString * const SFTrackWorkCellID = @"SFTrackWorkCellID";
@interface SFTrackWorksView ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFTrackWorksView

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

+ (instancetype)shareSFTrackWorkView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFTrackWorksView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = bgColor;
    [_tableView registerNib:[UINib nibWithNibName:@"SFTrackWorkCell" bundle:nil] forCellReuseIdentifier:SFTrackWorkCellID];
}

- (void)setArray:(NSArray *)array{
    _array = array;
    [self.dataArray addObjectsFromArray:array];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFTrackWorkCell * cell = [tableView dequeueReusableCellWithIdentifier:SFTrackWorkCellID forIndexPath:indexPath];
    SFTrackWorksModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFTrackWorksModel * model = self.dataArray[indexPath.row];
    !self.selectTrackClick?:self.selectTrackClick(model);
}

@end

@implementation SFTrackWorksModel

+ (NSArray *)shareTrackModel {
    
    SFTrackWorksModel * model1 = [SFTrackWorksModel comfirmModelWith:@"员工" withIcon:@"icon_employees_black" withDestitle:[SFInstance shareInstance].userInfo.name withType:1];
    SFTrackWorksModel * model2 = [SFTrackWorksModel comfirmModelWith:@"日期" withIcon:@"icon_date_black" withDestitle:[NSDate dateWithFormat:@"yyyy-MM-dd"] withType:2];
    SFTrackWorksModel * model3 = [SFTrackWorksModel comfirmModelWith:@"路径" withIcon:@"icon_the_path_black" withDestitle:@"原始点路径" withType:3];
    
    return @[model1,model2,model3];
    
}

+ (instancetype)comfirmModelWith:(NSString *)title withIcon:(NSString *)icon withDestitle:(NSString *)destitle withType:(NSInteger)type{
    
    SFTrackWorksModel *model = [SFTrackWorksModel new];
    model.title = title;
    model.icon = icon;
    model.destitle = destitle;
    model.type = type;
    
    return model;
}

@end
