//
//  DeactivateAccountVC.m
//  QuickClick
//
//  Created by Kaushal PC on 02/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "DeactivateAccountVC.h"

@import Firebase;
@import GoogleSignIn;

@interface DeactivateAccountVC ()

@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwAllData;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDeactivateAccount;
@property (strong, nonatomic) IBOutlet UILabel *lblEmailId;
@property (strong, nonatomic) IBOutlet UILabel *lblMobileNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblPassword;

@property (strong, nonatomic) IBOutlet UITextField *txtEmailId;
@property (strong, nonatomic) IBOutlet UITextField *txtMobileNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtEnterYourPass;

@property (strong, nonatomic) IBOutlet UIButton *btnConfirmDeactivation;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@end

@implementation DeactivateAccountVC {
    UIView *vw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([Util getBoolData:kFromFBorGoogle])
    {
        self.txtEnterYourPass.hidden = YES;
        self.lblPassword.hidden = YES;
    }
    else
    {
        self.txtEnterYourPass.hidden = NO;
        self.lblPassword.hidden = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    [Util setSecondaryColorButton:self.btnConfirmDeactivation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self localize];
    [Util setHeaderColorView:vw];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}

#pragma mark - Localize Language
/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)localize
{
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.textColor = OtherTitleColor;
    
    self.lblTitle.text = [MCLocalization stringForKey:@"Account settings"];
    
    self.lblDeactivateAccount.text = [MCLocalization stringForKey:@"Deactive Account"];
    self.lblEmailId.text = [MCLocalization stringForKey:@"Email ID"];
    self.lblMobileNumber.text = [MCLocalization stringForKey:@"Mobile Number"];
    self.lblPassword.text = [MCLocalization stringForKey:@"Password"];
    
    self.txtEmailId.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Email ID"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtMobileNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Mobile Number"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtEnterYourPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Enter your Password"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    [self.btnConfirmDeactivation setTitle:[MCLocalization stringForKey:@"CONFIRM DEACTIVATION"] forState:UIControlStateNormal];
    
    
    self.lblTitle.font = Font_Size_Navigation_Title;
    self.lblDeactivateAccount.font = Font_Size_Price_Sale_Bold;
    self.lblEmailId.font = Font_Size_Product_Name_Regular;
    self.lblPassword.font = Font_Size_Product_Name_Regular;
    
    self.txtEmailId.font = Font_Size_Product_Name_Regular;
    self.txtEnterYourPass.font = Font_Size_Product_Name_Regular;
    
    self.btnConfirmDeactivation.titleLabel.font = Font_Size_Price_Sale_Bold;
    
    if (appDelegate.isRTL)
    {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        
        self.lblDeactivateAccount.textAlignment = NSTextAlignmentRight;
        self.lblEmailId.textAlignment = NSTextAlignmentRight;
        self.lblMobileNumber.textAlignment = NSTextAlignmentRight;
        self.lblPassword.textAlignment = NSTextAlignmentRight;
       
        self.txtEmailId.textAlignment = NSTextAlignmentRight;
        self.txtMobileNumber.textAlignment = NSTextAlignmentRight;
        self.txtEnterYourPass.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //NonRTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
        
        self.lblDeactivateAccount.textAlignment = NSTextAlignmentLeft;
        self.lblEmailId.textAlignment = NSTextAlignmentLeft;
        self.lblMobileNumber.textAlignment = NSTextAlignmentLeft;
        self.lblPassword.textAlignment = NSTextAlignmentLeft;
        
        self.txtEmailId.textAlignment = NSTextAlignmentLeft;
        self.txtMobileNumber.textAlignment = NSTextAlignmentLeft;
        self.txtEnterYourPass.textAlignment = NSTextAlignmentLeft;
    }
}

#pragma mark - Button Clicks
/*!
 * @discussion will Take you to Previous page
 * @param sender For indentifying sender
 */
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*!
 * @discussion Check All Validation and Ask for Confirm Deactivate Popup
 * @param sender For indentifying sender
 */
-(IBAction)btnConfirmDeactivationClicked:(id)sender
{
    if (self.txtEmailId.text.length > 0)
    {
        if ([Util ValidateEmailString:self.txtEmailId.text])
        {
            if ([[self.txtEmailId.text lowercaseString] isEqualToString:[[Util getStringData:kEmail] lowercaseString]])
            {
                if ([Util getBoolData:kFromFBorGoogle])
                {
                    [self showAlertForConfirmation];
                }
                else if (self.txtEnterYourPass.text.length > 0)
                {
                    if ([self.txtEnterYourPass.text isEqualToString:[Util getStringData:kPassword]])
                    {
                        [self showAlertForConfirmation];
                    }
                    else
                    {
                        ALERTVIEW([MCLocalization stringForKey:@"Your Email address or password is not correct"], self);
                    }
                }
                else
                {
                    ALERTVIEW([MCLocalization stringForKey:@"Enter Password"], self);
                }
            }
            else
            {
                ALERTVIEW([MCLocalization stringForKey:@"Enter Proper Email Address"], self);
            }
        }
        else
        {
            ALERTVIEW([MCLocalization stringForKey:@"Enter Proper Email Address"], self);
        }
    }
    else
    {
        ALERTVIEW([MCLocalization stringForKey:@"Enter Proper Email Address"], self);
    }
}



#pragma mark - Alert
/*!
 * @discussion Shows a Confirm Deactivate PopUp
 */
-(void)showAlertForConfirmation
{
    NSString *strMsg = @"Are you Sure to deactivate your profile? \n If yes then to Re-Active your profile You need to Contact Admin.";
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:appNAME
                                                                  message:strMsg
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    [self confirmDeactivation];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - API calls
/*!
 * @discussion Webservice call for Deactivate User Account
 */
-(void)confirmDeactivation
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.txtEmailId.text forKey:@"email"];
    [dict setValue:self.txtEnterYourPass.text forKey:@"password"];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    [dict setValue:@"1" forKey:@"disable_user"];
    if ([Util getBoolData:kFromFBorGoogle])
    {
        [dict setValue:@"yes" forKey:@"social_user"];
    }
    [CiyaShopAPISecurity deactivateUser:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        HIDE_PROGRESS;
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                [FBSDKAccessToken setCurrentAccessToken:nil];
                [[GIDSignIn sharedInstance] signOut];
                
                NSArray *arrWishList = [[NSArray alloc] initWithArray:[[Util getArrayData:kWishList] mutableCopy]];
                NSArray *arrMyCart = [[NSArray alloc] initWithArray:[[Util getArrayData:kMyCart] mutableCopy]];
                NSArray *arrSearchedString = [[NSArray alloc] initWithArray:[[Util getArrayData:kSearchedString] mutableCopy]];
                
                NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
                
                [Util setArray:[arrWishList mutableCopy] setData:kWishList];
                [Util setArray:[arrMyCart mutableCopy] setData:kMyCart];
                [Util setArray:[arrSearchedString mutableCopy] setData:kSearchedString];
                
                appDelegate.loggedIn = kLoggedOut;
                appDelegate.dictCustData = [[NSMutableDictionary alloc] init];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                ALERTVIEW([MCLocalization stringForKey:@"Your Account is deactivated successfully"], appDelegate.window.rootViewController);
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
                }
                else
                {
                    ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
                }
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


#pragma mark - StatusBar Delegate
/*!
 * @discussion This method is used to set Status bar text color
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
