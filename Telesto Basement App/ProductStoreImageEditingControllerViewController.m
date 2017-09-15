//
//  ProductStoreImageEditingControllerViewController.m
//  Telesto Basement App
//
//  Created by CSM on 9/14/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "ProductStoreImageEditingControllerViewController.h"
#import "ProductStoreImageDescriptionViewController.h"
@interface ProductStoreImageEditingControllerViewController ()

@end

@implementation ProductStoreImageEditingControllerViewController
@synthesize productDescriptionTextField;
@synthesize baseViewController;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    productDescriptionTextField.text = @"Add some description after adding picture.";
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cameraBtnAction:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];

}
- (void) imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    // get the image
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!img) img = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imgData= UIImageJPEGRepresentation(img,0.1 /*compressionQuality*/);
    [_imageViewer setImage:img forState:UIControlStateNormal];
    int imageSize   = (int)imgData.length;
    NSLog(@"size of image in KB: %f ", imageSize/1024.0);
    
    
    gallerImage =[UIImage imageWithData:imgData];
    [self dismissViewControllerAnimated:picker completion:nil];
    
}
- (IBAction)saveBtnAction:(id)sender {
    GalleryItem *galleryItem = [[GalleryItem alloc] init];
    galleryItem.itemImage = gallerImage;
    galleryItem.itemDescription = productDescriptionTextField.text;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    [baseViewController getGalleryItem:galleryItem];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - KeyboardNotificationDelegate
#pragma mark -
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _baseScroller.contentInset = contentInsets;
    _baseScroller.scrollIndicatorInsets = contentInsets;
}
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)     name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if ([activeField isKindOfClass:[UITextField class]]) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        _baseScroller.contentInset = contentInsets;
        _baseScroller.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height+180);
            [_baseScroller setContentOffset:scrollPoint animated:YES];
        }
    }
    else{
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        _baseScroller.contentInset = contentInsets;
        _baseScroller.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, productDescriptionTextField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, productDescriptionTextField.frame.origin.y-kbSize.height+210);
            [_baseScroller setContentOffset:scrollPoint animated:YES];
        }
    }
}

@end
