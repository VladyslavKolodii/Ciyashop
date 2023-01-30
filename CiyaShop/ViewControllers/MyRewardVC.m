//
//  MyRewardVC.m
//  QuickClick
//
//  Created by Kaushal PC on 02/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "MyRewardVC.h"
#import "MyRewardCell.h"
#import "ScratchCardVC.h"

@import ListPlaceholder;
@interface MyRewardVC ()<ScratchViewDelegate>

@property (strong,nonatomic) IBOutlet UIView *vwLoader;
@property (strong,nonatomic) IBOutlet UIView *vwLoader1;
@property (strong,nonatomic) IBOutlet UIView *vwLoader2;
@property (strong,nonatomic) IBOutlet UIView *vwLoader3;
@property (strong,nonatomic) IBOutlet UIView *vwLoader4;
@property (strong,nonatomic) IBOutlet UIView *vwLoader5;

@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UITableView *tblMyRewards;
@property (strong, nonatomic) IBOutlet UIView *vwMyRewards;
@property (strong, nonatomic) IBOutlet UIView *vwNoRewards;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblnoRewards;
@property (strong, nonatomic) IBOutlet UIButton *btnContinueShopping;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong,nonatomic) IBOutlet UIView *vwAllData;

@property (strong,nonatomic) IBOutlet UIImageView *imgCoupon;
@property (strong,nonatomic) IBOutlet UIImageView *imgScratchCoupon;

@property (strong,nonatomic) IBOutlet UIImageView *imgArrow;


@end

@implementation MyRewardVC
{
    NSMutableArray *arrCouponData,  *arrScratch;
    int page, selectedCoupon;
    BOOL apiCallRunning;
    UIView *vw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.strComeFrom isEqualToString:@"Notification"])
    {
        self.strComeFrom=@"";
    }
    
    appDelegate.vc= NSStringFromClass([self class]);

    [self setLayout];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    page = 1;
    arrCouponData = [[NSMutableArray alloc]  init];
    arrScratch = [[NSMutableArray alloc]  init];
    [self getCoupon];
    
    [Util setSecondaryColorButtonImage:self.btnContinueShopping image:[UIImage imageNamed:@"MyRewardsButtonBG"]];
    
    [Util setSecondaryColorImageView:self.imgArrow];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getCoupon)
                                                 name:kRefresh
                                               object:nil];
    [Util setHeaderColorView:vw];
    [super viewWillAppear:YES];
    [self localize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setLayout
{
    self.vwNoRewards.frame = CGRectMake(-SCREEN_SIZE.width, 42, SCREEN_SIZE.width, self.vwNoRewards.frame.size.height);
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    appDelegate.vc=@"";
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}

#pragma mark - Localize Language

- (void)localize
{
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.textColor = OtherTitleColor;
    [Util setSecondaryColorButtonTitle:self.btnContinueShopping];
    self.lblTitle.text = [MCLocalization stringForKey:@"My Coupons"];
    
    self.lblnoRewards.text = [MCLocalization stringForKey:@"No Rewards yet..!!"];
    [self.btnContinueShopping setTitle:[MCLocalization stringForKey:@"CONTINUE SHOPPING"] forState:UIControlStateNormal];
    
    self.lblTitle.font = Font_Size_Navigation_Title;
    
    if (appDelegate.isRTL) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }
    
    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

#pragma mark - Navigation

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnContinueShoppingClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.tabBarController setSelectedIndex:0];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrCouponData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MyRewardCell";
    
    MyRewardCell *cell = (MyRewardCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyRewardCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.row % 3 == 0)
    {
        cell.imgCoupon.image = [UIImage imageNamed:@"MyRewardsCoupon1"];
        cell.imgScratchCoupon.image = [UIImage imageNamed:@"MyRewardsCoupon1"];
    }
    else if (indexPath.row % 3 == 1)
    {
        cell.imgCoupon.image = [UIImage imageNamed:@"MyRewardsCoupon2"];
        cell.imgScratchCoupon.image = [UIImage imageNamed:@"MyRewardsCoupon2"];
    }
    else
    {
        cell.imgCoupon.image = [UIImage imageNamed:@"MyRewardsCoupon3"];
        cell.imgScratchCoupon.image = [UIImage imageNamed:@"MyRewardsCoupon3"];
    }
    
    cell.lblTitle.text = [[[arrCouponData objectAtIndex:indexPath.row] valueForKey:@"code"] uppercaseString];
    cell.lblDescription.text = [[arrCouponData objectAtIndex:indexPath.row] valueForKey:@"description"];
    

    cell.lblCouponCode.text = [MCLocalization stringForKey:@"Coupon Code"];
    cell.lblTitle.font = Font_Size_Navigation_Title;
    cell.lblCouponCode.font = Font_Size_Product_Name_Regular;
    cell.lblDescription.font = Font_Size_Product_Name_Regular;
    
    if ([[arrScratch objectAtIndex:indexPath.row] isEqualToString:@"0"])
    {
        //not scratched
        cell.imgScratchCoupon.hidden = false;
        cell.lblScratchText.hidden = false;
        cell.lblScratchText.text = [MCLocalization stringForKey:@"Scratch here to get coupon Code."];
    }
    else
    {
        //scratched
        cell.imgScratchCoupon.hidden = true;
        cell.lblScratchText.hidden = true;
    }

    
    
    if (!apiCallRunning)
    {
        if ((page - 1)*10 == arrCouponData.count)
        {
            if (indexPath.row == arrCouponData.count - 4)
            {
                [self getCoupon];
                apiCallRunning = YES;
            }
        }
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrScratch objectAtIndex:indexPath.row] isEqualToString:@"0"])
    {
        //not scratched
        selectedCoupon = (int)indexPath.row;
        
        ScratchCardVC *vc = [[ScratchCardVC alloc] initWithNibName:@"ScratchCardVC" bundle:nil];
        vc.delegate = self;
        vc.strCouponCode = [[[arrCouponData objectAtIndex:indexPath.row] valueForKey:@"code"] uppercaseString];
        vc.strCouponDesc = [[arrCouponData objectAtIndex:indexPath.row] valueForKey:@"description"];
        vc.providesPresentationContextTransitionStyle = YES;
        vc.definesPresentationContext = YES;
//        [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
//        [self presentViewController:vc animated:YES completion:nil];
        
        [self.navigationController pushViewController:vc animated:NO];
    }
    else
    {
        //scratched
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [[arrCouponData objectAtIndex:indexPath.row] valueForKey:@"code"];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [MCLocalization stringForKey:@"Coupon Code is Copied to your Clipboard"];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        label.adjustsFontSizeToFitWidth = true;
        [label sizeToFit];
        label.numberOfLines = 4;
        label.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        label.layer.shadowOffset = CGSizeMake(4, 3);
        label.layer.shadowOpacity = 0.3;
        label.frame = CGRectMake(320, SCREEN_SIZE.height - 200, appDelegate.window.frame.size.width, 44);
        label.alpha = 1;
        label.backgroundColor = [UIColor blackColor];
        label.textColor = [UIColor whiteColor];
        
        [appDelegate.window addSubview:label];
        
        CGRect basketTopFrame  = label.frame;
        basketTopFrame.origin.x = 0;
        
        [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut animations: ^(void){
            label.frame = basketTopFrame;
        } completion:^(BOOL finished){
            [label removeFromSuperview];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155;
}

-(void)hideTable
{
    if (arrCouponData.count == 0)
    {
        self.vwMyRewards.hidden = YES;
        self.vwNoRewards.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.vwNoRewards.frame = CGRectMake(0, 42, SCREEN_SIZE.width, self.vwNoRewards.frame.size.height);
        }];
    }
}


#pragma mark - API calls

-(void)getCoupon
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
    [dict setValue:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [dict setValue:[Util getStringData:kDeviceToken] forKey:@"device_token"];
    
    if ([Util getBoolData:kLogin])
    {
        [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    }

    [CiyaShopAPISecurity getCoupons:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        self->apiCallRunning = NO;
        if (success)
        {
            HIDE_PROGRESS;
            NSArray *arrData = [dictionary valueForKey:@"data"];
            if (arrData.count>0)
            {
                for (int i = 0; i < arrData.count; i++)
                {
                    [self->arrCouponData addObject:[arrData objectAtIndex:i]];
                    
                    if ([[[arrData objectAtIndex:i] valueForKey:@"is_coupon_scratched"] isEqualToString:@"yes"])
                    {
                        //scratched
                        [self->arrScratch addObject:@"1"];
                    }
                    else
                    {
                        //not scratched
                        [self->arrScratch addObject:@"0"];
                    }
                }
                [self.tblMyRewards reloadData];
                self->page++;
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
                ALERTVIEW(decodedString.string, self);
            }
            else
            {
                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
            }
        }
        self.vwLoader.hidden = true;
        [self.vwLoader1 hideLoader];
        [self.vwLoader2 hideLoader];
        [self.vwLoader3 hideLoader];
        [self.vwLoader4 hideLoader];
        [self.vwLoader5 hideLoader];
        
        [self hideTable];
    }];
}

-(void)scratchedCoupon
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[arrCouponData objectAtIndex:selectedCoupon] valueForKey:@"id"] forKey:@"coupon_id"];
    [dict setValue:@"yes" forKey:@"is_coupon_scratched"];
    [dict setValue:[Util getStringData:kDeviceToken] forKey:@"device_token"];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    
    [CiyaShopAPISecurity scratchCoupon:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        self->apiCallRunning = NO;

        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                [self->arrScratch removeObjectAtIndex:self->selectedCoupon];
                [self->arrScratch insertObject:@"1" atIndex:self->selectedCoupon];
                [self.tblMyRewards reloadData];
            }
        }
        else
        {
            if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
                NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                NSAttributedString *decodedString;
                decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                 options:options
                                                      documentAttributes:NULL
                                                                   error:NULL];
                ALERTVIEW(decodedString.string, self);
            }
            else
            {
                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
            }
        }
    }];
}

#pragma mark - Scratch View Delegate

- (void)scratchView {
    //API call here for scratch coupon
    [self scratchedCoupon];
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
