//
//  ItemDetailVC.h
//  QuickClick
//
//  Created by Kaushal PC on 24/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDetailVC : UIViewController

//@property NSMutableArray *arrProductData;
@property Product *product;

- (void)setScrollView:(UIScrollView*)scrl;

@end
