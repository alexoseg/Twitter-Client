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
     
    [self setupTweetView];
}

- (void)setupTweetView {
    self.tweetView.tweet = self.tweet;
    
    if(self.tweet.favorited){
        self.tweetView.favButton.selected = YES;
    }
    if(self.tweet.retweeted){
        self.tweetView.retweetButton.selected = YES;
    }
    
    self.tweetView.nameLabel.text = self.tweet.user.name;
    self.tweetView.screenNameLabel.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
    self.tweetView.tweetTextLabel.text = self.tweet.text;
    self.tweetView.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.tweetView.favCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    self.tweetView.dateLabel.text = [self.tweet.createdAtDate formattedDateWithFormat:@"d MMM yy"];
    self.tweetView.timeLabel.text = [self.tweet.createdAtDate formattedDateWithFormat:@"hh:mm a"];
    
    [self.tweetView.profileImage setImageWithURL:self.tweet.user.profileImageURL];
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
