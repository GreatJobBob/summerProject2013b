//
//  PhotoBoothController.h
//  ImageManipulation
//
//  Created by Roger Chapman on 10/06/2011.
//  Copyright 2011 Storm ID Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>



@interface PhotoBoothController : UIViewController <UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate> {
   
    CGFloat _lastScale;
	CGFloat _lastRotation;  
	CGFloat _firstX;
	CGFloat _firstY;
    UIImagePickerController *picker;
    UIImage *pickedImage;
    //UIImageView *photoImage;
    UIView *canvas;    
    CAShapeLayer *_marque;
    UIPopoverController *popover;
 
    IBOutlet UIImageView * photoImage;
    IBOutlet UIImageView * faceMaskImage;
}

@property (nonatomic, retain) IBOutlet UIView *canvas;
@property (nonatomic, retain) IBOutlet UIImageView *photoImage;
@property (nonatomic, retain) UIImageView * selectedImage;
@property (nonatomic, retain) UIImageView * faceImageView2;
@property (retain, nonatomic) IBOutlet UIButton *CloseView;
@property (retain, nonatomic) IBOutlet UIButton *ChooseButton;
@property (retain, nonatomic) IBOutlet UIPopoverController *popover;
@property (nonatomic, retain) UIImageView * faceMaskImage;


- (IBAction)CloseClicked:(id)sender;
- (IBAction)ChooseButtonClicked:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)SaveButtonClicked:(id)sender;

- (UIImage *)clipImage:(UIImage *)imageIn withMask:(UIImage *)maskIn atRect:(CGRect) maskRect;


@end
