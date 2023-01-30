//
//  ThankYouVC.m
//  QuickClick
//
//  Created by Kaushal PC on 31/07/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "ThankYouVC.h"

@interface ThankYouVC ()

@property (strong, nonatomic) IBOutlet UILabel *lblThankYou;
@property (strong, nonatomic) IBOutlet UILabel *lblPlacedSuccessfully;
@property (strong, nonatomic) IBOutlet UILabel *lblMoment;

@property (strong, nonatomic) IBOutlet UIButton *btnContinueShopping;

@property (strong, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UIImageView *imgArrow;

@end

@implementation ThankYouVC {
    UIView *vw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self logoutUser];
    if (appDelegate.isFromBuyNow)
    {
        [Util setArray:nil setData:kBuyNow];
        appDelegate.isFromBuyNow = NO;
    }
    else
    {
        [Util setArray:nil setData:kMyCart];
        appDelegate.isFromBuyNow = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    [Util setSecondaryColorButtonImage:self.btnContinueShopping image:[UIImage imageNamed:@"MyRewardsButtonBG"]];

    [Util setSecondaryColorImageView:self.imgArrow];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [appDelegate showBadge];
    [self localize];
    [Util setHeaderColorView:vw];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Localize Language

/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)localize
{
    [Util setPrimaryColorLabelText:self.lblPlacedSuccessfully];
    
    self.lblMoment.textColor = FontColorLightGray;
    
    [Util setPrimaryColorLabelText:self.lblThankYou];

    self.lblThankYou.text = [MCLocalization stringForKey:@"THANK YOU"];
    self.lblMoment.text = [MCLocalization stringForKey:@"You will notify in few Moments."];
    self.lblPlacedSuccessfully.text = [MCLocalization stringForKey:@"Your Order is Placed Successfully."];
    
    [Util setSecondaryColorButtonTitle:self.btnContinueShopping];
    [self.btnContinueShopping setTitle:[MCLocalization stringForKey:@"CONTINUE SHOPPING"] forState:UIControlStateNormal];
}

#pragma mark - Button Clicked
/*!
 * @discussion It will take you to PreviousView
 * @param sender For indentifying sender
 */
-(IBAction)btnContinueShoppingCLicked:(id)sender
{
    [[appDelegate.baseTabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
    appDelegate.baseTabBarController.selectedIndex = 0;

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API calls
/*!
 * @discussion Webservice call for LogOut User from server
 */
- (void)logoutUser
{
    SHOW_LOADER_ANIMTION();
   
    [CiyaShopAPISecurity userLogout:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        HIDE_PROGRESS;
        if(success==YES)
        {
            //no error
            NSLog(@"Done");
        }
        else
        {
            //error
            NSLog(@"Error");
        }
    }];
}


#pragma mark - hide botttom Bar

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
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
