//
//  SearchVC.m
//  QuickClick
//
//  Created by Kaushal PC on 05/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "SearchVC.h"
#import "SearchCell.h"
#import "SubSearchCell.h"
#import "SubCategoryVC.h"
#import "HomeShopDataVC.h"
#import "GroupItemDetailVC.h"
#import "ItemDetailVC.h"
#import "VariableItemDetailVC.h"
#import "ShopNowCatagoryCell.h"

@interface SearchVC ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;

@property (strong, nonatomic) IBOutlet UITableView *tblSearch; // tag = 1
@property (strong, nonatomic) IBOutlet UITableView *tblSearchedString; // tag = 2
@property (strong, nonatomic) IBOutlet UITableView *tblLiveSearch; // tag = 3

@property (strong, nonatomic) IBOutlet UIButton *btnGo;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UIImageView *imgSearch;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actSearch;

@property (strong, nonatomic) NSTimer * searchTimer;

@property (strong, nonatomic) IBOutlet UIView *vwNoProduct;
@property (strong, nonatomic) IBOutlet UIButton *btnContinueShopping;
@property (strong, nonatomic) IBOutlet UIImageView *imgArrow;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;


@end

@implementation SearchVC
{
    NSMutableArray *arrTitle, *arrContent, *arrSubContent, *arrSearchedString;
    int selectedIndex, prevSelectedIndex;
    UITableView *tblData;
    UIView *vw;
    BOOL apiCallRunning, fromLiveSearch;
    NSMutableArray *arrProductData;
    BOOL isSearched;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isSearched = true;
    
    self.tblLiveSearch.hidden = YES;
    self.tblSearchedString.hidden = YES;
    
    NSLog(@"%@",appDelegate.arrCategory);
    
    arrTitle = [[NSMutableArray alloc] init];
    arrContent = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < appDelegate.arrCategory.count; i++)
    {
        NSLog(@"%d", i);
        NSString *val = [NSString stringWithFormat:@"%@",[[appDelegate.arrCategory objectAtIndex:i] valueForKey:@"parent"]];
        if ([val isEqualToString:@"0"])
        {
            if([[[appDelegate.arrCategory objectAtIndex:i] valueForKey:@"name"] isEqualToString:@"Uncategorized"])
            {
                continue;
            }
            //parent Category
            [arrTitle addObject:[appDelegate.arrCategory objectAtIndex:i]];
        }
        else
        {
            //sub Category
            [arrContent addObject:[appDelegate.arrCategory objectAtIndex:i]];
        }
    }
    
    selectedIndex = -1;
    prevSelectedIndex = -1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    if (appDelegate.from == 1)
    {
        appDelegate.from = 0;
        [self.txtSearch becomeFirstResponder];
    }
    self.btnGo.layer.cornerRadius = 3;
    self.btnGo.layer.masksToBounds = true;
    
//    self.btnGo.hidden = true;
    
    if (!self.fromMore && self.fromViewController)
    {
        self.tblSearch.hidden = YES;
    }
    if (arrSearchedString.count == 0) {
        self.tblSearchedString.hidden = true;
        self.vwNoProduct.hidden = false;
    }
    else
    {
        self.tblSearchedString.hidden = false;
        self.vwNoProduct.hidden = true;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
    [self.tblSearch reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    arrTitle = [[NSMutableArray alloc] init];
    arrContent = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < appDelegate.arrCategory.count; i++)
    {
        NSLog(@"%d", i);
        NSString *val = [NSString stringWithFormat:@"%@",[[appDelegate.arrCategory objectAtIndex:i] valueForKey:@"parent"]];
        if ([val isEqualToString:@"0"])
        {
            if([[[appDelegate.arrCategory objectAtIndex:i] valueForKey:@"name"] isEqualToString:@"Uncategorized"])
            {
                continue;
            }
            //parent Category
            [arrTitle addObject:[appDelegate.arrCategory objectAtIndex:i]];
        }
        else
        {
            //sub Category
            [arrContent addObject:[appDelegate.arrCategory objectAtIndex:i]];
        }
    }

    [self.tblSearch reloadData];
    [self.tblSearchedString reloadData];
    [self localize];
    [Util setHeaderColorView:vw];
}

#pragma mark - Localize Language

- (void)localize
{
    [Util setHeaderColorView:self.vwHeader];
    [self.btnGo setTitleColor:SearchBG forState:UIControlStateNormal];
    self.txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Search for products"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [self.btnGo setTitle:[MCLocalization stringForKey:@"Go"] forState:UIControlStateNormal];
    self.btnGo.titleLabel.font = Font_Size_Title;
    
    [Util setSecondaryColorButtonImage:self.btnContinueShopping image:[UIImage imageNamed:@"MyRewardsButtonBG"]];
    [Util setSecondaryColorImageView:self.imgArrow];
    
    [Util setSecondaryColorButtonTitle:self.btnContinueShopping];

    self.txtSearch.font = Font_Size_Product_Name_Not_Bold;
    
    self.lblMessage.text = [MCLocalization stringForKey:@"Search List is empty"];
    self.lblDesc.text = [MCLocalization stringForKey:@"Browse our store and take a look at other items to buy."];

    [Util setPrimaryColorActivityIndicator:self.actSearch];
    
    if (appDelegate.isRTL)
    {
        //RTL
        [self.vwHeader setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI); //rotation in radians

        [self.tblSearch setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.txtSearch.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        [self.vwHeader setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.transform = CGAffineTransformMakeRotation(0); //rotation in radians
        [self.tblSearch setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];

        //No RTL
        self.txtSearch.textAlignment = NSTextAlignmentLeft;
    }
    [self.tblSearch reloadData];
    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 101)
    {
        [self.txtSearch addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        
        arrSearchedString = [[NSMutableArray alloc] initWithArray:[Util getArrayData:kSearchedString]];
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[Util getArrayData:kSearchedString]];
        arrSearchedString = [[NSMutableArray alloc] init];
        if (self.txtSearch.text == nil || [self.txtSearch.text isEqualToString:@""])
        {
            arrSearchedString = [[NSMutableArray alloc] initWithArray:[Util getArrayData:kSearchedString]];
        }
        else
        {
            for (int i = 0; i < arr.count; i++)
            {
                if ([[[arr objectAtIndex:i] lowercaseString] containsString:[self.txtSearch.text lowercaseString]])
                {
                    [arrSearchedString addObject:[arr objectAtIndex:i]];
                }
            }
        }
        
        if (arrSearchedString.count == 0) {
            self.tblSearchedString.hidden = YES;
            if (isSearched)
            {
                self.vwNoProduct.hidden = NO;
            }
        } else {
            self.tblSearchedString.hidden = NO;
            self.vwNoProduct.hidden = YES;
        }

        [self.tblSearchedString reloadData];
        self.tblSearchedString.frame = CGRectMake(0, self.vwHeader.frame.origin.y + self.vwHeader.frame.size.height, SCREEN_SIZE.width, SCREEN_SIZE.height - (self.vwHeader.frame.origin.y + self.vwHeader.frame.size.height));
    }
}

-(void)textChanged:(UITextField *)textField
{
    NSLog(@"textfield data %@ ",textField.text);
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[Util getArrayData:kSearchedString]];
    arrSearchedString = [[NSMutableArray alloc] init];
    if (self.txtSearch.text == nil || [self.txtSearch.text isEqualToString:@""])
    {
        arrSearchedString = [[NSMutableArray alloc] initWithArray:[Util getArrayData:kSearchedString]];
    }
    else
    {
        for (int i = 0; i < arr.count; i++)
        {
            if ([[[arr objectAtIndex:i] lowercaseString] containsString:[self.txtSearch.text lowercaseString]])
            {
                [arrSearchedString addObject:[arr objectAtIndex:i]];
            }
        }
    }
    if (arrSearchedString.count == 0) {
        self.tblSearchedString.hidden = YES;
        if (isSearched)
        {
            self.vwNoProduct.hidden = NO;
        }
    } else {
        self.tblSearchedString.hidden = NO;
        self.vwNoProduct.hidden = YES;
    }
    [self.tblSearchedString reloadData];

    // if a timer is already active, prevent it from firing
    if (self.searchTimer != nil) {
        [self.searchTimer invalidate];
        self.searchTimer = nil;
    }
    
    // reschedule the search: in 1.0 second, call the searchForKeyword: method on the new textfield content
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                        target: self
                                                      selector: @selector(searchForKeyword:)
                                                      userInfo: self.txtSearch.text
                                                       repeats: NO];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 101)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (!self->fromLiveSearch) {
                self.tblSearchedString.hidden = YES;
                [self redirectToHomeData];
            }
        });
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 101)
    {
        self.tblSearchedString.hidden = YES;
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - Seach For Data

- (void) searchForKeyword:(NSTimer *)timer
{
    // retrieve the keyword from user info
    NSString *keyword = (NSString*)timer.userInfo;
    
    // perform your search (stubbed here using NSLog)
    NSLog(@"Searching for keyword %@", keyword);
    
    //api call for product search
    if ([self.txtSearch.text length] >= 3)
    {
        [self loadProducts];
    }
}

#pragma mark - Button Clicks

-(IBAction)btnBackClicked:(id)sender
{
    if (self.fromViewController)
    {
        self.fromViewController = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        self.tabBarController.selectedIndex = 0;
        [[self.tabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
    }
}

-(IBAction)btnGoClicked:(id)sender
{
    fromLiveSearch = false;
    [self.txtSearch becomeFirstResponder];
    [self.view endEditing:YES];
}

-(void)redirectToHomeData
{
    if (self.txtSearch.text == nil || [self.txtSearch.text isEqualToString:@""])
    {
        return;
    }
    
    // Facebook Pixel for Search Product
    [Util logSearchedEvent:FBSEARCH_CONTENT_TYPE searchString:self.txtSearch.text success:FBSDKAppEventParameterValueYes];
    
    [self setSearchedData];
    
    HomeShopDataVC *vc = [[HomeShopDataVC alloc] initWithNibName:@"HomeShopDataVC" bundle:nil];
    vc.fromSearch = YES;
    vc.strSearchString = self.txtSearch.text;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setSearchedData {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[Util getArrayData:kSearchedString]];
    
    BOOL flag = NO;
    int pos = -1;
    for (int i = 0; i < arr.count; i++)
    {
        if ([[self.txtSearch.text lowercaseString] isEqualToString:[[arr objectAtIndex:i] lowercaseString]])
        {
            flag = YES;
            pos = i;
            break;
        }
    }
    
    if (flag)
    {
        [arr removeObjectAtIndex:pos];
    }
    [arr insertObject:self.txtSearch.text atIndex:0];
    
    [Util setArray:arr setData:kSearchedString];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1)
    {
        //tblSearch
        return arrTitle.count;
    }
    else if (tableView.tag == 2)
    {
        //tblSearchedString
        return arrSearchedString.count;
    }
    else if (tableView.tag == 3)
    {
        //tblSearchedString
        return arrProductData.count;
    }
    else
    {
        return arrSubContent.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
    {
        static NSString *simpleTableIdentifier = @"SearchCell";
        
        SearchCell *cell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (indexPath.row == 0)
        {
            cell.imgDevider.hidden = YES;
        }
        
        cell.lblTitle.text = [[arrTitle objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.lblTitle.font=Font_Size_Product_Name_Not_Bold;
        cell.lblTitle.textColor = LightBlackColor;
        
        if ([[[arrTitle objectAtIndex:indexPath.row] objectForKey:@"image"] count] > 0)
        {
            [cell.imgIcon sd_setImageWithURL:[Util EncodedURL:[[[arrTitle objectAtIndex:indexPath.row] valueForKey:@"image"] valueForKey:@"src"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                cell.imgIcon.image=image;
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (appDelegate.isRTL)
            {
                //RTL
                
//                cell.vwImage.frame = CGRectMake(cell.frame.size.width - 15 - cell.vwImage.frame.size.width, cell.vwImage.frame.origin.y, cell.vwImage.frame.size.width, cell.vwImage.frame.size.height);
//
//                cell.lblTitle.frame = CGRectMake(cell.frame.size.width - cell.lblTitle.frame.size.width - 58, cell.lblTitle.frame.origin.y, cell.lblTitle.frame.size.width, cell.lblTitle.frame.size.height);
//                cell.lblTitle.textAlignment = NSTextAlignmentRight;
//                cell.imgArrow.frame = CGRectMake(17, cell.imgArrow.frame.origin.y, cell.imgArrow.frame.size.width, cell.imgArrow.frame.size.height);
                cell.imgArrow.transform = CGAffineTransformMakeRotation(M_PI); //rotation in radians
            }
            else
            {
                //No RTL
                cell.imgArrow.transform = CGAffineTransformMakeRotation(0); //rotation in radians
            }
        });

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (tableView.tag == 2)
    {
        //tblSearchedString
        static NSString *simpleTableIdentifier = @"SubSearchCell";
        
        SubSearchCell *cell = (SubSearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SubSearchCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.lblTitle.text = [[arrSearchedString objectAtIndex:indexPath.row] capitalizedString];
        cell.lblTitle.font = Font_Size_Product_Name_Not_Bold;
        cell.lblTitle.textColor = LightBlackColor;
//        cell.lblTitle.frame = CGRectMake(27, cell.lblTitle.frame.origin.y, cell.frame.size.width - 54, cell.lblTitle.frame.size.height);

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (appDelegate.isRTL)
        {
            //RTL
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
        } else {
            cell.lblTitle.textAlignment = NSTextAlignmentLeft;
        }
        return cell;
    }
    if (tableView.tag == 3) {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
                
        NSString * htmlString1 = [[arrProductData objectAtIndex:indexPath.row] valueForKey:@"name"];
        NSMutableAttributedString * attrStr1 = [[NSMutableAttributedString alloc] initWithData:[htmlString1 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        [attrStr1 addAttribute:NSFontAttributeName value:Font_Size_Product_Name_Not_Bold range:NSMakeRange(0, attrStr1.length)];
        
        [attrStr1 addAttribute:NSForegroundColorAttributeName value:LightBlackColor range:NSMakeRange(0,attrStr1.length)];

        cell.textLabel.attributedText = attrStr1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (appDelegate.isRTL) {
            cell.textLabel.textAlignment = NSTextAlignmentRight;
        } else {
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.txtSearch resignFirstResponder];
    if (tableView.tag == 1)
    {
        fromLiveSearch = false;
        
        selectedIndex = (int)indexPath.row;
        int setSubCategory = 0;
        arrSubContent = [[NSMutableArray alloc] init];
        for (int i = 0; i < arrContent.count; i++)
        {
            NSString *val = [NSString stringWithFormat:@"%@",[[arrTitle objectAtIndex:selectedIndex] valueForKey:@"id"]];
            NSString *val2 = [NSString stringWithFormat:@"%@",[[arrContent objectAtIndex:i] valueForKey:@"parent"]];
            
            if ([val isEqualToString:val2])
            {
                //parent Category
                [arrSubContent addObject:[arrContent objectAtIndex:i]];
                setSubCategory = 1;
            }
            else
            {
                //sub Category
            }
        }
        
        if (setSubCategory == 1)
        {
            SubCategoryVC *vc = [[SubCategoryVC alloc] initWithNibName:@"SubCategoryVC" bundle:nil];
            vc.arrSubCategory = arrSubContent;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            HomeShopDataVC *vc = [[HomeShopDataVC alloc]initWithNibName:@"HomeShopDataVC" bundle:nil];
            vc.fromCategory = YES;
            vc.CategoryID = [[[arrTitle objectAtIndex:selectedIndex] valueForKey:@"id"] intValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (tableView.tag == 2)
    {
        //tblSearchedString
        fromLiveSearch = true;
        self.txtSearch.text = @"";
        self.txtSearch.text = [[arrSearchedString objectAtIndex:indexPath.row] capitalizedString];
        [self.txtSearch becomeFirstResponder];
        
        self.tblSearchedString.hidden = YES;
        [self redirectToHomeData];

        [self.tblSearchedString reloadData];
    }
    else if (tableView.tag == 3)
    {
        //live search data selected
        //redirect to product detail page
        fromLiveSearch = true;
        [self.view endEditing:YES];
        
        [self setSearchedData];
        
        [self getSingleProduct:[[arrProductData objectAtIndex:indexPath.row] valueForKey:@"id"]];
    }
}

-(void)reloadUITableView
{
    [self.tblSearch reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
    {
        return 50;
    }
    else
    {
        return 50;
    }
}

#pragma mark - Redirect to product detail

-(void)redirectToProductDetail:(Product*)product
{
    [appDelegate setRecentProduct:product];
    if ([product.type1 isEqualToString:@"external"])
    {
        NSString *strUrl = product.external_url;
        NSURL *_url = [Util EncodedURL:strUrl];
        [[UIApplication sharedApplication] openURL:_url options:@{} completionHandler:nil];
//        [[UIApplication sharedApplication] openURL:_url];
    }
    else if ([product.type1 isEqualToString:@"grouped"])
    {
        //GroupItemDetailVC
        GroupItemDetailVC *vc = [[GroupItemDetailVC alloc] initWithNibName:@"GroupItemDetailVC" bundle:nil];
        vc.product = product;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([product.type1 isEqualToString:@"variable"])
    {
        //VariableItemDetailVC
        VariableItemDetailVC *vc = [[VariableItemDetailVC alloc] initWithNibName:@"VariableItemDetailVC" bundle:nil];
        vc.product = product;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        ItemDetailVC *vc = [[ItemDetailVC alloc] initWithNibName:@"ItemDetailVC" bundle:nil];
        vc.product = product;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - to hide bottom bar

-(BOOL)hidesBottomBarWhenPushed
{
    return NO;
}

#pragma mark - API call

- (void)loadProducts
{
    [self.actSearch startAnimating];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:self.txtSearch.text forKey:@"search"];
    
    isSearched = false;
    
    NSLog(@" dict is :: %@", dict);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^()
                   {
                       self->apiCallRunning = YES;
                       self->isSearched = true;
                       [CiyaShopAPISecurity liveSearch:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
                           
                           NSLog(@"%@", dictionary);
                           
                           [self.actSearch stopAnimating];

                           self->apiCallRunning = NO;
                           self->arrProductData = [[NSMutableArray alloc] init];

                           if(success==YES)
                           {
                               //no error
                               if (dictionary.count > 0)
                               {
                                   if([dictionary isKindOfClass:[NSArray class]])
                                   {
                                       //Is array
                                       NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
                                       
                                       self.tblLiveSearch.hidden = NO;
                                       for (int i = 0; i < arrData.count; i++)
                                       {
                                           [self->arrProductData addObject:[arrData objectAtIndex:i]];
                                       }
                                   }
                                   else if([dictionary isKindOfClass:[NSDictionary class]])
                                   {
                                       //is dictionary means no data available
                                   }
                               }
                               else
                               {
                                   //not data in response
                               }
                           }
                           else
                           {
                               //error
                           }
                           if (self->arrProductData.count == 0) {
                               self.tblLiveSearch.hidden = true;
                               self.vwNoProduct.hidden = false;
                           } else {
                               self.tblLiveSearch.hidden = false;
                               self.vwNoProduct.hidden = true;
                           }
                           dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                               //Background Thread
                               dispatch_async(dispatch_get_main_queue(), ^(void){
                                   //Run UI Updates
                                   [self.tblLiveSearch reloadData];
                               });
                           });
                           
                       }];
                   });
}

-(void)getSingleProduct:(NSString*)productId
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:productId forKey:@"include"];
    
    
    [CiyaShopAPISecurity productListing:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        if (success)
        {
            HIDE_PROGRESS;
            if (dictionary.count > 0)
            {
                NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
                
                Product *object = [Util setProductData:[arrData objectAtIndex:0]];
                [self redirectToProductDetail:object];
            }
        }
        else
        {
            HIDE_PROGRESS;
            ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], appDelegate.window.rootViewController);
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

-(void)clearAllCookies {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
}
@end

