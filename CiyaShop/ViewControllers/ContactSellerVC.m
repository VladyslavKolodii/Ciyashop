//
//  ContactSellerVC.m
//  CiyaShop
//
//  Created by Kaushal PC on 08/11/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "ContactSellerVC.h"

@interface ContactSellerVC ()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrl;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;

@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextView *txtMessage;

@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwAllData;

@end

@implementation ContactSellerVC {
    UIView *vw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"View loaded");

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
        //Logged In then set text for username and email
        self.txtName.text = [Util getStringData:kUsername];
        self.txtEmail.text = [Util getStringData:kEmail];
    }
    self.txtMessage.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    [self localize];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Util setHeaderColorView:vw];
}
- (void)didReceiveMemoryWarning {
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

#pragma mark - Localization

- (void)localize
{
    self.lblTitle.text = [MCLocalization stringForKey:@"Contact Seller"];
    self.lblTitle.textColor = OtherTitleColor;
    [Util setHeaderColorView:self.vwHeader];

    self.txtMessage.text = [MCLocalization stringForKey:@"Message"];
    self.txtMessage.textColor = [UIColor lightGrayColor];
    
    self.lblName.text = [MCLocalization stringForKey:@"Name"];
    self.lblEmail.text = [MCLocalization stringForKey:@"Email"];
    self.lblMessage.text = [MCLocalization stringForKey:@"Message"];
    
    
    self.lblName.textColor = LightBlackColor;
    self.lblEmail.textColor = LightBlackColor;
    self.lblMessage.textColor = LightBlackColor;
    
    
    self.txtName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Name"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Email"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    
    [self.btnSend setTitle:[MCLocalization stringForKey:@"SEND"] forState:UIControlStateNormal];
    [Util setSecondaryColorButton:self.btnSend];

    self.lblTitle.font = Font_Size_Navigation_Title;
    
    self.lblName.font = Font_Size_Product_Name_Regular;
    self.lblEmail.font = Font_Size_Product_Name_Regular;
    self.lblMessage.font = Font_Size_Product_Name_Regular;
    
    
    self.txtName.font = Font_Size_Product_Name_Regular;
    self.txtEmail.font = Font_Size_Product_Name_Regular;
    self.txtMessage.font = Font_Size_Product_Name_Regular;
    
    self.btnSend.titleLabel.font = Font_Size_Price_Sale_Bold;
    
    if (appDelegate.isRTL)
    {
        //RTL
        self.lblName.textAlignment = NSTextAlignmentRight;
        self.lblEmail.textAlignment = NSTextAlignmentRight;
        self.lblMessage.textAlignment = NSTextAlignmentRight;
        
        self.txtName.textAlignment = NSTextAlignmentRight;
        self.txtEmail.textAlignment = NSTextAlignmentRight;
        self.txtMessage.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //NonRTL
        self.lblName.textAlignment = NSTextAlignmentLeft;
        self.lblEmail.textAlignment = NSTextAlignmentLeft;
        self.lblMessage.textAlignment = NSTextAlignmentLeft;
        
        self.txtName.textAlignment = NSTextAlignmentLeft;
        self.txtEmail.textAlignment = NSTextAlignmentLeft;
        self.txtMessage.textAlignment = NSTextAlignmentLeft;
    }
    if (appDelegate.isRTL)
    {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
    }
    else
    {
        //NonRTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }

}

#pragma mark - UitextView Delegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    //NSLog(@"textViewShouldBeginEditing");
    if([self.txtMessage.text isEqualToString:[MCLocalization stringForKey:@"Message"]] && [self.txtMessage.textColor isEqual:[UIColor lightGrayColor]])
    {
        self.txtMessage.text = @"";
        self.txtMessage.textColor = [UIColor blackColor];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(self.txtMessage.text.length == 0)
    {
        self.txtMessage.textColor = [UIColor lightGrayColor];
        self.txtMessage.text = [MCLocalization stringForKey:@"Message"];
    }
    return YES;
}

#pragma mark - button Clicks

-(IBAction)btnSendClicked:(id)sender
{
    if (self.txtName.text.length > 0)
    {
        if (self.txtEmail.text.length > 0)
        {
            if ([Util ValidateEmailString:self.txtEmail.text])
            {
                    if([self.txtMessage.text isEqualToString:[MCLocalization stringForKey:@"Message"]] && [self.txtMessage.textColor isEqual:[UIColor lightGrayColor]])
                    {
                        ALERTVIEW([MCLocalization stringForKey:@"Please Enter Message"], self);
                    }
                    else
                    {
                        [self contactSeller];
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
        ALERTVIEW([MCLocalization stringForKey:@"Enter your name"], self);
    }
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - API calls

-(void)contactSeller
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.txtName.text forKey:@"name"];
    [dict setValue:self.txtEmail.text forKey:@"email"];
    [dict setValue:self.txtMessage.text forKey:@"message"];
    [dict setValue:self.strSellerID forKey:@"seller_id"];

    [CiyaShopAPISecurity contactSeller:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        if (success)
        {
            HIDE_PROGRESS;
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                //done
                self.txtName.text = @"";
                self.txtEmail.text = @"";
                self.txtMessage.textColor = [UIColor lightGrayColor];
                self.txtMessage.text = [MCLocalization stringForKey:@"Message"];
                
                

                [self showAlert];


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
    }];
}
-(void)showAlert
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:appNAME
                                          message:[MCLocalization stringForKey:@"Message Sent"]
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
