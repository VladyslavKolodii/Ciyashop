//
//  AccountSettingVC.m
//  QuickClick
//
//  Created by Kaushal PC on 02/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "AccountSettingVC.h"
#import "ChangePasswordVC.h"
#import "DeactivateAccountVC.h"

@interface AccountSettingVC ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrl;

@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwChangePass;
@property (strong, nonatomic) IBOutlet UIView *vwLast;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblFirstName;
@property (strong, nonatomic) IBOutlet UILabel *lblLastName;
@property (strong, nonatomic) IBOutlet UILabel *lblDateOfBirth;
@property (strong, nonatomic) IBOutlet UILabel *lblGender;
@property (strong, nonatomic) IBOutlet UILabel *lblMobileNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblEmailId;

@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtDateOfBirth;
@property (strong, nonatomic) IBOutlet UITextField *txtMobileNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailId;

@property (strong, nonatomic) IBOutlet UIButton *btnChangePass;
@property (strong, nonatomic) IBOutlet UIButton *btnDeactivateAcct;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UIImageView *imgArrowChangePass;
@property (strong, nonatomic) IBOutlet UIImageView *imgArrowDeactivateAcct;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;

@property (strong, nonatomic) IBOutlet UIImageView *imgMaleBG;
@property (strong, nonatomic) IBOutlet UIImageView *imgFemaleBG;
@property (strong, nonatomic) IBOutlet UIImageView *imgMaleBGSelected;
@property (strong, nonatomic) IBOutlet UIImageView *imgFemaleBGSelected;

@property (strong,nonatomic) IBOutlet UIView *vwAllData;

@end

@implementation AccountSettingVC {
    BOOL set;
    NSString *strSelectedGender;
    UIView *vw;
    UIDatePicker *pickerDOB;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([Util getBoolData:kFromFBorGoogle]) {
        self.vwChangePass.frame = CGRectMake(0, self.vwChangePass.frame.origin.y, SCREEN_SIZE.width, 0);
        self.vwChangePass.hidden = YES;
    } else {
        self.vwChangePass.hidden = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    [Util setSecondaryColorButton:self.btnSave];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self localize];
    [Util setHeaderColorView:vw];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.vwLast.frame = CGRectMake(0, self.vwChangePass.frame.origin.y + self.vwChangePass.frame.size.height, self.vwLast.frame.size.width, self.vwLast.frame.size.height);
    
    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.vwLast.frame.origin.y+self.vwLast.frame.size.height+20);

    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}

#pragma mark - Localize Language
/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)localize {
    [Util setHeaderColorView:self.vwHeader];

    self.lblTitle.textColor = OtherTitleColor;
    
    self.lblTitle.text = [MCLocalization stringForKey:@"Account settings"];
    
    self.lblFirstName.text = [MCLocalization stringForKey:@"First Name"];
    self.lblLastName.text = [MCLocalization stringForKey:@"Last Name"];
    self.lblDateOfBirth.text = [MCLocalization stringForKey:@"Date of Birth"];
    self.lblGender.text = [MCLocalization stringForKey:@"Gender"];
    self.lblMobileNumber.text = [MCLocalization stringForKey:@"Mobile Number"];
    self.lblEmailId.text = [MCLocalization stringForKey:@"Email ID"];
    
    self.txtFirstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"First Name"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtLastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Last Name"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtDateOfBirth.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Date of Birth"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtMobileNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Mobile Number"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtEmailId.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Email ID"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];

    [self.btnSave setTitle:[MCLocalization stringForKey:@"Save"] forState:UIControlStateNormal];
    [self.btnChangePass setTitle:[MCLocalization stringForKey:@"Change Password"] forState:UIControlStateNormal];
    [self.btnDeactivateAcct setTitle:[MCLocalization stringForKey:@"Deactive Account"] forState:UIControlStateNormal];
    
    [self setData];
    
    self.lblTitle.font = Font_Size_Navigation_Title;
    self.lblFirstName.font = Font_Size_Product_Name_Regular;
    self.lblLastName.font = Font_Size_Product_Name_Regular;
    self.lblDateOfBirth.font = Font_Size_Product_Name_Regular;
    self.lblGender.font = Font_Size_Product_Name_Regular;
    self.lblMobileNumber.font = Font_Size_Product_Name_Regular;
    self.lblEmailId.font = Font_Size_Product_Name_Regular;

    self.txtFirstName.font = Font_Size_Product_Name_Regular;
    self.txtLastName.font = Font_Size_Product_Name_Regular;
    self.txtDateOfBirth.font = Font_Size_Product_Name_Regular;
    self.txtMobileNumber.font = Font_Size_Product_Name_Regular;
    self.txtEmailId.font = Font_Size_Product_Name_Regular;
    
    self.btnSave.titleLabel.font = Font_Size_Price_Sale_Bold;
    self.btnChangePass.titleLabel.font = Font_Size_Price_Sale_Bold;
    self.btnDeactivateAcct.titleLabel.font = Font_Size_Price_Sale_Bold;
    
    if (appDelegate.isRTL) {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);

        self.lblFirstName.textAlignment = NSTextAlignmentRight;
        self.lblLastName.textAlignment = NSTextAlignmentRight;
        self.lblDateOfBirth.textAlignment = NSTextAlignmentRight;
        self.lblMobileNumber.textAlignment = NSTextAlignmentRight;
        self.lblEmailId.textAlignment = NSTextAlignmentRight;
        self.lblGender.textAlignment = NSTextAlignmentRight;
        
        self.txtFirstName.textAlignment = NSTextAlignmentRight;
        self.txtLastName.textAlignment = NSTextAlignmentRight;
        self.txtDateOfBirth.textAlignment = NSTextAlignmentRight;
        self.txtMobileNumber.textAlignment = NSTextAlignmentRight;
        self.txtEmailId.textAlignment = NSTextAlignmentRight;
        
        self.btnChangePass.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.btnDeactivateAcct.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        self.imgArrowChangePass.frame = CGRectMake(self.view.frame.size.width - self.imgArrowChangePass.frame.size.width - 336*SCREEN_SIZE.width/375, self.imgArrowChangePass.frame.origin.y, self.imgArrowChangePass.frame.size.width, self.imgArrowChangePass.frame.size.height);
        self.imgArrowDeactivateAcct.frame = CGRectMake(self.view.frame.size.width - self.imgArrowDeactivateAcct.frame.size.width - 336*SCREEN_SIZE.width/375, self.imgArrowDeactivateAcct.frame.origin.y, self.imgArrowDeactivateAcct.frame.size.width, self.imgArrowDeactivateAcct.frame.size.height);
        
        self.imgArrowChangePass.transform = CGAffineTransformMakeRotation(M_PI);
        self.imgArrowDeactivateAcct.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
        
        self.lblFirstName.textAlignment = NSTextAlignmentLeft;
        self.lblLastName.textAlignment = NSTextAlignmentLeft;
        self.lblDateOfBirth.textAlignment = NSTextAlignmentLeft;
        self.lblMobileNumber.textAlignment = NSTextAlignmentLeft;
        self.lblEmailId.textAlignment = NSTextAlignmentLeft;
        self.lblGender.textAlignment = NSTextAlignmentLeft;
        
        self.txtFirstName.textAlignment = NSTextAlignmentLeft;
        self.txtLastName.textAlignment = NSTextAlignmentLeft;
        self.txtDateOfBirth.textAlignment = NSTextAlignmentLeft;
        self.txtMobileNumber.textAlignment = NSTextAlignmentLeft;
        self.txtEmailId.textAlignment = NSTextAlignmentLeft;
        
        self.btnChangePass.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.btnDeactivateAcct.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        self.imgArrowChangePass.frame = CGRectMake(336*SCREEN_SIZE.width/375, self.imgArrowChangePass.frame.origin.y, self.imgArrowChangePass.frame.size.width, self.imgArrowChangePass.frame.size.height);
        self.imgArrowDeactivateAcct.frame = CGRectMake(336*SCREEN_SIZE.width/375, self.imgArrowDeactivateAcct.frame.origin.y, self.imgArrowDeactivateAcct.frame.size.width, self.imgArrowDeactivateAcct.frame.size.height);
        
        self.imgArrowChangePass.transform = CGAffineTransformMakeRotation(0);
        self.imgArrowDeactivateAcct.transform = CGAffineTransformMakeRotation(0);
    }
    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

-(void) setData {
    pickerDOB = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [pickerDOB setDatePickerMode:UIDatePickerModeDate];
    [pickerDOB addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-8];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    
    pickerDOB.maximumDate = maxDate;
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    //add a done button on this toolbar
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:[MCLocalization stringForKey:@"Done"] style:UIBarButtonItemStyleDone target:self action:@selector(btnDonePickerClick)];
    [toolbar setItems:[[NSArray alloc] initWithObjects:doneButton, nil] animated:true];
    [self.txtDateOfBirth setInputAccessoryView:toolbar];

    self.txtDateOfBirth.inputView = pickerDOB;

    if (appDelegate.dictCustData.count > 0) {
        self.txtFirstName.text = [appDelegate.dictCustData valueForKey:@"first_name"];
        self.txtLastName.text = [appDelegate.dictCustData valueForKey:@"last_name"];
        self.txtEmailId.text = [appDelegate.dictCustData valueForKey:@"email"];
        
        NSString *strDOB = [[NSString alloc] init];
        NSString *strGender = [[NSString alloc] init];
        
        for (int i = 0; i < [[appDelegate.dictCustData valueForKey:@"meta_data"] count]; i++) {
            if ([[[[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"key"] lowercaseString] isEqualToString:@"mobile"]) {
                //set Mobile Number
                self.txtMobileNumber.text = [[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"value"];
            } else if ([[[[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"key"] lowercaseString] isEqualToString:@"dob"]) {
                //set DOB
                strDOB = [[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"value"];
                self.txtDateOfBirth.text = strDOB;
            } else if ([[[[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"key"] lowercaseString] isEqualToString:@"gender"]) {
                //set Gender
                strGender = [[[appDelegate.dictCustData valueForKey:@"meta_data"] objectAtIndex:i] valueForKey:@"value"];
            }
        }
        if ([[strGender lowercaseString] isEqualToString:@"male"]) {
            strSelectedGender = @"Male";
            self.imgMaleBGSelected.hidden = NO;
            self.imgFemaleBGSelected.hidden = YES;

            self.imgMaleBG.image = [UIImage imageNamed:@"AccountProfileBG"];
            self.imgFemaleBG.image = [UIImage imageNamed:@"AccountSettingManBG"];
            [Util setPrimaryColorImageView:self.imgMaleBG];
        } else {
            strSelectedGender = @"Female";
            self.imgMaleBGSelected.hidden = YES;
            self.imgFemaleBGSelected.hidden = NO;

            self.imgMaleBG.image = [UIImage imageNamed:@"AccountSettingManBG"];
            self.imgFemaleBG.image = [UIImage imageNamed:@"AccountProfileBG"];
            [Util setPrimaryColorImageView:self.imgFemaleBG];
        }

        if (strDOB == nil || [strDOB isEqualToString:@""]) { } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            NSDate *date  = [dateFormatter dateFromString:strDOB];
            [pickerDOB setDate:date];
        }
    }
}

-(void)btnDonePickerClick {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Convert to new Date Format
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    self.txtDateOfBirth.text = [dateFormatter stringFromDate:pickerDOB.date];
    [self.view endEditing:true];
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Convert to new Date Format
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    self.txtDateOfBirth.text = [dateFormatter stringFromDate:datePicker.date];
}

#pragma mark - Button Clicks
/*!
 * @discussion Will save the Information to server
 * @param sender For indentifying sender
 */
-(IBAction)btnSaveDataClicked:(id)sender {
    [self updateUserData];
}
/*!
 * @discussion For Male Gender Selection
 * @param sender For indentifying sender
 */
-(IBAction)btnMaleClicked:(id)sender {
    strSelectedGender = @"Male";
    self.imgMaleBGSelected.hidden = NO;
    self.imgFemaleBGSelected.hidden = YES;
    self.imgMaleBG.image = [UIImage imageNamed:@"AccountProfileBG"];
    self.imgFemaleBG.image = [UIImage imageNamed:@"AccountSettingManBG"];
    [Util setPrimaryColorImageView:self.imgMaleBG];
}

/*!
 * @discussion For Female Gender Selection
 * @param sender For indentifying sender
 */
-(IBAction)btnFemaleClicked:(id)sender {
    strSelectedGender = @"Female";
    self.imgMaleBGSelected.hidden = YES;
    self.imgFemaleBGSelected.hidden = NO;
    self.imgMaleBG.image = [UIImage imageNamed:@"AccountSettingManBG"];
    self.imgFemaleBG.image = [UIImage imageNamed:@"AccountProfileBG"];
    [Util setPrimaryColorImageView:self.imgFemaleBG];
}
/*!
 * @discussion To go previous page
 * @param sender For indentifying sender
 */
-(IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/*!
 * @discussion Will take you for Change Password
 * @param sender For indentifying sender
 */
-(IBAction)btnChangePasswordClicked:(id)sender {
    ChangePasswordVC *vc = [[ChangePasswordVC alloc] initWithNibName:@"ChangePasswordVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
/*!
 * @discussion Will take you to Deactivate Account
 * @param sender For indentifying sender
 */
-(IBAction)btnDeactivateAccountClicked:(id)sender {
    DeactivateAccountVC *vc = [[DeactivateAccountVC alloc] initWithNibName:@"DeactivateAccountVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - API calls
/*!
 * @discussion Webservice call for Updating UserData
 */
-(void) updateUserData {
    SHOW_LOADER_ANIMTION();
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[appDelegate.dictCustData mutableCopy]];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    [dict setValue:self.txtFirstName.text forKey:@"first_name"];
    [dict setValue:self.txtLastName.text forKey:@"last_name"];
    [dict setValue:self.txtDateOfBirth.text forKey:@"dob"];
    [dict setValue:self.txtMobileNumber.text forKey:@"mobile"];
    [dict setValue:strSelectedGender forKey:@"gender"];
    
    [CiyaShopAPISecurity updateCustomer:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
                
        if (success) {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"]) {
                ALERTVIEW([MCLocalization stringForKey:@"Information Updated Successfully"], self);
                appDelegate.dictCustData = [[NSMutableDictionary alloc] initWithDictionary:[dictionary mutableCopy]];
            } else if ([[dictionary valueForKey:@"status"] isEqualToString:@"error"]) {
                NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                NSAttributedString *decodedString;
                decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                 options:options
                                                      documentAttributes:NULL
                                                                   error:NULL];
                ALERTVIEW(decodedString.string, self);
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
    }];
}

#pragma mark - StatusBar Delegate
/*!
 * @discussion This method is used to set Status bar text color
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
