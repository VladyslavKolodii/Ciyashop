//
//  VariableItemDetailVC.h
//  QuickClick
//
//  Created by Kaushal PC on 24/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VariableItemDetailVC : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrlImages;
@property (weak, nonatomic) IBOutlet UILabel *lblProductNotAvailable;


//@property NSMutableArray *arrProductData;
@property NSMutableArray *arrVariations;
@property Product *product;


- (void)setScrollView:(UIScrollView*)scrl;

@end
