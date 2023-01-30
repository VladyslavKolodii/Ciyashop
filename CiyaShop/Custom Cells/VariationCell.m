//
//  VariationCell.m
//  QuickClick
//
//  Created by Kaushal PC on 13/07/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "VariationCell.h"
#import "VariationItemCell.h"
#import "VariableItemDetailVC.h"

@implementation VariationCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    [self.colItem setDelegate:self];
    [self.colItem setDataSource:self];

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

    if(self.arrNewData.count != 0)
    {
        if ([[self.arrNewData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
            cell.lblVariationText.text = [self.arrData objectAtIndex:indexPath.row];
            cell.vwVariationColor.hidden = YES;
            cell.vwVariationText.hidden = NO;
            cell.vwVariationImage.hidden = YES;
        } else if (![[[self.arrNewData objectAtIndex:indexPath.row] valueForKey:@"image"] isEqualToString:@""]) {
            //image available
            [cell.imgVariationImage sd_setImageWithURL:[Util EncodedURL:[[self.arrNewData objectAtIndex:indexPath.row] valueForKey:@"image"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                cell.imgVariationImage.image = image;
            }];
            cell.vwVariationColor.hidden = YES;
            cell.vwVariationText.hidden = YES;
            cell.vwVariationImage.hidden = NO;
        } else if (![[[self.arrNewData objectAtIndex:indexPath.row] valueForKey:@"color"] isEqualToString:@""]) {
            //color available
            
            NSString *str = [[[self.arrNewData objectAtIndex:indexPath.row] valueForKey:@"color"] stringByReplacingOccurrencesOfString:@"#" withString:@""];
            cell.imgVariationColor.backgroundColor = [Util colorWithHexString:str];
            
            cell.vwVariationColor.hidden = NO;
            cell.vwVariationText.hidden = YES;
            cell.vwVariationImage.hidden = YES;
        } else if (![[[self.arrNewData objectAtIndex:indexPath.row] valueForKey:@"variation_name"] isEqualToString:@""]) {
            //text available
            cell.lblVariationText.text = [[self.arrNewData objectAtIndex:indexPath.row] valueForKey:@"variation_name"];
            
            cell.vwVariationColor.hidden = YES;
            cell.vwVariationText.hidden = NO;
            cell.vwVariationImage.hidden = YES;
        } else {
            //nothing is available
            cell.lblVariationText.text = [self.arrData objectAtIndex:indexPath.row];
            cell.vwVariationColor.hidden = YES;
            cell.vwVariationText.hidden = NO;
            cell.vwVariationImage.hidden = YES;
        }
    }
    else
    {
        cell.lblVariationText.text = [self.arrData objectAtIndex:indexPath.row];
        
        cell.vwVariationColor.hidden = YES;
        cell.vwVariationText.hidden = NO;
        cell.vwVariationImage.hidden = YES;
    }
    cell.lblVariationBG.layer.cornerRadius = 3;
    cell.imgBG.layer.cornerRadius = 3;
    cell.imgBG.alpha = 0.5;
    [cell.imgBG setBackgroundColor:[Util colorWithHexString:[Util getStringData:kPrimaryColor]]];
    [self setBorderColor:cell.lblVariationBG colorData:[Util getStringData:kPrimaryColor]];

    if (appDelegate.arrSelectedVariable.count > 0) {
        
        if ([[self.arrData objectAtIndex:indexPath.row] isEqualToString:[appDelegate.arrSelectedVariable objectAtIndex:self.CellNumber]]) {
            //selected
//            if(self.arrNewData.count != 0) {
//                [self setBorderColor:cell.lblVariationBG colorData:[Util getStringData:kPrimaryColor]];
//            } else {
//                [self setBorderColor:cell.lblVariationBG colorData:[Util getStringData:kPrimaryColor]];
//            }
            cell.imgBG.hidden = false;
            cell.imgRight.hidden = false;
        } else {
            //unselected
//            cell.lblVariationBG.hidden = YES;
            cell.imgBG.hidden = true;
            cell.imgRight.hidden = true;
        }
        
        // make alpha value set for cell to be available or not
        
//        int CellHidden = 0;
//
//        for (int i = 0; i < appDelegate.arrVariations.count; i++)
//        {
//            CellHidden = 0;
//            if (self.CellNumber == 0)
//            {
//                CellHidden = 1111;
//                break;
//            }
//            NSMutableArray *arrAttribute = [[NSMutableArray alloc] init];
//
//            for (int k = 0; k < [[[appDelegate.arrVariations objectAtIndex:i] valueForKey:@"attributes"] count]; k++)
//            {
//                [arrAttribute addObject:[[[[appDelegate.arrVariations objectAtIndex:i] valueForKey:@"attributes"] objectAtIndex:k] valueForKey:@"option"]];
//            }
//            NSLog(@"%d",self.CellNumber);
//            for (int j = 0; j <= self.CellNumber; j++)
//            {
//                NSLog(@"%@",[appDelegate.arrSelectedVariable objectAtIndex:j]);
//                if ([arrAttribute containsObject:[appDelegate.arrSelectedVariable objectAtIndex:j]])
//                {
//                    CellHidden++;
//                }
//            }
//
//            if (arrAttribute.count < appDelegate.arrSelectedVariable.count)
//            {
//                if(CellHidden == self.CellNumber)
//                {
//                    CellHidden = 1111;
//                    break;
//                }
//                else if (CellHidden >= self.CellNumber)
//                {
//                    CellHidden = 1;
//                    if ([arrAttribute containsObject:[self.arrData objectAtIndex:indexPath.row]])
//                    {
//                        CellHidden = 1111;
//                    }
//                }
//                else if (CellHidden < self.CellNumber)
//                {
//                    if (CellHidden >= appDelegate.arrSelectedVariable.count - arrAttribute.count)
//                    {
//                        if ([arrAttribute containsObject:[self.arrData objectAtIndex:indexPath.row]])
//                        {
//                            CellHidden = 1111;
//                        }
//                    }
//                }
//            }
//
//            if (CellHidden >= self.CellNumber)
//            {
//                CellHidden = 1;
//                if ([arrAttribute containsObject:[self.arrData objectAtIndex:indexPath.row]])
//                {
//                    CellHidden = 1111;
//                }
//            }
//
//            if (CellHidden == 1111)
//            {
//                break;
//            }
//        }
//
//        if (CellHidden == 1111)
//        {
//            cell.alpha = 1.0;
//        }
//        else if(CellHidden < 1111)
//        {
//            cell.alpha = 1.0;
//        }
    } else {
        cell.imgBG.hidden = true;
        cell.imgRight.hidden = true;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (appDelegate.arrSelectedVariable.count > 0)
    {
        [appDelegate.arrSelectedVariable removeObjectAtIndex:self.CellNumber];
        [appDelegate.arrSelectedVariable insertObject:[self.arrData objectAtIndex:indexPath.row] atIndex:self.CellNumber];
        
        [self.colItem reloadData];
        NSMutableArray *arrData = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < appDelegate.arrSelectedVariable.count; i++)
        {
            if (i == self.CellNumber)
            {
                continue;
            }
            NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [arrData addObject:tempIndexPath];
        }
        
        if(_delegate)
        {
            [_delegate shouldReloadTable:arrData];
        }
    }
}
//set variation border color

-(void)setBorderColor:(UILabel*)lbl colorData:(NSString*)colorData {
    lbl.hidden = false;
//    lbl.layer.cornerRadius = lbl.frame.size.width/2;
    lbl.layer.borderColor = [[Util colorWithHexString:colorData] CGColor];
    lbl.layer.borderWidth = 2;
//    lbl.clipsToBounds = YES;
//    lbl.layer.masksToBounds = YES;
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
