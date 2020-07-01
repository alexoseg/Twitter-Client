//
//  TweetView.m
//  twitter
//
//  Created by Alex Oseguera on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetView.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"

@implementation TweetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setTweet:(Tweet *)tweet{
    _tweet = tweet;
    
    if(self.tweet.favorited){
        self.favButton.selected = YES;
    }
       if(self.tweet.retweeted){
           self.retweetButton.selected = YES;
       }
       
       self.nameLabel.text = self.tweet.user.name;
       self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
       self.tweetTextLabel.text = self.tweet.text;
       self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
       self.favCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
       
       self.dateLabel.text = [self.tweet.createdAtDate formattedDateWithFormat:@"d MMM yy"];
       self.timeLabel.text = [self.tweet.createdAtDate formattedDateWithFormat:@"hh:mm a"];
       
       [self.profileImage setImageWithURL:self.tweet.user.profileImageURL];
}

-(void)refreshData{
    self.nameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = self.tweet.user.screenName;
    
    self.tweetTextLabel.text = self.tweet.text;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    self.dateLabel.text = [self.tweet.createdAtDate formattedDateWithFormat:@"d MMM yy"];
    self.timeLabel.text = [self.tweet.createdAtDate formattedDateWithFormat:@"hh:mm a"];

    [self.profileImage setImageWithURL:self.tweet.user.profileImageURL];
}

- (IBAction)didTapFav:(id)sender{
    NSLog(@"Tapped the Favorite");
    UIButton *button = (UIButton *)sender;
    NSLog(@"Fav Button Pressed");
    
    if(self.tweet.favorited){
        self.tweet.favorited = NO;
        button.selected = NO;
        self.tweet.favoriteCount -= 1;
        [[APIManager shared] performFavoriteActionOn:self.tweet withAction:UnFavorite completion:^(Tweet *tweet, NSError *error) {
             if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             } else {
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
        }];
    }
    
    else {
        self.tweet.favorited = YES;
        button.selected = YES;
        self.tweet.favoriteCount += 1;
        [[APIManager shared] performFavoriteActionOn:self.tweet withAction:Favorite completion:^(Tweet *tweet, NSError *error) {
             if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             } else {
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
        }];
    }
    
    [self refreshData];
}

- (IBAction)didTapRetweet:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    if(self.tweet.retweeted){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        button.selected = NO;
        [[APIManager shared] performRetweetActionOn:self.tweet withAction:UnRetweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully unretweeting the following Tweet: %@", tweet.text);
            }
        }];
    }
    else {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        button.selected = YES;
        [[APIManager shared] performRetweetActionOn:self.tweet withAction:Retweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully retweeting the following Tweet: %@", tweet.text);
            }
        }];
    }
    
    [self refreshData];
}

@end
