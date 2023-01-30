//
//  SellerInfoVC.h
//  CiyaShop
//
//  Created by Kaushal PC on 04/11/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "ViewController.h"

@interface SellerInfoVC : ViewController

@property NSString *strTitle, *strDesc;
@property (weak, nonatomic) IBOutlet UIWebView *wvDetails;
@property (weak, nonatomic) IBOutlet WKWebView *wkWebDetails;

@end
