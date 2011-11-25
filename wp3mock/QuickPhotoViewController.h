//
//  QuickPhotoViewController.h
//  wp3mock
//
//  Created by Jorge Bernal on 11/11/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//



@interface QuickPhotoViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    IBOutlet UIImageView *thumbnailView;
    IBOutlet UITextField *titleTextField;
}

@property (assign) UIImagePickerControllerSourceType sourceType;
@property (strong) UIImage *photo;
- (IBAction)dismiss:(id)sender;
- (IBAction)save:(id)sender;
@end
