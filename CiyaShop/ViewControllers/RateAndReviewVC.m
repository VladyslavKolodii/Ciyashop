//
//  RateAndReviewVC.m
//  CiyaShop
//
//  Created by Kaushal PC on 16/04/18.
//  Copyright © 2018 Potenza. All rights reserved.
//

#import "RateAndReviewVC.h"

@interface RateAndReviewVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *vwHeader;
@property (weak, nonatomic) IBOutlet UIView *vwAllData;
@property (weak, nonatomic) IBOutlet UIView *vwStarRating;
@property (weak, nonatomic) IBOutlet UIView *vwLast;
@property (weak, nonatomic) IBOutlet UIView *vwName;
@property (weak, nonatomic) IBOutlet UIView *vwImage;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblRateProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailAddress;

@property (weak, nonatomic) IBOutlet UITextView *txtComment;

@property (weak, nonatomic) IBOutlet UIScrollView *scrl;

@end

@implementation RateAndReviewVC
{
    UIView *vw;
    int set;
    float rating;
    HCSStarRatingView *starRatingView;
}
@synthesize strID, strName, strProductUrl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    self.lblProductName.text = strName;
    
    set = 0;
    rating = 0;
    
    [self.imgProduct sd_setImageWithURL:[Util EncodedURL:strProductUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image != nil)
        {
            self.imgProduct.image = image;
        }
        else
        {
            //no image
        }
    }];
    self.txtComment.delegate = self;
    
    if ([Util getBoolData:kLogin])
    {
        //log in
        self.txtName.text = [Util getStringData:kUsername];
        self.txtEmailAddress.text = [Util getStringData:kEmail];
        [self.txtName setUserInteractionEnabled:NO];
        [self.txtEmailAddress setUserInteractionEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
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
    
    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.vwLast.frame.origin.y + self.vwLast.frame.size.height);

    if (set == 0)
    {
        [self localize];

        set = 1;
        //add star rating
        starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(0, 0, self.vwStarRating.frame.size.width, self.vwStarRating.frame.size.height)];
        starRatingView.maximumValue = 5;
        starRatingView.minimumValue = 0;
        starRatingView.backgroundColor = [UIColor clearColor];
        starRatingView.value = 0;
        starRatingView.allowsHalfStars = NO;
        starRatingView.accurateHalfStars = NO;
        starRatingView.tintColor = [Util colorWithHexString:@"ffcc00"];;
        [starRatingView addTarget:self action:@selector(didChangeStarRatingValue:) forControlEvents:UIControlEventValueChanged];
        starRatingView.userInteractionEnabled = YES;
        
        [self.vwStarRating addSubview:starRatingView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Util setHeaderColorView:vw];
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
    self.lblTitle.text = [MCLocalization stringForKey:@"Review"];
    
    [self.btnSubmit setTitle:[MCLocalization stringForKey:@"SUBMIT"] forState:UIControlStateNormal];
    [Util setSecondaryColorButton:self.btnSubmit];

    self.txtName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Name"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtEmailAddress.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Email"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    self.txtComment.text = [MCLocalization stringForKey:@"Comment"];
    self.txtComment.textColor = [UIColor lightGrayColor];
    
    self.lblName.text = [MCLocalization stringForKey:@"Name"];
    self.lblEmailAddress.text = [MCLocalization stringForKey:@"Email Address"];
    self.lblRateProduct.text = [MCLocalization stringForKey:@"Rate Product"];
    self.lblComment.text = [MCLocalization stringForKey:@"Comment"];
    
    if (appDelegate.isRTL)
    {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);

        self.lblName.textAlignment = NSTextAlignmentRight;
        self.lblEmailAddress.textAlignment = NSTextAlignmentRight;
        self.lblRateProduct.textAlignment = NSTextAlignmentRight;
        self.lblComment.textAlignment = NSTextAlignmentRight;
        self.lblProductName.textAlignment = NSTextAlignmentRight;

        self.txtName.textAlignment = NSTextAlignmentRight;
        self.txtEmailAddress.textAlignment = NSTextAlignmentRight;
        self.txtComment.textAlignment = NSTextAlignmentRight;
        
        self.vwImage.frame = CGRectMake(self.vwName.frame.size.width - self.vwImage.frame.size.width - 26, self.vwImage.frame.origin.y, self.vwImage.frame.size.width, self.vwImage.frame.size.height);
        
        self.lblProductName.frame = CGRectMake(self.vwName.frame.size.width - self.lblProductName.frame.size.width - 99, self.lblProductName.frame.origin.y, self.lblProductName.frame.size.width, self.lblProductName.frame.size.height);
    } else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }
}

#pragma mark - StarRating Value changed

- (void)didChangeStarRatingValue:(HCSStarRatingView *)sender
{
    NSLog(@"Changed rating to %.1f", sender.value);
}

#pragma mark - Navigation

-(IBAction)btnSubmitClicked:(id)sender
{
    if (self.txtName.text.length == 0)
    {
        //no name
        [Util showalert:[MCLocalization stringForKey:@"Enter Name"] onView:self];
    }
    else if (self.txtEmailAddress.text.length == 0)
    {
        //no email
        [Util showalert:[MCLocalization stringForKey:@"Enter Email address"] onView:self];
    }
    else if (starRatingView.value == 0)
    {
        [Util showalert:[MCLocalization stringForKey:@"Add Star Rating"] onView:self];
    }
    else if ([self.txtComment.text isEqualToString:[MCLocalization stringForKey:@"Comment"]] || [self.txtComment.text  isEqualToString:@""])
    {
        //no comment
        [Util showalert:[MCLocalization stringForKey:@"Enter Comment"] onView:self];
    }
    else
    {
        [self AddReview];
    }
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UitextView Delegate
/*!
 * @discussion Check for at the start of editing view Message is Empty or any Charcter Exist
 * @param textView For indentifying sender
 */
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([self.txtComment.text isEqualToString:[MCLocalization stringForKey:@"Comment"]] && [self.txtComment.textColor isEqual:[UIColor lightGrayColor]])
    {
        self.txtComment.text = @"";
        self.txtComment.textColor = [UIColor blackColor];
    }
    return YES;
}
/*!
 * @discussion Check for at the End of editing view Message is Empty or any Charcter Exist
 * @param textView For indentifying sender
 */
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(self.txtComment.text.length == 0)
    {
        self.txtComment.textColor = [UIColor lightGrayColor];
        self.txtComment.text = [MCLocalization stringForKey:@"Comment"];
    }
    return YES;
}

#pragma mark - API Calls

-(void)AddReview
{
    SHOW_LOADER_ANIMTION();
    
    if (starRatingView.value == 0)
    {
        [Util showalert:[MCLocalization stringForKey:@""] onView:self];
    }    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:strID forKey:@"product"];
    [dict setValue:self.txtComment.text forKey:@"comment"];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)starRatingView.value] forKey:@"ratestar"];
    [dict setValue:self.txtName.text forKey:@"namecustomer"];
    [dict setValue:self.txtEmailAddress.text forKey:@"emailcustomer"];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];

    [CiyaShopAPISecurity postReview:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        HIDE_PROGRESS;

        NSLog(@"%@", dictionary);
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                [self.navigationController popViewControllerAnimated:YES];
                [Util showalert:[MCLocalization stringForKey:@"Your review is awaiting approval"] onView:appDelegate.window.rootViewController];
                NSLog(@"review updated.");
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
            }
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
