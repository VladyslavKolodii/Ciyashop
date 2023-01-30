//
//  DealOfTheDayCell.m
//  QuickClick
//
//  Created by APPLE on 24/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "DealOfTheDayCell.h"

@interface DealOfTheDayCell() <DealOfTheDayDelegate>

@end

@implementation DealOfTheDayCell
@synthesize delegate, seconds, mins, hours, set;

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    //312*135
    self.colProducts.showsHorizontalScrollIndicator=NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.colProducts setCollectionViewLayout:flowLayout];
    
    [self.colProducts registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellWithReuseIdentifier:@"ProductCell"];
    self.colProducts.delegate=self;
    self.colProducts.dataSource=self;
    set = 0;
    
    [TimerHelper sharedInstance].delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)TimerHelper:(NSString *)time
{
    self.lblTimer.text = time;
}

-(void)timerData
{
    seconds--;
    if (mins == 0 && hours == 0 && seconds == 0)
    {
        //remove data of the table
    }
    else
    {
        if (seconds == -1)
        {
            seconds = 59;
            mins--;
            if(mins == -1)
            {
                mins = 59;
                hours--;
                if (hours == -1)
                {
                    hours = 0;
                }
            }
        }
    }
    [[[appDelegate.arrDealOfTheDay objectAtIndex:0] valueForKey:@"deal_life"] setValue:[NSString stringWithFormat:@"%d", seconds] forKey:@"seconds"];
    [[[appDelegate.arrDealOfTheDay objectAtIndex:0] valueForKey:@"deal_life"] setValue:[NSString stringWithFormat:@"%d", hours] forKey:@"hours"];
    [[[appDelegate.arrDealOfTheDay objectAtIndex:0] valueForKey:@"deal_life"] setValue:[NSString stringWithFormat:@"%d", mins] forKey:@"minutes"];
    
    self.lblTimer.text = [NSString stringWithFormat:@"%.2d : %.2d : %.2d", hours, mins, seconds];
}


#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (appDelegate.isRTL) {
        [self.colProducts setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    } else {
        [self.colProducts setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (appDelegate.arrDealOfTheDay.count > 4)
    {
        return 4;
    }
    else
    {
        return appDelegate.arrDealOfTheDay.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ProductCell";
    
    ProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.index = (int)indexPath.row;
    
    cell.lblProductName.textColor = FontColorGray;
    cell.lblProductName.text = [[appDelegate.arrDealOfTheDay objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.lblProductName.font=Font_Size_Product_Name_Small;
    
    cell.lblSalePersent.textColor = [UIColor colorWithRed:255/255 green:56/255 blue:56/255 alpha:1.0];
    cell.lblSalePersent.text = [NSString stringWithFormat:@"%d%% off",[[[appDelegate.arrDealOfTheDay objectAtIndex:indexPath.row] valueForKey:@"percentage"] intValue]];
    cell.lblSalePersent.font=Font_Size_Product_Name_Small;
    

    [cell.act startAnimating];
    
    [Util setPrimaryColorActivityIndicator:cell.act];

    NSString * htmlString = [[appDelegate.arrDealOfTheDay objectAtIndex:indexPath.row] valueForKey:@"price_html"];
    cell.lblPrice.attributedText = [Util setPriceForItemSmall:htmlString];
    
    [cell.img sd_setImageWithURL:[Util EncodedURL:[[appDelegate.arrDealOfTheDay objectAtIndex:indexPath.row] valueForKey:@"image"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        cell.img.image = image;
        [cell.act stopAnimating];
    }];

             
                 
    cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell.layer.shadowRadius = 1.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.layer.cornerRadius].CGPath;


    cell.vwDays.layer.shadowOpacity = 0.5f;
    cell.vwDays.layer.masksToBounds = NO;
    cell.vwMinutes.layer.shadowOpacity = 0.5f;
    cell.vwMinutes.layer.masksToBounds = NO;
    cell.vwHours.layer.shadowOpacity = 0.5f;
    cell.vwHours.layer.masksToBounds = NO;

    if (indexPath.row == appDelegate.arrDealOfTheDay.count - 1)
    {
        set = 1;
    }
    
    if (appDelegate.isRTL)
    {
        //RTL
        cell.lblSalePersent.frame = CGRectMake(0, cell.lblSalePersent.frame.origin.y, cell.lblSalePersent.frame.size.width, cell.lblSalePersent.frame.size.height);
        cell.lblProductName.frame = CGRectMake(0, cell.lblProductName.frame.origin.y, cell.lblProductName.frame.size.width, cell.lblProductName.frame.size.height);
        cell.lblPrice.frame = CGRectMake(0, cell.lblPrice.frame.origin.y, cell.lblPrice.frame.size.width, cell.lblPrice.frame.size.height);

        cell.vwImages.frame = CGRectMake(cell.lblSalePersent.frame.size.width + 5, cell.vwImages.frame.origin.y, cell.vwImages.frame.size.width, cell.vwImages.frame.size.height);

        [cell setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        cell.lblSalePersent.textAlignment = NSTextAlignmentRight;
        cell.lblProductName.textAlignment = NSTextAlignmentRight;
        cell.lblPrice.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //No RTL
        cell.vwImages.frame = CGRectMake(0, cell.vwImages.frame.origin.y, cell.vwImages.frame.size.width, cell.vwImages.frame.size.height);
        
        cell.lblSalePersent.frame = CGRectMake(cell.vwImages.frame.size.width + 2, cell.lblSalePersent.frame.origin.y, cell.lblSalePersent.frame.size.width, cell.lblSalePersent.frame.size.height);
        cell.lblProductName.frame = CGRectMake(cell.vwImages.frame.size.width + 2, cell.lblProductName.frame.origin.y, cell.lblProductName.frame.size.width, cell.lblProductName.frame.size.height);
        cell.lblPrice.frame = CGRectMake(cell.vwImages.frame.size.width + 2, cell.lblPrice.frame.origin.y, cell.lblPrice.frame.size.width, cell.lblPrice.frame.size.height);
        
        
        [cell setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        cell.lblSalePersent.textAlignment = NSTextAlignmentLeft;
        cell.lblProductName.textAlignment = NSTextAlignmentLeft;
        cell.lblPrice.textAlignment = NSTextAlignmentLeft;
    }

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self getSingleProduct:[[appDelegate.arrDealOfTheDay objectAtIndex:indexPath.row] valueForKey:@"id"]];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 6.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Error here
    NSLog(@"width %f",[[[[UIApplication sharedApplication] keyWindow] rootViewController].view convertRect:[[UIScreen mainScreen] bounds] fromView:nil].size.width);
    
    
    return CGSizeMake((collectionView.frame.size.width/2) - 3, 85*SCREEN_SIZE.width/375);
}

-(void)setDealOfTheDay
{
    [self.colProducts reloadData];
}

#pragma mark - API calls

-(void)getSingleProduct:(NSString*)productId
{
    SHOW_LOADER_ANIMTION();

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:productId forKey:@"include"];
    
    [CiyaShopAPISecurity productListing:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {

        NSLog(@"%@", dictionary);
        if (success)
        {
            HIDE_PROGRESS;
            if (dictionary.count > 0)
            {
                if (dictionary.count > 0)
                {
                    NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
//                    NSMutableDictionary *dictt = [[NSMutableDictionary alloc] initWithDictionary:[arrData objectAtIndex:0]];
                    
                    Product *object = [Util setProductData:[arrData objectAtIndex:0]];
                    if (self->delegate)
                    {
                        [self->delegate RedirectToDealOfTheDay:object];
                    }
                }
            }
        }
        else
        {
            HIDE_PROGRESS;
            if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
                NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                NSAttributedString *decodedString;
                decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                 options:options
                                                      documentAttributes:NULL
                                                                   error:NULL];
                ALERTVIEW(decodedString.string, appDelegate.window.rootViewController);
            }
            else
            {
                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], appDelegate.window.rootViewController);
            }
        }
    }];
}

@end
