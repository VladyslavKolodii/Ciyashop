//
//  WebViewVC.h
//  QuickClick
//
//  Created by Kaushal PC on 28/07/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThankYouDelegate <NSObject>

-(void)setThankYouPage:(BOOL)set;

@end

@interface WebViewVC : UIViewController


@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet WKWebView *wkWebView;


@property NSString *url;
@property NSString *urlThankYou;
@property NSString *urlThankYouEndPoint;

@property NSMutableDictionary *dictCart;

@property (strong, nonatomic) id <ThankYouDelegate> delegate;

@end
