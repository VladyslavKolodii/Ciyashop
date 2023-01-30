
//
//  SigninVC.m
//  QuickClick
//
//  Created by Umesh on 4/14/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "SigninVC.h"
#import "HomeVC.h"
#import "AccountVC.h"
#import "SignupVC.h"

@import Firebase;
@import GoogleSignIn;

@interface SigninVC ()<UITextFieldDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UIView *vwPopUpBG;
@property (weak, nonatomic) IBOutlet UIView *vwPopUp;
@property (weak, nonatomic) IBOutlet UIView *vwPopUpPass;

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPin;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmNewPassword;

@property (strong, nonatomic) IBOutlet UILabel *lblFacebook;
@property (strong, nonatomic) IBOutlet UILabel *lblGooglePlus;
@property (strong, nonatomic) IBOutlet UILabel *lblDescriptionPass;
@property (strong, nonatomic) IBOutlet UILabel *lblEnterNewPass;
@property (strong, nonatomic) IBOutlet UILabel *lblOrSignUpWith;

@property (strong, nonatomic) IBOutlet UILabel *lblResetPassDescription;

@property (strong, nonatomic) IBOutlet UILabel *lblResetYourWord;
@property (strong, nonatomic) IBOutlet UILabel *lblResetYourWordPass;

@property (strong, nonatomic) IBOutlet UIButton *btnRequestPass;
@property (strong, nonatomic) IBOutlet UIButton *btnSetNewPass;

@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;
@property (strong, nonatomic) IBOutlet UIButton *btnForgetPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnNewUser;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnBackPopup;



@property (strong, nonatomic) IBOutlet UIImageView *imgUserName;
@property (strong, nonatomic) IBOutlet UIImageView *imgPass;
@property (strong, nonatomic) IBOutlet UIImageView *imgMail;

@property (strong, nonatomic) IBOutlet UIImageView *imgDeviderPass;
@property (strong, nonatomic) IBOutlet UIImageView *imgDeviderConfirmPass;
@property (strong, nonatomic) IBOutlet UIImageView *imgDevider1;
@property (strong, nonatomic) IBOutlet UIImageView *imgDevider2;
@property (strong, nonatomic) IBOutlet UIImageView *imgDevider3;
@property (strong, nonatomic) IBOutlet UIImageView *imgHeaderImage;

@property (strong, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UIView *vwContent;

@end

@implementation SigninVC
{
    NSMutableDictionary *dictData;
    UIView *vw;
    int set;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    set = 0;
    // Do any additional setup after loading the view from its nib.
    
    [GIDSignIn sharedInstance].uiDelegate = self;

    self.navigationController.navigationBarHidden = YES;

    self.vwPopUpBG.hidden = YES;
    self.vwPopUpPass.hidden = YES;
    self.vwPopUp.hidden=YES;
    self.vwPopUpBG.alpha=0;
    

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HidePopUp)];
    [self.vwPopUpBG addGestureRecognizer:tapRecognizer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    
    if([Util getStringData:kAppNameWhiteImage] !=nil){
        
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
    } else {
        self.imgHeaderImage.image = [UIImage imageNamed:@"HeaderClickShop"];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (![Util getBoolData:kLogin] && appDelegate.isLoginScreen) {
        self.btnBack.hidden = true;
    } else {
        self.btnBack.hidden = false;
    }
    NSLog(@"open sign in");
    
    appDelegate.delegateGoogle = self;
    [Util setHeaderColorView:vw];

    [self localize];
    
    
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

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    appDelegate.delegateGoogle = nil;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height);
    vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    
    if (set == 0)
    {
        set = 1;
        [self.view addSubview:vw];
    }
}

#pragma mark - Localize Language

- (void)localize
{
    self.lblOrSignUpWith.text = [MCLocalization stringForKey:@"Or sign up with"];

    [Util setSecondaryColorButton:self.btnRequestPass];
    [Util setSecondaryColorButton:self.btnSetNewPass];

    [Util setSecondaryColorButton:self.btnSignIn];
    
    
    [self.btnSignIn setTitle:[MCLocalization stringForKey:@"SIGN IN"] forState:UIControlStateNormal];
    [self.btnForgetPassword setTitle:[MCLocalization stringForKey:@"Forgot Password?"] forState:UIControlStateNormal];
    [self.btnNewUser setTitle:[MCLocalization stringForKey:@"New User? Register Now"] forState:UIControlStateNormal];

    [Util setPrimaryColorButtonImageBG:self.btnBack image:[UIImage imageNamed:@"BackArrow"]];
    
    [Util setPrimaryColorButtonTitle:self.btnForgetPassword];
    [Util setPrimaryColorButtonTitle:self.btnNewUser];
    
    
    [Util setColorImageView:self.imgUserName Color:[UIColor blackColor]];
    [Util setColorImageView:self.imgPass Color:[UIColor blackColor]];
    [Util setColorImageView:self.imgDevider1 Color:[UIColor blackColor]];
    [Util setColorImageView:self.imgDevider2 Color:[UIColor blackColor]];
    [Util setColorImageView:self.imgDevider3 Color:[UIColor blackColor]];
   

    self.lblGooglePlus.text = [MCLocalization stringForKey:@"GOOGLE+"];
    self.lblFacebook.text = [MCLocalization stringForKey:@"FACEBOOK"];

    
    self.lblResetYourWord.text = [MCLocalization stringForKey:@"Reset your world"];
    self.lblResetYourWordPass.text = [MCLocalization stringForKey:@"Reset your world"];
    
    self.lblResetPassDescription.text = [MCLocalization stringForKey:@"It's often forgotten that password thing. Enter your email address below and click on the 'Request Password Reset' button. We will contact you shortly!"];
    
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"E-mail"] attributes:@{NSForegroundColorAttributeName: color}];
    
    [self.btnRequestPass setTitle:[MCLocalization stringForKey:@"REQUEST PASSWORD RESET"] forState:UIControlStateNormal];
    
    self.lblDescriptionPass.text = [MCLocalization stringForKey:@"Enter PIN that we have sent you in your registered Email address."];
    self.lblEnterNewPass.text = [MCLocalization stringForKey:@"Now you can Enter new password."];
    
    
    self.txtUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Email"] attributes:@{NSForegroundColorAttributeName: SearchBG}];
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Email"] attributes:@{NSForegroundColorAttributeName: color}];
    self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Password"] attributes:@{NSForegroundColorAttributeName: SearchBG}];
    
    self.txtPin.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Enter PIN"] attributes:@{NSForegroundColorAttributeName: color}];
    self.txtNewPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Enter New Password"] attributes:@{NSForegroundColorAttributeName: color}];
    self.txtConfirmNewPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Confirm New Password"] attributes:@{NSForegroundColorAttributeName: color}];

    [self.btnSetNewPass setTitle:[MCLocalization stringForKey:@"SET NEW PASSWORD"] forState:UIControlStateNormal];
    
    
    self.lblFacebook.font = Font_Size_Product_Name_Regular;
    self.lblGooglePlus.font = Font_Size_Product_Name_Regular;
    self.lblOrSignUpWith.font = Font_Size_Product_Name_Regular;

    self.txtUserName.font = Font_Size_Product_Name_Regular;
    self.txtPassword.font = Font_Size_Product_Name_Regular;
    
    self.btnSignIn.titleLabel.font = Font_Size_Product_Name_Regular;
    self.btnForgetPassword.titleLabel.font = Font_Size_Product_Name_Regular;
    self.btnNewUser.titleLabel.font = Font_Size_Price_Sale_Yes_Small;
    
    self.lblResetPassDescription.font = Font_Size_Product_Name_Regular;
    self.txtEmail.font = Font_Size_Product_Name_Regular;
    self.btnRequestPass.titleLabel.font = Font_Size_Product_Name_Regular;
    
    self.txtPin.font = Font_Size_Product_Name_Regular;
    self.lblDescriptionPass.font = Font_Size_Product_Name_Regular;
    self.lblEnterNewPass.font = Font_Size_Product_Name_Regular;
    self.txtNewPassword.font = Font_Size_Product_Name_Regular;
    self.txtConfirmNewPassword.font = Font_Size_Product_Name_Regular;
    
    self.btnSetNewPass.titleLabel.font = Font_Size_Product_Name_Regular;
    
    if (appDelegate.isRTL)
    {
        //RTL
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        self.btnBackPopup.transform = CGAffineTransformMakeRotation(M_PI);
        self.btnBackPopup.frame = CGRectMake(self.vwPopUpPass.frame.size.width - self.btnBackPopup.frame.size.width, self.btnBackPopup.frame.origin.y, self.btnBackPopup.frame.size.width, self.btnBackPopup.frame.size.height);
        
        self.imgDevider1.frame = CGRectMake(0, self.imgDevider1.frame.origin.y, self.imgDevider1.frame.size.width, self.imgDevider1.frame.size.height);
        self.imgDevider2.frame = CGRectMake(0, self.imgDevider2.frame.origin.y, self.imgDevider2.frame.size.width, self.imgDevider2.frame.size.height);
        self.imgDevider3.frame = CGRectMake(self.vwPopUp.frame.size.width - self.txtEmail.frame.size.width - 75*SCREEN_SIZE.width/375, self.imgDevider3.frame.origin.y, self.imgDevider3.frame.size.width, self.imgDevider3.frame.size.height);

        self.txtEmail.frame = CGRectMake(self.vwPopUp.frame.size.width - self.txtEmail.frame.size.width - 75*SCREEN_SIZE.width/375, self.txtEmail.frame.origin.y, self.txtEmail.frame.size.width, self.txtEmail.frame.size.height);
        self.txtUserName.frame = CGRectMake(0, self.txtUserName.frame.origin.y, self.txtUserName.frame.size.width, self.txtUserName.frame.size.height);
        self.txtPassword.frame = CGRectMake(0, self.txtPassword.frame.origin.y, self.txtPassword.frame.size.width, self.txtPassword.frame.size.height);

        self.imgUserName.frame = CGRectMake(self.vwContent.frame.size.width - self.imgUserName.frame.size.width, self.imgUserName.frame.origin.y, self.imgUserName.frame.size.width, self.imgUserName.frame.size.height);
        self.imgPass.frame = CGRectMake(self.vwContent.frame.size.width - self.imgPass.frame.size.width, self.imgPass.frame.origin.y, self.imgPass.frame.size.width, self.imgPass.frame.size.height);
        self.imgMail.frame = CGRectMake(self.vwPopUp.frame.size.width - self.imgMail.frame.size.width - 40*SCREEN_SIZE.width/375, self.imgMail.frame.origin.y, self.imgMail.frame.size.width, self.imgMail.frame.size.height);

        self.txtUserName.textAlignment = NSTextAlignmentRight;
        self.txtPassword.textAlignment = NSTextAlignmentRight;
        self.txtEmail.textAlignment = NSTextAlignmentRight;

//        self.btnForgetPassword.frame = CGRectMake(self.btnSignIn.frame.origin.x, self.btnForgetPassword.frame.origin.y, self.btnForgetPassword.frame.size.width, self.btnForgetPassword.frame.size.height);
//        self.btnForgetPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    } else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
        self.btnBackPopup.transform = CGAffineTransformMakeRotation(0);
        self.txtUserName.textAlignment = NSTextAlignmentLeft;
        self.txtPassword.textAlignment = NSTextAlignmentLeft;
        self.txtEmail.textAlignment = NSTextAlignmentLeft;
    }
    
    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Google signIn Delegate

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    if (error != nil)
    {
        ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
    }
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)googleSignUp
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[Util getDictData:kGoogleData] mutableCopy]];
    if ([dict valueForKey:@"email"] != nil)
    {
        if ([dict valueForKey:@"email"] == nil || [[dict valueForKey:@"email"] isEqualToString:@""])
        {
            ALERTVIEW([MCLocalization stringForKey:@"We do not found your Email Id"], self);
            [[GIDSignIn sharedInstance] signOut];
        }
        else
        {
            NSString *strImgURLAsString = [[dict valueForKey:@"imageurl"] absoluteString];
            [strImgURLAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *imgURL = [Util EncodedURL:strImgURLAsString];
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                [self socialLogin:dict imgData:data];
            }];
        }
    }
    else
    {
        [[GIDSignIn sharedInstance] signOut];
        ALERTVIEW([MCLocalization stringForKey:@"We do not found your Email Id"], self);
    }
}



#pragma mark - Buttons IBAction Methods

- (IBAction)btnPopUpBackClicked:(id)sender
{
    self.vwPopUp.transform = CGAffineTransformIdentity;
    self.vwPopUpPass.transform = CGAffineTransformIdentity;
    
    [self clearText];

    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.vwPopUp.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.vwPopUpPass.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.vwPopUpBG.alpha=0.0;
        
    } completion:^(BOOL finished){
        
        [self clearText];
        
        self.vwPopUp.hidden = YES;
        self.vwPopUpPass.hidden = YES;
        self.vwPopUpBG.hidden = YES;
    }];
}

-(void) clearText {
    self.txtPin.text = @"";
    self.txtEmail.text = @"";
    self.txtNewPassword.text = @"";
    self.txtConfirmNewPassword.text = @"";
    
    [self.txtPin endEditing:YES];
    [self.txtEmail endEditing:YES];
    [self.txtNewPassword endEditing:YES];
    [self.txtConfirmNewPassword endEditing:YES];
}

- (IBAction)btnSignUpWithGoogleClicked:(id)sender
{
    [[GIDSignIn sharedInstance] signIn];
}

- (IBAction)btnSignUpWithFBClicked:(id)sender
{
    SHOW_LOADER_ANIMTION_1(self);
    [[FaceBookHelper shareInstance] GetDetialsFromFacebook:^(NSMutableDictionary *result)
     {
         if ([[result valueForKey:@"error"] isEqualToString:@"1"] || [[result valueForKey:@"error"] isEqualToString:@"2"])
         {
             HIDE_PROGRESS_1(self);
         }
         else if ([result valueForKey:@"email"] == nil || [[result valueForKey:@"email"] isEqualToString:@""])
         {
             HIDE_PROGRESS_1(self);
             [FBSDKAccessToken setCurrentAccessToken:nil];
             [Util setBoolData:NO setBoolData:kFromFBorGoogle];
             [Util setBoolData:NO setBoolData:kLogin];
             ALERTVIEW([MCLocalization stringForKey:@"Provide Email Id to your Facebook account"], self);
         }
         else
         {
             NSString *strImgURLAsString = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
             [strImgURLAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             NSURL *imgURL = [Util EncodedURL:strImgURLAsString];
             [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 [self socialLogin:result imgData:data];
             }];
         }
     }];
}

- (IBAction)btnForgotPasswordClicked:(id)sender
{
    self.vwPopUpBG.hidden = NO;
    self.vwPopUp.hidden=NO;
    
    self.vwPopUp.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.4 animations:^{
        
        self.vwPopUpBG.alpha=0.75;
        self.vwPopUp.transform = CGAffineTransformIdentity;
        
    }];
}

- (IBAction)btnSignUpClicked:(id)sender
{
    SignupVC *vc1 = [[SignupVC alloc]initWithNibName:@"SignupVC" bundle:nil];
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (IBAction)btnSignInClicked:(id)sender
{
    [self resignFirstResponder];
    if (self.txtUserName.text.length > 0)
    {
        if ([Util ValidateEmailString:self.txtUserName.text] )
        {
            if (self.txtPassword.text.length > 0)
            {
                [self loginAPI];
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
        ALERTVIEW([MCLocalization stringForKey:@"Enter Email address"], self);
    }
}

- (IBAction)btnRequestPasswordResetClicked:(id)sender
{
    if (self.txtEmail.text.length > 0)
    {
        if ([Util ValidateEmailString:self.txtEmail.text] )
        {
            [self forgetPassword];
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

- (IBAction)btnSetPassClicked:(id)sender
{
    if (self.txtPin.text.length > 0)
    {
        if ([self.txtPin.text isEqualToString:[Util getStringData:kPin]])
        {
            if (self.txtNewPassword.text.length > 0)
            {
                if (self.txtConfirmNewPassword.text.length > 0)
                {
                    if ([self.txtNewPassword.text isEqualToString:self.txtConfirmNewPassword.text])
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
                    ALERTVIEW([MCLocalization stringForKey:@"Enter New Password to Confirm"], self);
                }
            }
            else
            {
                ALERTVIEW([MCLocalization stringForKey:@"Enter your New Password"], self);
            }
        }
        else
        {
            ALERTVIEW([MCLocalization stringForKey:@"Entered PIN is not Correct"], self);
        }
    }
    else
    {
        ALERTVIEW([MCLocalization stringForKey:@"Enter Pin that we have sent you in your Registered Email Address"], self);
    }
}

- (IBAction)btnBackClicked:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //Run UI Updates
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)HidePopUp
{
    self.vwPopUp.transform = CGAffineTransformIdentity;
    [self clearText];

    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.vwPopUp.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.vwPopUpBG.alpha=0.0;
    } completion:^(BOOL finished) {
        
        self.vwPopUp.hidden = YES;
        if (self.vwPopUpPass.hidden )
        {
            self.vwPopUpBG.hidden = YES;
        }
        else
        {
            self.vwPopUpBG.alpha=0.75;
        }
    }];
}

#pragma mark - Textfield delegates value changed

- (IBAction)valuechangeTextPin:(id)sender
{
    BOOL flagSearch;
    //check pin
    NSString *searchText = [Util getStringData:kPin];
    if ([self.txtPin.text isEqualToString:searchText])
    {
        flagSearch = YES;
        self.lblEnterNewPass.hidden = NO;
        self.txtNewPassword.hidden = NO;
        self.txtConfirmNewPassword.hidden = NO;
        
        self.imgDeviderPass.hidden = NO;
        self.imgDeviderConfirmPass.hidden = NO;
    }
    else
    {
        flagSearch = NO;
        self.lblEnterNewPass.hidden = YES;
        self.txtNewPassword.hidden = YES;
        self.txtConfirmNewPassword.hidden = YES;
        
        self.imgDeviderPass.hidden = YES;
        self.imgDeviderConfirmPass.hidden = YES;
    }
}

#pragma mark - API call

-(void)loginAPI
{
    SHOW_LOADER_ANIMTION_1(self);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.txtUserName.text forKey:@"email"];
    [dict setValue:self.txtPassword.text forKey:@"password"];
    [dict setValue:appDelegate.strDeviceToken forKey:@"device_token"];
    [dict setValue:@"1" forKey:@"device_type"];
    
    [CiyaShopAPISecurity loginCustomer:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                [Util setData:self.txtPassword.text key:kPassword];
                [Util setData:[[dictionary valueForKey:@"user"] valueForKey:@"email"] key:kEmail];
                [Util setData:[[dictionary valueForKey:@"user"] valueForKey:@"username"] key:kUsername];

                [Util setBoolData:NO setBoolData:kFromFBorGoogle];
                [Util setData:[[[dictionary valueForKey:@"user"] valueForKey:@"id"] stringValue] key:kUserID];
                [Util setBoolData:YES setBoolData:kLogin];

                appDelegate.loggedIn = kLoggedIn;
                
                if (appDelegate.isWishList)
                {
                    [self addAllItemToWishList];
                }
                else
                {
                    //no wishlist
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            }
            else if ([[dictionary valueForKey:@"status"] isEqualToString:@"error"])
            {
                HIDE_PROGRESS_1(self);
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
                HIDE_PROGRESS_1(self);
                
                [Util setBoolData:NO setBoolData:kLogin];
                [Util setBoolData:NO setBoolData:kFromFBorGoogle];
                
                [FBSDKAccessToken setCurrentAccessToken:nil];
                [[GIDSignIn sharedInstance] signOut];
                
                ALERTVIEW([MCLocalization stringForKey:@"Your Email address or password is not correct"], self);
            }
        }
        else
        {
            HIDE_PROGRESS_1(self);
            if (dictionary.count > 0)
            {
                if ([[dictionary valueForKey:@"status"] isEqualToString:@"error"])
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
                else
                {
                    ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
                }
                [Util setBoolData:NO setBoolData:kFromFBorGoogle];
                
                [FBSDKAccessToken setCurrentAccessToken:nil];
                [[GIDSignIn sharedInstance] signOut];
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
        }
    }];
}

-(void)socialLogin:(NSDictionary*)dictFbDetail imgData:(NSData*)imgData
{
    SHOW_LOADER_ANIMTION_1(self);

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    [dict setValue:[dictFbDetail valueForKey:@"email"] forKey:@"email"];
    [dict setValue:[dictFbDetail valueForKey:@"id"] forKey:@"social_id"];
    [dict setValue:[dictFbDetail valueForKey:@"gender"] forKey:@"gender"];
    [dict setValue:[dictFbDetail valueForKey:@"birthday"] forKey:@"dob"];
    [dict setValue:[dictFbDetail valueForKey:@"first_name"] forKey:@"first_name"];
    [dict setValue:[dictFbDetail valueForKey:@"last_name"] forKey:@"last_name"];
    [dict setValue:appDelegate.strDeviceToken forKey:@"device_token"];
    [dict setValue:@"1" forKey:@"device_type"];
    
    float low_bound = 0;
    float high_bound = 5000;
    float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);//image1
    int intRndValue = (int)(rndValue + 0.5);
    NSString *str_image1 = [@(intRndValue) stringValue];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    
    [dictData setValue:[NSString stringWithFormat:@"%@.jpg",str_image1] forKey:@"name"];
    [dictData setValue:[imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed] forKey:@"data"];
    [dict setValue:dictData forKey:@"user_image"];

    [CiyaShopAPISecurity socialLoginCustomer:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                [Util setBoolData:YES setBoolData:kFromFBorGoogle];

                [Util setData:[[dictionary valueForKey:@"user"] valueForKey:@"email"] key:kEmail];
                [Util setData:[[dictionary valueForKey:@"user"] valueForKey:@"username"] key:kUsername];

                [Util setData:[[[dictionary valueForKey:@"user"] valueForKey:@"id"] stringValue] key:kUserID];
                [Util setBoolData:YES setBoolData:kLogin];
                
                appDelegate.loggedIn = kLoggedIn;
                
                if (appDelegate.isWishList)
                {
                    [self addAllItemToWishList];
                }
                else
                {
                    //no wishlist
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            }
            else if ([[dictionary valueForKey:@"status"] isEqualToString:@"error"])
            {
                HIDE_PROGRESS_1(self);
                
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
                HIDE_PROGRESS_1(self);
                
                [Util setBoolData:NO setBoolData:kLogin];
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
        }
        else
        {
            HIDE_PROGRESS_1(self);
            if (dictionary.count > 0)
            {
                if ([[dictionary valueForKey:@"status"] isEqualToString:@"error"])
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
                else
                {
                    ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
                }
                [Util setBoolData:NO setBoolData:kFromFBorGoogle];
                
                [FBSDKAccessToken setCurrentAccessToken:nil];
                [[GIDSignIn sharedInstance] signOut];
            }
            else
            {
                [Util setBoolData:NO setBoolData:kFromFBorGoogle];
                
                [FBSDKAccessToken setCurrentAccessToken:nil];
                [[GIDSignIn sharedInstance] signOut];
                
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
                }
                else
                {
                    ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
                }
            }
        }
    }];
}

-(void)forgetPassword
{
    SHOW_LOADER_ANIMTION_1(self);

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.txtEmail.text forKey:@"email"];
    
    [CiyaShopAPISecurity forgetPassword:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                HIDE_PROGRESS_1(self);
                
                [Util setData:[dictionary valueForKey:@"key"] key:kPin];
                
                self.lblEnterNewPass.hidden = YES;
                self.txtNewPassword.hidden = YES;
                self.txtConfirmNewPassword.hidden = YES;
                
                self.imgDeviderPass.hidden = YES;
                self.imgDeviderConfirmPass.hidden = YES;
                
                self.vwPopUpPass.transform = CGAffineTransformIdentity;
                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    self.vwPopUp.transform = CGAffineTransformMakeScale(0.01, 0.01);
                    self.vwPopUpBG.alpha=0.0;
                    
                } completion:^(BOOL finished){
                    
                    self.vwPopUp.hidden = YES;
                    self.vwPopUpPass.hidden=NO;
                    
                    self.vwPopUpPass.transform = CGAffineTransformMakeScale(0.01, 0.01);
                    [UIView animateWithDuration:0.4 animations:^{
                        
                        self.vwPopUpBG.alpha=0.75;
                        self.vwPopUpPass.transform = CGAffineTransformIdentity;
                        
                    }];
                }];
            }
            else
            {
                HIDE_PROGRESS_1(self);
                ALERTVIEW([MCLocalization stringForKey:@"Enter Proper Email Address"], self);
            }
        }
        else
        {
            HIDE_PROGRESS_1(self);
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
    }];
}

- (void)updatePassword
{
    SHOW_LOADER_ANIMTION_1(self);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.txtEmail.text forKey:@"email"];
    [dict setValue:self.txtNewPassword.text forKey:@"password"];
    [dict setValue:self.txtPin.text forKey:@"key"];
   
    [CiyaShopAPISecurity updatePassword:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                HIDE_PROGRESS_1(self);
                [self clearText];

                self.vwPopUpPass.transform = CGAffineTransformIdentity;
                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    self.vwPopUpPass.transform = CGAffineTransformMakeScale(0.01, 0.01);
                    self.vwPopUpBG.alpha=0.0;
                    
                } completion:^(BOOL finished) {
                    
                    self.vwPopUpPass.hidden = YES;
                    self.vwPopUpBG.hidden = YES;
                    ALERTVIEW([MCLocalization stringForKey:@"Your Password Updated Successfully"], self);
                }];
            }
            else
            {
                HIDE_PROGRESS_1(self);
                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
            }
        }
        else
        {
            HIDE_PROGRESS_1(self);
            ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
        }  
    }];
}

- (void)addAllItemToWishList
{
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
                
        NSLog(@"%@", dictionary);
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                HIDE_PROGRESS_1(self);
                if([[dictionary valueForKey:@"sync_list"] isKindOfClass:[NSArray class]])
                {
                    //Is array
                    NSLog(@"Product List Added to wishlist successfully!");
                }
                else if([dictionary isKindOfClass:[NSDictionary class]])
                {
                    HIDE_PROGRESS_1(self);
                    //is dictionary
                }
            }
            else
            {
                NSLog(@"Something Went Wrong while adding in Wishlist.");
            }
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
        else
        {
            HIDE_PROGRESS_1(self);
        }
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

@end
