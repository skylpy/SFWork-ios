//
//  SFSelectPersonCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/9.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelectAapprovalPersonCell.h"
#import "SFOrganizationModel.h"
#import "SFApprovalPreeCell.h"
#import "SFPersonItemCell.h"
#import "SFCopyWhoCell.h"

static NSString * const SFPersonItemCellID = @"SFPersonItemCellID";
static NSString * const SFCopyWhoCellID = @"SFCopyWhoCellID";
#define cellH (kWidth - 60) / 5
@interface SFSelectAapprovalPersonCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray * dataSource;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;

@end

@implementation SFSelectAapprovalPersonCell

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
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = flowLayout;
    /// 设置此属性为yes 不满一屏幕 也能滚动
    
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
//    self.titleLabel.textColor = Color(@"#666666");
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    flowLayout.minimumInteritemSpacing = 5;      // cell之间左右间隔

    [self.collectionView registerNib:[UINib nibWithNibName:@"SFPersonItemCell" bundle:nil] forCellWithReuseIdentifier:SFPersonItemCellID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SFCopyWhoCell" bundle:nil] forCellWithReuseIdentifier:SFCopyWhoCellID];
}

- (void)setModel:(SFMyAttendanceModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.starLabel.text = model.stars;
}

- (void)setArray:(NSArray *)array{
    _array = array;
     self.isAdd = YES;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:array];
    [self.collectionView reloadData];
}

- (void)cellContent:(NSArray *)list withType:(BOOL)isAdd withCopy:(BOOL)isCopy{
    
    self.isAdd = isAdd;
    self.isCopy = isCopy;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:list];
    [self.collectionView reloadData];
}

- (void)cellApprovalContent:(NSArray *)list with:(AapprovalPreeType)type withType:(BOOL)isAdd withCopy:(BOOL)isCopy{
    
    self.type = type;
    self.isAdd = isAdd;
    self.isCopy = isCopy;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:list];
    [self.collectionView reloadData];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    
    size = CGSizeMake(87, 110);
    return size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.isAdd ? self.dataSource.count+1 : self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource.count == indexPath.row) {
        SFPersonItemCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:SFPersonItemCellID forIndexPath:indexPath];
        cell.iconImage.image = [UIImage imageNamed:@"btn_add_people"];
        cell.nameLabel.text = @"";
        cell.statueLabel.text = @"";
        cell.arrowImage.hidden = YES;
        return cell;
        
    }
    
    id model = self.dataSource[indexPath.row];
    SFPersonItemCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:SFPersonItemCellID forIndexPath:indexPath];
    cell.arrowImage.hidden = NO;
    if (self.type == FinancialAppType) {
        
        cell.bmodel = model;
        if (self.dataSource.count-1 == indexPath.row) {
            cell.arrowImage.hidden = YES;
        }
    }else{
       
        if (self.isAdd) {
            cell.model = model;
        }else{
            if (self.isCopy) {
                cell.cmodel = model;
            }else{
                cell.amodel = model;
            }
            if (self.dataSource.count-1 == indexPath.row) {
                cell.arrowImage.hidden = YES;
            }
        }
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count == indexPath.row) {
        !self.addPeopleClick?:self.addPeopleClick();
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
