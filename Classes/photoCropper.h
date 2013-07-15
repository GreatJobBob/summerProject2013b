//
//  photoCropper.h
//  ThrashingTime
//
//  Created by Robert kessler on 7/7/13.
//  Copyright (c) 2013 roslyn-Robot.com. All rights reserved.
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>

@interface photoCropper : CCLayer  <UIImagePickerControllerDelegate, UINavigationControllerDelegate>  {
    UIWindow *window;
    UIImage *newImage;
    UIViewController *myViewController;
}




// returns a Scene that contains the HelloWorld as the only child
+(id) scene;


- (void)doSomething:(UIButton*)sender;


@end
