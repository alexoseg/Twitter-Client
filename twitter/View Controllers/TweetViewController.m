//
//  TweetViewController.m
//  twitter
//
//  Created by Alex Oseguera on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetViewController.h"
#import "TweetView.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet TweetView *tweetView;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetView.tweet = self.tweet;
}

- (IBAction)dismissTweet:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
