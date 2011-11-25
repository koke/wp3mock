//
//  EditorViewController.h
//  wp3mock
//
//  Created by Jorge Bernal on 11/11/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//



@interface EditorViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
- (IBAction)dismiss:(id)sender;
- (IBAction)save:(id)sender;
@end
