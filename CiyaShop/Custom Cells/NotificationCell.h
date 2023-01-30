//
//  NotificationCell.h
//  QuickClick
//
//  Created by Kaushal PC on 04/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblNotification;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@end
