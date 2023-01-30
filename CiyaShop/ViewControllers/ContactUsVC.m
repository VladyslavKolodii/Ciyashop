//
//  ContactUsVC.m
//  QuickClick
//
//  Created by Kaushal PC on 15/09/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "ContactUsVC.h"
#import "SocialCell.h"
#import <MessageUI/MessageUI.h>

@interface ContactUsVC ()<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblContact;
@property (strong, nonatomic) IBOutlet UILabel *lblSubject;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblContactUsNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblFollowUs;
@property (strong, nonatomic) IBOutlet UILabel *lblContactUsEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblWhatsappNumber;


@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtContact;
@property (strong, nonatomic) IBOutlet UITextField *txtSubject;
@property (strong, nonatomic) IBOutlet UITextView *txtMessage;

@property (strong, nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwlast;
@property (strong, nonatomic) IBOutlet UIView *vwAllData;

@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UICollectionView *colSocial;
@property (strong, nonatomic) IBOutlet UIScrollView *scrl;

@property (strong, nonatomic) IBOutlet UIImageView *imgLogoContactUs;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhone;
@property (strong, nonatomic) IBOutlet UIImageView *imgLocation;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmail;
@property (strong, nonatomic) IBOutlet UIImageView *imgWhatsapp;

@end

@implementation ContactUsVC
{
    NSMutableArray *arrSocialKey, *arrSocialValues;
    UIView *vw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([Util getStringData:kAppNameImage] !=nil){
        
        [self.imgLogoContactUs sd_setImageWithURL:[Util EncodedURL:[Util getStringData:kAppNameImage]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image == nil)
            {
                self.imgLogoContactUs.image = [UIImage imageNamed:@"LogoContactUs"];
            }
            else
            {
                self.imgLogoContactUs.image = image;
            }
        }];
    }
    
    arrSocialKey = [[NSMutableArray alloc] initWithArray:[appDelegate.dictSocialData allKeys]];
    arrSocialValues = [[NSMutableArray alloc] init];
    
    NSMutableArray *arrkey = [[NSMutableArray alloc] init];
    NSMutableArray *arrValues = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrSocialKey.count; i++)
    {
        if (![[appDelegate.dictSocialData valueForKey:[arrSocialKey objectAtIndex:i]] isEqualToString:@""])
        {
            [arrkey addObject:[arrSocialKey objectAtIndex:i]];
            [arrValues addObject:[appDelegate.dictSocialData valueForKey:[arrSocialKey objectAtIndex:i]]];
        }
    }
    arrSocialKey = [[NSMutableArray alloc] initWithArray:arrkey];
    arrSocialValues = [[NSMutableArray alloc] initWithArray:arrValues];
    

    [self.colSocial registerNib:[UINib nibWithNibName:@"SocialCell" bundle:nil] forCellWithReuseIdentifier:@"SocialCell"];
    UICollectionViewFlowLayout *layout1 = (UICollectionViewFlowLayout *)[self.colSocial collectionViewLayout];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    
    self.lblContactUsNumber.text=appDelegate.strContactUsPhoneNumber;
       self.lblContactUsEmail.text=appDelegate.strContactUsEmail;
    self.lblAddress.text=appDelegate.strContactUsAddress;
    self.lblWhatsappNumber.text = appDelegate.strWhatsAppNumber;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.vwlast.frame.origin.y + self.vwlast.frame.size.height + 20);
    
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];

    [self.view addSubview:vw];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Util setHeaderColorView:vw];
    [self localize];

}
#pragma mark - Localize Language
/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)localize
{
    
    [Util setPrimaryColorImageView:self.imgPhone];
    [Util setPrimaryColorImageView:self.imgLocation];
    [Util setPrimaryColorImageView:self.imgEmail];
    [Util setPrimaryColorImageView:self.imgWhatsapp];
    
    self.lblTitle.text = [MCLocalization stringForKey:@"Contact Us"];
    self.lblTitle.textColor = OtherTitleColor;
    [Util setHeaderColorView:self.vwHeader];

    self.txtMessage.text = [MCLocalization stringForKey:@"Message"];
    self.txtMessage.textColor = [UIColor lightGrayColor];
    
    self.lblName.text = [MCLocalization stringForKey:@"Name"];
    self.lblEmail.text = [MCLocalization stringForKey:@"Email"];
    self.lblContact.text = [MCLocalization stringForKey:@"Contact Number"];
    self.lblSubject.text = [MCLocalization stringForKey:@"Subject"];
    self.lblMessage.text = [MCLocalization stringForKey:@"Message"];
    self.lblFollowUs.text = [MCLocalization stringForKey:@"Follow Us"];
    
    
    self.lblName.textColor = LightBlackColor;
    self.lblEmail.textColor = LightBlackColor;
    self.lblContact.textColor = LightBlackColor;
    self.lblSubject.textColor = LightBlackColor;
    self.lblMessage.textColor = LightBlackColor;
    self.lblFollowUs.textColor = LightBlackColor;
    
    
    
    self.txtName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Name"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Email"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtContact.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Contact Number"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtSubject.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Subject"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    
    [self.btnSend setTitle:[MCLocalization stringForKey:@"SEND"] forState:UIControlStateNormal];
    [Util setSecondaryColorButton:self.btnSend];
    
    self.lblTitle.font = Font_Size_Navigation_Title;
    
    self.lblName.font = Font_Size_Product_Name_Regular;
    self.lblEmail.font = Font_Size_Product_Name_Regular;
    self.lblContact.font = Font_Size_Product_Name_Regular;
    self.lblSubject.font = Font_Size_Product_Name_Regular;
    self.lblMessage.font = Font_Size_Product_Name_Regular;
    self.lblContactUsNumber.font = Font_Size_Title_Not_Bold;
    self.lblAddress.font = Font_Size_Title_Not_Bold;
    self.lblContactUsEmail.font = Font_Size_Title_Not_Bold;
    self.lblWhatsappNumber.font = Font_Size_Title_Not_Bold;


    self.lblFollowUs.font = Font_Size_Price_Sale_Bold;

    self.txtName.font = Font_Size_Product_Name_Regular;
    self.txtEmail.font = Font_Size_Product_Name_Regular;
    self.txtContact.font = Font_Size_Product_Name_Regular;
    self.txtSubject.font = Font_Size_Product_Name_Regular;
    self.txtMessage.font = Font_Size_Product_Name_Regular;
    
    self.btnSend.titleLabel.font = Font_Size_Price_Sale_Bold;
    
    if (appDelegate.isRTL)
    {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        
//        self.btnBack.backgroundColor = FontColorGray;
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);

        self.lblName.textAlignment = NSTextAlignmentRight;
        self.lblEmail.textAlignment = NSTextAlignmentRight;
        self.lblContact.textAlignment = NSTextAlignmentRight;
        self.lblSubject.textAlignment = NSTextAlignmentRight;
        self.lblMessage.textAlignment = NSTextAlignmentRight;
        
        self.txtName.textAlignment = NSTextAlignmentRight;
        self.txtEmail.textAlignment = NSTextAlignmentRight;
        self.txtContact.textAlignment = NSTextAlignmentRight;
        self.txtSubject.textAlignment = NSTextAlignmentRight;
        self.txtMessage.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //NonRTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
        
        self.lblName.textAlignment = NSTextAlignmentLeft;
        self.lblEmail.textAlignment = NSTextAlignmentLeft;
        self.lblContact.textAlignment = NSTextAlignmentLeft;
        self.lblSubject.textAlignment = NSTextAlignmentLeft;
        self.lblMessage.textAlignment = NSTextAlignmentLeft;
        
        self.txtName.textAlignment = NSTextAlignmentLeft;
        self.txtEmail.textAlignment = NSTextAlignmentLeft;
        self.txtContact.textAlignment = NSTextAlignmentLeft;
        self.txtSubject.textAlignment = NSTextAlignmentLeft;
        self.txtMessage.textAlignment = NSTextAlignmentLeft;
    }
}


#pragma mark - UitextView Delegate
/*!
 * @discussion Check for at the start of editing view Message is Empty or any Charcter Exist
 * @param textView For indentifying sender
 */
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([self.txtMessage.text isEqualToString:[MCLocalization stringForKey:@"Message"]] && [self.txtMessage.textColor isEqual:[UIColor lightGrayColor]])
    {
        self.txtMessage.text = @"";
        self.txtMessage.textColor = [UIColor blackColor];
    }
    return YES;
}
/*!
 * @discussion Check for at the End of editing view Message is Empty or any Charcter Exist
 * @param textView For indentifying sender
 */
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
/*!
 * @discussion Send A request for Cantacting the CiyaShop
 * @param sender For indentifying sender
 */
-(IBAction)btnSendClicked:(id)sender
{
    if (self.txtName.text.length > 0)
    {
        if (self.txtEmail.text.length > 0)
        {
            if ([Util ValidateEmailString:self.txtEmail.text])
            {
                if (self.txtSubject.text.length > 0)
                {
                    if([self.txtMessage.text isEqualToString:[MCLocalization stringForKey:@"Message"]] && [self.txtMessage.textColor isEqual:[UIColor lightGrayColor]])
                    {
                        ALERTVIEW([MCLocalization stringForKey:@"Please Enter Message"], self);
                    }
                    else
                    {
                        [self contactUs];
                    }
                }
                else
                {
                    ALERTVIEW([MCLocalization stringForKey:@"Enter Subject"], self);
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
/*!
 * @discussion will Take you to Previous page
 * @param sender For indentifying sender
 */
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/*!
 * @discussion will Open  call dialog
 * @param sender For indentifying sender
 */
-(IBAction)btnPhoneNumberClickClicked:(id)sender
{
    NSString *strNumber=[NSString stringWithFormat:@"tel://%@",self.lblContactUsNumber.text];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strNumber]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNumber] options:@{} completionHandler:nil];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNumber]];
    }
    else
    {
        NSLog(@"Phone Number not valid");
    }
}


/*!
 * @discussion will Open Email Compose dialog
 * @param sender For indentifying sender
 */
-(IBAction)btnEmailClicked:(id)sender
{
    if ([self.lblContactUsEmail.text isEqualToString:@""])
    {
        return;
    }
    NSString *emailTitle = appNAME;
    // Email Content
    NSString *messageBody = @"Contact us";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:self.lblContactUsEmail.text];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
 }
/*
 * @discussion will Email Compose delegate
 */
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/*!
 * @discussion will Open Whatsapp
 */
- (IBAction)btnWhatsappNumberClickClicked:(id)sender {
    NSLog(@"Whatsapp");
    if ([appDelegate.strWhatsAppNumber isEqualToString:@""]) {
        return;
    }
    NSString *whatsappUrl1 = appDelegate.strWhatsAppNumber;
    if (![whatsappUrl1 containsString:@"+"])
    {
        whatsappUrl1 = [NSString stringWithFormat:@"%@%@", MOBILE_COUNTRY_CODE, whatsappUrl1];
    }
    if ([whatsappUrl1 isEqualToString:@""]) {
        return;
    }
    NSString *whatsappUrl2 = @"&text=";
    NSString *whatsappUrl3 = appURL;
    whatsappUrl3 = (NSString *) CFBridgingRelease (CFURLCreateStringByAddingPercentEscapes (NULL, (CFStringRef) whatsappUrl3, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));

    NSString *formattedString = [NSString stringWithFormat:@"whatsapp://send?phone=%@%@%@", whatsappUrl1, whatsappUrl2, whatsappUrl3];
    NSLog(@"%@", formattedString);
    
    NSURL *whatsappURL = [NSURL URLWithString: formattedString];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
//        [[UIApplication sharedApplication] openURL: whatsappURL];
        [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:nil];
    }
    else {
        ALERTVIEW([MCLocalization stringForKey:@"WhatsApp is not installed on your device."], appDelegate.window.rootViewController);
    }
}



#pragma mark - API calls
/*!
 * @discussion webservice call for Submiting request for Cantact the CiyaShop
 */
-(void)contactUs
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.txtName.text forKey:@"name"];
    [dict setValue:self.txtEmail.text forKey:@"email"];
    [dict setValue:self.txtSubject.text forKey:@"subject"];
    [dict setValue:self.txtContact.text forKey:@"contact_no"];
    [dict setValue:self.txtMessage.text forKey:@"message"];
    
    [CiyaShopAPISecurity contactUs:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        if (success)
        {
            HIDE_PROGRESS;
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                //done
                self.txtName.text = @"";
                self.txtEmail.text = @"";
                self.txtSubject.text = @"";
                self.txtContact.text = @"";
                self.txtMessage.textColor = [UIColor lightGrayColor];
                self.txtMessage.text = [MCLocalization stringForKey:@"Message"];
                
                ALERTVIEW([MCLocalization stringForKey:@"Message Sent"], self);
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

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrSocialValues.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SocialCell";
    
    SocialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SocialCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if ([[[arrSocialKey objectAtIndex:indexPath.row] lowercaseString] isEqualToString:@"facebook"])
    {
        cell.img.image = [UIImage imageNamed:@"iconFBContactUs"];
    }
    else if ([[[arrSocialKey objectAtIndex:indexPath.row] lowercaseString] isEqualToString:@"google_plus"])
    {
        cell.img.image = [UIImage imageNamed:@"iconGoogleContactUs"];
    }
    else if ([[[arrSocialKey objectAtIndex:indexPath.row] lowercaseString] isEqualToString:@"linkedin"])
    {
        cell.img.image = [UIImage imageNamed:@"iconLinkedInContactUs"];
    }
    else if ([[[arrSocialKey objectAtIndex:indexPath.row] lowercaseString] isEqualToString:@"pinterest"])
    {
        cell.img.image = [UIImage imageNamed:@"iconPintrestContactUs"];
    }
    else if ([[[arrSocialKey objectAtIndex:indexPath.row] lowercaseString] isEqualToString:@"twitter"])
    {
        cell.img.image = [UIImage imageNamed:@"iconTwitterContactUs"];
    }
    else if ([[[arrSocialKey objectAtIndex:indexPath.row] lowercaseString] isEqualToString:@"instagram"])
    {
        cell.img.image = [UIImage imageNamed:@"iconInstaContactUs"];
    }
    [Util setPrimaryColorImageView:cell.img];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strUrl = [arrSocialValues objectAtIndex:indexPath.row];
    NSURL *_url = [Util EncodedURL:strUrl];
    [[UIApplication sharedApplication] openURL:_url options:@{} completionHandler:nil];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 6.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat totalCellWidth = (collectionView.frame.size.height + 6) * arrSocialValues.count;
    CGFloat totalSpacingWidth = 3 * (arrSocialValues.count - 1);
    CGFloat leftInset = (collectionView.bounds.size.width - (totalCellWidth + totalSpacingWidth)) / 2;
    CGFloat rightInset = leftInset;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, leftInset, 0, rightInset);
    return sectionInset;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
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
