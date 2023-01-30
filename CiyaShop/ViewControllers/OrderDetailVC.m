//
//  OrderDetailVC.m
//  QuickClick
//
//  Created by Kaushal PC on 02/08/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "OrderDetailVC.h"
#import "MyOrderDetailCell.h"

@interface OrderDetailVC ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrl;

@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwInformation;
@property (strong, nonatomic) IBOutlet UIView *vwCustomerDetail;
@property (strong, nonatomic) IBOutlet UIView *vwShipAddress;
@property (strong, nonatomic) IBOutlet UIView *vwBillAddress;
@property (strong, nonatomic) IBOutlet UIView *vwLast;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderId;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblCustomerDetail;

@property (strong, nonatomic) IBOutlet UILabel *lblShippingAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblShipCompany;
@property (strong, nonatomic) IBOutlet UILabel *lblShipName;
@property (strong, nonatomic) IBOutlet UILabel *lblShipAddress1;
@property (strong, nonatomic) IBOutlet UILabel *lblShipAddress2;
@property (strong, nonatomic) IBOutlet UILabel *lblShipCityPin;
@property (strong, nonatomic) IBOutlet UILabel *lblShipStateCountry;

@property (strong, nonatomic) IBOutlet UILabel *lblBillingAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblBillCompany;
@property (strong, nonatomic) IBOutlet UILabel *lblBillName;
@property (strong, nonatomic) IBOutlet UILabel *lblBillAddress1;
@property (strong, nonatomic) IBOutlet UILabel *lblBillAddress2;
@property (strong, nonatomic) IBOutlet UILabel *lblBillCityPin;
@property (strong, nonatomic) IBOutlet UILabel *lblBillStateCountry;

@property (strong, nonatomic) IBOutlet UILabel *lblEmailTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;

@property (strong, nonatomic) IBOutlet UIView *vwCancelOrder;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelOrder;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UITableView *tblOrderDetail;

@property (strong,nonatomic) IBOutlet UIView *vwAllData;
@property (strong,nonatomic) IBOutlet UIView *vwTrackOrder;

@property (strong, nonatomic) IBOutlet UILabel *lblTrackOrderDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblTrackOrderContent;
@property (strong, nonatomic) IBOutlet UIButton *btnTrack;

@end

@implementation OrderDetailVC
{
    NSString *currencySymbol;
    UIView *vw;
}
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *orderID = [[self.dictMyOrderData valueForKey:@"id"] stringValue];
    NSString *strOrder = [NSString stringWithFormat:@"%@ #%@", [MCLocalization stringForKey:@"Order"], orderID];
    
    NSMutableAttributedString * attrStr1 = [[NSMutableAttributedString alloc] initWithData:[strOrder dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType } documentAttributes:nil error:nil];
    
    
    [attrStr1 addAttribute:NSForegroundColorAttributeName value:FontColorGray range:NSMakeRange(0, attrStr1.length)];//TextColor
    [attrStr1 addAttribute:NSFontAttributeName value:Font_Size_Big_Title range:NSMakeRange(0, attrStr1.length)];
    [attrStr1 addAttribute:NSForegroundColorAttributeName value:[Util colorWithHexString:[Util getStringData:kPrimaryColor]] range:NSMakeRange([[MCLocalization stringForKey:@"Order"] length] + 1, orderID.length + 1)];//TextColor
    [attrStr1 addAttribute:NSFontAttributeName value:Font_Size_Big_Title range:NSMakeRange([[MCLocalization stringForKey:@"Order"] length] + 1, orderID.length + 1)];

    self.lblOrderId.attributedText = attrStr1;
    
    NSString *strTime = [self.dictMyOrderData valueForKey:@"date_created_gmt"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale1];
    NSDate *dateFromString = [dateFormatter dateFromString:strTime];
    
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:dateFromString];

    NSString * htmlString = [NSString stringWithFormat:@"%@ #%@ %@ %@ %@ %@.", [MCLocalization stringForKey:@"Order"], orderID, [MCLocalization stringForKey:@"was placed on"], timestamp, [MCLocalization stringForKey:@"and is currently"], [[self.dictMyOrderData valueForKey:@"status"] capitalizedString]];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType } documentAttributes:nil error:nil];
    
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:FontColorGray range:NSMakeRange(0, attrStr.length)];//TextColor
    [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Bold range:NSMakeRange(0, attrStr.length)];

    NSUInteger location = [attrStr.string rangeOfString:[NSString stringWithFormat:@"%@ ",[MCLocalization stringForKey:@"Order"]]].location + [[MCLocalization stringForKey:@"Order"] length] + 1;
    [attrStr addAttribute:NSForegroundColorAttributeName value:[Util colorWithHexString:[Util getStringData:kPrimaryColor]] range:NSMakeRange(location, orderID.length + 1)];//TextColor
    [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes range:NSMakeRange(location, orderID.length + 1)];
    
    location = [attrStr.string rangeOfString:[MCLocalization stringForKey:@"was placed on"]].location + [[MCLocalization stringForKey:@"was placed on"] length] + 1;
    [attrStr addAttribute:NSForegroundColorAttributeName value:[Util colorWithHexString:[Util getStringData:kPrimaryColor]] range:NSMakeRange(location, timestamp.length)];
    [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes range:NSMakeRange(location, timestamp.length)];
    
    location = [attrStr.string rangeOfString:[MCLocalization stringForKey:@"and is currently"]].location + [[MCLocalization stringForKey:@"and is currently"] length] + 1;
    [attrStr addAttribute:NSForegroundColorAttributeName value:[Util colorWithHexString:[Util getStringData:kPrimaryColor]] range:NSMakeRange(location, [[self.dictMyOrderData valueForKey:@"status"] length])];//TextColor
    [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes range:NSMakeRange(location, [[self.dictMyOrderData valueForKey:@"status"] length])];
    
    
    self.lblOrderStatus.attributedText = attrStr;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    NSString *currencyCode = [self.dictMyOrderData valueForKey:@"currency"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currencyCode];
    currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
    NSLog(@"Currency Symbol : %@", currencySymbol);
    
    if([[[self.dictMyOrderData valueForKey:@"status"] lowercaseString] isEqualToString:@"on-hold"] || [[[self.dictMyOrderData valueForKey:@"status"] lowercaseString] isEqualToString:@"pending"])
    {
        [self.btnCancelOrder setUserInteractionEnabled:YES];
        self.btnCancelOrder.alpha = 1.0;
    }
    else
    {
        [self.btnCancelOrder setUserInteractionEnabled:NO];
        self.btnCancelOrder.alpha = 0.6;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self localize];
    [Util setHeaderColorView:vw];

    //shadow to cell
    
    self.vwCancelOrder.layer.shadowColor = [UIColor blackColor].CGColor;
    self.vwCancelOrder.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.vwCancelOrder.layer.shadowRadius = 1.0f;
    self.vwCancelOrder.layer.shadowOpacity = 0.5f;
    self.vwCancelOrder.layer.masksToBounds = NO;
    self.vwCancelOrder.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.vwCancelOrder.bounds cornerRadius:self.vwCancelOrder.layer.cornerRadius].CGPath;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.vwInformation.layer.borderColor = FontColorGray.CGColor;
    self.vwInformation.layer.borderWidth = 0.5f;
    self.vwCustomerDetail.layer.borderColor = FontColorGray.CGColor;
    self.vwCustomerDetail.layer.borderWidth = 0.5f;

    self.lblEmail.text = [[self.dictMyOrderData valueForKey:@"billing"] valueForKey:@"email"];
    self.lblPhone.text = [[self.dictMyOrderData valueForKey:@"billing"] valueForKey:@"phone"];
    
    
    self.lblBillCompany.text = [[self.dictMyOrderData valueForKey:@"billing"] valueForKey:@"company"];
    
    self.lblBillName.text = [NSString stringWithFormat:@"%@ %@", [[[self.dictMyOrderData valueForKey:@"billing"] valueForKey:@"first_name"] capitalizedString], [[[self.dictMyOrderData valueForKey:@"billing"] valueForKey:@"last_name"] capitalizedString]];
    self.lblBillAddress1.text = [[self.dictMyOrderData valueForKey:@"billing"] valueForKey:@"address_1"];
    self.lblBillAddress2.text = [[self.dictMyOrderData valueForKey:@"billing"] valueForKey:@"address_2"];
    self.lblBillCityPin.text = [NSString stringWithFormat:@"%@ - %@.", [[[self.dictMyOrderData valueForKey:@"billing"] valueForKey:@"city"] capitalizedString], [[self.dictMyOrderData valueForKey:@"billing"] valueForKey:@"postcode"]];
    
    NSString *countryName = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:[[self.dictMyOrderData valueForKey:@"billing"] valueForKey:@"country"]];
    NSString *stateName = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:[[self.dictMyOrderData valueForKey:@"billing"] valueForKey:@"state"]];
    
    if (stateName == nil || stateName == NULL || [stateName isEqualToString:@""])
    {
        self.lblBillStateCountry.text = [NSString stringWithFormat:@"%@.", countryName];
    }
    else if (countryName == nil || countryName == NULL || [countryName isEqualToString:@""])
    {
        self.lblBillStateCountry.text = [NSString stringWithFormat:@"%@.", stateName];
    }
    else
    {
        self.lblBillStateCountry.text = [NSString stringWithFormat:@"%@, %@.", stateName, countryName];
    }
    
    self.lblShipCompany.text = [[self.dictMyOrderData valueForKey:@"shipping"] valueForKey:@"company"];
    self.lblShipName.text = [NSString stringWithFormat:@"%@ %@", [[[self.dictMyOrderData valueForKey:@"shipping"] valueForKey:@"first_name"] capitalizedString], [[[self.dictMyOrderData valueForKey:@"shipping"] valueForKey:@"last_name"] capitalizedString]];
    self.lblShipAddress1.text = [[self.dictMyOrderData valueForKey:@"shipping"] valueForKey:@"address_1"];
    self.lblShipAddress2.text = [[self.dictMyOrderData valueForKey:@"shipping"] valueForKey:@"address_2"];
    self.lblShipCityPin.text = [NSString stringWithFormat:@"%@ - %@.", [[[self.dictMyOrderData valueForKey:@"shipping"] valueForKey:@"city"] capitalizedString], [[self.dictMyOrderData valueForKey:@"shipping"] valueForKey:@"postcode"]];
    
    NSString *countryName1 = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:[[self.dictMyOrderData valueForKey:@"shipping"] valueForKey:@"country"]];
    NSString *stateName1 = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:[[self.dictMyOrderData valueForKey:@"shipping"] valueForKey:@"state"]];

    if (stateName1 == nil || stateName1 == NULL || [stateName1 isEqualToString:@""])
    {
        if (countryName1 == nil || countryName1 == NULL || [countryName1 isEqualToString:@""]) {
            self.lblShipStateCountry.text = @"";
        } else {
            self.lblShipStateCountry.text = [NSString stringWithFormat:@"%@.", countryName1];
        }
    }
    else if (countryName1 == nil || countryName1 == NULL || [countryName1 isEqualToString:@""])
    {
        self.lblShipStateCountry.text = [NSString stringWithFormat:@"%@.", stateName1];
    }
    else
    {
        self.lblShipStateCountry.text = [NSString stringWithFormat:@"%@, %@.", stateName1, countryName1];
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[self.dictMyOrderData valueForKey:@"order_tracking_data"]];
    if (arr.count > 0 && appDelegate.isOrderTrackingActive) {
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[arr objectAtIndex:0]];
        
        NSNumber* trackActive = [dict valueForKey:@"use_track_button"];
        if ([trackActive boolValue] == false) {
            //set button disable
            self.btnTrack.userInteractionEnabled = false;
        } else {
            self.btnTrack.userInteractionEnabled = true;
        }
        self.lblTrackOrderDesc.text = [dict valueForKey:@"track_message_1"];
        [self.lblTrackOrderContent sizeToFit];
        [self.btnTrack setTitle:[dict valueForKey:@"track_message_2"] forState:UIControlStateNormal];
        [self.btnTrack sizeToFit];
        
        if (appDelegate.isRTL)
        {
            //rtl
            self.lblTrackOrderDesc.textAlignment = NSTextAlignmentRight;
            
            self.lblTrackOrderContent.frame = CGRectMake(SCREEN_SIZE.width - self.lblTrackOrderContent.frame.origin.x - self.lblTrackOrderContent.frame.size.width, self.lblTrackOrderContent.frame.origin.y, self.lblTrackOrderContent.frame.size.width, self.lblTrackOrderContent.frame.size.height);

            float yPos = self.lblTrackOrderContent.frame.origin.y - (self.btnTrack.frame.size.height/2) + (self.lblTrackOrderContent.frame.size.height/2);
            
            self.btnTrack.frame = CGRectMake(self.lblTrackOrderContent.frame.origin.x - self.btnTrack.frame.size.width - 8, yPos, self.btnTrack.frame.size.width, self.btnTrack.frame.size.height);
            
            self.tblOrderDetail.frame = CGRectMake(self.tblOrderDetail.frame.origin.x, self.tblOrderDetail.frame.origin.y, self.tblOrderDetail.frame.size.width, self.tblOrderDetail.contentSize.height);
        }
        else
        {
            float yPos = self.lblTrackOrderContent.frame.origin.y + (self.lblTrackOrderContent.frame.size.height/2) - (self.btnTrack.frame.size.height/2);
            self.btnTrack.frame = CGRectMake(self.lblTrackOrderContent.frame.origin.x + self.lblTrackOrderContent.frame.size.width + 8, yPos, self.btnTrack.frame.size.width, self.btnTrack.frame.size.height);
            
            self.tblOrderDetail.frame = CGRectMake(self.tblOrderDetail.frame.origin.x, self.tblOrderDetail.frame.origin.y, self.tblOrderDetail.frame.size.width, self.tblOrderDetail.contentSize.height);
        }
        self.vwTrackOrder.hidden = NO;
    }
    else
    {
        self.vwTrackOrder.hidden = YES;
        self.lblOrderDetail.frame = CGRectMake(self.lblOrderDetail.frame.origin.x, self.vwTrackOrder.frame.origin.y, self.lblOrderDetail.frame.size.width, self.lblOrderDetail.frame.size.height);
        self.tblOrderDetail.frame = CGRectMake(self.tblOrderDetail.frame.origin.x, self.vwTrackOrder.frame.origin.y + self.lblOrderDetail.frame.size.height + 15, self.tblOrderDetail.frame.size.width, self.tblOrderDetail.contentSize.height);
    }
    self.vwLast.frame = CGRectMake(0, self.tblOrderDetail.frame.origin.y + self.tblOrderDetail.frame.size.height + 2, SCREEN_SIZE.width, self.vwLast.frame.size.height);
    
    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.vwLast.frame.origin.y + self.vwLast.frame.size.height);
    
    
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Localize Language

- (void)localize
{
    [Util setSecondaryColorButton:self.btnCancelOrder];
    [Util setPrimaryColorButtonTitle:self.btnTrack];
    
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.textColor = OtherTitleColor;
    self.lblTitle.text = [MCLocalization stringForKey:@"MY ORDERS"];
    
    [self.btnCancelOrder setTitle:[MCLocalization stringForKey:@"CANCEL ORDER"] forState:UIControlStateNormal];
    
    self.lblTrackOrderContent.text = [MCLocalization stringForKey:@"Tracking number is"];
    self.lblEmailTitle.text = [MCLocalization stringForKey:@"Email"];
    self.lblPhoneTitle.text = [MCLocalization stringForKey:@"Phone"];
    self.lblOrderDetail.text = [MCLocalization stringForKey:@"Order Detail"];
    self.lblCustomerDetail.text = [MCLocalization stringForKey:@"Customer Detail"];
    self.lblShippingAddress.text = [MCLocalization stringForKey:@"Shipping Address"];
    self.lblBillingAddress.text = [MCLocalization stringForKey:@"Billing Address"];
    
    self.lblTitle.font = Font_Size_Navigation_Title;
    
    self.lblOrderDetail.font = Font_Size_Big_Title;
    self.lblCustomerDetail.font = Font_Size_Big_Title;
    self.lblEmailTitle.font = Font_Size_Product_Name;
    self.lblEmail.font = Font_Size_Product_Name_Regular;
    self.lblPhoneTitle.font = Font_Size_Product_Name;
    self.lblPhone.font = Font_Size_Product_Name_Regular;

    self.lblBillingAddress.font = Font_Size_Product_Name;
    self.lblBillCompany.font = Font_Size_Product_Name_Regular;
    self.lblBillName.font = Font_Size_Product_Name_Regular;
    self.lblBillAddress1.font = Font_Size_Product_Name_Regular;
    self.lblBillAddress2.font = Font_Size_Product_Name_Regular;
    self.lblBillStateCountry.font = Font_Size_Product_Name_Regular;
    self.lblBillCityPin.font = Font_Size_Product_Name_Regular;

    self.lblShippingAddress.font = Font_Size_Product_Name;
    self.lblShipCompany.font = Font_Size_Product_Name_Regular;
    self.lblShipName.font = Font_Size_Product_Name_Regular;
    self.lblShipAddress1.font = Font_Size_Product_Name_Regular;
    self.lblShipAddress2.font = Font_Size_Product_Name_Regular;
    self.lblShipStateCountry.font = Font_Size_Product_Name_Regular;
    self.lblShipCityPin.font = Font_Size_Product_Name_Regular;
    
    self.btnCancelOrder.titleLabel.font = Font_Size_Price_Sale_Yes_Bold;
    
    if (appDelegate.isRTL)
    {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.tblOrderDetail setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.lblOrderStatus.textAlignment = NSTextAlignmentRight;
        
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        
    } else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.tblOrderDetail setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }
    
    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

#pragma mark - Button Clicks

-(IBAction)btnTrackClicked:(id)sender
{
    //track order
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[self.dictMyOrderData valueForKey:@"order_tracking_data"]];
    if (arr.count > 0 && appDelegate.isOrderTrackingActive)
    {
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[arr objectAtIndex:0]];
        NSString *strURL = [dict valueForKey:@"order_tracking_link"];
        NSURL *_url = [Util EncodedURL:strURL];
        [[UIApplication sharedApplication] openURL:_url options:@{} completionHandler:nil];
    }
}

-(IBAction)btnCancelOrderClicked:(id)sender
{
    [self cancelOrder];
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dictMyOrderData valueForKey:@"line_items"] count] + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MyOrderDetailCell";
    
    MyOrderDetailCell *cell = (MyOrderDetailCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyOrderDetailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.row == 0)
    {
        cell.lblTitle.text = [MCLocalization stringForKey:@"Product"];
        cell.lblRate.text = [MCLocalization stringForKey:@"Total"];
        
        [cell.lblTitle setFont:Font_Size_Price_Sale_Bold];
        [cell.lblRate setFont:Font_Size_Price_Sale_Bold];
    }
    else if (indexPath.row == [[self.dictMyOrderData valueForKey:@"line_items"] count] + 1)
    {
        cell.lblTitle.text = [MCLocalization stringForKey:@"Subtotal"];
        float price = 0;
        for (int i = 0; i < [[self.dictMyOrderData valueForKey:@"line_items"] count]; i++)
        {
            price = price + [[[[self.dictMyOrderData valueForKey:@"line_items"] objectAtIndex:i] valueForKey:@"subtotal"] doubleValue];
        }
        cell.lblRate.text = [NSString stringWithFormat:@"%@ %.2f", currencySymbol, price];
        [cell.lblTitle setFont:Font_Size_Price_Sale_Bold];
        [cell.lblRate setFont:Font_Size_Price_Sale_Bold];
    }
    else if (indexPath.row == [[self.dictMyOrderData valueForKey:@"line_items"] count] + 2)
    {
        cell.lblTitle.text = [MCLocalization stringForKey:@"Shipping"];
        cell.lblRate.text = [NSString stringWithFormat:@"%@ %@", currencySymbol,[self.dictMyOrderData valueForKey:@"shipping_total"]];
        [cell.lblTitle setFont:Font_Size_Price_Sale_Bold];
        [cell.lblRate setFont:Font_Size_Price_Sale_Bold];
    }
    else if (indexPath.row == [[self.dictMyOrderData valueForKey:@"line_items"] count] + 3)
    {
        cell.lblTitle.text = [MCLocalization stringForKey:@"Payment Method"];
        cell.lblRate.text = [[self.dictMyOrderData valueForKey:@"payment_method_title"] capitalizedString];
        [cell.lblTitle setFont:Font_Size_Price_Sale_Bold];
        [cell.lblRate setFont:Font_Size_Price_Sale_Bold];
    }
    else if (indexPath.row == [[self.dictMyOrderData valueForKey:@"line_items"] count] + 4)
    {
        cell.lblTitle.text = [MCLocalization stringForKey:@"Total"];
        
        cell.lblRate.text = [NSString stringWithFormat:@"%@ %@", currencySymbol,[self.dictMyOrderData valueForKey:@"total"]];
        [cell.lblTitle setFont:Font_Size_Price_Sale_Bold];
        [cell.lblRate setFont:Font_Size_Price_Sale_Bold];
    }
    else
    {
        NSString *qty = [[[self.dictMyOrderData valueForKey:@"line_items"] objectAtIndex:indexPath.row - 1] valueForKey:@"quantity"];
        
        NSString *str = [NSString stringWithFormat:@"%@ X %@", [[[self.dictMyOrderData valueForKey:@"line_items"] objectAtIndex:indexPath.row - 1] valueForKey:@"name"], qty];
        
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType } documentAttributes:nil error:nil];

        
        NSUInteger location = [attrStr.string rangeOfString:[NSString stringWithFormat:@" X %@", qty]].location;
        [attrStr addAttribute:NSForegroundColorAttributeName value:[Util colorWithHexString:[Util getStringData:kPrimaryColor]] range:NSMakeRange(0, location)];//TextColor

        cell.lblTitle.attributedText = attrStr;
        
        cell.lblRate.text = [NSString stringWithFormat:@"%@ %@", currencySymbol, [[[self.dictMyOrderData valueForKey:@"line_items"] objectAtIndex:indexPath.row - 1] valueForKey:@"total"]];
        
        cell.lblRate.font = Font_Size_Product_Name_Regular;
        cell.lblTitle.font = Font_Size_Product_Name_Regular;
    }
    
    if(appDelegate.isRTL)
    {
        //RTL
        cell.lblTitle.textAlignment = NSTextAlignmentRight;
        cell.lblRate.textAlignment = NSTextAlignmentRight;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Rate&MyOrderDetailCell";
    
    MyOrderDetailCell *cell = (MyOrderDetailCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyOrderDetailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    if (indexPath.row == 0 || indexPath.row == [[self.dictMyOrderData valueForKey:@"line_items"] count] + 1 || indexPath.row == [[self.dictMyOrderData valueForKey:@"line_items"] count] + 2 || indexPath.row == [[self.dictMyOrderData valueForKey:@"line_items"] count] + 3 || indexPath.row == [[self.dictMyOrderData valueForKey:@"line_items"] count] + 4)
    {
        return 50;
    }
    else
    {
        NSString *str = [[[self.dictMyOrderData valueForKey:@"line_items"] objectAtIndex:indexPath.row - 1] valueForKey:@"name"];
        NSString *qty = [[[self.dictMyOrderData valueForKey:@"line_items"] objectAtIndex:indexPath.row - 1] valueForKey:@"quantity"];
        
        cell.lblTitle.text = [NSString stringWithFormat:@"%@ X %@", str, qty];
        [cell.lblTitle sizeToFit];
        
        return cell.lblTitle.frame.size.height + 16;
    }
}

#pragma mark - API calls

-(void)cancelOrder
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[self.dictMyOrderData valueForKey:@"id"] stringValue] forKey:@"order"];
    
    [CiyaShopAPISecurity cancelOrder:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        if (success)
        {
            HIDE_PROGRESS;
            if ([[[dictionary valueForKey:@"result"] lowercaseString] isEqualToString:@"fail"])
            {
                [Util showNegativeMessage:@"Order is On-hold or Pending."];
            }
            else
            {
                if (self->delegate)
                {
                    [self->delegate updateOrderDetail];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                [Util showPositiveMessage:@"Order Cancelled Successfully."];
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

#pragma mark - hide bottomBar

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
