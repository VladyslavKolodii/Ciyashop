//
//  WebViewContainVC.h
//  CiyaShop
//
//  Created by Potenza ` on 14/06/19.
//  Copyright © 2019 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewContainVC : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webViewContain;

@property (weak, nonatomic) IBOutlet WKWebView *wkWebViewContain;

@property NSInteger index;

@end

NS_ASSUME_NONNULL_END
