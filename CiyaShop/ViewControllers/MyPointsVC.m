//
//  MyPointsVC.m
//  CiyaShop
//
//  Created by potenza on 10/05/18.
//  Copyright © 2018 Potenza. All rights reserved.
//

#import "MyPointsVC.h"
#import "MyPoints.h"
#import "MyPointsCell.h"

@interface MyPointsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *vwHeader;
@property (weak, nonatomic) IBOutlet UIView *vwAllData;
@property (weak, nonatomic) IBOutlet UIView *vwTbl;
@property (weak, nonatomic) IBOutlet UIView *vwNoAnyProduct;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPointsTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPoints;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblEvent;
@property (weak, nonatomic) IBOutlet UILabel *lblPoint;
@property (weak, nonatomic) IBOutlet UILabel *lblLine;

@property (weak, nonatomic) IBOutlet UILabel *lblNoItemEarned;
@property (weak, nonatomic) IBOutlet UILabel *lblBuyProduct;

@property (weak, nonatomic) IBOutlet UITableView *tblMyPoint;

@property (weak, nonatomic) IBOutlet UIButton *btnContinueShopping;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@end

@implementation MyPointsVC
{
    UIView *vw;
    NSMutableArray *arrPoints;
    int total_rows,page;
    BOOL apiCallRunning;
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    page = 1;
    [self GetAllPoints];
    arrPoints = [[NSMutableArray alloc] init];
    self.vwNoAnyProduct.hidden = YES;

    [self localize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    [self HideOtherLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} 


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
    
    [self.lblPointsTitle sizeToFit];
    
    if (appDelegate.isRTL) {
        
        self.lblPoints.textAlignment = NSTextAlignmentRight;
        self.lblPointsTitle.frame = CGRectMake(SCREEN_SIZE.width - self.lblPointsTitle.frame.origin.x - self.lblPointsTitle.frame.size.width, self.lblPointsTitle.frame.origin.y, self.lblPointsTitle.frame.size.width, self.lblPointsTitle.frame.size.height);
        self.lblPoints.frame = CGRectMake(self.lblPointsTitle.frame.origin.x - self.lblPoint.frame.size.width - 15, self.lblPoints.frame.origin.y, self.lblPoints.frame.size.width, self.lblPoints.frame.size.height);
        
        self.lblEvent.textAlignment = NSTextAlignmentRight;
        self.lblDate.textAlignment = NSTextAlignmentRight;
        self.lblPoint.textAlignment = NSTextAlignmentLeft;
        
        self.lblEvent.frame = CGRectMake(self.vwTbl.frame.size.width - self.lblEvent.frame.origin.x - self.lblEvent.frame.size.width, self.lblEvent.frame.origin.y, self.lblEvent.frame.size.width, self.lblEvent.frame.size.height);
        self.lblDate.frame = CGRectMake(self.vwTbl.frame.size.width - self.lblDate.frame.origin.x - self.lblDate.frame.size.width, self.lblDate.frame.origin.y, self.lblDate.frame.size.width, self.lblDate.frame.size.height);
        self.lblPoint.frame = CGRectMake(self.vwTbl.frame.size.width - self.lblPoint.frame.origin.x - self.lblPoint.frame.size.width, self.lblPoint.frame.origin.y, self.lblPoint.frame.size.width, self.lblEvent.frame.size.height);
    }
    [Util setSecondaryColorButtonImage:self.btnContinueShopping image:[UIImage imageNamed:@"MyRewardsButtonBG"]];
    [Util setSecondaryColorImageView:self.imgArrow];
}




#pragma mark - Localize Language

/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)localize
{
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.textColor = OtherTitleColor;
    self.lblTitle.font=Font_Size_Navigation_Title;

    
    self.lblPointsTitle.font=Font_Size_Title;
    self.lblPoints.font=Font_Size_Title;
    
    self.lblPoints.textAlignment=NSTextAlignmentLeft;
    
    [Util setPrimaryColorLabelText:self.lblPoints];
    
    self.lblTitle.text = [MCLocalization stringForKey:@"My Points"];
    self.lblPointsTitle.text = [MCLocalization stringForKey:@"You have Points"];

    
    
    self.lblDate.text  = [MCLocalization stringForKey:@"Date"];
    self.lblEvent.text = [MCLocalization stringForKey:@"Event"];
    self.lblPoint.text = [MCLocalization stringForKey:@"Points"];

    
    
    self.lblDate.font=Font_Size_Navigation_Title_Medium;
    self.lblEvent.font=Font_Size_Navigation_Title_Medium;
    self.lblPoint.font=Font_Size_Navigation_Title_Medium;


    
    self.vwTbl.layer.borderWidth=0.5;
    self.vwTbl.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    
    self.lblTitle.textColor = OtherTitleColor;
    [Util setHeaderColorView:self.vwHeader];
    
    self.lblBuyProduct.text = [MCLocalization stringForKey:@"Purchase product and earn Points."];
    self.lblNoItemEarned.text = [MCLocalization stringForKey:@"No Points Earned"];
    [self.btnContinueShopping setTitle:[MCLocalization stringForKey:@"CONTINUE SHOPPING"] forState:UIControlStateNormal];
    
    [Util setSecondaryColorButtonTitle:self.btnContinueShopping];

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

}


#pragma mark - UITableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)arrPoints.count);
    return arrPoints.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MyPointsCell";
    
    MyPointsCell *cell = (MyPointsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyPointsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblDate.font=Font_Size_Product_Name_Medium;
    cell.lblEvent.font=Font_Size_Product_Name_Medium;
    cell.lblPoint.font=Font_Size_Product_Name_Medium;

    MyPoints *point=[arrPoints objectAtIndex:indexPath.row];
    cell.lblPoint.text=point.strPoints;
    cell.lblEvent.text=point.strDescription;
    cell.lblDate.text=point.strDate;
    
    if ((arrPoints.count-1)==indexPath.row)
    {
        cell.lblLine.hidden=YES;
        if (arrPoints.count<total_rows)
        {
                if (!apiCallRunning)
                {
         
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                    //Background Thread
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self->apiCallRunning = YES;
                            [self GetAllPoints];
                        });
                    });
            }
        }
    }
    else
    {
                cell.lblLine.hidden = NO;
    }
    
    if (appDelegate.isRTL) {
        cell.lblEvent.textAlignment = NSTextAlignmentRight;
        cell.lblDate.textAlignment = NSTextAlignmentRight;
        cell.lblPoint.textAlignment = NSTextAlignmentLeft;
        
        cell.lblEvent.frame = CGRectMake(cell.frame.size.width - cell.lblEvent.frame.origin.x - cell.lblEvent.frame.size.width, cell.lblEvent.frame.origin.y, cell.lblEvent.frame.size.width, cell.lblEvent.frame.size.height);
        cell.lblDate.frame = CGRectMake(cell.frame.size.width - cell.lblDate.frame.origin.x - cell.lblDate.frame.size.width, cell.lblDate.frame.origin.y, cell.lblDate.frame.size.width, cell.lblDate.frame.size.height);
        cell.lblPoint.frame = CGRectMake(cell.frame.size.width - cell.lblPoint.frame.origin.x - cell.lblPoint.frame.size.width, cell.lblPoint.frame.origin.y, cell.lblPoint.frame.size.width, cell.lblEvent.frame.size.height);
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - ButtonClicks
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnContinueShoppingClicked:(id)sender
{
    self.tabBarController.selectedIndex = 0;
    [[self.tabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
}


#pragma mark - API calls
/*!
 * @discussion This method is used to get Points
 */
- (void)GetAllPoints
{
    if (page==1) {
            SHOW_LOADER_ANIMTION();
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    [dict setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    apiCallRunning = YES;

    
    [CiyaShopAPISecurity getRewardPoints:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        HIDE_PROGRESS;
        NSLog(@"%@", dictionary);
        self->apiCallRunning = NO;
        self->page++;
        if (success)
        {
            
            NSArray *arr=[[dictionary valueForKey:@"data"] valueForKey:@"events"];
            if (arr.count>0)
            {
                [self ShowOtherLabel];
                for (int i = 0; i < arr.count; i++)
                {
                    MyPoints *myPoints = [[MyPoints alloc] init];
                    myPoints.strDescription = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] valueForKey:@"description"]];
                    myPoints.strDate = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] valueForKey:@"date_display_human"]];
                    myPoints.strPoints = [[arr objectAtIndex:i] valueForKey:@"points"];
                    [self->arrPoints addObject:myPoints];
                }
                [self.tblMyPoint reloadData];
                if (self.tblMyPoint.contentSize.height<SCREEN_SIZE.height-196) {
                    self.vwTbl.frame = CGRectMake(self.vwTbl.frame.origin.x,self.vwTbl.frame.origin.y, self.vwTbl.frame.size.width,self.tblMyPoint.contentSize.height+45);
                }
                else
                {
                    self.vwTbl.frame = CGRectMake(self.vwTbl.frame.origin.x,self.vwTbl.frame.origin.y, self.vwTbl.frame.size.width,(SCREEN_SIZE.height - 196));
                }
                
                self.lblPoints.text = [NSString stringWithFormat:@"%@",[[dictionary valueForKey:@"data"] valueForKey:@"points_balance"]];
                [self.lblPoints sizeToFit];

                self->total_rows = [[[dictionary valueForKey:@"data"] valueForKey:@"total_rows"] intValue];
            }
            else
            {
                [self HideOtherLabel];
                [self ShowNoPointEarned];
            }
        } else
        {
//            ALERTVIEW([dictionary valueForKey:@"data"]valueForKey:@"msg"], self);
        }
    }];
}

-(void)HideOtherLabel
{
    self.vwTbl.hidden=YES;
    self.lblPoint.hidden=YES;
    self.lblLine.hidden=YES;
    self.lblPointsTitle.hidden=YES;

}
-(void)ShowOtherLabel
{
    self.vwTbl.hidden=NO;
    self.lblPoint.hidden=NO;
    self.lblLine.hidden=NO;
    self.lblPointsTitle.hidden=NO;
    self.vwNoAnyProduct.hidden=YES;
}

-(void)ShowNoPointEarned
{
            self.vwNoAnyProduct.hidden = NO;
            self.vwNoAnyProduct.frame = CGRectMake(SCREEN_SIZE.width, self.vwNoAnyProduct.frame.origin.y, SCREEN_SIZE.width, self.vwNoAnyProduct.frame.size.height);
            [UIView animateWithDuration:0.4 animations:^{
                
                self.vwNoAnyProduct.frame = CGRectMake(0, self.vwNoAnyProduct.frame.origin.y, SCREEN_SIZE.width, self.vwNoAnyProduct.frame.size.height);
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
