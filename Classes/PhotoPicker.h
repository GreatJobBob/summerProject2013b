//
//  PhotoPicker.h
//  ThrashingTime
//
//  Created by Robert kessler on 7/2/13.
//  Copyright (c) 2013 roslyn-Robot.com. All rights reserved.
//


#import "cocos2d.h"
#import <Foundation/Foundation.h>



@interface PhotoPicker : CCLayer  <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
//@interface PhotoPicker : CCLayer{
    UIWindow *window;
    UIImage *newImage;
}




// returns a Scene that contains the HelloWorld as the only child
+(id) scene;


- (void)doSomething:(UIButton*)sender;




@end
