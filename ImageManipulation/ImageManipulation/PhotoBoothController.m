//
//  PhotoBoothController.m
//  ImageManipulation
//
//  Created by Roger Chapman on 10/06/2011.
//  Copyright 2011 Storm ID Ltd. All rights reserved.
//

#import "PhotoBoothController.h"
#import "RootViewControllerInterface.h"


@implementation PhotoBoothController
@synthesize canvas;
@synthesize photoImage;
@synthesize selectedImage;
@synthesize faceImageView2;
@synthesize popover;
@synthesize faceMaskImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
  [photoImage release];
  [canvas release];
  [_marque release];
    [_CloseView release];
    [_ChooseButton release];
    [faceImageView2 release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Private Methods

-(void)showOverlayWithFrame:(CGRect)frame {
  
  if (![_marque actionForKey:@"linePhase"]) {
    CABasicAnimation *dashAnimation;
    dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
    [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
    [dashAnimation setDuration:0.5f];
    [dashAnimation setRepeatCount:HUGE_VALF];
    [_marque addAnimation:dashAnimation forKey:@"linePhase"];
  }
  
  _marque.bounds = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
  _marque.position = CGPointMake(frame.origin.x + canvas.frame.origin.x, frame.origin.y + canvas.frame.origin.y);
  
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddRect(path, NULL, frame);
  [_marque setPath:path];
  CGPathRelease(path);
  
  _marque.hidden = NO;
  
}

-(void)scale:(id)sender {
      
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
      _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = photoImage.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [photoImage setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    [self showOverlayWithFrame:photoImage.frame];
}

-(void)rotate:(id)sender {
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
      
      _lastRotation = 0.0;
      return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = photoImage.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [photoImage setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    [self showOverlayWithFrame:photoImage.frame];
}


-(void)move:(id)sender {
    
  CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:canvas];
    
  if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
    _firstX = [photoImage center].x;
    _firstY = [photoImage center].y;
  }
    
  translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
  [photoImage setCenter:translatedPoint];
  [self showOverlayWithFrame:photoImage.frame];
}

-(void)tapped:(id)sender {
  _marque.hidden = YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (!_marque) {
    _marque = [[CAShapeLayer layer] retain];
    _marque.fillColor = [[UIColor clearColor] CGColor];
    _marque.strokeColor = [[UIColor grayColor] CGColor];
    _marque.lineWidth = 1.0f;
    _marque.lineJoin = kCALineJoinRound;
    _marque.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
    _marque.bounds = CGRectMake(photoImage.frame.origin.x, photoImage.frame.origin.y, 0, 0);
    _marque.position = CGPointMake(photoImage.frame.origin.x + canvas.frame.origin.x, photoImage.frame.origin.y + canvas.frame.origin.y);
  }
  [[self.view layer] addSublayer:_marque];
    
  UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)] autorelease];
  [pinchRecognizer setDelegate:self];
  [self.view addGestureRecognizer:pinchRecognizer];
  
  UIRotationGestureRecognizer *rotationRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)] autorelease];
  [rotationRecognizer setDelegate:self];
  [self.view addGestureRecognizer:rotationRecognizer];
  
  UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] autorelease];
  [panRecognizer setMinimumNumberOfTouches:1];
  [panRecognizer setMaximumNumberOfTouches:1];
  [panRecognizer setDelegate:self];
  [canvas addGestureRecognizer:panRecognizer];
  
  UITapGestureRecognizer *tapProfileImageRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
  [tapProfileImageRecognizer setNumberOfTapsRequired:1];
  [tapProfileImageRecognizer setDelegate:self];
  [canvas addGestureRecognizer:tapProfileImageRecognizer];
    
    
    // load custom mole
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory

    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"myMole.png"]; //Add the file name
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
     pickedImage = [UIImage imageWithData:pngData];
    [photoImage setImage:pickedImage];
    
 /*
    UIImage *backgroundImage = pickedImage;
    UIImage *watermarkImage = [UIImage imageNamed:@"faceMask.png"];
    
    UIGraphicsBeginImageContext(backgroundImage.size);
    [backgroundImage drawInRect:CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y, canvas.frame.size.width, canvas.frame.size.height)];
    [watermarkImage drawInRect:CGRectMake(backgroundImage.size.width - watermarkImage.size.width, backgroundImage.size.height - watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
     [photoImage setImage:result];
  */
}

- (void)viewDidUnload
{
  [self setPhotoImage:nil];
  [self setCanvas:nil];
    [self setCloseView:nil];
    [self setChooseButton:nil];
 [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

#pragma mark UIGestureRegognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}

- (IBAction)CloseClicked:(id)sender {
    
    
    [[RootViewControllerInterface rootViewControllerInterfaceSharedInstance] closeClicked];
   [self dismissModalViewControllerAnimated:YES];
    [ self.parentViewController dismissPopoverAnimated:TRUE];
    
}

- (IBAction)ChooseButtonClicked:(id)sender {
    
    [self pickPhoto:nil];
}

- (IBAction)takePhoto:(id)sender {
    [self pickPhoto:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)SaveButtonClicked:(id)sender {
   
 /*   float imageScaleFactor = photoImage.image.scale;
    CGRect clippedRect  = CGRectMake(canvas.frame.origin.x, canvas.frame.origin.y,canvas.frame.size.width / imageScaleFactor,canvas.frame.size.height / imageScaleFactor  );
    CGImageRef imageRef = CGImageCreateWithImageInRect([pickedImage CGImage], clippedRect);
    UIImage *newImage   = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
   */
    
    UIGraphicsBeginImageContext(canvas.bounds.size);
    
    
    //save image in view to context
    [canvas.layer renderInContext:UIGraphicsGetCurrentContext()];
  //  [customView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
 
    
    // create a new context same size as cropping view window
    UIGraphicsBeginImageContext(canvas.bounds.size);
    
    // place image in context
    [newImage drawInRect:CGRectMake(canvas.bounds.origin.x,canvas.bounds.origin.y,canvas.bounds.size.width,canvas.bounds.size.height)];
    
    UIGraphicsEndImageContext();
    
    
    // Drawing code here.
    
    
    
/*
    // now mask the image
    
    UIImage *maskImage = [UIImage imageNamed:@"FaceMask400-hd.png"];
    UIImage *imageWithMask = [self maskAnImage:newImage withMask:maskImage];
    
 
    // Scale the image to mole size
   // CGSize newSize = CGSizeMake(400.0, 400.0);
   // UIGraphicsBeginImageContext( newSize );
    
    // skip mask while testing size
    //[imageWithMask drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
   
    // create a new context same size as cropping view window
    UIGraphicsBeginImageContext(photoImage.bounds.size);

    // place image in context
   [newImage drawInRect:CGRectMake(photoImage.bounds.origin.x,photoImage.bounds.origin.y,photoImage.bounds.size.width,photoImage.bounds.size.height)];
   
    
    UIImage* scaledMaskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
   
    UIImage *maskImage = [UIImage imageNamed:@"Girl400MaskBW-hd.png"];
    //UIImage *maskImage = faceMaskImage.image;
    
    UIImage *imageWithMask = [self maskAnImage:newImage withMask:maskImage];
    
    
    
    NSData *pngData = UIImagePNGRepresentation(imageWithMask);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"myMole.png"]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    
    
    
    // load custom mole
    pngData = [NSData dataWithContentsOfFile:filePath];
    pickedImage = [UIImage imageWithData:pngData];
    
  
}




-(void)pickPhoto:(UIImagePickerControllerSourceType)sourceType{
    
    picker = [[UIImagePickerController alloc] init];
                                    
                                    picker.delegate = self;
                                    
                                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && sourceType ==UIImagePickerControllerSourceTypeCamera)
                                        
                                    {
                                        
                                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                        
                                    } else
                                        
                                    {
                                        
                                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                        
                                    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.popover = [[UIPopoverController alloc]
                        initWithContentViewController:picker];
        self.popover.delegate = self;
        [popover presentPopoverFromRect:CGRectMake(0.0, 0.0, 400.0, 400.0)
                                 inView:self.view.window
               permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
    }
    else
    {
                                    
        [self presentModalViewController:picker animated:YES];
    }
                                
   
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker {
    
    [[Picker parentViewController] dismissModalViewControllerAnimated:YES];
    [popover dismissPopoverAnimated:YES];
    
    
    [Picker release];
    
}




- (void)imagePickerController:(UIImagePickerController *) Picker

didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [popover dismissPopoverAnimated:YES];
    
    
     pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [Picker dismissModalViewControllerAnimated:YES];
    
    //photoImage.image = [UIImage imageNamed:@"Robot-4.jpg"];
    [photoImage setImage:pickedImage];
 
    
    [Picker release];
    
     //faceImageView. = selectedImage;
  //  photoImage = selectedImage;
    
   
    
}

//-(void)imagePickerController:(UIImagePickerController *)picker
//didFinishPickingMediaWithInfo:(NSDictionary *)info{
//
//    // newImage is a UIImage do not try to use a UIImageView
//    newImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    // Dismiss UIImagePickerController and release it
//    [picker dismissModalViewControllerAnimated:YES];
//    [picker.view removeFromSuperview];
//    [picker release];
//    // Let's create a sprite now that we have an image
//    CCSprite *imageFromPicker = [CCSprite spriteWithCGImage:newImage.CGImage  key:@"ImageFromPicker"];
//    imageFromPicker.position = ccp(200,200);
//    imageFromPicker.scale = .25;
//    //remove previous
//    [self removeChildByTag:1001 cleanup:TRUE];
//    // add new , but just work at the first time, not working since first time
//    [self addChild:imageFromPicker z:0 tag: 1001];
//
//}

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *anImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(anImage, 1.0);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *tmpPathToFile = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/specificImagedName.jpg", path]];
    
    if([imageData writeToFile:tmpPathToFile atomically:YES]){
        //Write was successful.
 
    }
 
}
*/

/*********************************************************************************************
 *
 *  This method returns a masked image, pass it the original image, the mask image, 
 *  and a mask Rect
 *********************************************************************************************/

- (UIImage *)clipImage:(UIImage *)imageIn withMask:(UIImage *)maskIn atRect:(CGRect) maskRect
{
    CGRect rect = CGRectMake(0, 0, imageIn.size.width, imageIn.size.height);
    CGImageRef msk = maskIn.CGImage;
	
    UIGraphicsBeginImageContext(imageIn.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // Clear whole thing
    CGContextClearRect(ctx, rect);
	
    // Create the masked clipping region
    CGContextClipToMask(ctx, maskRect, msk);
	
    CGContextTranslateCTM(ctx, 0.0, rect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
	
    // Draw view into context
    CGContextDrawImage(ctx, rect, imageIn.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
	
    return newImage;
}



- (UIImage*) maskAnImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
}
@end
