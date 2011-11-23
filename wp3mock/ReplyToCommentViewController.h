//
//  ReplyToCommentViewController.h
//  wp3mock
//
//  Created by Jorge Bernal on 11/18/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyToCommentViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITextView *replyTextView;
@property (nonatomic, strong) IBOutlet UIWebView *commentWebView;
@property (nonatomic, strong) IBOutlet UIButton *inReplyToButton;
@property (strong) NSDictionary *comment;
- (IBAction)inReplyToButtonTapped:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@end
