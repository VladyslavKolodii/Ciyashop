
//
//  ReasonToBuyWithUsCell.m
//  CiyaShop
//
//  Created by Kaushal PC on 04/10/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "ReasonToBuyWithUsCell.h"
#import "BuyReasonCell.h"

@implementation ReasonToBuyWithUsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    [self.colReasons registerNib:[UINib nibWithNibName:@"BuyReasonCell" bundle:nil] forCellWithReuseIdentifier:@"BuyReasonCell"];
    self.colReasons.delegate = self;
    self.colReasons.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
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
    return appDelegate.arrReasonToBuyWithUs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BuyReasonCell";
    
    BuyReasonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BuyReasonCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblTitle.text = [[appDelegate.arrReasonToBuyWithUs objectAtIndex:indexPath.row] valueForKey:@"feature_title"];
    cell.lblDescription.text = [[appDelegate.arrReasonToBuyWithUs objectAtIndex:indexPath.row] valueForKey:@"feature_content"];
    
    [cell.lblDescription sizeToFit];
    [Util setPrimaryColorImageView:cell.img];
    
    cell.lblTitle.textColor = LightBlackColor;
    cell.lblDescription.textColor = FontColorGray;
    
    cell.lblTitle.font = Font_Size_Product_Name_Small_Regular;
    cell.lblDescription.font = Font_Size_Price_Sale_Small;
    
    [cell.imgIcon sd_setImageWithURL:[Util EncodedURL:[[appDelegate.arrReasonToBuyWithUs objectAtIndex:indexPath.row] valueForKey:@"feature_image"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        cell.imgIcon.image = image;
    }];
    
    if (indexPath.row == appDelegate.arrReasonToBuyWithUs.count - 1)
    {
        cell.lblRight.hidden = YES;
    }
    else if (indexPath.row % 2 == 0)
    {
        cell.lblRight.hidden = NO;
    }
    else
    {
        cell.lblRight.hidden = YES;
    }

    if (indexPath.row == appDelegate.arrReasonToBuyWithUs.count - 1)
    {
        cell.lblBottom.hidden = YES;
    }
    else if (indexPath.row % 2 == 1)
    {
        if (indexPath.row >= appDelegate.arrReasonToBuyWithUs.count - 1)
        {
            cell.lblBottom.hidden = YES;
        }
        else
        {
            cell.lblBottom.hidden = NO;
        }
    }
    else
    {
        if (indexPath.row >= appDelegate.arrReasonToBuyWithUs.count - 2)
        {
            cell.lblBottom.hidden = YES;
        }
        else
        {
            cell.lblBottom.hidden = NO;
        }
    }
    
    cell.img.frame = CGRectMake(cell.img.frame.origin.x, cell.img.frame.origin.y, cell.img.frame.size.width, cell.img.frame.size.width);
    
    if (appDelegate.isRTL)
    {
        //RTL
        cell.lblTitle.textAlignment = NSTextAlignmentRight;
        cell.lblDescription.textAlignment = NSTextAlignmentRight;
        
        cell.vwImage.frame = CGRectMake((collectionView.frame.size.width/2) - cell.vwImage.frame.size.width - 3, cell.vwImage.frame.origin.y, cell.vwImage.frame.size.width, cell.vwImage.frame.size.height);

        cell.lblTitle.frame = CGRectMake(3, cell.lblTitle.frame.origin.y, cell.lblTitle.frame.size.width, cell.lblTitle.frame.size.height);
        cell.lblDescription.frame = CGRectMake(3, cell.lblDescription.frame.origin.y, cell.lblTitle.frame.size.width, cell.lblDescription.frame.size.height);
    }
    else
    {
        cell.lblTitle.frame = CGRectMake(46, cell.lblTitle.frame.origin.y, cell.lblTitle.frame.size.width, cell.lblTitle.frame.size.height);
        cell.lblDescription.frame = CGRectMake(48, cell.lblDescription.frame.origin.y, cell.lblTitle.frame.size.width, cell.lblDescription.frame.size.height);
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Error here
    NSLog(@"width %f",[[[[UIApplication sharedApplication] keyWindow] rootViewController].view convertRect:[[UIScreen mainScreen] bounds] fromView:nil].size.width);
    
    return CGSizeMake(collectionView.frame.size.width/2, 97*SCREEN_SIZE.width/375);
}

@end
