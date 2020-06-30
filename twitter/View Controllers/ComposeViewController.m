//
//  ComposeViewController.m
//  twitter
//
//  Created by Alex Oseguera on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

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
    
    NSString *composedText = [NSString stringWithString:self.composeTextView.text];
    
    typeof(self) __weak weakSelf = self;
    [[APIManager shared] postStatusWithText:composedText completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else {
            [self.delegate didTweet:tweet];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)cancelMessage:(id)sender {
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

@end
