//
//  MyOrderVC.m
//  QuickClick
//
//  Created by Kaushal PC on 02/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "MyOrderVC.h"
#import "MyOrderCell.h"
#import "OrderDetailVC.h"

@import ListPlaceholder;
@interface MyOrderVC ()<OrderDetailDelegate>

@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwNoOrders;
@property (strong, nonatomic) IBOutlet UIButton *btnContinueShopping;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UITableView *tblMyOrders;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblNoNotification;
@property (strong, nonatomic) IBOutlet UILabel *lblNoNotificationMessage;

@property (strong,nonatomic) IBOutlet UIView *vwAllData;
@property (strong,nonatomic) IBOutlet UIImageView *imgArrow;

@property (strong,nonatomic) IBOutlet UIView *vwLoader;
@property (strong,nonatomic) IBOutlet UIView *vwLoader1;
@property (strong,nonatomic) IBOutlet UIView *vwLoader2;
@property (strong,nonatomic) IBOutlet UIView *vwLoader3;
@property (strong,nonatomic) IBOutlet UIView *vwLoader4;
@property (strong,nonatomic) IBOutlet UIView *vwLoader5;

@end

@implementation MyOrderVC
{
    NSMutableArray *arrMyOrders;
    int page;
    BOOL noProduct, apiCallRunning;
    UIView *vw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate.vc= NSStringFromClass([self class]);

    page = 1;
    noProduct = NO;
    
    arrMyOrders = [[NSMutableArray alloc] init];
    [self getMyOrders];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    [Util setSecondaryColorButtonImage:self.btnContinueShopping image:[UIImage imageNamed:@"MyRewardsButtonBG"]];
    [Util setSecondaryColorImageView:self.imgArrow];


    [self.tblMyOrders registerClass:[MyOrderCell class] forCellReuseIdentifier:@"MyOrderCell"];
    [self.tblMyOrders registerNib:[UINib nibWithNibName:@"MyOrderCell" bundle:nil] forCellReuseIdentifier:@"MyOrderCell"];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getMyOrders)
                                                 name:kRefresh
                                               object:nil];
    [Util setHeaderColorView:vw];

    [self localize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    appDelegate.vc = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Localize Language

- (void)localize
{
    [Util setHeaderColorView:self.vwHeader];
    [Util setSecondaryColorButtonTitle:self.btnContinueShopping];
    
    self.lblTitle.textColor = OtherTitleColor;

    self.lblTitle.text = [MCLocalization stringForKey:@"MY ORDERS"];
    self.lblNoNotification.text = [MCLocalization stringForKey:@"No Order yet"];
    self.lblNoNotificationMessage.text = [MCLocalization stringForKey:@"Simply browse , create a wish list or make a purchase."];

    [self.btnContinueShopping setTitle:[MCLocalization stringForKey:@"CONTINUE SHOPPING"] forState:UIControlStateNormal];

    if (appDelegate.isRTL) {
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];

    } else {
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    [self.tblMyOrders reloadData];
    
    self.lblTitle.font = Font_Size_Navigation_Title;

    
    
    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

#pragma mark - Button Clicks

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnViewClicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    OrderDetailVC *vc = [[OrderDetailVC alloc] initWithNibName:@"OrderDetailVC" bundle:nil];
    vc.dictMyOrderData = [arrMyOrders objectAtIndex:btn.tag];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - Button Clicks
-(IBAction)btnContinueShoppingClicked:(id)sender {
    self.tabBarController.selectedIndex = 0;
    [[self.tabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrMyOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *simpleTableIdentifier = @"MyOrderCell";
    
    MyOrderCell *cell = (MyOrderCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyOrderCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.lblOrderDate.font = Font_Size_Product_Name_Small_Regular;
    cell.lblOrderDate.textColor = FontColorGray;
    cell.lblOrderNumber.font = Font_Size_Product_Name_Small_Regular;
    cell.lblOrderNumber.textColor = FontColorGray;
    cell.lblOrderedItem.font = Font_Size_Product_Name_Regular;
    cell.lblDeliveryStatus.font = Font_Size_Product_Name;
    cell.lblDeliveredDate.font = Font_Size_Product_Name_Small_Regular;
    cell.lblDeliveredDate.textColor = FontColorGray;
    cell.lblDeliveryStatus.font = Font_Size_Product_Name;
    [Util setPrimaryColorLabelText:cell.lblDeliveryStatus];

    cell.lblDesc.font = Font_Size_Product_Name_Small_Regular;
    cell.lblDesc.textColor = FontColorGray;
    
    cell.btnViewAll.layer.cornerRadius = 3;
    cell.btnViewAll.layer.masksToBounds = true;
    cell.btnViewAll.titleLabel.font = Font_Size_Product_Name_Not_Bold;
    [cell.btnViewAll setTitle:[MCLocalization stringForKey:@"View"] forState:UIControlStateNormal];

    
    [Util setSecondaryColorButton:cell.btnViewAll];
    [cell.btnViewAll addTarget:self action:@selector(btnViewClicked:) forControlEvents:UIControlEventTouchUpInside];

    cell.btnViewAll.tag = indexPath.row;
    
    cell.lblDesc.text = [MCLocalization stringForKey:@"Rate and Review the product based on your Experience."];

    if ([[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"line_items"] count] > 0) {
        if([[[[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"line_items"] objectAtIndex:0] valueForKey:@"product_image"] isKindOfClass:[NSString class]]) {
            [Util setPrimaryColorActivityIndicator:cell.activity];
            [cell.activity startAnimating];
            [cell.imgLogo sd_setImageWithURL:[Util EncodedURL:[[[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"line_items"] objectAtIndex:0] valueForKey:@"product_image"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                cell.imgLogo.image = image;
                [cell.activity stopAnimating];
            }];
        }
    }
    
    //    for star rating View
    NSString *str = [[NSString alloc] init];
    for (int i = 0; i < [[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"line_items"] count]; i++)
    {
        NSString *str2 = [[[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"line_items"] objectAtIndex:i] valueForKey:@"name"];
        if (i == 0)
        {
            str = [NSString stringWithFormat:@"%@",str2];
        }
        else
        {
            str = [NSString stringWithFormat:@"%@ & %@",str,str2];
        }
    }
    cell.lblOrderedItem.text = str;
    cell.lblDeliveryStatus.text = [[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"status"] capitalizedString];
    
    NSString *strTime = [[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"date_created_gmt"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];// [NSLocale currentLocale];
    [dateFormatter setLocale:locale];

    NSDate *dateFromString = [dateFormatter dateFromString:strTime];
    
    
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:dateFromString];
    
    
    cell.lblOrderDate.text = [NSString stringWithFormat:@"%@ %@", [MCLocalization stringForKey:@"On"], timestamp];
//    [cell.lblOrderDate sizeToFit];
    
    cell.lblOrderNumber.text = [NSString stringWithFormat:@"%@-#%@", [MCLocalization stringForKey:@"Order Id"], [[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"id"] stringValue]];
//    [cell.lblOrderNumber sizeToFit];
    
    
    
    
    if ([[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"any"])
    {
        cell.lblDeliveredDate.text = [MCLocalization stringForKey:@"Delivered Soon"];
    }
    else if ([[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"pending"])
    {
        cell.lblDeliveredDate.text = [MCLocalization stringForKey:@"Order is in Pending State"];
    }
    else if ([[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"processing"])
    {
        cell.lblDeliveredDate.text = [MCLocalization stringForKey:@"Order is Under Processing"];
    }
    else if ([[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"on-hold"])
    {
        cell.lblDeliveredDate.text = [MCLocalization stringForKey:@"Order is On-Hold"];
    }
    else if ([[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"completed"])
    {
        cell.lblDeliveryStatus.text = [MCLocalization stringForKey:@"Delivered"];
        
        NSString *strTime = [[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"date_completed"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:locale];
        NSDate *dateFromString = [dateFormatter dateFromString:strTime];
        
        [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *timestamp1 = [dateFormatter stringFromDate:dateFromString];
        
        cell.lblDeliveredDate.text = [NSString stringWithFormat:@"Delivered On %@",timestamp1];
    }
    else if ([[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"cancelled"])
    {
        cell.lblDeliveredDate.text = [MCLocalization stringForKey:@"Order is Cancelled"];
    }
    else if ([[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"refunded"])
    {
        cell.lblDeliveredDate.text = [MCLocalization stringForKey:@"You are refunded for this order"];
    }
    else if ([[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"failed"])
    {
        cell.lblDeliveredDate.text = [MCLocalization stringForKey:@"Order is Failed"];
    }
    else if ([[[arrMyOrders objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"shipping"])
    {
        cell.lblDeliveredDate.text = [MCLocalization stringForKey:@"Your Order will be deliver soon"];
    }
    
    
    if (!apiCallRunning)
    {
        if (!noProduct)
        {
            if ((page - 1)*10 == arrMyOrders.count)
            {
                if (indexPath.row == arrMyOrders.count - 4)
                {
                    [self getMyOrders];
                    apiCallRunning = YES;
                }
            }
        }
    }
    
    if (appDelegate.isRTL)
    {
        cell.lblOrderedItem.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //NonRTL
        cell.lblOrderedItem.textAlignment = NSTextAlignmentLeft;
    }
    
    [cell layoutIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

#pragma mark - StarRating Value changed

- (void)didChangeValue:(id)sender
{
    
}

#pragma mark - API Calls

-(void)getMyOrders
{
    if (appDelegate.isShimmerLoader) {
        [self.vwLoader1 showLoader];
        [self.vwLoader2 showLoader];
        [self.vwLoader3 showLoader];
        [self.vwLoader4 showLoader];
        [self.vwLoader5 showLoader];
        self.vwLoader.hidden = false;
    } else {
        SHOW_LOADER_ANIMTION();
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kUserID] forKey:@"customer"];
    [dict setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    
    apiCallRunning = YES;
    
    [CiyaShopAPISecurity getOrders:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        self->apiCallRunning = NO;
        if (success)
        {
            if([dictionary isKindOfClass:[NSArray class]])
            {
                //Is array
                NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
                
                for (int i = 0; i < arrData.count; i++)
                {
                    [self->arrMyOrders addObject:[arrData objectAtIndex:i]];
                }
                self->page++;
                HIDE_PROGRESS;
            }
            else if([dictionary isKindOfClass:[NSDictionary class]])
            {
                //is dictionary
                self->noProduct = YES;
                HIDE_PROGRESS;
            }
        }
        else
        {
            self->noProduct = YES;
            HIDE_PROGRESS;
        }
        if (self->arrMyOrders.count > 0)
        {
            [self.tblMyOrders reloadData];
            self.vwNoOrders.hidden = YES;
            self.tblMyOrders.hidden = NO;
        }
        else
        {
            self.vwNoOrders.hidden = NO;
            self.tblMyOrders.hidden = YES;
        }
        self.vwLoader.hidden = true;
        [self.vwLoader1 hideLoader];
        [self.vwLoader2 hideLoader];
        [self.vwLoader3 hideLoader];
        [self.vwLoader4 hideLoader];
        [self.vwLoader5 hideLoader];
    }];
}

#pragma mark - Order Detail Delegate

-(void)updateOrderDetail
{
    page = 1;
    noProduct = NO;
    arrMyOrders = [[NSMutableArray alloc] init];
    [self getMyOrders];
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
