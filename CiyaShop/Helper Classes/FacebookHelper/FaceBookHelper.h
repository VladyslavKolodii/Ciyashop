//
//  FaceBookHelper.h
//  CupidLove
//
//  Created by potenza on 16/03/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceBookHelper : NSObject

typedef void (^FaceBookLoginBlock)(NSMutableDictionary* result);


@property (nonatomic, strong) FaceBookLoginBlock FacebookLogin;
@property(strong,nonatomic) NSMutableDictionary *dictFbDetails;
@property(strong,nonatomic) NSMutableArray *arrPermissions;
-(void)LoginWithFaceBook;
-(void)GetDetialsFromFacebook:(FaceBookLoginBlock)FacebookLogin;

+(FaceBookHelper *)shareInstance;

-(void)ClearToken;

@end
