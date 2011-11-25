//
//  ReplyToCommentViewController.m
//  wp3mock
//
//  Created by Jorge Bernal on 11/18/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import "ReplyToCommentViewController.h"

@implementation ReplyToCommentViewController
@synthesize replyTextView;
@synthesize commentWebView;
@synthesize inReplyToButton;
@synthesize comment;

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"comment"];
    self.replyTextView = nil;
    self.commentWebView = nil;
    self.inReplyToButton = nil;
    self.comment = nil;

    [super dealloc];
}

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

- (void)updateComment {
    [self.commentWebView loadHTMLString:[self.comment objectForKey:@"content"] baseURL:nil];
    [self.inReplyToButton setTitle:[NSString stringWithFormat:@"in reply to %@", [self.comment objectForKey:@"postTitle"]] forState:UIControlStateNormal];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.comment) {
        [self updateComment];
    }
    [self addObserver:self forKeyPath:@"comment" options:0 context:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.replyTextView = nil;
    self.commentWebView = nil;
    self.inReplyToButton = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [replyTextView becomeFirstResponder];
}

- (IBAction)inReplyToButtonTapped:(id)sender {
    if (replyTextView.isFirstResponder) {
        [replyTextView resignFirstResponder];
    } else {
        [replyTextView becomeFirstResponder];
    }
}

- (IBAction)save:(id)sender {
    NSDictionary *newComment = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Fred", @"authorName",
                             @"fred@whales.com", @"authorEmail",
                             @"http://fred.whales.com/", @"authorUrl",
                             @"A whale walks into a bar...", @"postTitle",
                             self.replyTextView.text, @"content",
                             nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewComment" object:newComment];

    [TestFlight passCheckpoint:@"Replied to comment"];

    [self cancel:sender];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"comment"]) {
        [self updateComment];
    }
}

@end
