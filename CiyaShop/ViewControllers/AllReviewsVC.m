//
//  AllReviewsVC.m
//  CiyaShop
//
//  Created by Kaushal PC on 14/11/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "AllReviewsVC.h"
#import "Rate&ReviewCell.h"

@interface AllReviewsVC ()
@property (strong, nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UITableView *tblReview;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@end

@implementation AllReviewsVC{
    UIView *vw;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self localize];
    if (@available(iOS 13, *))
    {
        UIView *statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
        [Util setHeaderColorView:statusBar];
        [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
    }
    else
    {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            [Util setHeaderColorView:statusBar];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Util setHeaderColorView:vw];
}


#pragma mark - Button clicks
/*!
 * @discussion Will Take you to seller Contact page
 * @param sender For indentifying sender
 */
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Localize Language

/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)localize
{
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.text = self.strTitle;
    self.lblTitle.textColor = OtherTitleColor;
    if (appDelegate.isRTL)
    {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
    }
    else
    {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Rate&ReviewCell";
    
    Rate_ReviewCell *cell = (Rate_ReviewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Rate&ReviewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblTime.font = Font_Size_Product_Name_Regular;
    cell.lblReview.font = Font_Size_Product_Name;
    cell.lblRate.font = Font_Size_Product_Name_Small;
    cell.btnMore.titleLabel.font = Font_Size_Product_Name_Not_Bold;
    
    cell.lblReview.textColor = FontColorGray;
    [Util setPrimaryColorButtonTitle:cell.btnMore];
    
    if (self.fromProductDetail)
    {
        cell.lblDescription.text = [[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"review"];
        [cell.lblDescription sizeToFit];
        
        cell.lblRate.text = [[[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"rating"] stringValue];
        cell.lblName.text = [[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"name"];
        [cell.lblName sizeToFit];
        cell.lblReview.text = [[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        NSString *strTime = [[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"date_created_gmt"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *dateFromString = [dateFormatter dateFromString:strTime];
        
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *timestamp = [dateFormatter stringFromDate:dateFromString];
        NSLog(@"%@",timestamp);
        cell.lblTime.text = timestamp;
        [cell.lblTime sizeToFit];
    }
    else
    {
        cell.lblDescription.text = [[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"comment_content"];
        [cell.lblDescription sizeToFit];
        
        cell.lblRate.text = [[[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"rating"] stringValue];
        cell.lblName.text = [[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"comment_author"];
        [cell.lblName sizeToFit];
        cell.lblReview.text = [[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"comment_author"];
        
        
        NSString *strTime = [[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"comment_date"];
        cell.lblTime.text = strTime;
        [cell.lblTime sizeToFit];
    }
    
    [cell.btnMore setTitle:[MCLocalization stringForKey:@"More >"] forState:UIControlStateNormal];
    
    cell.lblDescription.frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblReview.frame.origin.y + cell.lblReview.frame.size.height + 4, cell.frame.size.width - 46, cell.lblDescription.frame.size.height);
    
    cell.lblName.frame = CGRectMake(cell.lblName.frame.origin.x, cell.lblDescription.frame.origin.y + cell.lblDescription.frame.size.height + 8, cell.lblName.frame.size.width, cell.lblName.frame.size.height);
    
    cell.lblName.hidden = YES;
    cell.lblTime.frame = CGRectMake(cell.lblName.frame.origin.x, cell.lblName.frame.origin.y, cell.lblTime.frame.size.width, cell.lblName.frame.size.height);
    
    cell.btnMore.frame = CGRectMake(cell.btnMore.frame.origin.x, cell.lblName.frame.origin.y + cell.lblName.frame.size.height + 4, cell.btnMore.frame.size.width, cell.btnMore.frame.size.height);
    
    if (indexPath.row == self.arrComments.count - 1)
    {
        cell.Devider.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblDescription.font = Font_Size_Product_Name_Regular;
    
    if (appDelegate.isRTL)
    {
        //RTL
        cell.lblDescription.textAlignment = NSTextAlignmentRight;
        cell.lblName.textAlignment = NSTextAlignmentRight;
        cell.lblTime.textAlignment = NSTextAlignmentRight;
        cell.lblReview.textAlignment = NSTextAlignmentRight;
        
        cell.vwRating.frame = CGRectMake(tableView.frame.size.width - cell.vwRating.frame.size.width - 22, cell.vwRating.frame.origin.y, cell.vwRating.frame.size.width, cell.vwRating.frame.size.height);
        cell.lblReview.frame = CGRectMake(22, cell.lblReview.frame.origin.y, cell.lblReview.frame.size.width, cell.lblReview.frame.size.height);
        cell.lblTime.frame = CGRectMake(tableView.frame.size.width - cell.lblTime.frame.size.width - 22, cell.lblTime.frame.origin.y, cell.lblTime.frame.size.width, cell.lblTime.frame.size.height);
    }
    else
    {
        cell.lblReview.frame = CGRectMake(71, cell.lblReview.frame.origin.y, cell.lblReview.frame.size.width, cell.lblReview.frame.size.height);
        cell.lblDescription.textAlignment = NSTextAlignmentLeft;
        cell.lblName.textAlignment = NSTextAlignmentLeft;
        cell.lblTime.textAlignment = NSTextAlignmentLeft;
        cell.lblReview.textAlignment = NSTextAlignmentLeft;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Rate&ReviewCell";
    Rate_ReviewCell *cell = (Rate_ReviewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Rate&ReviewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (self.fromProductDetail)
    {
        cell.lblDescription.text = [[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"review"];
    }
    else
    {
        cell.lblDescription.text = [[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"comment_content"];
    }
    [cell.lblDescription sizeToFit];
    return 56 + cell.lblDescription.frame.size.height + 4;
//            return cell.frame.size.height + cell.lblDescription.frame.size.height + 4;

}
#pragma mark - StatusBar Delegate
/*!
 * @discussion This method is used to set Status bar text color
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
