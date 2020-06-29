//
//  ComposeViewController.m
//  twitter
//
//  Created by Alex Oseguera on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelTweetBarButton;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)tweetMessage:(id)sender {
}

- (IBAction)cancelMessage:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
