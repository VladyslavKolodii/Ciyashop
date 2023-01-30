//
//  ContentVC.h
//  QuickClick
//
//  Created by Kaushal PC on 08/09/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentVC : UIViewController

@property int Page;//1 then terms of use, 2 then privacy policy
@property int contentID;//1 then terms of use, 2 then privacy policy
@property (strong, nonatomic) NSString *strTitle;

@property BOOL fromPages;

@end
