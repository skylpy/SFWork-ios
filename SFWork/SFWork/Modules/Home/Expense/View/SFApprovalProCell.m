//
//  SFApprovalProCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFApprovalProCell.h"
#import "SFApprovalPreeCell.h"
#import "SFCopyWhoCell.h"
static NSString * const SFApprovalPreeCellID = @"SFApprovalPreeCellID";
static NSString * const SFCopyWhoCellID = @"SFCopyWhoCellID";
#define cellH (kWidth - 100) / 5

@interface SFApprovalProCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray * dataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SFApprovalProCell

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 纵向
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textColor = Color(@"#666666");
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    flowLayout.minimumInteritemSpacing = 2;      // cell之间左右间隔
    flowLayout.minimumLineSpacing = 0;          // cell之间上下间隔
    _collectionView.scrollEnabled = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"SFApprovalPreeCell" bundle:nil] forCellWithReuseIdentifier:SFApprovalPreeCellID];
    [_collectionView registerNib:[UINib nibWithNibName:@"SFCopyWhoCell" bundle:nil] forCellWithReuseIdentifier:SFCopyWhoCellID];
}

- (void)setModel:(SFExpenseModel *)model{
    _model = model;
    self.titleLabel.text = @"审批流程";
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:model.persons];
    [self.collectionView reloadData];
}

- (void)setArray:(NSArray *)array{
    _array = array;
    self.titleLabel.attributedText = [NSMutableAttributedString setupAttributeString:@"抄送人（审批通过后，通知抄送人）" rangeText:@"（审批通过后，通知抄送人）" textFont:[UIFont fontWithName:kRegFont size:12] textColor:Color(@"#666666")];
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:array];
    [self.collectionView reloadData];
}

- (void)setAttModel:(SFAttendanceMgrModel *)attModel{
    _attModel = attModel;
    self.titleLabel.text = @"审批流程";
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:@[]];
    [self.collectionView reloadData];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 1, 0, 1);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    size = CGSizeMake(kWidth , 0);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    
    size = CGSizeMake(cellH+20, 2*cellH);
    return size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    
    return self.dataSource.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.model.type == 7||self.attModel.type == 7) {
        
        SFApprovalPreeCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:SFApprovalPreeCellID forIndexPath:indexPath];
        
        ExpenseProcessModel * model = self.dataSource[indexPath.row];
        cell.model = model;
        
        if (indexPath.row == self.dataSource.count-1) {
            cell.arrowImage.hidden = YES;
        }else{
            cell.arrowImage.hidden = NO;
        }
        
        return cell;
    }
    SFCopyWhoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SFCopyWhoCellID forIndexPath:indexPath];
    
    ExpenseToWhoModel * model = self.dataSource[indexPath.row];
    cell.whoModel = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
