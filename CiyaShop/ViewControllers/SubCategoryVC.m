//
//  SubCategoryVC.m
//  QuickClick
//
//  Created by Kaushal PC on 07/07/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "SubCategoryVC.h"
#import "SearchCell.h"
#import "HomeShopDataVC.h"
#import "SubSearchCell.h"

@interface SubCategoryVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwAllData;

@property (strong, nonatomic) IBOutlet UITableView *tblCategory; //tag = 1
@property (strong, nonatomic) IBOutlet UITableView *tblSearchedString; // tag = 2

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;

@property (strong, nonatomic) IBOutlet UIButton *btnGo;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UIImageView *imgSearch;

@end

@implementation SubCategoryVC
{
    NSMutableArray *arrSubContent, *arrSearchedString;
    int selectedIndex, prevSelectedIndex;
    UIView *vw;
}
@synthesize arrSubCategory;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.btnGo.layer.cornerRadius = 3;
    self.btnGo.layer.masksToBounds = true;
    
    self.tblSearchedString.hidden = YES;
    
    selectedIndex = -1;
    prevSelectedIndex = -1;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    [self localize];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.tblCategory reloadData];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tblCategory reloadData];
    [Util setHeaderColorView:vw];
}

#pragma mark - Localize Language

/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)localize
{
    [Util setHeaderColorView:self.vwHeader];
    self.txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Search for products"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtSearch.font=Font_Size_Product_Name_Not_Bold;
    [self.btnGo setTitleColor:SearchBG forState:UIControlStateNormal];
    [self.btnGo setTitle:[MCLocalization stringForKey:@"Go"] forState:UIControlStateNormal];
    self.btnGo.titleLabel.font = Font_Size_Title;
    if (appDelegate.isRTL)
    {
        //RTL
        [self.vwHeader setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//        self.txtSearch.frame = CGRectMake(self.vwHeader.frame.size.width - self.txtSearch.frame.size.width - 27, self.txtSearch.frame.origin.y, self.txtSearch.frame.size.width, self.txtSearch.frame.size.height);
        self.txtSearch.textAlignment = NSTextAlignmentRight;
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        [self.tblCategory setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//        self.imgSearch.frame = CGRectMake(27*SCREEN_SIZE.width/375, self.imgSearch.frame.origin.y, self.imgSearch.frame.size.width, self.imgSearch.frame.size.height);
    }
    else
    {
        //No RTL
        [self.vwHeader setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.tblCategory setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
//        self.txtSearch.frame = CGRectMake(27, self.txtSearch.frame.origin.y, self.txtSearch.frame.size.width, self.txtSearch.frame.size.height);
        self.txtSearch.textAlignment = NSTextAlignmentLeft;
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
//        self.imgSearch.frame = CGRectMake(self.vwHeader.frame.size.width - self.imgSearch.frame.size.width - 27*SCREEN_SIZE.width/375, self.imgSearch.frame.origin.y, self.imgSearch.frame.size.width, self.imgSearch.frame.size.height);
    }
    [self.tblCategory reloadData];
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
        [self.tblSearchedString reloadData];
        self.tblSearchedString.hidden = NO;
        self.tblSearchedString.frame = CGRectMake(0, self.vwHeader.frame.origin.y + self.vwHeader.frame.size.height, SCREEN_SIZE.width, SCREEN_SIZE.height - (self.vwHeader.frame.origin.y + self.vwHeader.frame.size.height));
    }
}

-(void)textChanged:(UITextField *)textField
{
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
    [self.tblSearchedString reloadData];
    self.tblSearchedString.hidden = NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 101)
    {
        self.tblSearchedString.hidden = YES;
        [self redirectToHomeData];
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


#pragma mark - Button Clicks
/*!
 * @discussion It will take you to PreviousView
 * @param sender For indentifying sender
 */
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*!
 * @discussion It will take you to Search Product Listing Page
 * @param sender For indentifying sender
 */
-(IBAction)btnGoClicked:(id)sender
{
    [self.txtSearch becomeFirstResponder];
    [self.view endEditing:YES];
}
/*!
 * @discussion It will take you to Home Page
 */
-(void)redirectToHomeData
{
    if (self.txtSearch.text == nil || [self.txtSearch.text isEqualToString:@""])
    {
        return;
    }
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
    HomeShopDataVC *vc = [[HomeShopDataVC alloc] initWithNibName:@"HomeShopDataVC" bundle:nil];
    vc.fromSearch = YES;
    vc.strSearchString = self.txtSearch.text;
    [self.navigationController pushViewController:vc animated:YES];
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
        return arrSubCategory.count;
    }
    else if (tableView.tag == 2)
    {
        //tblSearchedString
        return arrSearchedString.count;
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
        cell.lblTitle.text = [[arrSubCategory objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.lblTitle.font=Font_Size_Product_Name_Not_Bold;
        cell.lblTitle.textColor = LightBlackColor;
        if ([[[arrSubCategory objectAtIndex:indexPath.row] objectForKey:@"image"] count] > 0)
        {
            [cell.imgIcon sd_setImageWithURL:[Util EncodedURL:[[[arrSubCategory objectAtIndex:indexPath.row] valueForKey:@"image"] valueForKey:@"src"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                cell.imgIcon.image=image;
            }];
        }
        cell.vwTable.frame = CGRectMake(65, 50, SCREEN_SIZE.width - 40 - 65, arrSubContent.count*50);
        UITableView *tableSubView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width - 40 - 65, arrSubContent.count*50) style:UITableViewStylePlain];

        tableSubView.delegate = self;
        tableSubView.dataSource = self;
        tableSubView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableSubView.separatorColor = [UIColor clearColor];
        [tableSubView setBounces:NO];
        tableSubView.hidden = YES;
        
        [cell.vwTable.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];

        [cell.vwTable addSubview:tableSubView];

        if (appDelegate.isRTL)
        {
            //RTL
            [UIView animateWithDuration:0.3 animations:^{
                cell.imgArrow.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }

        if (selectedIndex == indexPath.row)
        {
            //rotate rect
            if (arrSubContent.count>0)
            {
                //NonRTL
                [UIView animateWithDuration:0.3 animations:^{
                    cell.imgArrow.transform = CGAffineTransformMakeRotation(M_PI_2); //rotation in radians
                }];
            }
            [tableSubView reloadData];
            tableSubView.hidden = NO;
        }
        if (indexPath.row==prevSelectedIndex)
        {
            if (appDelegate.isRTL)
            {
                //RTL
                [UIView animateWithDuration:0.3 animations:^{
                    cell.imgArrow.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            }
            else
            {
                //NonRTL
                [UIView animateWithDuration:0.3 animations:^{
                    cell.imgArrow.transform = CGAffineTransformMakeRotation(0); //rotation in radians
                }];
            }
        }
        if (indexPath.row == arrSubCategory.count - 1)
        {
            prevSelectedIndex = selectedIndex;
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
//
//                cell.vwTable.frame = CGRectMake(cell.frame.size.width - cell.vwTable.frame.size.width - 65, cell.vwTable.frame.origin.y, cell.vwTable.frame.size.width, cell.vwTable.frame.size.width);
            }
            else
            {
                //No RTL
//                cell.lblTitle.frame = CGRectMake(58, cell.lblTitle.frame.origin.y, cell.lblTitle.frame.size.width, cell.lblTitle.frame.size.height);
//                cell.lblTitle.textAlignment = NSTextAlignmentLeft;
//                cell.vwTable.frame = CGRectMake(65, cell.vwTable.frame.origin.y, cell.vwTable.frame.size.width, cell.vwTable.frame.size.width);
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
        cell.lblTitle.frame = CGRectMake(27, cell.lblTitle.frame.origin.y, cell.frame.size.width - 54, cell.lblTitle.frame.size.height);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (appDelegate.isRTL)
        {
            //RTL
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
        }
        return cell;
    }
    else
    {
        static NSString *simpleTableIdentifier = @"SubSearchCell";
        SubSearchCell *cell = (SubSearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SubSearchCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.lblTitle.text = [[arrSubContent objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.lblTitle.font = Font_Size_Product_Name_Not_Bold;
        cell.lblTitle.textColor = LightBlackColor;

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        CGRect frame = cell.frame;
        [cell setFrame:CGRectMake(0, -tableView.frame.size.width, frame.size.width, frame.size.height)];

        [UIView animateWithDuration:1.0 animations:^{
            cell.frame = frame;
        }];
        if (appDelegate.isRTL)
        {
            //RTL
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
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
        prevSelectedIndex = selectedIndex;
        if (selectedIndex==indexPath.row)
        {
            [self.tblCategory reloadData];
            selectedIndex = -1;
            [self.tblCategory beginUpdates];
            [self.tblCategory endUpdates];
        }
        else
        {
            int setSubCategory = 0;
            arrSubContent = [[NSMutableArray alloc] init];
            for (int i = 0; i < appDelegate.arrCategory.count; i++)
            {
                NSString *val = [NSString stringWithFormat:@"%@",[[appDelegate.arrCategory objectAtIndex:i] valueForKey:@"parent"]];
                NSString *val2 = [NSString stringWithFormat:@"%@",[[arrSubCategory objectAtIndex:indexPath.row] valueForKey:@"id"]];
                if ([val isEqualToString:val2])
                {
                    //Sub Category
                    [arrSubContent addObject:[appDelegate.arrCategory objectAtIndex:i]];
                    setSubCategory = 1;
                }
            }
            [self.tblCategory reloadData];
            selectedIndex = (int)indexPath.row;
            if (setSubCategory == 1)
            {
                
            }
            else
            {
                HomeShopDataVC *vc = [[HomeShopDataVC alloc]initWithNibName:@"HomeShopDataVC" bundle:nil];
                vc.fromCategory = YES;
                vc.CategoryID = [[[arrSubCategory objectAtIndex:selectedIndex] valueForKey:@"id"] intValue];
                [self.navigationController pushViewController:vc animated:YES];
            }

            [self.tblCategory beginUpdates];
            [self.tblCategory endUpdates];
        }
    }
    else if (tableView.tag == 2)
    {
        //tblSearchedString
        self.txtSearch.text = [[arrSearchedString objectAtIndex:indexPath.row] capitalizedString];
        [self.txtSearch becomeFirstResponder];
        [self.tblSearchedString reloadData];
        [self.view endEditing:YES];
    }
    else
    {
        //SubPart for Search i.e SubSearch
        self.txtSearch.text = @"";
        HomeShopDataVC *vc = [[HomeShopDataVC alloc]initWithNibName:@"HomeShopDataVC" bundle:nil];
        vc.fromCategory = YES;
        vc.CategoryID = [[[arrSubContent objectAtIndex:indexPath.row] valueForKey:@"id"] intValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)reloadUITableView
{
    [self.tblCategory reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
    {
        if (selectedIndex == indexPath.row)
        {
            if(arrSubContent.count > 0)
            {
                return ((arrSubContent.count*50)+50);
            }
        }
        return 50;
    }
    else
    {
        return 50;
    }
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
