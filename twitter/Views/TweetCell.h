//
//  TweetCell.h
//  twitter
//
//  Created by Alex Oseguera on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TTTAttributedLabel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TweetCellDelegate;

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favLabel;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;
@property (nonatomic, strong) Tweet *tweet;

@end

@protocol TweetCellDelegate

- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;

@end

NS_ASSUME_NONNULL_END
