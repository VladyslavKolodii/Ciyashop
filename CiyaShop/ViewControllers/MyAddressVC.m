//
//  MyAddressVC.m
//  QuickClick
//
//  Created by Kaushal PC on 02/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "MyAddressVC.h"
#import "MyAddressCell.h"
#import "AddNewAddressVC.h"

@interface MyAddressVC ()

@property (strong,nonatomic) IBOutlet UIView *vwHeader;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSavedAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnAddAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UITableView *tblAddresses;

@property (strong,nonatomic) IBOutlet UIView *vwAllData;

@end

@implementation MyAddressVC
{
    NSMutableDictionary *dictCustomer;
    UIView *vw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Util setHeaderColorView:vw];

    [self.tblAddresses reloadData];
    [self localize];
}

- (void)didReceiveMemoryWarning
{
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

#pragma mark - Localize Language

- (void)localize
{
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.textColor = OtherTitleColor;
    [Util setPrimaryColorButtonTitle:self.btnAddAddress];

    if (appDelegate.dictCustData == nil || [appDelegate.dictCustData count] == 0)
    {
        self.lblSavedAddress.text = [NSString stringWithFormat:@"0 %@", [MCLocalization stringForKey:@"SAVED ADDRESSES"]];
    }
    else
    {
        self.lblSavedAddress.text = [NSString stringWithFormat:@"2 %@", [MCLocalization stringForKey:@"SAVED ADDRESSES"]];
    }

    self.lblTitle.text = [MCLocalization stringForKey:@"My Addresses"];
    
    [self.btnAddAddress setTitle:[MCLocalization stringForKey:@"ADD NEW ADDRESS"] forState:UIControlStateNormal];
    self.btnAddAddress.hidden = YES;
    
    [self.tblAddresses reloadData];
    
    self.lblTitle.font = Font_Size_Navigation_Title;
    self.lblSavedAddress.font = Font_Size_Product_Name_Regular;
    
    if (appDelegate.isRTL) {
        [self.tblAddresses setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        [self.tblAddresses setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }
    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}


#pragma mark - Button Clicks

-(IBAction)btnAddNewAddress:(id)sender
{
    AddNewAddressVC *vc = [[AddNewAddressVC alloc] initWithNibName:@"AddNewAddressVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnAddAddressClicked:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblAddresses];
    NSIndexPath *indexPath = [self.tblAddresses indexPathForRowAtPoint:buttonPosition];

    if (indexPath.row == 0)
    {
        //billing address
        AddNewAddressVC *vc = [[AddNewAddressVC alloc] initWithNibName:@"AddNewAddressVC" bundle:nil];
        vc.from = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 1)
    {
        //Shipping address
        AddNewAddressVC *vc = [[AddNewAddressVC alloc] initWithNibName:@"AddNewAddressVC" bundle:nil];
        vc.from = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)btnRemoveAddressClicked:(UIButton *)sender
{
    //Remove Address
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblAddresses];
    NSIndexPath *indexPath = [self.tblAddresses indexPathForRowAtPoint:buttonPosition];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dictAddress = [[NSMutableDictionary alloc] init];
    [dictAddress setValue:@"" forKey:@"address_1"];
    [dictAddress setValue:@"" forKey:@"address_2"];
    [dictAddress setValue:@"" forKey:@"city"];
    [dictAddress setValue:@"" forKey:@"company"];
    [dictAddress setValue:@"" forKey:@"country"];
    [dictAddress setValue:@"" forKey:@"first_name"];
    [dictAddress setValue:@"" forKey:@"last_name"];
    [dictAddress setValue:@"" forKey:@"postcode"];
    [dictAddress setValue:@"" forKey:@"state"];
    
    NSString *key = [[NSString alloc] init];
    if (indexPath.row == 0)
    {
        //billing Address Remove
        [dictAddress setValue:@"" forKey:@"phone"];
        key = @"billing";
    }
    else if (indexPath.row == 1)
    {
        //billing Address Remove
        key = @"shipping";
    }
    [dict setValue:dictAddress forKey:key];
    
    [self updateCustomerData:dict];
}

-(void)btnEditAddressClicked:(UIButton *)sender
{
    //Edit Address
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblAddresses];
    NSIndexPath *indexPath = [self.tblAddresses indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath.row == 0)
    {
        //billing address
        AddNewAddressVC *vc = [[AddNewAddressVC alloc] initWithNibName:@"AddNewAddressVC" bundle:nil];
        vc.dictCustomerDetail = [[NSMutableDictionary alloc] initWithDictionary:appDelegate.dictCustData];
        vc.from = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 1)
    {
        //Shipping address
        AddNewAddressVC *vc = [[AddNewAddressVC alloc] initWithNibName:@"AddNewAddressVC" bundle:nil];
        vc.dictCustomerDetail = [[NSMutableDictionary alloc] initWithDictionary:appDelegate.dictCustData];
        vc.from = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MyAddressCell";
    
    MyAddressCell *cell = (MyAddressCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyAddressCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblAddressTitle.font = Font_Size_Price_Sale_Bold;
    cell.lblAddAddress.font = Font_Size_Price_Sale_Bold;
    cell.btnAddAddress.titleLabel.font = Font_Size_Price_Sale_Bold;
    cell.lblName.font = Font_Size_Product_Name;
    cell.lblPhoneNumberTitle.font = Font_Size_Product_Name_Small_Regular;
    cell.lblPhoneNumber.font = Font_Size_Product_Name_Small_Regular;
    cell.lblAddress.font = Font_Size_Product_Name_Small_Regular;
    
    cell.btnEdit.titleLabel.font = Font_Size_Product_Name;
    cell.btnRemove.titleLabel.font = Font_Size_Product_Name;
    
    cell.lblAddAddress.text = [MCLocalization stringForKey:@"Please Add Address"];
    [cell.btnAddAddress setTitle:[MCLocalization stringForKey:@"ADD"] forState:UIControlStateNormal];
    
    if (appDelegate.dictCustData == nil || [appDelegate.dictCustData count] == 0)
    {
        cell.vwNoAddress.hidden = NO;
    }
    else
    {
        if (indexPath.row == 0)
        {
            //Billing Address
            cell.lblAddressTitle.text = [MCLocalization stringForKey:@"Billing Address"];
            
            if ([[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"postcode"] == nil || [[[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"postcode"] isEqualToString:@""])
            {
                cell.vwNoAddress.hidden = NO;
            }
            else
            {
                cell.vwNoAddress.hidden = YES;
                
                cell.lblPhoneNumberTitle.text = [MCLocalization stringForKey:@"Phone Number"];
                cell.lblName.text = [NSString stringWithFormat:@"%@ %@", [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"first_name"], [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"last_name"]];
                
                cell.lblSubAddress.text = [MCLocalization stringForKey:@"Address"];
                
                cell.lblPhoneNumber.text = [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"phone"];
                NSString *strAddress = [NSString stringWithFormat:@"%@, %@, %@",
                                        [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"address_1"],
                                        [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"address_2"],
                                        [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"city"]];
                if(![[[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"state"] isEqualToString:@""]){
                    strAddress = [NSString stringWithFormat:@"%@, %@", strAddress, [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"state"]];
                }
                
                if(![[[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"country"] isEqualToString:@""]){
                    strAddress = [NSString stringWithFormat:@"%@, %@", strAddress, [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"country"]];
                }
                
                strAddress = [NSString stringWithFormat:@"%@, %@", strAddress, [[appDelegate.dictCustData valueForKey:@"billing"] valueForKey:@"postcode"]];
                
                cell.lblAddress.text = strAddress;
                
                [cell.lblPhoneNumberTitle sizeToFit];
                cell.lblPhoneNumber.frame = CGRectMake(cell.lblPhoneNumberTitle.frame.origin.x + cell.lblPhoneNumberTitle.frame.size.width + 8, cell.lblPhoneNumberTitle.frame.origin.y, cell.lblPhoneNumber.frame.size.width, cell.lblPhoneNumberTitle.frame.size.height);
            }
        }
        else if(indexPath.row == 1)
        {
            //Shipping Address
            cell.lblAddressTitle.text = [MCLocalization stringForKey:@"Shipping Address"];

            if ([[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"postcode"] == nil || [[[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"postcode"] isEqualToString:@""])
            {
                cell.vwNoAddress.hidden = NO;
            }
            else
            {
                cell.vwNoAddress.hidden = YES;
                
                cell.lblName.text = [NSString stringWithFormat:@"%@ %@", [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"first_name"], [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"last_name"]];
                
                NSString *strAddress = [NSString stringWithFormat:@"%@, %@, %@",
                                        [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"address_1"],
                                        [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"address_2"],
                                        [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"city"]];
                if(![[[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"state"] isEqualToString:@""]){
                    strAddress = [NSString stringWithFormat:@"%@, %@", strAddress, [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"state"]];
                }
                
                if(![[[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"country"] isEqualToString:@""]){
                    strAddress = [NSString stringWithFormat:@"%@, %@", strAddress, [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"country"]];
                }
                
                strAddress = [NSString stringWithFormat:@"%@, %@", strAddress, [[appDelegate.dictCustData valueForKey:@"shipping"] valueForKey:@"postcode"]];
                
                cell.lblAddress.text = strAddress;
                
                cell.lblSubAddress.text = [MCLocalization stringForKey:@"Address"];
                cell.lblSubAddress.frame = CGRectMake(cell.lblSubAddress.frame.origin.x, (cell.frame.size.height/2 - cell.lblSubAddress.frame.size.height/2) + 10, cell.lblSubAddress.frame.size.width, cell.lblSubAddress.frame.size.height);
                cell.lblAddress.frame = CGRectMake(cell.lblAddress.frame.origin.x, (cell.frame.size.height/2 - cell.lblAddress.frame.size.height/2) + 10, cell.lblAddress.frame.size.width, cell.lblAddress.frame.size.height);
                
                cell.lblPhoneNumber.hidden = YES;
                cell.lblPhoneNumberTitle.hidden = YES;
            }
        }
        
        cell.btnEdit.tag = indexPath.row;
        cell.btnRemove.tag = indexPath.row + 10;
        
        [cell.btnRemove setTitle:[MCLocalization stringForKey:@"REMOVE"] forState:UIControlStateNormal];
        [Util setPrimaryColorButtonTitle:cell.btnRemove];

        [cell.btnEdit setTitle:[MCLocalization stringForKey:@"EDIT"] forState:UIControlStateNormal];
        [cell.btnEdit addTarget:self action: @selector(btnEditAddressClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnRemove addTarget:self action: @selector(btnRemoveAddressClicked:) forControlEvents:UIControlEventTouchUpInside];
        [Util setPrimaryColorButtonTitle:cell.btnAddAddress];

        [cell.btnAddAddress addTarget:self action: @selector(btnAddAddressClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (appDelegate.isRTL)
    {
        //RTL
        cell.lblAddressTitle.textAlignment = NSTextAlignmentRight;
        cell.lblName.textAlignment = NSTextAlignmentRight;
        
        cell.lblPhoneNumberTitle.frame = CGRectMake(cell.frame.size.width - cell.lblPhoneNumberTitle.frame.size.width - 16, cell.lblPhoneNumberTitle.frame.origin.y, cell.lblPhoneNumberTitle.frame.size.width, cell.lblPhoneNumberTitle.frame.size.height);
        cell.lblSubAddress.frame = CGRectMake(cell.frame.size.width - cell.lblSubAddress.frame.size.width - 16, cell.lblSubAddress.frame.origin.y, cell.lblSubAddress.frame.size.width, cell.lblSubAddress.frame.size.height);

        cell.lblPhoneNumber.frame = CGRectMake(cell.lblPhoneNumberTitle.frame.origin.x - cell.lblPhoneNumber.frame.size.width - 8, cell.lblPhoneNumber.frame.origin.y, cell.lblPhoneNumber.frame.size.width, cell.lblPhoneNumber.frame.size.height);
        cell.lblAddress.frame = CGRectMake(cell.lblSubAddress.frame.origin.x - cell.lblAddress.frame.size.width - 8, cell.lblAddress.frame.origin.y, cell.lblAddress.frame.size.width, cell.lblAddress.frame.size.height);

        cell.lblPhoneNumberTitle.textAlignment = NSTextAlignmentRight;
        cell.lblSubAddress.textAlignment = NSTextAlignmentRight;
        cell.lblPhoneNumber.textAlignment = NSTextAlignmentRight;
        cell.lblAddress.textAlignment = NSTextAlignmentRight;
        
        cell.btnEdit.frame = CGRectMake(8, cell.btnEdit.frame.origin.y, cell.btnEdit.frame.size.width, cell.btnEdit.frame.size.height);
        cell.btnRemove.frame = CGRectMake(138, cell.btnRemove.frame.origin.y, cell.btnRemove.frame.size.width, cell.btnRemove.frame.size.height);
    }
    else
    {
        //NonRTL
        cell.lblAddressTitle.textAlignment = NSTextAlignmentLeft;
        cell.lblName.textAlignment = NSTextAlignmentLeft;
        
        cell.lblPhoneNumberTitle.frame = CGRectMake(16, cell.lblPhoneNumberTitle.frame.origin.y, cell.lblPhoneNumberTitle.frame.size.width, cell.lblPhoneNumberTitle.frame.size.height);
        cell.lblSubAddress.frame = CGRectMake(16, cell.lblSubAddress.frame.origin.y, cell.lblSubAddress.frame.size.width, cell.lblSubAddress.frame.size.height);
        
        cell.lblPhoneNumber.frame = CGRectMake(cell.lblPhoneNumberTitle.frame.origin.x + cell.lblPhoneNumberTitle.frame.size.width + 8, cell.lblPhoneNumber.frame.origin.y, cell.lblPhoneNumber.frame.size.width, cell.lblPhoneNumber.frame.size.height);
        cell.lblAddress.frame = CGRectMake(cell.lblSubAddress.frame.origin.x + cell.lblSubAddress.frame.size.width + 8, cell.lblAddress.frame.origin.y, cell.lblAddress.frame.size.width, cell.lblAddress.frame.size.height);
        
        cell.lblPhoneNumberTitle.textAlignment = NSTextAlignmentLeft;
        cell.lblSubAddress.textAlignment = NSTextAlignmentLeft;
        cell.lblPhoneNumber.textAlignment = NSTextAlignmentLeft;
        cell.lblAddress.textAlignment = NSTextAlignmentLeft;
        
        cell.btnEdit.frame = CGRectMake(cell.frame.size.width - cell.btnEdit.frame.size.width - 8, cell.btnEdit.frame.origin.y, cell.btnEdit.frame.size.width, cell.btnEdit.frame.size.height);
        cell.btnRemove.frame = CGRectMake(cell.frame.size.width - cell.btnRemove.frame.size.width - 138, cell.btnRemove.frame.origin.y, cell.btnRemove.frame.size.width, cell.btnRemove.frame.size.height);

        
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 174;
}

#pragma mark - Api calls

-(void)updateCustomerData:(NSMutableDictionary*) dict
{    
    [CiyaShopAPISecurity updateCustomerAddress:dict userId:[Util getStringData:kUserID] completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        if (success)
        {
            appDelegate.dictCustData = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
            
            [self.tblAddresses reloadData];
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
