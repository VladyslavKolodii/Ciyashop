//
//  Notication VC.m
//  QuickClick
//
//  Created by Kaushal PC on 04/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "NoticationVC.h"
#import "NotificationCell.h"
#import "MyOrderVC.h"
#import "MyRewardVC.h"

@import ListPlaceholder;
@interface NoticationVC ()<UITableViewDelegate>

@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwUpdate;
@property (strong, nonatomic) IBOutlet UIView *vwNotification;
@property (strong, nonatomic) IBOutlet UITableView *tblNotification;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblRemoveAll;
@property (strong, nonatomic) IBOutlet UILabel *lblNoNotificationYet;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;

@property (strong, nonatomic) IBOutlet UIButton *btnContinueShopping;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UIImageView *imgArrow;

@property (strong,nonatomic) IBOutlet UIView *vwLoader;
@property (strong,nonatomic) IBOutlet UIView *vwLoader1;
@property (strong,nonatomic) IBOutlet UIView *vwLoader2;
@property (strong,nonatomic) IBOutlet UIView *vwLoader3;
@property (strong,nonatomic) IBOutlet UIView *vwLoader4;
@property (strong,nonatomic) IBOutlet UIView *vwLoader5;
@property (strong,nonatomic) IBOutlet UIView *vwLoader6;
@property (strong,nonatomic) IBOutlet UIView *vwLoader7;
@property (strong,nonatomic) IBOutlet UIView *vwLoader8;
@property (weak, nonatomic) IBOutlet UIView *vwLoader9;

@end

@implementation NoticationVC
{
    NSMutableArray *arrNotification;
    int selectedNotification;
    UIView *vw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrNotification = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    [self getNotification];
    
    [Util setSecondaryColorButtonImage:self.btnContinueShopping image:[UIImage imageNamed:@"MyRewardsButtonBG"]];

    [Util setSecondaryColorImageView:self.imgArrow];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self localize];
    [Util setHeaderColorView:vw];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwUpdate.frame = CGRectMake(0, statusBarSize.height, self.vwUpdate.frame.size.width, SCREEN_SIZE.height - statusBarSize.height);
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
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.textColor = OtherTitleColor;
    [Util setSecondaryColorButtonTitle:self.btnContinueShopping];
    
    self.lblTitle.text = [MCLocalization stringForKey:@"Notification"];
    
    self.lblNoNotificationYet.text = [MCLocalization stringForKey:@"No Notification yet"];
    self.lblDesc.text = [MCLocalization stringForKey:@"Simply browse , create a wish list or make a purchase."];
    self.lblRemoveAll.text = [MCLocalization stringForKey:@"REMOVE ALL"];
    
    [self.btnContinueShopping setTitle:[MCLocalization stringForKey:@"CONTINUE SHOPPING"] forState:UIControlStateNormal];
    
    self.lblTitle.font = Font_Size_Navigation_Title;
    self.lblRemoveAll.font = Font_Size_Price_Sale_Bold;
    
    if (appDelegate.isRTL) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }


    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

#pragma mark - Button Clicks

-(IBAction)btnContinueShoppingClicked:(id)sender
{
    UIViewController *selectedVC = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];

    if (selectedVC.tabBarItem.tag == 1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.tabBarController setSelectedIndex:0];
}

-(IBAction)btnDeleteAllClicked:(id)sender
{
    [self deleteAllNotification];
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrNotification.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"NotificationCell";
    
    NotificationCell *cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblMessage.text = [[arrNotification objectAtIndex:indexPath.row] valueForKey:@"msg"];
    cell.lblNotification.text = [[arrNotification objectAtIndex:indexPath.row] valueForKey:@"custom_msg"];
    
    NSString *strTime = [[arrNotification objectAtIndex:indexPath.row] valueForKey:@"created"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [dateFormatter dateFromString:strTime];
    
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:dateFromString];

    cell.lblDate.text = timestamp;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    cell.lblNotification.font = Font_Size_Product_Name_Regular;
    cell.lblMessage.font = Font_Size_Price_Sale_Bold;
    cell.lblDate.font = Font_Size_Product_Name_Small_Regular;
    
    if (appDelegate.isRTL)
    {
        //RTL
        cell.lblDate.frame = CGRectMake(8, cell.lblDate.frame.origin.y, cell.lblDate.frame.size.width, cell.lblDate.frame.size.height);
        cell.lblMessage.textAlignment = NSTextAlignmentRight;
        cell.lblNotification.textAlignment = NSTextAlignmentRight;
        cell.lblDate.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //NonRTL
        cell.lblDate.frame = CGRectMake(cell.frame.size.width - cell.lblDate.frame.size.width - 8, cell.lblDate.frame.origin.y, cell.lblDate.frame.size.width, cell.lblDate.frame.size.height);
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteNotification:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)hideTable
{
    if (arrNotification.count == 0)
    {
        self.vwNotification.hidden = YES;
    }
}


#pragma mark - API calls

-(void)getNotification
{
    
    if(appDelegate.isShimmerLoader){
        [self.vwLoader1 showLoader];
        [self.vwLoader2 showLoader];
        [self.vwLoader3 showLoader];
        [self.vwLoader4 showLoader];
        [self.vwLoader5 showLoader];
        [self.vwLoader6 showLoader];
        [self.vwLoader7 showLoader];
        [self.vwLoader8 showLoader];
        [self.vwLoader9 showLoader];
        self.vwLoader.hidden = false;
    } else {
        SHOW_LOADER_ANIMTION();
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:appDelegate.strDeviceToken forKey:@"device_token"];
    [dict setValue:@"1" forKey:@"device_type"];
    NSLog(@"%@",dict);
    
    [CiyaShopAPISecurity getAllNotifications:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                self->arrNotification = [[NSMutableArray alloc] initWithArray:[dictionary valueForKey:@"data"]];
                [self.tblNotification reloadData];
                HIDE_PROGRESS;
            }
            else
            {
                HIDE_PROGRESS;
            }
        }
        else
        {
            HIDE_PROGRESS;
        }
        [self hideTable];
        self.vwLoader.hidden = true;
        [self.vwLoader1 hideLoader];
        [self.vwLoader2 hideLoader];
        [self.vwLoader3 hideLoader];
        [self.vwLoader4 hideLoader];
        [self.vwLoader5 hideLoader];
        [self.vwLoader6 hideLoader];
        [self.vwLoader7 hideLoader];
        [self.vwLoader8 hideLoader];
        [self.vwLoader9 hideLoader];
    }];
}


-(void)deleteNotification:(NSIndexPath*)indexPath
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:[[arrNotification objectAtIndex:indexPath.row] valueForKey:@"push_meta_id"]];
    [dict setValue:arr forKey:@"push_meta_id"];

    NSLog(@"%@",dict);
    
    [CiyaShopAPISecurity deleteNotification:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                HIDE_PROGRESS;
                if ([[[self->arrNotification objectAtIndex:indexPath.row] valueForKey:@"not_code"] isEqualToString:@"1"])
                {
                    //My Rewards
                    MyRewardVC *vc = [[MyRewardVC alloc] initWithNibName:@"MyRewardVC" bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if ([[[self->arrNotification objectAtIndex:indexPath.row] valueForKey:@"not_code"] isEqualToString:@"2"])
                {
                    //My Order
                    MyOrderVC *vc = [[MyOrderVC alloc] initWithNibName:@"MyOrderVC" bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
                [self->arrNotification removeObjectAtIndex:indexPath.row];
                
                NSArray *deletedIndexPaths = [[NSArray alloc]initWithObjects:indexPath,nil];
                
                [self.tblNotification beginUpdates];
                [self.tblNotification deleteRowsAtIndexPaths:deletedIndexPaths withRowAnimation:UITableViewRowAnimationRight];
                [self.tblNotification endUpdates];
                
                [self performSelector:@selector(hideTable) withObject:nil afterDelay:0.99];
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
                HIDE_PROGRESS;
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
        [self hideTable];
    }];
}


-(void)deleteAllNotification
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrNotification.count; i++)
    {
        [arr addObject:[[arrNotification objectAtIndex:i] valueForKey:@"push_meta_id"]];
    }
    [dict setValue:arr forKey:@"push_meta_id"];

    NSLog(@"%@",dict);
    
    [CiyaShopAPISecurity deleteNotification:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                HIDE_PROGRESS;
                [self->arrNotification removeAllObjects];
                [self.tblNotification reloadData];
                self.vwNotification.hidden = YES;
                
                self->arrNotification = [[NSMutableArray alloc] init];
                [self performSelector:@selector(hideTable) withObject:nil afterDelay:0.99];
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
                HIDE_PROGRESS;
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
        [self hideTable];
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
