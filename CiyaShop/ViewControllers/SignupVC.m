//
//  SignupVC.m
//  QuickClick
//
//  Created by Umesh on 4/14/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "SignupVC.h"
#import "HomeVC.h"
#import "AccountVC.h"
#import "VerificationVC.h"
#import "PCCPViewController.h"

@import Firebase;
@import GoogleSignIn;

@interface SignupVC () <VerificationOTPDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtContactNo;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnSignInNow;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;

@property (weak, nonatomic) IBOutlet UILabel *lblAlreadyHaveAnAccount;
@property (weak, nonatomic) IBOutlet UILabel *lblLine;

@property (strong, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UIView *vwContent;

@property (strong, nonatomic) IBOutlet UIImageView *imgDevider1;
@property (strong, nonatomic) IBOutlet UIImageView *imgDevider2;
@property (strong, nonatomic) IBOutlet UIImageView *imgDevider3;
@property (strong, nonatomic) IBOutlet UIImageView *imgDevider4;
@property (strong, nonatomic) IBOutlet UIImageView *imgDevider5;

@property (strong, nonatomic) IBOutlet UIImageView *imgUsername;
@property (strong, nonatomic) IBOutlet UIImageView *imgMail;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhone;
@property (strong, nonatomic) IBOutlet UIImageView *imgPass;
@property (strong, nonatomic) IBOutlet UIImageView *imgConfirmPass;
@property (strong, nonatomic) IBOutlet UIImageView *imgHeaderImage;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@end

@implementation SignupVC
{
    NSMutableDictionary *dictData;
    UIView *vw;
    NSString *strVerificationToken;

    NSString *strEmail;
    NSString *strUserName;
    NSString *strUserId;
    UILabel *lblCountryCode;
    UIView *vwCountryCode;
    UIImageView *imgCountryCode;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    [Util setSecondaryColorButton:self.btnSignUp];
    if([Util getStringData:kAppNameWhiteImage] !=nil)
    {
        [self.imgHeaderImage sd_setImageWithURL:[Util EncodedURL:[Util getStringData:kAppNameImage]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image == nil)
            {
                self.imgHeaderImage.image = [UIImage imageNamed:@"HeaderClickShop"];
            }
            else
            {
                self.imgHeaderImage.image = image;
            }
        }];
    }
    else
    {
        self.imgHeaderImage.image = [UIImage imageNamed:@"HeaderClickShop"];
    }
    vwCountryCode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60*SCREEN_SIZE.width/375, self.txtContactNo.frame.size.height)];
    lblCountryCode = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50*SCREEN_SIZE.width/375, self.txtContactNo.frame.size.height)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCountryCode:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [vwCountryCode addGestureRecognizer:tapGestureRecognizer];
    vwCountryCode.userInteractionEnabled = YES;
    lblCountryCode.textAlignment = NSTextAlignmentCenter;
//    [btnCountryCode addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
    
//    lblCountryCode.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    lblCountryCode.layer.borderWidth = 1;
//    lblCountryCode.layer.cornerRadius = 2;
    
    [vwCountryCode addSubview:lblCountryCode];
    imgCountryCode = [[UIImageView alloc] initWithFrame:CGRectMake(54*SCREEN_SIZE.width/375, 0, 5*SCREEN_SIZE.width/375, self.txtContactNo.frame.size.height)];
    [imgCountryCode setImage:[UIImage imageNamed:@"dropForCountry"]];
    imgCountryCode.contentMode = UIViewContentModeScaleAspectFit;
    [vwCountryCode addSubview:imgCountryCode];
    
    if (appDelegate.isRTL) {
        self.txtContactNo.rightView = vwCountryCode;
        self.txtContactNo.rightViewMode = UITextFieldViewModeAlways;
    } else {
        self.txtContactNo.leftView = vwCountryCode;
        self.txtContactNo.leftViewMode = UITextFieldViewModeAlways;
    }
    [self updateViewsWithCountryDic:[PCCPViewController infoFromSimCardAndiOSSettings]];
//    NSMutableString * defalultInfo = [lblCountryCode.text  mutableCopy];
//    [lblCountryCode setText:defalultInfo];
}

- (void)didReceiveMemoryWarning
{
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
    [self localize];
    [Util setHeaderColorView:vw];
}

#pragma mark - Mobile Country code

-(void)tapCountryCode:(id)sender {
    PCCPViewController * vc = [[PCCPViewController alloc] initWithCompletion:^(id countryDic) {
        [self updateViewsWithCountryDic:countryDic];
    }];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
    naviVC.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:naviVC animated:YES completion:NULL];
}

- (void)updateViewsWithCountryDic:(NSDictionary*)countryDic {
    [lblCountryCode setText:[NSString stringWithFormat:@"(%@) +%@", countryDic[@"country_code"], countryDic[@"phone_code"]]];
    [lblCountryCode sizeToFit];
    vwCountryCode.frame = CGRectMake(0, 0, lblCountryCode.frame.size.width + imgCountryCode.frame.size.width + (15*SCREEN_SIZE.width/375), lblCountryCode.frame.size.height);
    [lblCountryCode sizeToFit];
    lblCountryCode.frame = CGRectMake(0, 0, lblCountryCode.frame.size.width, lblCountryCode.frame.size.height);
    imgCountryCode.frame = CGRectMake(lblCountryCode.frame.size.width + (4*SCREEN_SIZE.width/375), 0, 10*SCREEN_SIZE.width/375, lblCountryCode.frame.size.height);
//    [self.txtContactNo setText:[NSString stringWithFormat:@"country_code: %@\ncountry_en: %@\ncountry_cn: %@\nphone_code: %@",countryDic[@"country_code"],countryDic[@"country_en"],countryDic[@"country_cn"],countryDic[@"phone_code"]]];
    //        [_imageView setImage:[PCCPViewController imageForCountryCode:countryDic[@"country_code"]]];
    [self.imgPhone setImage:[PCCPViewController imageForCountryCode:countryDic[@"country_code"]]];
}
    
#pragma mark - Localize Language
/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)localize
{
    [self.btnSignUp setTitle:[MCLocalization stringForKey:@"SIGN UP"] forState:UIControlStateNormal];
    [self.btnSignInNow setTitle:[MCLocalization stringForKey:@"Sign In Now"] forState:UIControlStateNormal];
    
    self.lblAlreadyHaveAnAccount.text = [MCLocalization stringForKey:@"Already have an account?"];
    
    [Util setPrimaryColorLabelText:self.lblAlreadyHaveAnAccount];
    [Util setPrimaryColorButtonTitle:self.btnSignInNow];
    
    
    [Util setPrimaryColorLabelBackGround:self.lblLine];
    
    self.txtUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Username"] attributes:@{NSForegroundColorAttributeName: SearchBG}];
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"E-mail"] attributes:@{NSForegroundColorAttributeName: SearchBG}];
    self.txtContactNo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Contact Number"] attributes:@{NSForegroundColorAttributeName: SearchBG}];
    self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Password"] attributes:@{NSForegroundColorAttributeName: SearchBG}];
    self.txtConfirmPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Confirm Password"] attributes:@{NSForegroundColorAttributeName: SearchBG}];
    
    
    self.btnSignUp.titleLabel.font = Font_Size_Product_Name_Regular;
    self.txtUserName.font = Font_Size_Product_Name_Regular;
    self.txtEmail.font = Font_Size_Product_Name_Regular;
    self.txtContactNo.font = Font_Size_Product_Name_Regular;
    self.txtPassword.font = Font_Size_Product_Name_Regular;
    self.txtConfirmPassword.font = Font_Size_Product_Name_Regular;
    
    self.lblAlreadyHaveAnAccount.font = Font_Size_Product_Name_Small;
    self.btnSignInNow.titleLabel.font = Font_Size_Product_Name_Small;
    
    self.txtEmail.font = Font_Size_Product_Name_Regular;

    
    [Util setColorImageView:self.imgUsername Color:[UIColor blackColor]];
    [Util setColorImageView:self.imgMail Color:[UIColor blackColor]];
    [Util setColorImageView:self.imgPass Color:[UIColor blackColor]];
//    [Util setColorImageView:self.imgPhone Color:[UIColor blackColor]];
    [Util setColorImageView:self.imgConfirmPass Color:[UIColor blackColor]];
    [Util setColorImageView:self.imgDevider1 Color:[UIColor blackColor]];
    [Util setColorImageView:self.imgDevider2 Color:[UIColor blackColor]];
    [Util setColorImageView:self.imgDevider3 Color:[UIColor blackColor]];
    [Util setColorImageView:self.imgDevider4 Color:[UIColor blackColor]];
    [Util setColorImageView:self.imgDevider5 Color:[UIColor blackColor]];
    [Util setPrimaryColorButtonImageBG:self.btnBack image:[UIImage imageNamed:@"BackArrow"]];
    if (appDelegate.isRTL)
    {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        
        self.imgDevider1.frame = CGRectMake(0, self.imgDevider1.frame.origin.y, self.imgDevider1.frame.size.width, self.imgDevider1.frame.size.height);
        self.imgDevider2.frame = CGRectMake(0, self.imgDevider2.frame.origin.y, self.imgDevider2.frame.size.width, self.imgDevider2.frame.size.height);
        self.imgDevider3.frame = CGRectMake(0, self.imgDevider3.frame.origin.y, self.imgDevider3.frame.size.width, self.imgDevider3.frame.size.height);
        self.imgDevider4.frame = CGRectMake(0, self.imgDevider4.frame.origin.y, self.imgDevider4.frame.size.width, self.imgDevider4.frame.size.height);
        self.imgDevider5.frame = CGRectMake(0, self.imgDevider5.frame.origin.y, self.imgDevider5.frame.size.width, self.imgDevider5.frame.size.height);
        
        self.txtEmail.frame = CGRectMake(0, self.txtEmail.frame.origin.y, self.txtEmail.frame.size.width, self.txtEmail.frame.size.height);
        self.txtUserName.frame = CGRectMake(0, self.txtUserName.frame.origin.y, self.txtUserName.frame.size.width, self.txtUserName.frame.size.height);
        self.txtPassword.frame = CGRectMake(0, self.txtPassword.frame.origin.y, self.txtPassword.frame.size.width, self.txtPassword.frame.size.height);
        self.txtConfirmPassword.frame = CGRectMake(0, self.txtConfirmPassword.frame.origin.y, self.txtConfirmPassword.frame.size.width, self.txtConfirmPassword.frame.size.height);
        self.txtContactNo.frame = CGRectMake(0, self.txtContactNo.frame.origin.y, self.txtContactNo.frame.size.width, self.txtContactNo.frame.size.height);
        
        self.imgUsername.frame = CGRectMake(self.vwContent.frame.size.width - self.imgUsername.frame.size.width, self.imgUsername.frame.origin.y, self.imgUsername.frame.size.width, self.imgUsername.frame.size.height);
        self.imgMail.frame = CGRectMake(self.vwContent.frame.size.width - self.imgMail.frame.size.width, self.imgMail.frame.origin.y, self.imgMail.frame.size.width, self.imgMail.frame.size.height);
        self.imgPass.frame = CGRectMake(self.vwContent.frame.size.width - self.imgPass.frame.size.width, self.imgPass.frame.origin.y, self.imgPass.frame.size.width, self.imgPass.frame.size.height);
        self.imgConfirmPass.frame = CGRectMake(self.vwContent.frame.size.width - self.imgConfirmPass.frame.size.width, self.imgConfirmPass.frame.origin.y, self.imgConfirmPass.frame.size.width, self.imgConfirmPass.frame.size.height);
        self.imgPhone.frame = CGRectMake(self.vwContent.frame.size.width - self.imgPhone.frame.size.width, self.imgPhone.frame.origin.y, self.imgPhone.frame.size.width, self.imgPhone.frame.size.height);
        
        self.txtUserName.textAlignment = NSTextAlignmentRight;
        self.txtPassword.textAlignment = NSTextAlignmentRight;
        self.txtConfirmPassword.textAlignment = NSTextAlignmentRight;
        self.txtContactNo.textAlignment = NSTextAlignmentRight;
        self.txtEmail.textAlignment = NSTextAlignmentRight;
    } else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }
}


#pragma mark - Button IBActions Method
/*!
 * @discussion It will take you to PreviousView
 * @param sender For indentifying sender
 */
- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*!
 * @discussion It will SignUp User
 * @param sender For indentifying sender
 */
- (IBAction)btnSignUpClicked:(id)sender
{
    if (self.txtUserName.text.length > 0)
    {
        if (self.txtEmail.text.length > 0)
        {
            if ([Util ValidateEmailString:self.txtEmail.text])
            {
                if (self.txtContactNo.text.length > 0)
                {
                    if (self.txtPassword.text.length > 0)
                    {
                        if (self.txtConfirmPassword.text.length > 0)
                        {
                            if ([self.txtPassword.text isEqualToString:self.txtConfirmPassword.text])
                            {
//                                [self registerUser];
                                [self sendMessage];
                            }
                            else
                            {
                                ALERTVIEW([MCLocalization stringForKey:@"Password and Confirm Password Does not match"], self);
                            }
                        }
                        else
                        {
                            ALERTVIEW([MCLocalization stringForKey:@"Enter Confirm Password"], self);
                        }
                    }
                    else
                    {
                        ALERTVIEW([MCLocalization stringForKey:@"Enter Password"], self);
                    }
                }
                else
                {
                    ALERTVIEW([MCLocalization stringForKey:@"Enter Your Contact Number"], self);
                }
            }
            else
            {
                ALERTVIEW([MCLocalization stringForKey:@"Enter Proper Email Address"], self);
            }
        }
        else
        {
            ALERTVIEW([MCLocalization stringForKey:@"Enter Email address"], self);
        }
    }
    else
    {
        ALERTVIEW([MCLocalization stringForKey:@"Please Enter Username"], self);
    }
}
/*!
 * @discussion It will take you to SignIn Page
 * @param sender For indentifying sender
 */
- (IBAction)btnSignInClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - API calls
/*!
 * @discussion Webservice for Register a User
 */
-(void)registerUser
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.txtEmail.text forKey:@"email"];
    [dict setValue:self.txtUserName.text forKey:@"username"];
    NSArray *arrCode = [lblCountryCode.text componentsSeparatedByString:@" "];
    [dict setValue:[NSString stringWithFormat:@"%@%@",[arrCode objectAtIndex:arrCode.count - 1], self.txtContactNo.text] forKey:@"mobile"];
    [dict setValue:self.txtPassword.text forKey:@"password"];
    [dict setValue:appDelegate.strDeviceToken forKey:@"device_token"];
    [dict setValue:@"1" forKey:@"device_type"];
    
    SHOW_LOADER_ANIMTION_1(self);
    
    [CiyaShopAPISecurity createCustomer:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        HIDE_PROGRESS_1(self);
        if (success)
        {
            if (dictionary.count > 0)
            {
                if ([[dictionary valueForKey:@"status"] isEqualToString:@"error"])
                {
                    [Util setBoolData:NO setBoolData:kLogin];
                    [Util setBoolData:NO setBoolData:kFromFBorGoogle];
                    
                    [FBSDKAccessToken setCurrentAccessToken:nil];
                    [[GIDSignIn sharedInstance] signOut];
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
                    self->strEmail = [[dictionary valueForKey:@"user"] valueForKey:@"email"];
                    self->strUserName = [[dictionary valueForKey:@"user"] valueForKey:@"username"];
                    self->strUserId = [[[dictionary valueForKey:@"user"] valueForKey:@"id"] stringValue];
                    
                    [Util setData:self->strEmail key:kEmail];
                    [Util setData:self->strUserName key:kUsername];
                    [Util setData:self.txtPassword.text key:kPassword];
                    [Util setBoolData:NO setBoolData:kFromFBorGoogle];
                    [Util setData:self->strUserId key:kUserID];
                    [Util setBoolData:YES setBoolData:kLogin];
                    appDelegate.loggedIn = kLoggedIn;

                    if (appDelegate.isWishList)
                    {
                        [self addAllItemToWishList];
                    }
                    else
                    {
                        //no wishlist
//                        [self sendMessage];
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            }
            else
            {
                NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                NSAttributedString *decodedString;
                decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                 options:options
                                                      documentAttributes:NULL
                                                                   error:NULL];
                ALERTVIEW(decodedString.string, self);
            }
        }
        else
        {
            [Util setBoolData:NO setBoolData:kFromFBorGoogle];
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [[GIDSignIn sharedInstance] signOut];
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
/*!
 * @discussion Webservice for all itme to wishlist
 */
- (void)addAllItemToWishList
{
    SHOW_LOADER_ANIMTION_1(self);

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    NSMutableArray *arrList = [[NSMutableArray alloc] init];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
    for (int i = 0; i < arr.count; i++)
    {
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        [dict1 setValue:[arr objectAtIndex:i] forKey:@"product_id"];
        [dict1 setValue:@"1" forKey:@"quantity"];
        [dict1 setValue:@"" forKey:@"wishlist_name"];
        [dict1 setValue:[Util getStringData:kUserID] forKey:@"user_id"];
        [arrList addObject:[dict1 mutableCopy]];
    }
    [dict setValue:arrList forKey:@"sync_list"];
    
    [CiyaShopAPISecurity addAllItemToWishList:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        HIDE_PROGRESS_1(self);
        if (success)
        {
            if([[dictionary valueForKey:@"sync_list"] isKindOfClass:[NSArray class]])
            {
                //Is array
                NSMutableArray *arrData = [[NSMutableArray alloc] initWithArray:[dictionary valueForKey:@"sync_list"]];
                [appDelegate setWishList:arrData];
            }
            else if([dictionary isKindOfClass:[NSDictionary class]])
            {
                //is dictionary
                NSMutableArray *arrData = [[NSMutableArray alloc] init];
                [appDelegate setWishList:arrData];
            }
        }
//        [self sendMessage];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - StatusBar Delegate
/*!
 * @discussion This method is used to set Status bar text color
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - Firebase OTP verification

-(void)sendMessage {
    if (!appDelegate.isOTPEnabled) {
        [self successInVerification];
        return;
    }
    NSArray *arrCode = [lblCountryCode.text componentsSeparatedByString:@" "];
    NSString *strPhoneNumber = [NSString stringWithFormat:@"%@%@",[arrCode objectAtIndex:arrCode.count - 1], self.txtContactNo.text];
    [[FIRPhoneAuthProvider provider] verifyPhoneNumber:strPhoneNumber UIDelegate:nil completion:^(NSString * _Nullable verificationID, NSError * _Nullable error) {
        if (error) {
            ALERTVIEW(error.localizedDescription, self);
            NSLog(@"Error while sending confirmation code = %@",error.localizedDescription);
        } else {
            NSLog(@"Confirmation code did sent  = %@",verificationID);
            self->strVerificationToken = verificationID;
            //Show OTP Verification Popup
            VerificationVC *vc = [[VerificationVC alloc] initWithNibName:@"VerificationVC" bundle:nil];
            self.definesPresentationContext = YES; //self is presenting view controller
            vc.view.backgroundColor = [UIColor clearColor];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            vc.strVerificationToken = verificationID;
            vc.strPhoneNumber = [NSString stringWithFormat:@"%@%@",self->lblCountryCode.text, self.txtContactNo.text];
            vc.strUserId = self->strUserId;
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
}

#pragma mark - Verification OTP Delegate

- (void)successInVerification {
    //verified so close
    [self registerUser];
//    [Util setData:self->strEmail key:kEmail];
//    [Util setData:self->strUserName key:kUsername];
//    [Util setData:self.txtPassword.text key:kPassword];
//    [Util setBoolData:NO setBoolData:kFromFBorGoogle];
//    [Util setData:self->strUserId key:kUserID];
//    [Util setBoolData:YES setBoolData:kLogin];
//    appDelegate.loggedIn = kLoggedIn;
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
