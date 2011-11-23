//
//  CommentViewController.h
//  wp3mock
//
//  Created by Jorge Bernal on 11/18/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController
@property (nonatomic, strong) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *authorEmailLabel;
@property (nonatomic, strong) IBOutlet UILabel *authorUrlLabel;
@property (nonatomic, strong) IBOutlet UIButton *inReplyToLabel;
@property (nonatomic, strong) IBOutlet UIWebView *contentWebView;
@property (nonatomic, strong) IBOutlet UIImageView *authorAvatarImageView;
@property (strong) NSDictionary *comment;

- (IBAction)replyToComment:(id)sender;
- (IBAction)approveComment:(id)sender;
- (IBAction)trashComment:(id)sender;

@end
