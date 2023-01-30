//
//  FilterCell.h
//  QuickClick
//
//  Created by Kaushal PC on 21/08/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITableView *tblData;
@property (strong, nonatomic) IBOutlet UIButton *btnData;
@property (strong, nonatomic) IBOutlet UIImageView *imgArrow;

@end
