//
//  CommentViewController.m
//  wp3mock
//
//  Created by Jorge Bernal on 11/18/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import "CommentViewController.h"
#import "ReplyToCommentViewController.h"

@implementation CommentViewController
@synthesize authorNameLabel, authorEmailLabel, authorUrlLabel;
@synthesize inReplyToLabel;
@synthesize contentWebView;
@synthesize authorAvatarImageView;
@synthesize comment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.authorNameLabel.text = [self.comment objectForKey:@"authorName"];
    self.authorUrlLabel.text = [self.comment objectForKey:@"authorUrl"];
    self.authorEmailLabel.text = [self.comment objectForKey:@"authorEmail"];
    [self.inReplyToLabel setTitle:[NSString stringWithFormat:@"in reply to %@", [self.comment objectForKey:@"postTitle"]] forState:UIControlStateNormal];
    [self.contentWebView loadHTMLString:[self.comment objectForKey:@"content"] baseURL:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"replyToComment"]) {
        ReplyToCommentViewController *replyViewController = (ReplyToCommentViewController *)segue.destinationViewController;
        replyViewController.comment = self.comment;
    }
}

- (IBAction)replyToComment:(id)sender {
    [self performSegueWithIdentifier:@"replyToComment" sender:sender];
}

- (IBAction)approveComment:(id)sender {
    
}

- (IBAction)trashComment:(id)sender {
    
}

@end
