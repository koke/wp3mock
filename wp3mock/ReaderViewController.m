//
//  ReaderViewController.m
//  wp3mock
//
//  Created by Jorge Bernal on 11/11/11.
//  Copyright (c) 2011 Automattic. All rights reserved.
//

#import "ReaderViewController.h"

@implementation ReaderViewController
@synthesize webView = __webView;
@synthesize url = __url;
@synthesize urlToLoad = __urlToLoad;

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

- (void)reloadWebView {
    NSMutableURLRequest *request;
    if (self.url) {
        request = [NSMutableURLRequest requestWithURL:self.url];
    } else {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://en.wordpress.com/wp-login.php"]];
        request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        NSString *request_body = [NSString stringWithFormat:@"log=%@&pwd=%@&redirect_to=%@",
                                  @"ilikedemos",
                                  @"rudy4fik",
                                  [@"https://en.wordpress.com/reader/mobile/v2/" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:[NSString stringWithFormat:@"%d", [request_body length]] forHTTPHeaderField:@"Content-Length"];
        [request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
        [request setHTTPMethod:@"POST"];        
    }
    [self.webView loadRequest:request];    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadWebView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return SHOULD_AUTOROTATE_TO(interfaceOrientation);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushReader"]) {
        ReaderViewController *destination = (ReaderViewController *)segue.destinationViewController;
        destination.url = self.urlToLoad;
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *requestedURL = [request URL];
    NSString *requestedURLAbsoluteString = [requestedURL absoluteString];
    NSLog(@"should Load: %@", requestedURLAbsoluteString);
    
    if ( ![requestedURL isEqual:self.url] && [requestedURLAbsoluteString rangeOfString:@"wp-login.php"].location == NSNotFound ) {
        
        if ( [requestedURLAbsoluteString rangeOfString:@"https://en.wordpress.com/wp-admin/admin-ajax.php"].location != NSNotFound ) {
            //The user tapped an item in the posts list
            self.urlToLoad = requestedURL;
            [self performSegueWithIdentifier:@"pushReader" sender:self];
            
            return NO;
        }
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (pageTitle != nil && ![[pageTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        self.navigationItem.title = pageTitle;
    } else {
        self.navigationItem.title = @"Read";
    }
}

@end
