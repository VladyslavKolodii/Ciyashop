//
//  RecentProductMainCell.h
//  QuickClick
//
//  Created by Kaushal PC on 11/08/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickOnRecentProductDelegate <NSObject>

-(void)setClickOnRecentProducts:(Product*)dict;

@end

@interface RecentProductMainCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UICollectionView *colRecentlyViewedProducts;
@property (strong, nonatomic) id<ClickOnRecentProductDelegate> delegate;

@end
