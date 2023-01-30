//
//  AddNewAddressVC.m
//  QuickClick
//
//  Created by Kaushal PC on 02/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "AddNewAddressVC.h"

@interface AddNewAddressVC ()

@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwLast;
@property (strong,nonatomic) IBOutlet UIView *vwAllData;

@property (strong, nonatomic) IBOutlet UIScrollView *scrl;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblAddNewAddress;

@property (strong, nonatomic) IBOutlet UITextField *txtAddress1;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress2;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtCompany;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtPincode;
@property (strong, nonatomic) IBOutlet UITextField *txtState;

@property (strong, nonatomic) IBOutlet UIImageView *imgDividerContact;

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;


@end

@implementation AddNewAddressVC {
    UIView *vw;
}
@synthesize from, dictCustomerDetail;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    [self localize];
    [self setData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Util setHeaderColorView:vw];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.vwLast.frame.origin.y + self.vwLast.frame.size.height + 30);
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}


#pragma mark - SetBasic Details and Scroll Content Size
/*!
 * @discussion this function will set all Basic data of page and Profile image
 */
-(void)setData
{
    if (from == 0)
    {
        //Billing
        self.txtAddress1.text = [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"address_1"];
        self.txtAddress2.text = [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"address_2"];
        self.txtCity.text = [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"city"];
        self.txtCompany.text = [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"company"];
        self.txtCountry.text = [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"country"];
        self.txtFirstName.text = [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"first_name"];
        self.txtLastName.text = [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"last_name"];
        self.txtPhoneNumber.text = [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"phone"];
        self.txtPincode.text = [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"postcode"];
        self.txtState.text = [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"state"];
        self.lblAddNewAddress.text = [MCLocalization stringForKey:@"ADD BILLING ADDRESS"];
    }
    else if(from == 1)
    {
        //Shipping
        self.txtAddress1.text = [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"address_1"];
        self.txtAddress2.text = [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"address_2"];
        self.txtCity.text = [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"city"];
        self.txtCompany.text = [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"company"];
        self.txtCountry.text = [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"country"];
        self.txtFirstName.text = [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"first_name"];
        self.txtLastName.text = [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"last_name"];
        self.txtPincode.text = [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"postcode"];
        self.txtState.text = [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"state"];
        self.vwLast.frame = CGRectMake(self.vwLast.frame.origin.x, self.txtPhoneNumber.frame.origin.y, self.vwLast.frame.size.width, self.vwLast.frame.size.height);
        
        self.txtPhoneNumber.hidden = YES;
        self.imgDividerContact.hidden = YES;

        self.lblAddNewAddress.text = [MCLocalization stringForKey:@"ADD SHIPPING ADDRESS"];
    }
    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.vwLast.frame.origin.y + self.vwLast.frame.size.height);
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

    self.lblTitle.text = [MCLocalization stringForKey:@"Add New Address"];
    
    self.lblAddNewAddress.text = [MCLocalization stringForKey:@"Add New Address"];
    
    self.txtFirstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"First Name"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtLastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Last Name"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtAddress1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Address1"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtAddress2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Address2"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtCity.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"City"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtCountry.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Country"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtCompany.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Company"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtPincode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Pincode"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtState.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"State"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtPhoneNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Phone Number"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];

    [self.btnCancel setTitle:[MCLocalization stringForKey:@"Cancel"] forState:UIControlStateNormal];
    [self.btnSave setTitle:[MCLocalization stringForKey:@"Save"] forState:UIControlStateNormal];
    
    
    self.lblTitle.font = Font_Size_Navigation_Title;
    self.lblAddNewAddress.font = Font_Size_Price_Sale_Bold;
    self.btnSave.titleLabel.font = Font_Size_Price_Sale_Yes;
    self.btnCancel.titleLabel.font = Font_Size_Price_Sale_Yes;
    
    self.txtFirstName.font = Font_Size_Product_Name_Regular;
    self.txtLastName.font = Font_Size_Product_Name_Regular;
    self.txtPincode.font = Font_Size_Product_Name_Regular;
    self.txtAddress1.font = Font_Size_Product_Name_Regular;
    self.txtAddress2.font = Font_Size_Product_Name_Regular;
    self.txtCity.font = Font_Size_Product_Name_Regular;
    self.txtCompany.font = Font_Size_Product_Name_Regular;
    self.txtPhoneNumber.font = Font_Size_Product_Name_Regular;
    
    if (appDelegate.isRTL)
    {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        
        self.lblAddNewAddress.textAlignment = NSTextAlignmentRight;
        self.txtFirstName.textAlignment = NSTextAlignmentRight;
        self.txtLastName.textAlignment = NSTextAlignmentRight;
        self.txtEmail.textAlignment = NSTextAlignmentRight;
        self.txtCompany.textAlignment = NSTextAlignmentRight;
        self.txtCity.textAlignment = NSTextAlignmentRight;
        self.txtState.textAlignment = NSTextAlignmentRight;
        self.txtCountry.textAlignment = NSTextAlignmentRight;
        self.txtPincode.textAlignment = NSTextAlignmentRight;
        self.txtAddress1.textAlignment = NSTextAlignmentRight;
        self.txtAddress2.textAlignment = NSTextAlignmentRight;
        self.txtPhoneNumber.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //NonRTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
        
        self.lblAddNewAddress.textAlignment = NSTextAlignmentLeft;
        self.txtFirstName.textAlignment = NSTextAlignmentLeft;
        self.txtLastName.textAlignment = NSTextAlignmentLeft;
        self.txtEmail.textAlignment = NSTextAlignmentLeft;
        self.txtCompany.textAlignment = NSTextAlignmentLeft;
        self.txtCity.textAlignment = NSTextAlignmentLeft;
        self.txtState.textAlignment = NSTextAlignmentLeft;
        self.txtCountry.textAlignment = NSTextAlignmentLeft;
        self.txtPincode.textAlignment = NSTextAlignmentLeft;
        self.txtAddress1.textAlignment = NSTextAlignmentLeft;
        self.txtAddress2.textAlignment = NSTextAlignmentLeft;
        self.txtPhoneNumber.textAlignment = NSTextAlignmentLeft;
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
    [self updateUserData];
}
/*!
 * @discussion will Take you to Previous page
 * @param sender For indentifying sender
 */
-(IBAction)btnCancelClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API calls

-(void)updateUserData
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[appDelegate.dictCustData mutableCopy]];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:self.txtAddress1.text forKey:@"address_1"];
    [dict1 setValue:self.txtAddress2.text forKey:@"address_2"];
    [dict1 setValue:self.txtCity.text forKey:@"city"];
    [dict1 setValue:self.txtCompany.text forKey:@"company"];
    [dict1 setValue:self.txtFirstName.text forKey:@"first_name"];
    [dict1 setValue:self.txtLastName.text forKey:@"last_name"];
    [dict1 setValue:self.txtPincode.text forKey:@"postcode"];

    if (from == 0)
    {
        //Billing
        [dict1 setValue:[[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"country"] forKey:@"country"];
        [dict1 setValue:[[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"state"] forKey:@"state"];
        [dict1 setValue:self.txtPhoneNumber.text forKey:@"phone"];
        [dict1 setValue:[Util getStringData:kEmail] forKey:@"email"];
        [dict setValue:dict1 forKey:@"billing"];
    }
    else if (from == 1)
    {
        //Shipping
        [dict1 setValue:[[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"country"] forKey:@"country"];
        [dict1 setValue:[[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"state"] forKey:@"state"];
        [dict setValue:dict1 forKey:@"shipping"];
    }
    
    for (int i = 0; i < [[appDelegate.dictCustData valueForKey:@"meta_data"] count]; i++)
    {
        if ([[[[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"key"] lowercaseString] isEqualToString:@"mobile"])
        {
            //set Mobile Number
            [dict setValue:[[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"value"] forKey:@"mobile"];
        }
        else if ([[[[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"key"] lowercaseString] isEqualToString:@"dob"])
        {
            //set DOB
            NSString *strDOB = [[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"value"];
            [dict setValue:strDOB forKey:@"dob"];
            
        }
        else if ([[[[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"key"] lowercaseString] isEqualToString:@"gender"])
        {
            //set Gender
            NSString *strGender = [[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"value"];
            [dict setValue:strGender forKey:@"gender"];
        }
    }
    
    [CiyaShopAPISecurity updateCustomer:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        HIDE_PROGRESS;
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                appDelegate.dictCustData = [[NSMutableDictionary alloc] initWithDictionary:[dictionary mutableCopy]];
                [self.navigationController popViewControllerAnimated:YES];
                ALERTVIEW([MCLocalization stringForKey:@"Address Updated Successfully"], appDelegate.window.rootViewController);
            }
            else if ([[dictionary valueForKey:@"status"] isEqualToString:@"error"])
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
