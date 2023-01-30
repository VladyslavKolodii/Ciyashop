
//
//  AccountVC.m
//  QuickClick
//
//  Created by APPLE on 21/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "AccountVC.h"
#import "AccountOptionCell.h"
#import "MyOrderVC.h"
#import "MyAddressVC.h"
#import "MyRewardVC.h"
#import "AccountSettingVC.h"
#import "ContentVC.h"
#import "ContactUsVC.h"
#import "AboutUsVC.h"
#import "SigninVC.h"
#import "MyPointsVC.h"
#import "DownloadVC.h"
#import "WebViewContainVC.h"

@import Firebase;
@import GoogleSignIn;

@interface AccountVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak,nonatomic) IBOutlet UIActivityIndicatorView *act;

@property (weak,nonatomic) IBOutlet UITableView *tblAccountOption;
@property (weak,nonatomic) IBOutlet UIScrollView *scrl;

@property (weak,nonatomic) IBOutlet UIImageView *imgTriangle;
@property (weak,nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (weak,nonatomic) IBOutlet UIImageView *imgUserProfileBG;
@property (weak,nonatomic) IBOutlet UIImageView *imgIconCamera;

@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property (weak,nonatomic) IBOutlet UIView *vwPopUpBG;
@property (weak,nonatomic) IBOutlet UIView *vwPopUpLogout;
@property (weak,nonatomic) IBOutlet UIView *vwPopUpClearHistory;
@property (weak,nonatomic) IBOutlet UIView *vwUserInfo;
@property (weak,nonatomic) IBOutlet UIView *vwUserImage;
@property (weak,nonatomic) IBOutlet UIView *vwWpmlLanguages;


@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblContact;

@property (strong, nonatomic) IBOutlet UILabel *lblClearHistory;
@property (strong, nonatomic) IBOutlet UILabel *lblDescHistory;

@property (strong, nonatomic) IBOutlet UIButton *btnCancelHistory;
@property (strong, nonatomic) IBOutlet UIButton *btnClearHistory;

@property (strong, nonatomic) IBOutlet UILabel *lblSignOut;
@property (strong, nonatomic) IBOutlet UILabel *lblDescSignOut;

@property (strong, nonatomic) IBOutlet UIButton *btnCancelSignOut;
@property (strong, nonatomic) IBOutlet UIButton *btnSureSignOut;

@property (strong, nonatomic) IBOutlet UIButton *btnCancelWpmlLanguages;
@property (strong, nonatomic) IBOutlet UIButton *btnSureWpmlLanguages;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UIView *vwHistoryLast;
@property (strong, nonatomic) IBOutlet UIView *vwLogoutLast;

@property (strong, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UIView *vwCurrency;

@property (nonatomic) CGRect originalFrame;

@property (strong, nonatomic) IBOutlet UIImageView *imgHeaderBG;

@property (strong, nonatomic) IBOutlet UIButton *btnCurrencyDone;
@property (strong, nonatomic) IBOutlet UIButton *btnCurrencyCancel;
@property (strong, nonatomic) IBOutlet UILabel *lblChooseCurrency;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerSortBy;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerWpmlLanguages;

@property (weak, nonatomic) IBOutlet UILabel *lblWpmlLanguages;

@end

@implementation AccountVC
{
    NSArray  *arrContentData;
    NSMutableArray *arrIcon;
    NSData *imgData;
    int getdata;
    UIView *vw;
    NSMutableArray *arrData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!appDelegate.flgAccount)
    {
         appDelegate.flgAccount=YES;
        [self checkNotifications];
    }
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    self.vwPopUpBG.hidden = YES;
    self.vwPopUpBG.alpha = 0.0;
    self.vwPopUpLogout.hidden = YES;
    self.vwPopUpLogout.layer.masksToBounds = YES;
    self.vwPopUpClearHistory.hidden = YES;
    self.vwPopUpClearHistory.layer.masksToBounds = YES;
    self.originalFrame = self.tabBarController.tabBar.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNotifications)
                                                 name:kRefresh
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    getdata = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSLog(@"closed sign in");
    [appDelegate showBadge];
    
    [self localize];

    [self.tblAccountOption reloadData];
    [self.pickerSortBy reloadAllComponents];
    [self.pickerWpmlLanguages reloadAllComponents];
    
    self.tblAccountOption.frame = CGRectMake(0, self.vwUserInfo.frame.size.height, SCREEN_SIZE.width, 56*(arrData.count + arrContentData.count + appDelegate.arrFromWebView.count));
    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.tblAccountOption.frame.origin.y + self.tblAccountOption.frame.size.height);

    
    [Util setHeaderColorView:vw];

    [Util setPrimaryColorImageView:self.imgUserProfileBG];

    [Util setPrimaryColorImageView:self.imgHeaderBG];

    
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

    if ([Util getBoolData:kLogin])
    {
        if (appDelegate.dictCustData.count == 0)
        {
            [self getCustomerDetail];
            self.lblEmail.text = [Util getStringData:kEmail];
        }
        self.imgIconCamera.hidden = NO;
    }
    else
    {
        self.imgUserProfile.image = [UIImage imageNamed:@"AccountTempProfile"];
        self.lblName.text = @"";
        self.lblContact.text = @"";
        self.lblEmail.text = @"";
        self.lblEmail.text = @"";
        self.imgIconCamera.hidden = YES;
    }
    self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.width/2;
    self.imgUserProfile.layer.masksToBounds = true;
    [self setData];
}



-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.vwUserInfo.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 206*SCREEN_SIZE.width/375);
    self.tblAccountOption.frame = CGRectMake(0, self.vwUserInfo.frame.size.height, SCREEN_SIZE.width, 56*(arrData.count + arrContentData.count + appDelegate.arrFromWebView.count));
    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.tblAccountOption.frame.origin.y + self.tblAccountOption.frame.size.height);
    
    self.imgTriangle.frame = CGRectMake(self.imgTriangle.frame.origin.x, self.tblAccountOption.frame.origin.y + ((56*3)/2) - (self.imgTriangle.frame.size.height/2), self.imgTriangle.frame.size.width, self.imgTriangle.frame.size.height);
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];

    self.vwUserImage.frame = CGRectMake(self.vwUserImage.frame.origin.x, self.vwUserImage.frame.origin.y, self.vwUserImage.frame.size.width, self.vwUserImage.frame.size.width);
    self.imgUserProfile.frame = CGRectMake((self.vwUserImage.frame.size.width/2) - ((104*SCREEN_SIZE.width/375)/2), self.imgUserProfile.frame.origin.y, 104*SCREEN_SIZE.width/375, 104*SCREEN_SIZE.width/375);
    self.imgUserProfileBG.frame = CGRectMake((self.vwUserImage.frame.size.width/2) - ((104*SCREEN_SIZE.width/375)/2), self.imgUserProfileBG.frame.origin.y, 104*SCREEN_SIZE.width/375, 104*SCREEN_SIZE.width/375);
    self.imgIconCamera.frame = CGRectMake(self.imgIconCamera.frame.origin.x, self.imgIconCamera.frame.origin.y, self.imgIconCamera.frame.size.width, self.imgIconCamera.frame.size.width);
    
    self.vwCurrency.frame =CGRectMake(0, SCREEN_SIZE.height, self.vwCurrency.frame.size.width, self.vwCurrency.frame.size.height);
    self.vwWpmlLanguages.frame =CGRectMake(0, SCREEN_SIZE.height, self.vwWpmlLanguages.frame.size.width, self.vwWpmlLanguages.frame.size.height);
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Application in Forground

- (void)applicationIsActive:(NSNotification *)notification {
    NSLog(@"Application Did Become Active");
    [self.tblAccountOption reloadData];
}


#pragma mark - CheckNotification
-(void)checkNotifications
{
    if ([appDelegate.strGotoVC isEqualToString:@"myorders"])
    {
        // MyOders
        appDelegate.strGotoVC=@"";
        MyOrderVC *vc = [[MyOrderVC alloc] initWithNibName:@"MyOrderVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([appDelegate.strGotoVC isEqualToString:@"myrewards"])
    {
        // Myrewards
        appDelegate.strGotoVC=@"";
        MyRewardVC *vc = [[MyRewardVC alloc] initWithNibName:@"MyRewardVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Localize Language
/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)localize
{
    [Util setPrimaryColorActivityIndicator:self.act];
    
    self.lblTitle.textColor = OtherTitleColor;
    [Util setHeaderColorView:self.vwHeader];

    [Util setSecondaryColorView:self.vwLogoutLast];
    [Util setSecondaryColorView:self.vwHistoryLast];
    [Util setPrimaryColorLabelText:self.lblClearHistory];
    [Util setPrimaryColorLabelText:self.lblSignOut];
    
    self.lblTitle.text = [MCLocalization stringForKey:@"ACCOUNT"];
    
    self.lblChooseCurrency.text = [MCLocalization stringForKey:@"Choose Currency"];
    self.lblWpmlLanguages.text = [MCLocalization stringForKey:@"Choose Language"];

    self.lblClearHistory.text = [MCLocalization stringForKey:@"Clear History"];
    self.lblDescHistory.text = [MCLocalization stringForKey:@"This permanently deletes your browse, search history from this device."];
    
    [self.btnCancelHistory setTitle:[MCLocalization stringForKey:@"Cancel"] forState:UIControlStateNormal];
    [self.btnClearHistory setTitle:[MCLocalization stringForKey:@"Clear"] forState:UIControlStateNormal];
    
    [self.btnCurrencyCancel setTitle:[MCLocalization stringForKey:@"Cancel"] forState:UIControlStateNormal];
    [self.btnCurrencyDone setTitle:[MCLocalization stringForKey:@"Done"] forState:UIControlStateNormal];
    
    [self.btnCancelWpmlLanguages setTitle:[MCLocalization stringForKey:@"Cancel"] forState:UIControlStateNormal];
    [self.btnSureWpmlLanguages setTitle:[MCLocalization stringForKey:@"Done"] forState:UIControlStateNormal];

    self.lblSignOut.text = [MCLocalization stringForKey:@"Sign Out"];
    self.lblDescSignOut.text = [MCLocalization stringForKey:@"Do you really want to sign out from your Account?"];
    
    [self.btnCancelSignOut setTitle:[MCLocalization stringForKey:@"Cancel"] forState:UIControlStateNormal];
    [self.btnSureSignOut setTitle:[MCLocalization stringForKey:@"Sure"] forState:UIControlStateNormal];
    
    if (getdata == 0 || appDelegate.isLanguageChange || appDelegate.isRefresh)
    {
        [self setContentText];
        [self getContentData];
        appDelegate.isLanguageChange = NO;
    }
    [self.tblAccountOption reloadData];
    
    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.tblAccountOption.frame.origin.y + self.tblAccountOption.frame.size.height);
    
    self.lblTitle.font = Font_Size_Navigation_Title;
    self.lblName.font = Font_Size_Product_Name;
    self.lblEmail.font = Font_Size_Price_Sale_Small;
    self.lblContact.font = Font_Size_Product_Name_Small_Regular;
    
    self.lblClearHistory.font = Font_Size_Price_Sale_Bold;
    self.btnClearHistory.titleLabel.font=Font_Size_Title;
    self.btnCancelHistory.titleLabel.font=Font_Size_Title;

    self.lblSignOut.font = Font_Size_Price_Sale_Bold;
    self.btnSureSignOut.titleLabel.font=Font_Size_Title;
    self.btnCancelSignOut.titleLabel.font=Font_Size_Title;
    
    if(appDelegate.isRTL) {
        //set up RTL
        [self.tblAccountOption setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);

    } else {
        //set up nonRTL
        [self.tblAccountOption setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }
    [self.tblAccountOption reloadData];
    
    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

-(void) setContentText {
    arrIcon = [[NSMutableArray alloc] init];
    [arrIcon addObject:[UIImage imageNamed:@"IconLogin"]];
    if (!appDelegate.isCatalogMode) {
        [arrIcon addObject:[UIImage imageNamed:@"IconAccountOrder"]];
    }
    [arrIcon addObject:[UIImage imageNamed:@"IconAccountAddress"]];
    
    if (appDelegate.arrCurrency.count > 1 && appDelegate.isCurrencySet)
    {
        [arrIcon addObject:[UIImage imageNamed:@"IconCurrency"]];
    }
    if (appDelegate.arrWpmlLanguages.count > 1 && appDelegate.isWpmlActive)
    {
        [arrIcon addObject:[UIImage imageNamed:@"IconLanguage"]];
    }
    
    appDelegate.isRefresh= NO;
    arrData = [[NSMutableArray alloc] init];
    int i = 0;
    [arrData insertObject:[MCLocalization stringForKey:@"Sign Out"] atIndex:i];
    i++;
    if (!appDelegate.isCatalogMode) {
        [arrData insertObject:[MCLocalization stringForKey:@"My Orders"] atIndex:i];
        i++;
    }
    [arrData insertObject:[MCLocalization stringForKey:@"My Addresses"] atIndex:i];
    i++;
    if (appDelegate.arrCurrency.count > 1 && appDelegate.isCurrencySet)
    {
        [arrData insertObject:[MCLocalization stringForKey:@"Choose Currency"] atIndex:i];
        i++;
    }
    if (appDelegate.arrWpmlLanguages.count > 1 && appDelegate.isWpmlActive)
    {
        [arrData insertObject:[MCLocalization stringForKey:@"Choose Language"] atIndex:i];
        i++;
    }
    
    if ([IS_DOWNLOADABLE isEqualToString:@"1"]) {
        [arrData insertObject:[MCLocalization stringForKey:@"Download"] atIndex:i];
        i++;
    }
    [arrData insertObject:[MCLocalization stringForKey:@"My Coupons"] atIndex:i];
    i++;
    if (appDelegate.isMyRewardPointsActive)
    {
        [arrData insertObject:[MCLocalization stringForKey:@"My Points"] atIndex:i];
        i++;
    }
    
    [arrData insertObject:[MCLocalization stringForKey:@"About Us"] atIndex:i];
    i++;
    [arrData insertObject:[MCLocalization stringForKey:@"Account settings"] atIndex:i];
    i++;
    [arrData insertObject:[MCLocalization stringForKey:@"Notification"] atIndex:i];
    i++;
    [arrData insertObject: [MCLocalization stringForKey:@"Contact Us"] atIndex:i];
    i++;
    [arrData insertObject:[MCLocalization stringForKey:@"Rate the App"] atIndex:i];
    i++;
    [arrData insertObject: [MCLocalization stringForKey:@"Clear History"] atIndex:i];
    i++;
}

#pragma mark - SetBasic Details and Image
/*!
 * @discussion this function will set all Basic data of page and Profile image
 */
-(void)setData
{
    if (appDelegate.dictCustData.count > 0)
    {
        [self.act startAnimating];
        [self.imgUserProfile sd_setImageWithURL:[Util EncodedURL:[appDelegate.dictCustData valueForKey:@"pgs_profile_image"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self.act stopAnimating];
            self.imgUserProfile.image = image;
        }];
        self.lblName.text = [NSString stringWithFormat:@"%@ %@", [appDelegate.dictCustData valueForKey:@"first_name"], [appDelegate.dictCustData valueForKey:@"last_name"]];
        for (int i = 0; i < [[appDelegate.dictCustData valueForKey:@"meta_data"] count]; i++)
        {
            if ([[[[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"key"] lowercaseString] isEqualToString:@"mobile"])
            {
                //set Mobile Number
                self.lblContact.text = [[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"value"];
            }
        }
    }
}

#pragma mark - Tap gesture Handler

-(void)Taphandler:(UIGestureRecognizer*)gesture
{
    [self HidePopUp:self.vwPopUpLogout];
    [self HidePopUp:self.vwPopUpClearHistory];
}

#pragma mark - Button Clicks

/*!
 * @discussion will Take you to Previous page
 * @param sender For indentifying sender
 */
-(IBAction)btnBackClicked:(id)sender
{
    if (self.tabBarController.selectedIndex != 0) {
        self.tabBarController.selectedIndex = 0;
        [[self.tabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
    }
}

/*!
 * @discussion Turn notifications On/Off
 * @param sender For indentifying sender
 */
- (IBAction) flipSwitch: (id) sender
{
    UISwitch *onoff = (UISwitch *) sender;
    if(onoff.on)
    {
        [self toggleNotification:@"1"];
    }
    else
    {
        [self toggleNotification:@"2"];
    }
}
/*!
 * @discussion Will Update the Profile Image
 * @param sender For indentifying sender
 */
-(IBAction)btnUpdateImageClicked:(id)sender
{
    if ([Util getBoolData:kLogin])
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *Camera = [UIAlertAction actionWithTitle:[MCLocalization stringForKey:@"Camera"]
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     NSLog(@"Camera");
                                     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                     picker.delegate = self;
                                     picker.allowsEditing = YES;
                                     [self presentViewController:picker animated:YES completion:^{
                                         if (@available(iOS 13, *))
                                         {
                                             UIView *statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
                                             statusBar.backgroundColor = [UIColor blackColor];
                                             [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
                                         }
                                         else
                                         {
                                             UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
                                             if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                                                 statusBar.backgroundColor = [UIColor blackColor];
                                             }
                                         }
                                     }];
                                 }];
        
        UIAlertAction *Gallery = [UIAlertAction actionWithTitle:[MCLocalization stringForKey:@"Gallery"]
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action)
                                  {
                                      NSLog(@"Gallery");
                                      UIImagePickerController *picker= [[UIImagePickerController alloc] init];
                                      picker.delegate = self;
                                      picker.allowsEditing = YES;
                                      picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                      [self presentViewController:picker animated:YES completion:^{
                                          
                                          if (@available(iOS 13, *))
                                          {
                                              UIView *statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
                                              statusBar.backgroundColor = [UIColor whiteColor];
                                              [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
                                          }
                                          else
                                          {
                                              UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
                                              if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                                                  statusBar.backgroundColor = [UIColor whiteColor];
                                              }
                                          }

                                      }];
                                  }];
        
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * action)
                                 {
                                     NSLog(@"Cancel");
                                 }];
        
        [alert addAction:Camera];
        [alert addAction:Gallery];
        [alert addAction:Cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        ALERTVIEW([MCLocalization stringForKey:@"Login first to set your profile picture"], self);
    }
}

/*!
 * @discussion Will take you to Login Process
 * @param sender For indentifying sender
 */
-(IBAction)btnLoginClicked:(id)sender
{
    SigninVC *vc = [[SigninVC alloc] initWithNibName:@"SigninVC" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc ];
    navigationController.modalPresentationStyle=UIModalPresentationFullScreen;

    [self presentViewController:navigationController animated:NO completion:nil];
    
}
/*!
 * @discussion Will Hide Logout Confirmation PopUp
 * @param sender For indentifying sender
 */
-(IBAction)btnLogoutCancelClicked:(id)sender
{
    [self HidePopUp:self.vwPopUpLogout];
}
/*!
 * @discussion Will Make user LogOut
 * @param sender For indentifying sender
 */
-(IBAction)btnLogoutSureClicked:(id)sender
{
    appDelegate.dictCustData = nil;
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [[GIDSignIn sharedInstance] signOut];
    
    NSArray *arrWishList = [[NSArray alloc] initWithArray:[[Util getArrayData:kWishList] mutableCopy]];
    NSArray *arrMyCart = [[NSArray alloc] initWithArray:[[Util getArrayData:kMyCart] mutableCopy]];
    NSArray *arrSearchedString = [[NSArray alloc] initWithArray:[[Util getArrayData:kSearchedString] mutableCopy]];
    NSArray *arrRecentSearch = [[NSArray alloc] initWithArray:[[appDelegate getRecentArray] mutableCopy]];
    
    NSString *strPrimaryColorCode = [Util getStringData:kPrimaryColor];
    NSString *strSecondaryColorCode = [Util getStringData:kSecondaryColor];
    NSString *strHeaderColorCode = [Util getStringData:kHeaderColor];
    NSString *strAppNameWhiteImage = [Util getStringData:kAppNameWhiteImage];
    NSString *strAppNameImage = [Util getStringData:kAppNameImage];
    NSString *strDeviceToken = [Util getStringData:kDeviceToken];
    
    BOOL flagFirst = [Util getBoolData:kFirstTime];
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [Util setBoolData:flagFirst setBoolData:kFirstTime];
    
    [Util setData:strDeviceToken key:kDeviceToken];
    [Util setData:strPrimaryColorCode key:kPrimaryColor];
    [Util setData:strSecondaryColorCode key:kSecondaryColor];
    [Util setData:strHeaderColorCode key:kHeaderColor];
    [Util setData:strAppNameWhiteImage key:kAppNameWhiteImage];
    [Util setData:strAppNameImage key:kAppNameImage ];
    
    [Util setArray:[arrWishList mutableCopy] setData:kWishList];
    [Util setArray:[arrMyCart mutableCopy] setData:kMyCart];
    [Util setArray:[arrSearchedString mutableCopy] setData:kSearchedString];
    [Util setArray:[arrRecentSearch mutableCopy] setData:kRecentItem];
    
    appDelegate.loggedIn = kLoggedOut;
    
    self.imgUserProfile.image = [UIImage imageNamed:@"AccountTempProfile"];
    self.lblName.text = @"";
    self.lblContact.text = @"";
    self.lblEmail.text = @"";
    
    [self.tblAccountOption reloadData];
    [self HidePopUp:self.vwPopUpLogout];
    [appDelegate registerForToken];
    [appDelegate setDataForCiyashopOauth];
    
    self.imgIconCamera.hidden = YES;
    
    if (![Util getBoolData:kLogin] && appDelegate.isLoginScreen) {
        [self redirectToLogin];
    }
}
/*!
 * @discussion Will Hide the ClearHistory Confirmation Popup
 * @param sender For indentifying sender
 */
-(IBAction)btnHistoryCancelClicked:(id)sender
{
    [self HidePopUp:self.vwPopUpClearHistory];
}
/*!
 * @discussion Will ClearHistory which is Localy Cached
 * @param sender For indentifying sender
 */
-(IBAction)btnHistoryClearClicked:(id)sender
{
    [Util setArray:nil setData:kSearchedString];
    [Util setArray:nil setData:kRecentItem];
    
    [Util setBoolData:false setBoolData:kLanguage];
    [Util setData:@"" key:kLanguageText];

    [appDelegate showBadge];
    [appDelegate setDataForCiyashopOauth];
    
    appDelegate.currency = YES;
    appDelegate.isRefresh = YES;
    appDelegate.isLanguageChange = YES;
    [self HidePopUp:self.vwPopUpClearHistory];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self ChangeTab];
    });
}

-(IBAction)btnCurrencyDoneClick:(id)sender
{
    //set currency data
    NSInteger row = [self.pickerSortBy selectedRowInComponent:0];
    
    appDelegate.currency = YES;
    [Util setBoolData:YES setBoolData:kCurrency];
    NSString *str = [NSString stringWithFormat:@"?currency=%@",[[appDelegate.arrCurrency objectAtIndex:row] valueForKey:@"title"]];
    [Util setData:str key:kCurrencyText];
    
    //remove recently viewed products
    [Util setArray:nil setData:kRecentItem];
    [Util setArray:nil setData:kMyCart];
    
    [appDelegate setDataForCiyashopOauth];
    
    UITabBar *tb = self.tabBarController.tabBar;
    [UIView animateWithDuration:0.4 animations:^{
        self.vwCurrency.frame =CGRectMake(0, SCREEN_SIZE.height, self.vwCurrency.frame.size.width, self.vwCurrency.frame.size.height);
        tb.frame = self.originalFrame;
    } completion:^(BOOL finished) {
        self.vwPopUpBG.hidden = YES;
        self.vwPopUpBG.alpha = 0.0;
    }];
}

-(IBAction)btnCurrencyCancelClick:(id)sender
{
    [UIView animateWithDuration:0.4 animations:^{
        self.vwCurrency.frame = CGRectMake(0, SCREEN_SIZE.height, self.vwCurrency.frame.size.width, self.vwCurrency.frame.size.height);
    } completion:^(BOOL finished) {
        self.vwPopUpBG.hidden = YES;
        self.vwPopUpBG.alpha = 0.0;
    }];
    UITabBar *tb = self.tabBarController.tabBar;
    [UIView animateWithDuration:0.4 animations:^{
        tb.frame = self.originalFrame;
    }];
}

-(IBAction)btnWpmlLanguagesDoneClick:(id)sender
{
    //set language data
    NSInteger row = [self.pickerWpmlLanguages selectedRowInComponent:0];
    
    appDelegate.currency = YES;
    [Util setBoolData:YES setBoolData:kLanguage];
    NSString *str = [[appDelegate.arrWpmlLanguages objectAtIndex:row] valueForKey:@"code"];
    
    [Util setData:str key:kLanguageText];
    
    if ([[[appDelegate.arrWpmlLanguages objectAtIndex:row] valueForKey:@"is_rtl"] boolValue]) {
        appDelegate.isRTL = true;
    } else {
        appDelegate.isRTL = false;
    }
    [MCLocalization sharedInstance].language = [[appDelegate.arrWpmlLanguages objectAtIndex:row] valueForKey:@"site_language"];
    
    //remove recently viewed products
    [Util setArray:nil setData:kRecentItem];
    [Util setArray:nil setData:kMyCart];
    
    [appDelegate setDataForCiyashopOauth];
    
    [self setContentText];
    
    UITabBar *tb = self.tabBarController.tabBar;
    [UIView animateWithDuration:0.4 animations:^{
        self.vwWpmlLanguages.frame =CGRectMake(0, SCREEN_SIZE.height, self.vwWpmlLanguages.frame.size.width, self.vwWpmlLanguages.frame.size.height);
        tb.frame = self.originalFrame;
    } completion:^(BOOL finished) {
        self.vwPopUpBG.hidden = YES;
        self.vwPopUpBG.alpha = 0.0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self ChangeTab];
    });
}

-(IBAction)btnWpmlLanguagesCancelClick:(id)sender
{
    [UIView animateWithDuration:0.4 animations:^{
        self.vwWpmlLanguages.frame = CGRectMake(0, SCREEN_SIZE.height, self.vwWpmlLanguages.frame.size.width, self.vwWpmlLanguages.frame.size.height);
    } completion:^(BOOL finished) {
        self.vwPopUpBG.hidden = YES;
        self.vwPopUpBG.alpha = 0.0;
    }];
    UITabBar *tb = self.tabBarController.tabBar;
    [UIView animateWithDuration:0.4 animations:^{
        tb.frame = self.originalFrame;
    }];
}

#pragma mark - PickerVIew Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.pickerSortBy)
    {
        NSString *title = [NSString stringWithFormat:@"%@ (%@)", [[appDelegate.arrCurrency objectAtIndex:row] valueForKey:@"title"], [[appDelegate.arrCurrency objectAtIndex:row] valueForKey:@"symbol"]];
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        return attrStr.string;
    }
    NSString *title = [NSString stringWithFormat:@"%@ (%@)", [[appDelegate.arrWpmlLanguages objectAtIndex:row] valueForKey:@"disp_language"], [[appDelegate.arrWpmlLanguages objectAtIndex:row] valueForKey:@"code"]];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr.string;
}

// The number of columns of data
- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.pickerSortBy) {
        return (int)appDelegate.arrCurrency.count;
    }
    return (int)appDelegate.arrWpmlLanguages.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = arrData.count + arrContentData.count + appDelegate.arrFromWebView.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"AccountOptionCell";
    
    AccountOptionCell *cell = (AccountOptionCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AccountOptionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.lblEmail.hidden = YES;
    if (indexPath.row < arrIcon.count) {
        cell.imgIcon.image = [arrIcon objectAtIndex:indexPath.row];
        cell.lblText.font = [UIFont boldSystemFontOfSize:15];
        cell.lblText.text = [arrData objectAtIndex:indexPath.row];
        cell.imgIcon.hidden = NO;
        cell.lblText.font = Font_Size_Title;
        if (indexPath.row == 0) {
            if ([appDelegate.loggedIn  isEqualToString:kLoggedIn]) {
                cell.lblEmail.hidden = YES;
                cell.lblEmail.text = [Util getStringData:kEmail];
                cell.lblEmail.font = Font_Size_Product_Name_Small_Regular;
                cell.lblText.text = [MCLocalization stringForKey:@"Sign Out"];
            } else {
                cell.lblEmail.hidden = YES;
                cell.lblText.text = [MCLocalization stringForKey:@"Login"];
            }
        }
        if (appDelegate.isRTL) {
            //RTL
            cell.imgIcon.frame = CGRectMake(SCREEN_SIZE.width - cell.imgIcon.frame.size.width - 20, cell.imgIcon.frame.origin.y, cell.imgIcon.frame.size.width, cell.imgIcon.frame.size.height);
            cell.lblText.frame = CGRectMake(SCREEN_SIZE.width - cell.lblText.frame.size.width - 70, cell.lblText.frame.origin.y, cell.lblText.frame.size.width, cell.lblText.frame.size.height);
        } else {
            //NonRTL
            cell.imgIcon.frame = CGRectMake(20, cell.imgIcon.frame.origin.y, cell.imgIcon.frame.size.width, cell.imgIcon.frame.size.height);
            cell.lblText.frame = CGRectMake(70, cell.lblText.frame.origin.y, cell.lblText.frame.size.width, cell.lblText.frame.size.height);
        }
    } else if (indexPath.row > arrIcon.count - 1) {
        cell.imgIcon.hidden = YES;

        cell.lblText.frame = CGRectMake(cell.imgIcon.frame.origin.x, cell.lblText.frame.origin.y, cell.lblText.frame.size.width, cell.lblText.frame.size.height);
        
//        NSString * htmlString = [arrData objectAtIndex:indexPath.row];
//        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        cell.lblText.attributedText = attrStr;
        
        cell.imgIcon.frame = CGRectMake(cell.imgIcon.frame.origin.x, cell.imgIcon.frame.origin.y, 0, cell.imgIcon.frame.size.height);
        cell.lblText.font = Font_Size_Product_Name_Regular;

        if (indexPath.row < arrData.count) {
            cell.lblText.text = [arrData objectAtIndex:indexPath.row];
        } else if (indexPath.row < arrData.count + arrContentData.count) {
            NSInteger i = indexPath.row - (int)(arrData.count);
            cell.lblText.text = [[arrContentData objectAtIndex:i] valueForKey:@"title"];
        } else {
            NSInteger i = indexPath.row - (int)(arrData.count + arrContentData.count);
            cell.lblText.text = [[appDelegate.arrFromWebView objectAtIndex:i] valueForKey:@"web_view_pages_page_title"];
        }
        if (appDelegate.isRTL) {
            //RTL
            cell.lblText.frame = CGRectMake(cell.frame.size.width - cell.lblText.frame.size.width - 26, cell.lblText.frame.origin.y, cell.lblText.frame.size.width, cell.lblText.frame.size.height);
        } else {
            //NonRTL
            cell.lblText.frame = CGRectMake(26, cell.lblText.frame.origin.y, cell.lblText.frame.size.width, cell.lblText.frame.size.height);
        }
    }
    
    if (indexPath.row == arrData.count + arrContentData.count - 1) {
        self.tblAccountOption.frame = CGRectMake(0, self.tblAccountOption.frame.origin.y, SCREEN_SIZE.width, 56*(arrData.count + arrContentData.count + appDelegate.arrFromWebView.count));
    }
    
    for (UIView *view in [cell subviews]) {
        if (view.tag == 123) {
            [view removeFromSuperview];
        }
    }

    if(indexPath.row < arrData.count && [[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"Notification"] ]) {
        UISwitch *onoffNotification = [[UISwitch alloc] init];
        
        if (appDelegate.isRTL) {
            onoffNotification.frame = CGRectMake(30, (cell.frame.size.height - 31)/2, 49, 31);
        } else {
            onoffNotification.frame = CGRectMake(cell.frame.size.width - 60, (cell.frame.size.height - 31)/2, 49, 31);
        }
        onoffNotification.onTintColor = [Util colorWithHexString:[Util getStringData:kPrimaryColor]];
        if([[Util getStringData:kNotification] isEqualToString:@"Off"]){
            onoffNotification.on = NO;
        } else {
            onoffNotification.on = YES;
        }
        [onoffNotification addTarget: self action: @selector(flipSwitch:) forControlEvents:UIControlEventValueChanged];
        onoffNotification.tag = 123;
        
        for (UIView *view in [cell subviews]) {
            if (view.tag == 123) {
                [view removeFromSuperview];
            }
        }
        // Set the desired frame location of onoff here
        [cell addSubview: onoffNotification];
        if ([Util notificationServicesEnabled]) {
            onoffNotification.userInteractionEnabled = YES;
        } else {
            [onoffNotification setOn:NO];
            onoffNotification.userInteractionEnabled = NO;
        }
    }
    if (appDelegate.isRTL) {
        cell.lblText.textAlignment = NSTextAlignmentRight;
    } else {
        cell.lblText.textAlignment = NSTextAlignmentLeft;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < arrData.count) {
        
        if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"Sign Out"]]) {
            //sign out
            if ([appDelegate.loggedIn isEqualToString:kLoggedOut]) {
                [self redirectToLogin];
            } else {
                [self ShowPopUp:self.vwPopUpLogout];
            }
        } else if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"My Orders"]]) {
            //My Orders
            if ([Util getBoolData:kLogin]) {
                [self OpenMyOrders];
            } else {
                [self redirectToLogin];
            }
        } else if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"My Addresses"]]) {
            //My Addresses
            if ([Util getBoolData:kLogin]) {
                [self OpenMyAddress];
            } else {
                [self redirectToLogin];
            }
        } else if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"Choose Currency"]]) {
            //Choose Currency
            [self CurrencyPopupShow];
        } else if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"Choose Language"]]) {
            //Choose Language
            [self LanguagePopupShow];
        } else if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"My Coupons"]]) {
            //My Coupons
            [self OpenMyRewards];
        } else if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"My Points"]]) {
            //My Points
            [self OpenMyPoints];
        } else if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"About Us"]]) {
            //About Us
            [self OpenAboutUs];
        } else if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"Account settings"]]) {
            //Account settings
            [self OpenAccountSetting];
        } else if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"Notification"]]) {
            //Notification
            if (![Util notificationServicesEnabled]) {
                //go to setting to allow notification
                [self CheckNotificationVerification];
            }
        } else if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"Contact Us"]]) {
            //Contact Us
            [self OpenContactUs];
        } else if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"Rate the App"]]) {
            //Rate the App
            [self OpenRateUs];
        } else if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"Clear History"]]) {
            //Clear History
            [self ShowPopUp:self.vwPopUpClearHistory];
        } else if ([[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"Web View"]]) {
            [self openFromWeb];
        } else if ([IS_DOWNLOADABLE isEqualToString:@"1"] && [[arrData objectAtIndex:indexPath.row] isEqualToString:[MCLocalization stringForKey:@"Download"]]) {
            //download
            if ([appDelegate.loggedIn isEqualToString:kLoggedOut]) {
                [self redirectToLogin];
            } else {
                DownloadVC *vc = [[DownloadVC alloc] initWithNibName:@"DownloadVC" bundle:nil];
                [self.navigationController pushViewController:vc animated:true];
            }
            return;
        } else {
            [self OpenContentView:(int)indexPath.row];
        }
    } else if (indexPath.row < arrData.count + arrContentData.count) {
        [self OpenContentView:(int)indexPath.row];
    } else {
        NSInteger i = indexPath.row - (int)(arrData.count + arrContentData.count);
        WebViewContainVC *vc = [[WebViewContainVC alloc] initWithNibName:@"WebViewContainVC" bundle:nil];
        vc.index = i;
        [self.navigationController pushViewController:vc animated:true];
    } 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

#pragma mark - Show Currency popup

/*!
 * @discussion This Function will shows Currency Popup
 */
-(void)CurrencyPopupShow {
    if ([Util getBoolData:kCurrency] && appDelegate.isCurrencySet) {
        NSString *needle = [[Util getStringData:kCurrencyText] componentsSeparatedByString:@"="][1];
        
        int pos = 0;
        for (int i = 0; i < appDelegate.arrCurrency.count; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[appDelegate.arrCurrency objectAtIndex:i]];
            if ([[dict valueForKey:@"title"] isEqualToString:needle]) {
                pos = i;
                break;
            }
        }
        [self.pickerSortBy selectRow:pos inComponent:0 animated:YES];
    }
    UITabBar *tb = self.tabBarController.tabBar;
    [UIView animateWithDuration:0.4 animations:^{
        self.vwCurrency.frame =CGRectMake(0, SCREEN_SIZE.height - self.vwCurrency.frame.size.height - statusBarSize.height, self.vwCurrency.frame.size.width, self.vwCurrency.frame.size.height);
        self.vwPopUpBG.hidden = NO;
        self.vwPopUpBG.alpha = 0.8;
        tb.frame = CGRectMake(tb.frame.origin.x, SCREEN_SIZE.height + 100, tb.frame.size.width, tb.frame.size.height);
    }];
}

#pragma mark - Show Language popup

/*!
 * @discussion This Function will shows Language Popup
 */
-(void)LanguagePopupShow {
    if ([Util getBoolData:kLanguage]) {
        NSString *needle = [Util getStringData:kLanguageText];
        
        int pos = 0;
        for (int i = 0; i < appDelegate.arrWpmlLanguages.count; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[appDelegate.arrWpmlLanguages objectAtIndex:i]];
            if ([[dict valueForKey:@"code"] isEqualToString:needle]) {
                pos = i;
                break;
            }
        }
        [self.pickerWpmlLanguages selectRow:pos inComponent:0 animated:YES];
    }
    
    UITabBar *tb = self.tabBarController.tabBar;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.vwWpmlLanguages.frame =CGRectMake(0, SCREEN_SIZE.height - self.vwWpmlLanguages.frame.size.height - statusBarSize.height, self.vwWpmlLanguages.frame.size.width, self.vwWpmlLanguages.frame.size.height);
        self.vwPopUpBG.hidden = NO;
        self.vwPopUpBG.alpha = 0.8;
        tb.frame = CGRectMake(tb.frame.origin.x, SCREEN_SIZE.height + 100, tb.frame.size.width, tb.frame.size.height);
    }];
}



#pragma mark - Open Views
/*!
 * @discussion This Function will Check Notification permission is allowed or not
 */
-(void)OpenContentView:(int)index {
    ContentVC *vc = [[ContentVC alloc] initWithNibName:@"ContentVC" bundle:nil];
    
    if (arrContentData.count>0) {
        int i = index - (int)(arrData.count);
        if (i >= 0) {
            vc.fromPages = YES;
            vc.Page = [[[arrContentData objectAtIndex:i] valueForKey:@"page_id"] intValue];
            vc.strTitle = [[arrContentData objectAtIndex:i] valueForKey:@"title"];
            vc.contentID = [[[arrContentData objectAtIndex:i] valueForKey:@"page_id"] intValue];
                [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


/*!
 * @discussion This Function will Check Notification permission is allowed or not
 */
-(void)CheckNotificationVerification {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:appNAME
                                                                             message:[MCLocalization stringForKey:@"Permission for Notification denied. Please Allow from Settings."]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionSetting = [UIAlertAction actionWithTitle:[MCLocalization stringForKey:@"Setting"]
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              //go to settings
                                                              
                                                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];

//                                                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                              
                                                          }]; //You can use a block here to handle a press on this button
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[MCLocalization stringForKey:@"Cancel"]
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
    
    [alertController addAction:actionCancel];
    [alertController addAction:actionSetting];
    [self presentViewController:alertController animated:YES completion:nil];

}

/*!
 * @discussion This Function will Open MyAddress
 */
-(void)OpenMyAddress {
    MyAddressVC *vc = [[MyAddressVC alloc] initWithNibName:@"MyAddressVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
/*!
 * @discussion This Function will Open My Rewards
 */
-(void)OpenMyRewards {
    MyRewardVC *vc = [[MyRewardVC alloc] initWithNibName:@"MyRewardVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
/*!
 * @discussion This Function will Open My Points
 */
-(void)OpenMyPoints {
    if ([Util getBoolData:kLogin]) {
        MyPointsVC *vc = [[MyPointsVC alloc] initWithNibName:@"MyPointsVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self redirectToLogin];
    }
}
/*!
 * @discussion This Function will Open AboutUs
 */
-(void)OpenAboutUs {
    AboutUsVC *vc = [[AboutUsVC alloc] initWithNibName:@"AboutUsVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
/*!
 * @discussion This Function will Open ContactUs
 */
-(void)OpenContactUs {
    ContactUsVC *vc = [[ContactUsVC alloc] initWithNibName:@"ContactUsVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
/*!
 * @discussion This Function will Redirect to Appstore for review
 */
-(void)OpenRateUs {
    if ([appDelegate.AppUrl isEqualToString:@""] || appDelegate.AppUrl == nil || appDelegate.AppUrl.length == 0) { } else {
        NSString *strUrl = appDelegate.AppUrl ;
        NSURL *_url = [Util EncodedURL:strUrl];
        [[UIApplication sharedApplication] openURL:_url options:@{} completionHandler:nil];
    }
}

/*!
 * @discussion This Function will Redirect to Account Setting
 */
-(void)OpenAccountSetting {
    if ([Util getBoolData:kLogin]) {
        AccountSettingVC *vc = [[AccountSettingVC alloc] initWithNibName:@"AccountSettingVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self redirectToLogin];
    }
}

-(void)openFromWeb {
    WebViewContainVC *vc = [[WebViewContainVC alloc] initWithNibName:@"WebViewContainVC" bundle:nil];
    [[self navigationController] pushViewController:vc animated:YES];
}
/*!
 * @discussion This Function will Redirect to Account Setting
 */
-(void)OpenMyOrders {
    MyOrderVC *vc = [[MyOrderVC alloc] initWithNibName:@"MyOrderVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Redirect to login 

/*!
 * @discussion This Function will redirect to Login Process
 */
-(void)redirectToLogin {
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [[GIDSignIn sharedInstance] signOut];
    
    SigninVC *vc=[[SigninVC alloc] initWithNibName:@"SigninVC" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:navigationController animated:YES completion:nil];
}


#pragma mark - Popup Show and Hide
/*!
 * @discussion Show a Popup
 */
-(void)ShowPopUp:(UIView*)popup {
    self.vwPopUpBG.hidden = NO;
    popup.hidden=NO;
    popup.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.4 animations:^{
        self.vwPopUpBG.alpha = 0.8;
        popup.transform = CGAffineTransformIdentity;
    }];
}
/*!
 * @discussion Hide a Popup
 */
-(void)HidePopUp:(UIView*)popup {
    popup.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        popup.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.vwPopUpBG.alpha=0.0;
        
    } completion:^(BOOL finished){
        
        popup.hidden = YES;
        self.vwPopUpBG.hidden = YES;
        
    }];
}

#pragma mark - ImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imgUserProfile.image = img;
    
    
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
    [picker dismissViewControllerAnimated:YES completion:^{
        self->imgData = [[NSData alloc]initWithData:UIImageJPEGRepresentation(img, 0.5)];
        [self uploadImage:self->imgData];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
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
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    UIImage *img = image;
    self.imgUserProfile.image = img;
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
    [self dismissViewControllerAnimated:picker completion:^{
        self->imgData = [[NSData alloc]initWithData:UIImageJPEGRepresentation(img, 0.8)];
        [self uploadImage:self->imgData];
    }];
}

#pragma mark - Api calls
/*!
 * @discussion Webservice call for Customer Details
 */
-(void)getCustomerDetail {
    SHOW_LOADER_ANIMTION();

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    
    [CiyaShopAPISecurity getCustomerDetail:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        if (success)         {
            if (dictionary.count > 0) {
                appDelegate.dictCustData = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
            } else {
                if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
                    NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                    NSAttributedString *decodedString;
                    decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                     options:options
                                                          documentAttributes:NULL
                                                                       error:NULL];
                    ALERTVIEW(decodedString.string, self);
                } else {
                    ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
                }
            }
        } else {
            if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
                NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                NSAttributedString *decodedString;
                decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                 options:options
                                                      documentAttributes:NULL
                                                                   error:NULL];
                ALERTVIEW(decodedString.string, self);
            } else {
                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
            }
        }
        HIDE_PROGRESS;
        [self setData];
    }];
}

/*!
 * @discussion Webservice call for Uploading Profile Image
 */
-(void)uploadImage:(NSData*)imgData1 {
    SHOW_LOADER_ANIMTION();

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    
    float low_bound = 0;
    float high_bound = 5000;
    float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);//image1
    int intRndValue = (int)(rndValue + 0.5);
    NSString *str_image1 = [@(intRndValue) stringValue];
    
    NSString *str = [imgData1 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    [dictData setValue:[NSString stringWithFormat:@"%@.jpg",str_image1] forKey:@"name"];
    [dictData setValue:str forKey:@"data"];
    
    [dict setValue:dictData forKey:@"user_image"];
    
    NSLog(@"%@",dict);
    
    [CiyaShopAPISecurity updateCustomerImage:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        HIDE_PROGRESS;

        NSLog(@"%@",dictionary);
        if (success) {
            if (dictionary.count > 0) {
                if ([[dictionary valueForKey:@"status"] isEqualToString:@"error"]) {
                    NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                    NSAttributedString *decodedString;
                    decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                     options:options
                                                          documentAttributes:NULL
                                                                       error:NULL];
                    ALERTVIEW(decodedString.string, self);
                    [self getCustomerDetail];
                } else {
                    appDelegate.dictCustData = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
                    [self setData];
                }
            } else {
                if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
                    NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                    NSAttributedString *decodedString;
                    decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                     options:options
                                                          documentAttributes:NULL
                                                                       error:NULL];
                    ALERTVIEW(decodedString.string, self);
                } else {
                    ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
                }
            }
        } else {
            if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
                NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                NSAttributedString *decodedString;
                decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                 options:options
                                                      documentAttributes:NULL
                                                                   error:NULL];
                ALERTVIEW(decodedString.string, self);
            } else {
                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
            }
        }
    }];
}

/*!
 * @discussion Webservice call for Geting Extra pages set in Back-end
 */
-(void)getContentData {
    SHOW_LOADER_ANIMTION();
    
    [CiyaShopAPISecurity getInfoPages:nil completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        if (success) {
            if (dictionary.count > 0) {
                self->arrContentData = [[NSArray alloc]initWithArray:[[dictionary valueForKey:@"data"] mutableCopy]];
                
//                NSMutableArray *arr = [[NSMutableArray alloc] init];
//                for (int i = 0; i < self->arrData.count; i++) {
//                    [arr addObject:[self->arrData objectAtIndex:i]];
//                }
//                for (int i = 0; i < self->arrContentData.count; i++) {
//                    [arr addObject:[[self->arrContentData objectAtIndex:i] valueForKey:@"title"]];
//                }
//                self->arrData = [[NSMutableArray alloc] initWithArray:arr];
                [self.tblAccountOption reloadData];
                self.tblAccountOption.frame = CGRectMake(0, self.tblAccountOption.frame.origin.y, SCREEN_SIZE.width, 56 * (self->arrData.count + self->arrContentData.count + appDelegate.arrFromWebView.count));
                self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.tblAccountOption.frame.origin.y + self.tblAccountOption.frame.size.height);
                self->getdata = 1;
                [self setData];
            }
        }
        HIDE_PROGRESS;
        if ([Util getBoolData:kLogin]) {
            [self getCustomerDetail];
        }
    }];
}

/*!
 * @discussion Api call for turn notification On/Off
 */
-(void)toggleNotification:(NSString *)strStatus {
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kDeviceToken] forKey:@"device_token"];//device token
    [dict setValue:@"1" forKey:@"device_type"];
    [dict setValue:strStatus forKey:@"status"];
    
    [CiyaShopAPISecurity changeNotification:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
                
        NSLog(@"%@", dictionary);
        if (success) {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"]) {
                HIDE_PROGRESS;
                if([strStatus intValue] == 1) {
                    [Util setData:@"On" key:kNotification];
                } else {
                    [Util setData:@"Off" key:kNotification];
                }
            } else {
                HIDE_PROGRESS;
                if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"])
                {
                    NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                    NSAttributedString *decodedString;
                    decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                     options:options
                                                          documentAttributes:NULL
                                                                       error:NULL];
                    ALERTVIEW(decodedString.string, self);
                } else {
                    ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
                }
            }
        } else {
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
            } else {
                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
            }
        }
    }];
}

-(void)ChangeTab {
//    self.tabBarController.selectedIndex = 0;   // to actually switch to the controller (your code would work as well) - not sure if this does or not send the didSelectViewController: message to the delegate
    [self.tabBarController.delegate tabBarController:self.tabBarController shouldSelectViewController:[self.tabBarController.viewControllers objectAtIndex:0]];  // send didSelectViewController to the tabBarController delegate
    [[appDelegate.baseTabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
    appDelegate.isAcctChanged = true;
}

#pragma mark - StatusBar Delegate
/*!
 * @discussion This method is used to set Status bar text color
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
