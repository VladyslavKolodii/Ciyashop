//
//  ChangePasswordVC.m
//  QuickClick
//
//  Created by Kaushal PC on 02/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblChangePass;
@property (strong, nonatomic) IBOutlet UILabel *lblEmailId;
@property (strong, nonatomic) IBOutlet UILabel *lblMobileNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblOldPassword;
@property (strong, nonatomic) IBOutlet UILabel *lblNewPassword;
@property (strong, nonatomic) IBOutlet UILabel *lblRetypePassword;

@property (strong, nonatomic) IBOutlet UITextField *txtEmailId;
@property (strong, nonatomic) IBOutlet UITextField *txtMobileNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtEnterCurrentPass;
@property (strong, nonatomic) IBOutlet UITextField *txtEnterNewPass;
@property (strong, nonatomic) IBOutlet UITextField *txtRetypeNewPass;

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwLast;
@property (strong, nonatomic) IBOutlet UIView *vwAllData;

@end

@implementation ChangePasswordVC {
    UIView *vw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
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

#pragma mark - Localize Language
/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)localize
{
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.textColor = OtherTitleColor;
    [Util setSecondaryColorView:self.vwLast];

    self.lblTitle.text = [MCLocalization stringForKey:@"Account settings"];
    
    self.lblChangePass.text = [MCLocalization stringForKey:@"Change Password"];
    self.lblEmailId.text = [MCLocalization stringForKey:@"Email ID"];
    self.lblMobileNumber.text = [MCLocalization stringForKey:@"Mobile Number"];
    self.lblOldPassword.text = [MCLocalization stringForKey:@"Old Password"];
    self.lblNewPassword.text = [MCLocalization stringForKey:@"New Password"];
    self.lblRetypePassword.text = [MCLocalization stringForKey:@"Retype Password"];
    
    self.txtEmailId.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Email ID"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtMobileNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Mobile Number"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtEnterCurrentPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Enter Current Password"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtEnterNewPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Enter New Password"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtRetypeNewPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Retype New Password"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    [self.btnCancel setTitle:[MCLocalization stringForKey:@"Cancel"] forState:UIControlStateNormal];
    [self.btnSave setTitle:[MCLocalization stringForKey:@"Save"] forState:UIControlStateNormal];
    
    
    self.lblTitle.font = Font_Size_Navigation_Title;
    self.lblChangePass.font = Font_Size_Price_Sale_Bold;
    self.lblEmailId.font = Font_Size_Product_Name_Regular;
    self.lblOldPassword.font = Font_Size_Product_Name_Regular;
    self.lblNewPassword.font = Font_Size_Product_Name_Regular;
    self.lblRetypePassword.font = Font_Size_Product_Name_Regular;
    
    self.txtEmailId.font = Font_Size_Product_Name_Regular;
    self.txtEnterCurrentPass.font = Font_Size_Product_Name_Regular;
    self.txtEnterNewPass.font = Font_Size_Product_Name_Regular;
    self.txtRetypeNewPass.font = Font_Size_Product_Name_Regular;
    
    self.btnSave.titleLabel.font = Font_Size_Price_Sale_Bold;
    self.btnCancel.titleLabel.font = Font_Size_Price_Sale_Bold;
    
    if (appDelegate.isRTL)
    {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        
        self.lblChangePass.textAlignment = NSTextAlignmentRight;
        self.lblEmailId.textAlignment = NSTextAlignmentRight;
        self.lblMobileNumber.textAlignment = NSTextAlignmentRight;
        self.lblOldPassword.textAlignment = NSTextAlignmentRight;
        self.lblNewPassword.textAlignment = NSTextAlignmentRight;
        self.lblRetypePassword.textAlignment = NSTextAlignmentRight;

        self.txtEmailId.textAlignment = NSTextAlignmentRight;
        self.txtMobileNumber.textAlignment = NSTextAlignmentRight;
        self.txtEnterNewPass.textAlignment = NSTextAlignmentRight;
        self.txtRetypeNewPass.textAlignment = NSTextAlignmentRight;
        self.txtEnterCurrentPass.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //NonRTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
        
        self.lblChangePass.textAlignment = NSTextAlignmentLeft;
        self.lblEmailId.textAlignment = NSTextAlignmentLeft;
        self.lblMobileNumber.textAlignment = NSTextAlignmentLeft;
        self.lblOldPassword.textAlignment = NSTextAlignmentLeft;
        self.lblNewPassword.textAlignment = NSTextAlignmentLeft;
        self.lblRetypePassword.textAlignment = NSTextAlignmentLeft;
        
        self.txtEmailId.textAlignment = NSTextAlignmentLeft;
        self.txtMobileNumber.textAlignment = NSTextAlignmentLeft;
        self.txtEnterNewPass.textAlignment = NSTextAlignmentLeft;
        self.txtRetypeNewPass.textAlignment = NSTextAlignmentLeft;
        self.txtEnterCurrentPass.textAlignment = NSTextAlignmentLeft;
    }
    
    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

#pragma mark - Button Clicks
/*!
 * @discussion will save the information
 * @param sender For indentifying sender
 */
-(IBAction)btnSaveClicked:(id)sender
{
    if (self.txtEmailId.text.length > 0)
    {
        if ([Util ValidateEmailString:self.txtEmailId.text])
        {
            if ([self.txtEmailId.text isEqualToString:[Util getStringData:kEmail]])
            {
                if (self.txtEnterCurrentPass.text.length > 0)
                {
                    if ([self.txtEnterCurrentPass.text isEqualToString:[Util getStringData:kPassword]])
                    {
                        if (self.txtEnterNewPass.text.length > 0)
                        {
                            if (self.txtRetypeNewPass.text.length > 0)
                            {
                                if ([self.txtEnterNewPass.text isEqualToString:self.txtRetypeNewPass.text])
                                {
                                    [self updatePassword];
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
                            ALERTVIEW([MCLocalization stringForKey:@"Enter your New Password"], self);
                        }
                    }
                    else
                    {
                        ALERTVIEW([MCLocalization stringForKey:@"Your Email address or password is not correct"], self);
                    }
                }
                else
                {
                    ALERTVIEW([MCLocalization stringForKey:@"Enter your Current Password"], self);
                }
            }
            else
            {
                ALERTVIEW([MCLocalization stringForKey:@"Enter Valid Email Address"], self);
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
/*!
 * @discussion will Take you to Previous page
 * @param sender For indentifying sender
 */
-(IBAction)btnCancelClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - API Calls
/*!
 * @discussion Webservice call for Updating the User Password
 */
-(void)updatePassword
{
    SHOW_LOADER_ANIMTION();

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    [dict setValue:self.txtEnterNewPass.text forKey:@"password"];
    
    [CiyaShopAPISecurity resetPassword:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        HIDE_PROGRESS;
        if (success)
        {
            if (dictionary.count > 0)
            {
                if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
                {
                    [Util setData:self.txtEnterNewPass.text key:kPassword];
                    self.txtEmailId.text = @"";
                    self.txtEnterNewPass.text = @"";
                    self.txtRetypeNewPass.text = @"";
                    self.txtEnterCurrentPass.text = @"";
                    [self.navigationController popViewControllerAnimated:YES];
                    ALERTVIEW([MCLocalization stringForKey:@"Password Changed Successfully"], appDelegate.window.rootViewController);
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
