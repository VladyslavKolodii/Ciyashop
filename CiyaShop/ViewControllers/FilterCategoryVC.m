//
//  FilterCategoryVC.m
//  QuickClick
//
//  Created by Kaushal PC on 22/08/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "FilterCategoryVC.h"
#import "SearchCell.h"

@interface FilterCategoryVC ()

@property (strong, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITableView *tblData;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@end

@implementation FilterCategoryVC
{
    NSMutableArray *arrCategory;
    UIView *vw;
}
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrCategory = [[NSMutableArray alloc] init];
    
    [Util setHeaderColorView:self.vwHeader];

    for (int i = 0; i < appDelegate.arrCategory.count; i++)
    {
        if ([[[appDelegate.arrCategory objectAtIndex:i] valueForKey:@"parent"] intValue] == 0)
        {
            [arrCategory addObject:[appDelegate.arrCategory objectAtIndex:i]];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    [self localize];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}

- (void)localize
{

    self.lblTitle.text=[MCLocalization stringForKey:@"Category"];
    self.lblTitle.font=Font_Size_Navigation_Title;
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

    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [Util setHeaderColorView:vw];
}
#pragma mark - Button Clicks

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrCategory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SearchCell";
    
    SearchCell *cell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblTitle.text = [[arrCategory objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.lblTitle.font = Font_Size_Product_Name_Not_Bold;

    [cell.imgIcon sd_setImageWithURL:[Util EncodedURL:[[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"image"] valueForKey:@"src"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        cell.imgIcon.image = image;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appDelegate.isRTL)
        {
            //RTL
            cell.vwImage.frame = CGRectMake(cell.frame.size.width - 15 - cell.vwImage.frame.size.width, cell.vwImage.frame.origin.y, cell.vwImage.frame.size.width, cell.vwImage.frame.size.height);
            
            cell.lblTitle.frame = CGRectMake(cell.frame.size.width - cell.lblTitle.frame.size.width - 58, cell.lblTitle.frame.origin.y, cell.lblTitle.frame.size.width, cell.lblTitle.frame.size.height);
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
            cell.imgArrow.frame = CGRectMake(17, cell.imgArrow.frame.origin.y, cell.imgArrow.frame.size.width, cell.imgArrow.frame.size.height);
            
            cell.imgArrow.transform = CGAffineTransformMakeRotation(M_PI); //rotation in radians
        }
        else
        {
            //No RTL
            cell.lblTitle.frame = CGRectMake(58, cell.lblTitle.frame.origin.y, cell.lblTitle.frame.size.width, cell.lblTitle.frame.size.height);
            cell.lblTitle.textAlignment = NSTextAlignmentLeft;
        }
    });
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (delegate)
    {
        [delegate setCategory:[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"id"]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - hide Bottom Bar

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
