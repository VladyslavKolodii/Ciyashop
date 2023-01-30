//
//  VariationCell.m
//  QuickClick
//
//  Created by Kaushal PC on 13/07/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "SimpleItemCell.h"
#import "VariationItemCell.h"
#import "VariableItemDetailVC.h"

@implementation SimpleItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //nib registration for cell
    [self.colItem registerNib:[UINib nibWithNibName:@"VariationItemCell" bundle:nil] forCellWithReuseIdentifier:@"VariationItemCell"];
    
    UICollectionViewFlowLayout *layout1 = (UICollectionViewFlowLayout *)[self.colItem collectionViewLayout];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"VariationItemCell";
    
    VariationItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VariationItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblTitle.text = [self.arrData objectAtIndex:indexPath.row];
    cell.lblTitle.font = Font_Size_Product_Name_Small;

    if (appDelegate.arrSelectedSimple.count > 0)
    {
        if ([[self.arrData objectAtIndex:indexPath.row] isEqualToString:[appDelegate.arrSelectedSimple objectAtIndex:self.CellNumber]])
        {
            if ([fromServer isEqualToString:@"1"])
            {
                cell.imgBG.image = [UIImage imageNamed:@"SizeColorSelectedBG"];
                [Util setPrimaryColorImageView:cell.imgBG];
            }
            else
            {
                cell.imgBG.image = [UIImage imageNamed:@"SizeColorSelectedBG"];
            }
            cell.imgRight.hidden = false;
        }
        else
        {
            if ([fromServer isEqualToString:@"1"])
            {
                cell.imgBG.image = [UIImage imageNamed:@"SizeColorUnselectedBG"];
                [Util setPrimaryColorImageView:cell.imgBG];
            }
            else
            {
                cell.imgBG.image = [UIImage imageNamed:@"SizeColorUnselectedBG"];
            }
            cell.imgRight.hidden = true;
        }
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (appDelegate.arrSelectedSimple.count > 0)
    {
        [appDelegate.arrSelectedSimple removeObjectAtIndex:self.CellNumber];
        [appDelegate.arrSelectedSimple insertObject:[self.arrData objectAtIndex:indexPath.row] atIndex:self.CellNumber];
        
        [self.colItem reloadData];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
}


@end
