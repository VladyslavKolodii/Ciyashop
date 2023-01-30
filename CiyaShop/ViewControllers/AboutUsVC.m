//
//  AboutUsVC.m
//  QuickClick
//
//  Created by Kaushal PC on 16/09/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "AboutUsVC.h"
#import "SocialCell.h"
#import "ContentVC.h"

@interface AboutUsVC ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrl;
@property (strong, nonatomic) IBOutlet UIView *vwHeader;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblContent;

@property (strong, nonatomic) IBOutlet UILabel *lblVersion;
@property (strong, nonatomic) IBOutlet UILabel *lblCopyRight;
@property (strong, nonatomic) IBOutlet UILabel *lblMoreAboutUs;
@property (strong, nonatomic) IBOutlet UILabel *lblFollowUs;

@property (strong, nonatomic) IBOutlet UICollectionView *colSocial;

@property (strong, nonatomic) IBOutlet UIButton *btnTermsAndCondition;
@property (strong, nonatomic) IBOutlet UIButton *btnPrivacyPolicy;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@end

@implementation AboutUsVC
{
    NSMutableArray *arrSocialKey, *arrSocialValues;
    NSArray *arrData, *arrContentData;
    UIView *vw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([Util getStringData:kAppNameImage] !=nil){
        
        [self.imgLogo sd_setImageWithURL:[Util EncodedURL:[Util getStringData:kAppNameImage]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image == nil)
            {
                self.imgLogo.image = [UIImage imageNamed:@"LogoContactUs"];
            }
            else
            {
                self.imgLogo.image = image;
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
    [self localize];
    [self getContentMainData];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];    
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [Util setHeaderColorView:vw];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Localize Language
/*!
 * @discussion This method is Localize the App (Change Language)
 */
-(void)localize
{
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.text = [MCLocalization stringForKey:@"About Us"];
    self.lblTitle.textColor = OtherTitleColor;
    
    self.lblVersion.text = [NSString stringWithFormat:@"%@ %@", [MCLocalization stringForKey:@"Version"], [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]];
    self.lblFollowUs.text = [MCLocalization stringForKey:@"Follow Us"];
    self.lblMoreAboutUs.text = [MCLocalization stringForKey:@"More about us"];
    
    self.lblCopyRight.text = [MCLocalization stringForKey:@"© CiyaShop 2018 | All Rights Reserved"];
    
    [Util setPrimaryColorButtonTitle:self.btnPrivacyPolicy];
    
    [Util setPrimaryColorButtonTitle:self.btnTermsAndCondition];

    self.lblFollowUs.font = Font_Size_Price_Sale_Bold;
    self.lblMoreAboutUs.font = Font_Size_Price_Sale_Bold;
    
    self.lblVersion.font = Font_Size_Title_Not_Bold;
    self.lblCopyRight.font = Font_Size_Title_Not_Bold;

    self.btnTermsAndCondition.titleLabel.font = Font_Size_Title_Not_Bold;
    self.btnPrivacyPolicy.titleLabel.font = Font_Size_Title_Not_Bold;
    
    [self.btnTermsAndCondition setTitle:[MCLocalization stringForKey:@"Terms & Conditions"] forState:UIControlStateNormal];
    [self.btnPrivacyPolicy setTitle:[MCLocalization stringForKey:@"Privacy Policy"] forState:UIControlStateNormal];
    if (appDelegate.isRTL)
    {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        self.lblContent.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
        self.lblContent.textAlignment = NSTextAlignmentLeft;
    }
}



#pragma mark - Button Clicked

/*!
 * @discussion To go previous page
 * @param sender For indentifying sender
 */
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*!
 * @discussion Will take you to TermsCondition page
 * @param sender For indentifying sender
 */
-(IBAction)btnTermsConditionClicked:(id)sender
{
    ContentVC *vc = [[ContentVC alloc] initWithNibName:@"ContentVC" bundle:nil];
    vc.Page = 1;    //1 then terms of use
    vc.strTitle = [MCLocalization stringForKey:@"Terms of Use"];
    vc.contentID = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
/*!
 * @discussion Will take you to PrivacyPolicy
 * @param sender For indentifying sender
 */
-(IBAction)btnPrivayPolicyClicked:(id)sender
{
    ContentVC *vc = [[ContentVC alloc] initWithNibName:@"ContentVC" bundle:nil];
    vc.Page = 2;    //2 then Privacy Policy
    vc.strTitle = [MCLocalization stringForKey:@"Privacy Policy"];
    vc.contentID = 2;
    [self.navigationController pushViewController:vc animated:YES];
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
//    [[UIApplication sharedApplication] openURL:_url];
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


#pragma mark - API Calls
/*!
 * @discussion Webservice call for the getting Data of About us
 */
-(void)getContentMainData
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"about_us" forKey:@"page"];
    
    [CiyaShopAPISecurity getStaticPages:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
                
        if (success)
        {
            if (dictionary.count > 0)
            {
                if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
                {
                    NSString * htmlString = [dictionary valueForKey:@"data"];
                    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                    
                    self.lblContent.attributedText = attrStr;
                    [self.lblContent sizeToFit];
                    
                    if (appDelegate.isRTL)
                    {
                        //RTL
                        self.lblContent.textAlignment = NSTextAlignmentRight;
                    }
                    else
                    {
                        self.lblContent.textAlignment = NSTextAlignmentLeft;
                    }
                    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.lblContent.frame.origin.y + self.lblContent.frame.size.height + 8);
                }
                else
                {
                    self.lblMoreAboutUs.hidden = YES;
                    self.lblFollowUs.hidden = YES;
                }
            }
            else
            {
                self.lblMoreAboutUs.hidden = YES;
                self.lblFollowUs.hidden = YES;
            }
            HIDE_PROGRESS;
        }
        else
        {
            HIDE_PROGRESS;
            self.lblMoreAboutUs.hidden = YES;
            self.lblFollowUs.hidden = YES;
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
