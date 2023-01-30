//
//  ContentVC.m
//  QuickClick
//
//  Created by Kaushal PC on 08/09/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "ContentVC.h"

@interface ContentVC ()

@property (strong, nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblContent;
@property (strong, nonatomic) IBOutlet UIScrollView *scrl;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UIView *vwAllData;

@end

@implementation ContentVC {
    UIView *vw;
}
@synthesize Page;//1 then terms of use, 2 then privacy policy
@synthesize contentID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%d",Page);
    
    //self.lblTitle.text = self.strTitle;
    NSString * htmlString = self.strTitle;
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    self.lblTitle.attributedText = attrStr;
    
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.textColor = OtherTitleColor;
    self.lblTitle.font = Font_Size_Navigation_Title;
    
    self.lblTitle.textAlignment = NSTextAlignmentCenter;
    
    if (self.fromPages)
    {
        [self getPageContent];
    }
    else
    {
        [self getContent];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [Util setHeaderColorView:vw];
    
    if (appDelegate.isRTL) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }
}

#pragma mark - button clicks

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - api calls

-(void)getContent
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    //1 then terms of use, 2 then privacy policy
    if (Page == 1)
    {
        [dict setValue:@"terms_of_use" forKey:@"page"];
    }
    else if(Page == 2)
    {
        [dict setValue:@"privacy_policy" forKey:@"page"];
    }
    
    [CiyaShopAPISecurity getStaticPages:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        if (success)
        {
            HIDE_PROGRESS;

            if (dictionary.count > 0)
            {
                if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
                {
                    NSString * htmlString = [dictionary valueForKey:@"data"];
                    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    
                    self.lblContent.attributedText = attrStr;
                    [self.lblContent sizeToFit];
                    if (appDelegate.isRTL)
                    {
                        //RTL
                        self.lblContent.textAlignment = NSTextAlignmentRight;
                    }
                    else
                    {
                        //NonRTL
                        self.lblContent.textAlignment = NSTextAlignmentLeft;
                    }
                    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.lblContent.frame.origin.y + self.lblContent.frame.size.height + 8);
                }
                else
                {
//                    ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
                }
            }
            else
            {
//                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
            }
        }
        else
        {
            HIDE_PROGRESS;
//            ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
        }
    }];
}


-(void)getPageContent
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    //1 then terms of use, 2 then privacy policy
    [dict setValue:[NSString stringWithFormat:@"%d", Page] forKey:@"page_id"];
    
    [CiyaShopAPISecurity getInfoPages:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        if (success)
        {
            HIDE_PROGRESS;

            if (dictionary.count > 0)
            {
                if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
                {
                    NSString * htmlString = [dictionary valueForKey:@"data"];
                    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    
                    self.lblContent.attributedText = attrStr;
                    [self.lblContent sizeToFit];
                    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.lblContent.frame.origin.y + self.lblContent.frame.size.height + 8);
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
    }];
}

#pragma mark - hide bottom bar

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
