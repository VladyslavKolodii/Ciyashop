//
//  FilterVC.m
//  QuickClick
//
//  Created by Kaushal PC on 23/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "FilterVC.h"
#import "FilterCell.h"
#import "ColorAndSizeCell.h"
#import "OccasionCell.h"

@interface FilterVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *colColor;

@property (weak, nonatomic) IBOutlet NMRangeSlider *sliderPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblMinPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblMaxPrice;

@property(weak,nonatomic) IBOutlet UITableView *tblFilter;

@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property(weak,nonatomic) IBOutlet UIView *vwColor;
@property(weak,nonatomic) IBOutlet UIView *vwPrice;
@property (strong,nonatomic) IBOutlet UIView *vwLast;
@property(weak,nonatomic) IBOutlet UIScrollView *scrl;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblColour;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@property(weak,nonatomic) IBOutlet UIView *vwAllData;

@property (strong,nonatomic) IBOutlet UIButton *btnClearFilter;
@property (strong,nonatomic) IBOutlet UIButton *btnBack;
@property (strong,nonatomic) IBOutlet UIButton *btnRight;

@end

@implementation FilterVC
{
    NSMutableArray *arrColor, *arrSelectedColor, *arrFilter, *arrFilterData, *arrSelectedAttribute, *arrSelectedValuesForFilter, *arrSelectedRatingValue;
    double sliderMinValue, sliderMaxValue, sliderMinValue1, sliderMaxValue1;
    int selectedCell;
    NSString *strSymbol;
    UIView *vw;
    BOOL isPriceEnable, isRatingEnable;
}
@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.lblMinPrice.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"FilterPriceBg"]];
    self.lblMaxPrice.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"FilterPriceBg"]];

    [self getFilterData];
    
    //nib registration for cell
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.colColor setCollectionViewLayout:flowLayout];

    [self.colColor registerNib:[UINib nibWithNibName:@"ColorAndSizeCell" bundle:nil] forCellWithReuseIdentifier:@"ColorAndSizeCell"];
    
    [self setFrames];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    arrSelectedAttribute = [[NSMutableArray alloc] init];
    arrSelectedRatingValue = [[NSMutableArray alloc] init];
    
    selectedCell = -1;
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
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height);

    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];

    self.vwLast.hidden = NO;
    self.tblFilter.tableFooterView = self.vwLast;
    
    [self.view addSubview:vw];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) setFrames
{
    self.vwPrice.frame=CGRectMake(0, 0, self.vwPrice.frame.size.width, self.vwPrice.frame.size.height);
    float heightPrice = 0;
    if (isPriceEnable)
    {
        heightPrice = self.vwPrice.frame.size.height;
        self.vwPrice.hidden = false;
    }
    else
    {
        heightPrice = 0;
        self.vwPrice.hidden = true;
    }
    if (arrColor.count > 0)
    {
        self.vwColor.frame=CGRectMake(self.vwColor.frame.origin.x, self.vwPrice.frame.origin.y + heightPrice + 8, self.vwColor.frame.size.width, 105);
    }
    else
    {
        self.vwColor.frame=CGRectMake(self.vwColor.frame.origin.x, self.vwPrice.frame.origin.y + heightPrice + 8, self.vwColor.frame.size.width, 0);
    }

    [self.tblFilter reloadData];
    [UIView animateWithDuration:0.4 animations:^{
        self.tblFilter.frame = CGRectMake(0, self.vwColor.frame.origin.y + self.vwColor.frame.size.height + 15, SCREEN_SIZE.width, self.tblFilter.contentSize.height);
        self.scrl.contentSize=CGSizeMake(SCREEN_SIZE.width, self.tblFilter.frame.size.height+self.tblFilter.frame.origin.y + 15);
    }];
}

#pragma mark - Localize Language

- (void)localize
{
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.textColor = OtherTitleColor;
    
    self.lblTitle.text = [MCLocalization stringForKey:@"Filter"];
    self.lblColour.text = [MCLocalization stringForKey:@"Colour"];
    self.lblPrice.text = [MCLocalization stringForKey:@"Price"];
    
    
    self.lblTitle.font = Font_Size_Navigation_Title;
    self.lblColour.font = Font_Size_Title;
    self.lblPrice.font = Font_Size_Title;
    
    [self.btnClearFilter setTitle:[MCLocalization stringForKey:@"Clear Filter"] forState:UIControlStateNormal];
    [Util setSecondaryColorButton:self.btnClearFilter];
    self.btnClearFilter.titleLabel.font=Font_Size_Title;
  
    self.lblPrice.textAlignment = NSTextAlignmentLeft;
    self.lblColour.textAlignment = NSTextAlignmentLeft;
    
    if (appDelegate.isRTL) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        self.btnRight.frame = CGRectMake(0, self.btnRight.frame.origin.y, self.btnRight.frame.size.width, self.btnRight.frame.size.height);
    } else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
        self.btnRight.frame = CGRectMake(SCREEN_SIZE.width - self.btnRight.frame.size.width, self.btnRight.frame.origin.y, self.btnRight.frame.size.width, self.btnRight.frame.size.height);
    }
    [self.tblFilter reloadData];
    
    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

#pragma mark - Button Clicks

-(IBAction)btnClearFilterClicked:(id)sender
{
    NSLog(@"clear filter clicked");
    arrSelectedValuesForFilter = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrFilterData.count; i++)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[[arrFilterData objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [dict setValue:arr forKey:@"options"];
        [dict setValue:[[arrFilterData objectAtIndex:i] valueForKey:@"slug"] forKey:@"slug"];
        [dict setValue:[[arrFilterData objectAtIndex:i] valueForKey:@"id"] forKey:@"id"];
        [arrSelectedValuesForFilter addObject:dict];
    }
    arrSelectedColor = [[NSMutableArray alloc] init];
    arrSelectedRatingValue = [[NSMutableArray alloc] init];
    
    sliderMinValue1 = sliderMinValue;
    sliderMaxValue1 = sliderMaxValue;
    
    [self.colColor reloadData];
    [self.tblFilter reloadData];
    [self setFrames];
    [self configureLabelSlider];
}

-(IBAction)btnApplyFilerClicked:(id)sender
{
    for (int i = 0; i < arrSelectedValuesForFilter.count; i++)
    {
        if ([[[[arrSelectedValuesForFilter objectAtIndex:i] valueForKey:@"name"] lowercaseString] isEqualToString:@"color"])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[arrSelectedValuesForFilter objectAtIndex:i] mutableCopy]];
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            
            if(arrSelectedColor.count > 0 && [[arrSelectedColor objectAtIndex:0] isKindOfClass:[NSDictionary class]])
            {
                //exist
                for (int j = 0; j < arrSelectedColor.count; j++)
                {
                    [arr addObject:[[arrSelectedColor objectAtIndex:j] valueForKey:@"color_name"]];
                }
                [dict setValue:arr forKey:@"options"];
            }
            else
            {
                //not exist
                [dict setValue:arrSelectedColor forKey:@"options"];
            }
            
            [arrSelectedValuesForFilter removeObjectAtIndex:i];
            [arrSelectedValuesForFilter insertObject:dict atIndex:i];
            break;
        }
    }
    for (int i = (int)arrSelectedValuesForFilter.count - 1; i >= 0; i--)
    {
        if ([[[arrSelectedValuesForFilter objectAtIndex:i] valueForKey:@"options"] count] == 0)
        {
            [arrSelectedValuesForFilter removeObjectAtIndex:i];
        }
    }
    if (delegate)
    {
        if (isPriceEnable)
        {
            [delegate applyFilter:arrSelectedValuesForFilter minPrice:sliderMinValue1 maxPrice:sliderMaxValue1 rating:arrSelectedRatingValue];
        }
        else
        {
            [delegate applyFilter:arrSelectedValuesForFilter minPrice:0 maxPrice:0 rating:arrSelectedRatingValue];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrColor.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ColorAndSizeCell";
    
    ColorAndSizeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ColorAndSizeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    BOOL flag = NO;
    for (int i = 0; i < arrSelectedColor.count; i++)
    {
        
        if([[arrSelectedColor objectAtIndex:i] isKindOfClass:[NSDictionary class]])
        {
            //exist
            if ([[[arrSelectedColor objectAtIndex:i] valueForKey:@"color_name"] isEqualToString:[[arrColor objectAtIndex:indexPath.row] valueForKey:@"color_name"]])
            {
                flag = YES;
                break;
            }
        }
        else
        {
            //not exist
            if ([[arrSelectedColor objectAtIndex:i] isEqualToString:[arrColor objectAtIndex:indexPath.row]])
            {
                flag = YES;
                break;
            }
        }

    }
    if (flag == YES)
    {
        if ([fromServer isEqualToString:@"1"])
        {
            cell.imgBG.image = [UIImage imageNamed:@"SizeColorSelectedBG"];
            [Util setPrimaryColorImageView:cell.imgBG];
        }
        else
        {
            cell.imgBG.image = [UIImage imageNamed:@"SizeColorSelectedBG"];
        }

        cell.imgBG.hidden = NO;
    }
    else
    {
        cell.imgBG.hidden = YES;
    }
    if([[arrColor objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]])
    {
        //exist
        NSString *str = [[arrColor objectAtIndex:indexPath.row] valueForKey:@"color_code"];
        
        if ([str containsString:@"#"])
        {
            str = [str stringByReplacingOccurrencesOfString:@"#" withString:@""];
        }
        if ([str isEqualToString:@""])
        {
            [cell.imgIcon setBackgroundColor:UIColor.blackColor];
        }
        else
        {
            [cell.imgIcon setBackgroundColor:[Util colorWithHexString:str]];
        }
        cell.lblTitle.hidden = YES;
    }
    else
    {
        //not exist
        cell.lblTitle.text = [arrColor objectAtIndex:indexPath.row];
    }
    
    cell.imgRightTick.hidden=YES;
    
    return cell;
}

- (BOOL)containsKey: (NSString *)key dict:(NSDictionary*)dict{
    BOOL retVal = 0;
    NSArray *allKeys = [dict allKeys];
    retVal = [allKeys containsObject:key];
    return retVal;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL flag = NO;
    int pos = -1;
    if([[arrColor objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]])
    {
        //exist
        for (int i = 0; i < arrSelectedColor.count; i++)
        {
            if ([[[arrSelectedColor objectAtIndex:i] valueForKey:@"color_name"] isEqualToString:[[arrColor objectAtIndex:indexPath.row] valueForKey:@"color_name"]])
            {
                flag = YES;
                pos = i;
                break;
            }
        }
        if (flag == YES)
        {
            [arrSelectedColor removeObjectAtIndex:pos];
        }
        else
        {
            [arrSelectedColor addObject:[arrColor objectAtIndex:indexPath.row]];
        }
    }
    else
    {
        //not exist
        for (int i = 0; i < arrSelectedColor.count; i++)
        {
            if ([[arrSelectedColor objectAtIndex:i] isEqualToString:[arrColor objectAtIndex:indexPath.row]])
            {
                flag = YES;
                pos = i;
                break;
            }
        }
        if (flag == YES)
        {
            [arrSelectedColor removeObjectAtIndex:pos];
        }
        else
        {
            [arrSelectedColor addObject:[arrColor objectAtIndex:indexPath.row]];
        }
    }
    [self.colColor reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.height - 2, collectionView.frame.size.height - 2);
}

#pragma mark - Price Slider

- (void) configureLabelSlider
{
    self.sliderPrice.minimumValue = sliderMinValue;
    self.sliderPrice.maximumValue = sliderMaxValue;
    
    self.sliderPrice.upperValue = sliderMaxValue1;
    self.sliderPrice.lowerValue = sliderMinValue1;

    self.sliderPrice.minimumRange = 1;
    self.sliderPrice.tintColor = [Util colorWithHexString:@"323232"];
    
    [self updateSliderLabels];
}

-(void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.sliderPrice.lowerCenter.x + self.sliderPrice.frame.origin.x);
    lowerCenter.y = (self.sliderPrice.center.y - 30.0f);
    self.lblMinPrice.text = [NSString stringWithFormat:@"%@  %d", strSymbol, (int)self.sliderPrice.lowerValue];
    sliderMinValue1 = self.sliderPrice.lowerValue;
    
    CGPoint upperCenter;
    upperCenter.x = (self.sliderPrice.upperCenter.x + self.sliderPrice.frame.origin.x);
    upperCenter.y = (self.sliderPrice.center.y - 30.0f);
    self.lblMaxPrice.text = [NSString stringWithFormat:@"%@  %d", strSymbol, (int)self.sliderPrice.upperValue];
    sliderMaxValue1 = self.sliderPrice.upperValue;
}

// Handle control value changed events just like a normal slider
- (IBAction)priceValueChanged:(NMRangeSlider*)sender
{
    [self updateSliderLabels];
}
#pragma mark - UITableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 103)
    {
        //table Filter
        return arrFilter.count;
    }
    else
    {
        return [[[arrFilter objectAtIndex:tableView.tag] valueForKey:@"options"] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 103)
    {
        static NSString *simpleTableIdentifier = @"FilterCell";
        
        FilterCell *cell = (FilterCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.lblTitle.text = [[arrFilter objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.lblTitle.font=Font_Size_Product_Name_Not_Bold;
        selectedCell = (int)indexPath.row;
        cell.tblData.tag = indexPath.row;
        cell.tblData.delegate = self;
        cell.tblData.dataSource = self;
        [cell.tblData reloadData];
        
        cell.btnData.tag = indexPath.row;
        [cell.btnData addTarget:self action:@selector(btnCellClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.tblData.frame = CGRectMake(cell.tblData.frame.origin.x, cell.tblData.frame.origin.y, cell.tblData.frame.size.width, cell.tblData.contentSize.height);
        
        BOOL Flag = NO;
        for (int  i = 0; i < arrSelectedAttribute.count; i++)
        {
            if (indexPath.row == [[arrSelectedAttribute objectAtIndex:i] integerValue])
            {
                Flag = YES;
                break;
            }
        }
        if (Flag)
        {
            cell.imgArrow.transform = CGAffineTransformMakeRotation(M_PI_2); //rotation in radians
        }
        else
        {
            //rotate arrow to normal
            [UIView animateWithDuration:0.1 animations:^{
                cell.imgArrow.transform = CGAffineTransformMakeRotation(0); //rotation in radians
            }];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *simpleTableIdentifier = @"OccasionCell";
        
        OccasionCell *cell = (OccasionCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OccasionCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSInteger index = tableView.tag;
        
        
        if ([[[[arrFilter objectAtIndex:index] valueForKey:@"name"] lowercaseString] isEqualToString:@"rating"])
        {
            //code for rating
            cell.lblOccasionName.text = @"";

            HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] init];
            
            if (appDelegate.isRTL) {
                //frame for rtl
                starRatingView.frame = CGRectMake(cell.imgSelectionImage.frame.origin.x - 110, cell.frame.size.height/2 - 15, 100, 30);
            } else {
                //not rtl frame
                starRatingView.frame = CGRectMake(10, cell.frame.size.height/2 - 15, 100, 30);
            }
            starRatingView.maximumValue = 5;
            starRatingView.minimumValue = 0;
            starRatingView.allowsHalfStars = YES;
            starRatingView.accurateHalfStars = YES;
            
            starRatingView.backgroundColor = [UIColor clearColor];
            starRatingView.tintColor = [Util colorWithHexString:@"ffcc00"];
            
            starRatingView.userInteractionEnabled = NO;

            NSString *rating = [[[arrFilter objectAtIndex:index] valueForKey:@"options"] objectAtIndex:indexPath.row];

            float value = [rating floatValue];
            starRatingView.value = value;
            
            [cell addSubview:starRatingView];
            
            
            if ([arrSelectedRatingValue containsObject:rating])
            {
                cell.imgSelectionImage.image = [UIImage imageNamed:@"FilterSelect"];
                [Util setPrimaryColorImageView:cell.imgSelectionImage];
            }
            else
            {
                cell.imgSelectionImage.image = [UIImage imageNamed:@"FilterDeselect"];
            }
        }
        else
        {
            cell.lblOccasionName.text = [[[arrFilter objectAtIndex:index] valueForKey:@"options"] objectAtIndex:indexPath.row];
            cell.lblOccasionName.font=Font_Size_Product_Name_Not_Bold;
            
            for (int  i = 0; i < arrSelectedValuesForFilter.count; i++)
            {
                if ([[[arrSelectedValuesForFilter objectAtIndex:i] valueForKey:@"name"] isEqualToString:[[arrFilter objectAtIndex:index] valueForKey:@"name"]])
                {
                    if ([[[arrSelectedValuesForFilter objectAtIndex:i] valueForKey:@"options"] containsObject:[[[arrFilter objectAtIndex:index] valueForKey:@"options"] objectAtIndex:indexPath.row]])
                    {
                        cell.imgSelectionImage.image = [UIImage imageNamed:@"FilterSelect"];
                        [Util setPrimaryColorImageView:cell.imgSelectionImage];
                    }
                    else
                    {
                        cell.imgSelectionImage.image = [UIImage imageNamed:@"FilterDeselect"];
                    }
                    break;
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)btnCellClicked:(UIButton*)sender
{
    [self.tblFilter beginUpdates];

    NSInteger index = sender.tag;
    BOOL Flag = NO;
    int pos = -1;
    for (int  i = 0; i < arrSelectedAttribute.count; i++)
    {
        if (index == [[arrSelectedAttribute objectAtIndex:i] integerValue])
        {
            Flag = YES;
            pos  = i;
            break;
        }
    }
    FilterCell *cell=[self.tblFilter cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (Flag)
    {
        [arrSelectedAttribute removeObjectAtIndex:pos];
        [UIView animateWithDuration:0.1 animations:^{
            cell.imgArrow.transform = CGAffineTransformMakeRotation(0); //rotation in radians
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            cell.imgArrow.transform = CGAffineTransformMakeRotation(M_PI_2); //rotation in radians
        }];

        [arrSelectedAttribute addObject:[NSString stringWithFormat:@"%ld",index]];
        selectedCell = (int)index;
    }

    [self.tblFilter endUpdates];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tblFilter.frame = CGRectMake(0, self.vwColor.frame.origin.y + self.vwColor.frame.size.height + 15, SCREEN_SIZE.width, self.tblFilter.contentSize.height);
        self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.tblFilter.frame.size.height + self.tblFilter.frame.origin.y + 15);
    }];
    
    [self performSelector:@selector(setFrames) withObject:nil afterDelay:0.4];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 103)
    {
        BOOL Flag = NO;
        for (int  i = 0; i < arrSelectedAttribute.count; i++)
        {
            if (indexPath.row == [[arrSelectedAttribute objectAtIndex:i] integerValue])
            {
                Flag = YES;
                break;
            }
        }
        if (Flag)
        {
            selectedCell = (int)indexPath.row;
            return 60 + ([[[arrFilter objectAtIndex:selectedCell] valueForKey:@"options"] count]*35);
        }
        else
        {
            return 60;
        }
    }
    return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 103)
    {
        //tbl FIlter
    }
    else
    {
        //subtable for filter
        NSInteger index = tableView.tag;
        
        if ([[[[arrFilter objectAtIndex:index] valueForKey:@"name"] lowercaseString] isEqualToString:@"rating"])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[arrFilter objectAtIndex:index]];

            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[dict valueForKey:@"options"] mutableCopy]];

            NSString *rating = [arr objectAtIndex:indexPath.row];
            if ([arrSelectedRatingValue containsObject:rating])
            {
                [arrSelectedRatingValue removeObject:rating];
            }
            else
            {
                [arrSelectedRatingValue addObject:rating];
            }
        }
        else
        {
            for (int  i = 0; i < arrSelectedValuesForFilter.count; i++)
            {
                if ([[[arrSelectedValuesForFilter objectAtIndex:i] valueForKey:@"name"] isEqualToString:[[arrFilter objectAtIndex:index] valueForKey:@"name"]])
                {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[arrSelectedValuesForFilter objectAtIndex:i]];
                    
                    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[dict valueForKey:@"options"] mutableCopy]];
                    
                    if ([arr containsObject:[[[arrFilter objectAtIndex:index] valueForKey:@"options"] objectAtIndex:indexPath.row]])
                    {
                        [arr removeObject:[[[arrFilter objectAtIndex:index] valueForKey:@"options"] objectAtIndex:indexPath.row]];
                    }
                    else
                    {
                        [arr addObject:[[[arrFilter objectAtIndex:index] valueForKey:@"options"] objectAtIndex:indexPath.row]];
                    }
                    [dict setObject:arr forKey:@"options"];
                    [arrSelectedValuesForFilter removeObjectAtIndex:i];
                    [arrSelectedValuesForFilter insertObject:dict atIndex:i];
                    break;
                }
            }
        }
        [tableView reloadData];
    }
}

#pragma mark - API calls

-(void)getFilterData
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%d", self.categoryId] forKey:@"category"];
    
    [CiyaShopAPISecurity getAttributes:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        if (success)
        {
            HIDE_PROGRESS;
            if (dictionary.count > 0)
            {
                if ([[dictionary valueForKey:@"price_filter_status"] isEqualToString:@"enable"])
                {
                    self->isPriceEnable = true;
                    self->sliderMinValue = [[[dictionary valueForKey:@"price_filter"] valueForKey:@"min_price"] doubleValue];
                    self->sliderMaxValue = [[[dictionary valueForKey:@"price_filter"] valueForKey:@"max_price"] doubleValue];
                    if (self->sliderMaxValue == self->sliderMinValue)
                    {
                        self->sliderMinValue = 0;
                    }
                }
                else
                {
                    self->isPriceEnable = false;
                    self->sliderMinValue = 0;
                    self->sliderMaxValue = 0;
                }
                
                self->strSymbol = [[dictionary valueForKey:@"price_filter"] valueForKey:@"currency_symbol"];
                
                for (int i = 0; i < [[dictionary valueForKey:@"filters"] count]; i++)
                {
                    if ([[[[[dictionary valueForKey:@"filters"] objectAtIndex:i] valueForKey:@"name"] lowercaseString] isEqualToString:@"color"])
                    {
                        //it is Color
                        self->arrColor = [[NSMutableArray alloc] initWithArray:[[[[dictionary valueForKey:@"filters"] objectAtIndex:i] valueForKey:@"options"] mutableCopy]];
                    }
                }
                self->arrFilter = [[NSMutableArray alloc] initWithArray:[[dictionary valueForKey:@"filters"] mutableCopy]];
                self->arrFilterData = [[NSMutableArray alloc] initWithArray:[[dictionary valueForKey:@"filters"] mutableCopy]];
                self->arrSelectedColor = [[NSMutableArray alloc] init];
                [self.colColor reloadData];
                
                if (self->arrColor.count > 0)
                {
                    for(int i  = 0; i < self->arrFilter.count; i++)
                    {
                        if ([[[[self->arrFilter objectAtIndex:i] valueForKey:@"name"]lowercaseString] isEqualToString:@"color"])
                        {
                            [self->arrFilter removeObjectAtIndex:i];
                            break;
                        }
                    }
                }
                
                for(int i  = 0; i < self->arrFilter.count; i++)
                {
                    NSArray *arr = [[self->arrFilter objectAtIndex:i] valueForKey:@"options"];
                    if (arr.count == 0)
                    {
                        [self->arrFilter removeObjectAtIndex:i];
                    }
                }
                
                if ([[dictionary valueForKey:@"rating_filters_status"] isEqualToString:@"enable"])
                {
                    self->isRatingEnable = true;
                }
                else
                {
                    self->isRatingEnable = false;
                }

                self->arrSelectedValuesForFilter = [[NSMutableArray alloc] init];
                for (int i = 0; i < self->arrFilterData.count; i++)
                {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setValue:[[self->arrFilterData objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    [dict setValue:arr forKey:@"options"];
                    [dict setValue:[[self->arrFilterData objectAtIndex:i] valueForKey:@"slug"] forKey:@"slug"];
                    [dict setValue:[[self->arrFilterData objectAtIndex:i] valueForKey:@"id"] forKey:@"id"];
                    [self->arrSelectedValuesForFilter addObject:dict];
                }
                
                if (self.fromAppliedFilter)
                {
                    self->arrSelectedValuesForFilter = [[NSMutableArray alloc] initWithArray:[self.arrSelectedValuesfromFilter mutableCopy]];
                    self->arrSelectedRatingValue = [[NSMutableArray alloc] initWithArray:[self.arrSelectedRatingValues mutableCopy]];

                    self->sliderMaxValue1 = self.sliderMaxValuefromFilter;
                    self->sliderMinValue1 = self.sliderMinValuefromFilter;
                    
                    self->arrSelectedColor = [[NSMutableArray alloc] init];

                    for (int i = 0; i < [[self->arrSelectedValuesForFilter valueForKey:@"attribute"] count]; i++)
                    {
                        if ([[[[self->arrSelectedValuesForFilter objectAtIndex:i] valueForKey:@"name"] lowercaseString] isEqualToString:@"color"])
                        {
                            for (int j = 0; j < [[[self->arrSelectedValuesForFilter objectAtIndex:i] valueForKey:@"options"] count]; j++)
                            {
                                for (int k = 0; k < self->arrColor.count; k++)
                                {
                                    if([[self->arrColor objectAtIndex:k] isKindOfClass:[NSDictionary class]])
                                    {
                                        //exist
                                        
                                        if ([[[[[self->arrSelectedValuesForFilter objectAtIndex:i] valueForKey:@"options"] objectAtIndex:j] lowercaseString] isEqualToString:[[[self->arrColor objectAtIndex:k] valueForKey:@"color_name"]lowercaseString]])
                                        {
                                            [self->arrSelectedColor addObject:[self->arrColor objectAtIndex:k]];
                                        }
                                    }
                                    else
                                    {
                                        //not exist
                                        if ([[[[[self->arrSelectedValuesForFilter objectAtIndex:i] valueForKey:@"options"] objectAtIndex:j] lowercaseString] isEqualToString:[[self->arrColor objectAtIndex:k]lowercaseString]])
                                        {
                                            [self->arrSelectedColor addObject:[self->arrColor objectAtIndex:k]];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (self->isPriceEnable)
                {
                    self->sliderMinValue1 = [[[dictionary valueForKey:@"price_filter"] valueForKey:@"min_price"] doubleValue];
                    self->sliderMaxValue1 = [[[dictionary valueForKey:@"price_filter"] valueForKey:@"max_price"] doubleValue];
                }
                else
                {
                    self->sliderMinValue1 = 0;
                    self->sliderMaxValue1 = 0;
                }
                [self.colColor reloadData];
                [self.tblFilter reloadData];
                
                [self setFrames];
                if (self->isPriceEnable) {
                    [self configureLabelSlider];
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
        HIDE_PROGRESS;
    }];
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
