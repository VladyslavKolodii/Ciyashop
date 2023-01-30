//
//  LoaderVC.m
//  EverAfter
//
//  Created by potenza on 28/07/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "LoaderVC.h"

@interface LoaderVC ()
@property(strong,nonatomic) IBOutlet UIImageView *img;
@end

@implementation LoaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  

    
    self.img.animationImages = appDelegate.LoaderImages;
    self.img.animationDuration = 1.5;
    [self.img startAnimating];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.img stopAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
