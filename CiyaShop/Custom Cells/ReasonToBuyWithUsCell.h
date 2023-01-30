//
//  ReasonToBuyWithUsCell.h
//  CiyaShop
//
//  Created by Kaushal PC on 04/10/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReasonToBuyWithUsCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *colReasons;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *vwHeader;

@end
