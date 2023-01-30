//
//  DownloadCell.h
//  CiyaShop
//
//  Created by Kaushal Parmar on 07/05/19.
//  Copyright © 2019 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblExpire;
@property (weak, nonatomic) IBOutlet UILabel *lblExpireData;
@property (weak, nonatomic) IBOutlet UILabel *lblRemaining;
@property (weak, nonatomic) IBOutlet UILabel *lblRemainingData;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblFileName;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;


@end

NS_ASSUME_NONNULL_END
