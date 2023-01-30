//
//  ShopNowCell.m
//  QuickClick
//
//  Created by Umesh on 4/22/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "ShopNowCell.h"
#import "ShopNowCatagoryCell.h"

@implementation ShopNowCell
@synthesize delegate;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.colShopNowCategory.showsHorizontalScrollIndicator=NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.colShopNowCategory setCollectionViewLayout:flowLayout];

    [self.colShopNowCategory registerNib:[UINib nibWithNibName:@"ShopNowCatagoryCell" bundle:nil] forCellWithReuseIdentifier:@"ShopNowCatagoryCell"];
    
//    self.colShopNowCategory.delegate = self;
//    self.colShopNowCategory.dataSource = self;
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
    return appDelegate.arrHomeCatagoryData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ShopNowCatagoryCell";
    ShopNowCatagoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopNowCatagoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblTitle.text = [[appDelegate.arrHomeCatagoryData objectAtIndex:indexPath.row] valueForKey:@"cat_banners_title"];
    cell.lblTitle.font=Font_Size_Title;
    
    [cell.btnShopNow setTitle:[MCLocalization stringForKey:@"SHOP NOW"] forState:UIControlStateNormal];
    cell.btnShopNow.titleLabel.font=Font_Size_Product_Name_Not_Bold;
    cell.btnShopNow.layer.cornerRadius = 1;
    cell.btnShopNow.layer.masksToBounds = true;

    
    [cell.imgBG sd_setImageWithURL:[Util EncodedURL:[[appDelegate.arrHomeCatagoryData objectAtIndex:indexPath.row] valueForKey:@"cat_banners_image_url"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image == nil)
        {
            cell.imgBG.image = [UIImage imageNamed:@"CategoryNoImage"];
        }
        else
        {
            cell.imgBG.image = image;
        }
    }];
    
    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell.layer.shadowRadius = 3.0f;
    cell.layer.shadowOpacity = 0.7f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (delegate)
    {
        [delegate setCategoryData:indexPath];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 25;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 8, 0, 8);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160*SCREEN_SIZE.width/375, collectionView.frame.size.height);
}

@end
