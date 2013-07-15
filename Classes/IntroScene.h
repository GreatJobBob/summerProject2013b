//
//  IntroScene.h
//  ThrashingTime
//
//  Created by Robert kessler on 6/30/13.
//  Copyright (c) 2013 roslyn-Robot.com. All rights reserved.
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>

@interface Intro : CCLayer{
    UIWindow *window;
   UIImage *newImage;
}




// returns a Scene that contains the HelloWorld as the only child
+(id) scene;


- (void)doSomething:(UIButton*)sender;

- (float)convertFontSize:(float)fontSize;



@end
