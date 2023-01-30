
//
//  DownloadVC.m
//  CiyaShop
//
//  Created by Kaushal Parmar on 06/05/19.
//  Copyright © 2019 Potenza. All rights reserved.
//

#import "DownloadVC.h"
#import "DownloadCell.h"
#import "DownloadProduct.h"

@interface DownloadVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *vwHeader;
@property (weak, nonatomic) IBOutlet UIView *vwNoProduct;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNoProductTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNoProductDesc;

@property (weak, nonatomic) IBOutlet UITableView *tblDownload;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnContinueShopping;

@property (weak, nonatomic) IBOutlet UIImageView *imgNoProductArrow;

@end

@implementation DownloadVC {
    NSMutableArray *arrDownload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrDownload = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    self.navigationController.navigationBar.hidden = YES;

    [self.tblDownload registerNib:[UINib nibWithNibName:@"DownloadCell" bundle:nil] forCellReuseIdentifier:@"DownloadCell"];
    self.tblDownload.estimatedRowHeight = 1;
    self.tblDownload.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self localize];
    [self downloadApi];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadApi)
                                                 name:kRefresh
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)localize {
    [Util setPrimaryColorView:self.vwHeader];
    self.lblTitle.text = [MCLocalization stringForKey:@"Download"];
    
    [self.btnContinueShopping setTitle:[MCLocalization stringForKey:@"CONTINUE SHOPPING"] forState:UIControlStateNormal];
    
    [Util setSecondaryColorButtonTitle:self.btnContinueShopping];
    
    [Util setSecondaryColorButtonImage:self.btnContinueShopping image:[UIImage imageNamed:@"MyRewardsButtonBG"]];
    [Util setSecondaryColorImageView:self.imgNoProductArrow];

    self.lblNoProductTitle.text = [MCLocalization stringForKey:@"No Product Found"];
    self.lblNoProductDesc.text = [MCLocalization stringForKey:@"Browse some Other Item"];
    
    if (appDelegate.isRTL) {
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }
}


#pragma mark - UIButton Clicks

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(IBAction)btnContinueShoppingClicked:(id)sender
{
    self.tabBarController.selectedIndex = 0;
    [[self.tabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
}


#pragma mark - UITableView Delegate and DataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadCell" forIndexPath:indexPath];
    
    DownloadProduct *object = [arrDownload objectAtIndex:indexPath.row];
    
    cell.lblTitle.text = object.product_name;
    cell.lblFileName.text = object.download_name;
    if (object.downloads_remaining != 0) {
        cell.lblRemainingData.text = [NSString stringWithFormat:@"%d", object.downloads_remaining];
    } else {
        cell.lblRemainingData.text = @"-";
    }
    cell.lblRemaining.text = [MCLocalization stringForKey:@"Remaining:"];
    
    if (![object.access_expires isEqualToString:@"never"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:locale1];
        NSDate *dateFromString = [dateFormatter dateFromString:object.access_expires];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        cell.lblExpireData.text = [dateFormatter stringFromDate:dateFromString];
    } else {
        cell.lblExpireData.text = @"-";
    }
    cell.lblExpire.text = [MCLocalization stringForKey:@"Expire:"];

    cell.lblTitle.font = Font_Size_Title;
    cell.lblFileName.font = Font_Size_Product_Name;
    cell.lblExpire.font = Font_Size_Product_Name;
    cell.lblExpireData.font = Font_Size_Price_Sale_Yes_Small;
    cell.lblRemaining.font = Font_Size_Product_Name;
    cell.lblRemainingData.font = Font_Size_Price_Sale_Yes_Small;
    
    cell.btnDownload.tag = indexPath.row;
    [cell.btnDownload addTarget:self action:@selector(btnDownloadClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDownload setBackgroundColor:[Util colorWithHexString:[Util getStringData:kPrimaryColor]]];
    
    return cell;
}

-(void)btnDownloadClicked:(UIButton*)btn {
    //open in safari
    DownloadProduct *object = [arrDownload objectAtIndex:btn.tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:object.download_url] options:@{} completionHandler:nil];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrDownload.count;
}

#pragma mark - API calls


-(void)downloadApi {
    SHOW_LOADER_ANIMTION();
    [CiyaShopAPISecurity getDownloadProducts:[[Util getStringData:kUserID] intValue] completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        HIDE_PROGRESS;
        NSLog(@"%@", dictionary);
        if(success == YES)
        {
            //no error
            if (dictionary.count>0)
            {
                if([dictionary isKindOfClass:[NSArray class]])
                {
                    //Is array
                    NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
                    self->arrDownload = [[NSMutableArray alloc] init];
                    for (int i = 0; i < arrData.count; i++)
                    {
                        DownloadProduct *object = [[DownloadProduct alloc] init];
                        object.order_id = [[[arrData objectAtIndex:i] valueForKey:@"order_id"] intValue];
                        object.downloads_remaining = [[[arrData objectAtIndex:i] valueForKey:@"downloads_remaining"] intValue];
                        object.download_name = [[arrData objectAtIndex:i] valueForKey:@"download_name"];
                        object.access_expires = [[arrData objectAtIndex:i] valueForKey:@"access_expires"];
                        object.download_url = [[arrData objectAtIndex:i] valueForKey:@"download_url"];
                        object.product_name = [[arrData objectAtIndex:i] valueForKey:@"product_name"];
                        [self->arrDownload addObject:object];
                    }
                }
                else if([dictionary isKindOfClass:[NSDictionary class]])
                {
                    //is dictionary
                    self->arrDownload = [[NSMutableArray alloc] init];
                }
            } else {
                //Error
                self->arrDownload = [[NSMutableArray alloc] init];
            }
        }
        else
        {
            //error
            self->arrDownload = [[NSMutableArray alloc] init];
        }
        [self.tblDownload reloadData];
        if (self->arrDownload.count == 0) {
            self.vwNoProduct.hidden = false;
        } else {
            self.vwNoProduct.hidden = true;
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
