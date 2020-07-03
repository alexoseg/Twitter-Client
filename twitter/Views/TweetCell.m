//
//  Tweetself.m
//  twitter
//
//  Created by Alex Oseguera on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "DateTools.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
     UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileImage addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImage setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTweet:(Tweet *)tweet{
    _tweet = tweet; //access the actual value

    //initializer you want to do _val because of side effects
    self.favButton.selected = NO;
    self.retweetButton.selected = NO;
    
    if(self.tweet.favorited){
           self.favButton.selected = YES;
       }
       if(tweet.retweeted){
           self.retweetButton.selected = YES;
       }
       
       self.nameLabel.text = tweet.user.name;
       self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
       self.dateLabel.text = [NSDate shortTimeAgoSinceDate:tweet.createdAtDate];
    
       self.tweetTextLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
       self.tweetTextLabel.text = (tweet.text) ? tweet.text : tweet.messageText;
    
       self.retweetLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
       self.favLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
       
       self.profileImage.image = nil;
       [self.profileImage setImageWithURL:tweet.user.profileImageURL];
}

-(void)refreshData{
    self.nameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = self.tweet.user.screenName;
    self.dateLabel.text = [NSDate shortTimeAgoSinceDate:self.tweet.createdAtDate];
    
    self.tweetTextLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.tweetTextLabel.text = self.tweet.text;
    
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    self.profileImage.image = nil;
    [self.profileImage setImageWithURL:self.tweet.user.profileImageURL];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate tweetCell:self didTap:self.tweet.user]; 
}

- (IBAction)didTapRetweet:(id)sender {
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

- (IBAction)didTapFavorite:(id)sender {
    UIButton *button = (UIButton *)sender;
    
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


@end
