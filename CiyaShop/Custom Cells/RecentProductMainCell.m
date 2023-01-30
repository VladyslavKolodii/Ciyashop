//
//  RecentProductMainCell.m
//  QuickClick
//
//  Created by Kaushal PC on 11/08/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "RecentProductMainCell.h"
#import "ShopDataGridCell.h"

@implementation RecentProductMainCell
{
    NSMutableArray *arrData;
}
@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.colRecentlyViewedProducts.showsHorizontalScrollIndicator=NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.colRecentlyViewedProducts setCollectionViewLayout:flowLayout];
    
    [self.colRecentlyViewedProducts registerNib:[UINib nibWithNibName:@"ShopDataGridCell" bundle:nil] forCellWithReuseIdentifier:@"ShopDataGridCell"];

    arrData = [[NSMutableArray alloc] initWithArray:[appDelegate getRecentArray]];
    
    [self.colRecentlyViewedProducts reloadData];
    
//    if (appDelegate.isRTL) {
////        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
////        [self.colRecentlyViewedProducts scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
//        [self.colRecentlyViewedProducts setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//    }
//    else
//    {
//        [self.colRecentlyViewedProducts setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
//    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    arrData = [[NSMutableArray alloc] initWithArray:[[appDelegate getRecentArray] mutableCopy]];
//    [self.colRecentlyViewedProducts reloadData];
//    if (appDelegate.isRTL)
//    {
//        [self.colRecentlyViewedProducts setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//    }
//    else
//    {
//        [self.colRecentlyViewedProducts setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
//    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (arrData.count > 0)
    {
        return [arrData count];
    }
    else
    {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    appDelegate.fromItemDetail = true;
    static NSString *identifier = @"ShopDataGridCell";
    
    ShopDataGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopDataGridCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[arrData ]]
    Product *object;

    if([[arrData objectAtIndex:indexPath.row] isKindOfClass:[NSData class]])
    {
        object = [Util decodeProductData:[arrData objectAtIndex:indexPath.row]];
    }
    else
    {
        object = [arrData objectAtIndex:indexPath.row];
    }
    

    cell.btnWishList.hidden = YES;
    
    cell.lblTitle.text = object.name;
    cell.lblTitle.textColor = FontColorGray;
    cell.lblTitle.font=Font_Size_Product_Name_Small;
    
    if ([object.arrImages count] > 0)
    {
        [cell.act startAnimating];
        [Util setPrimaryColorActivityIndicator:cell.act];
        [cell.imgProduct sd_setImageWithURL:[Util EncodedURL:[[object.arrImages objectAtIndex:0] valueForKey:@"src"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            cell.imgProduct.image = image;
            [cell.act stopAnimating];
        }];
    }
    
    NSString * htmlString = object.price_html;
    cell.lblRate.attributedText = [Util setPriceForItemSmall:htmlString];
    [cell.lblRate setTextAlignment:NSTextAlignmentCenter];
        
    //shadow to cell
    
    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell.layer.shadowRadius = 1.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;                   
    
//    cell.heightImage.constant = cell.frame.size.height - (cell.frame.size.height/3);
    cell.heightRating.constant = 0;
    
    appDelegate.fromItemDetail = false;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (delegate)
    {
        [delegate setClickOnRecentProducts:[arrData objectAtIndex:indexPath.row]];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 8, 0, 8);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(151 * SCREEN_SIZE.width/375, SCREEN_SIZE.width*230/375);
}

@end
