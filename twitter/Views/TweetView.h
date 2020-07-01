//
//  TweetView.h
//  twitter
//
//  Created by Alex Oseguera on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetView : UIView

@property (nonatomic, weak) IBOutlet UIImageView* profileImage;
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* screenNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* tweetTextLabel;
@property (nonatomic, weak) IBOutlet UILabel* timeLabel;
@property (nonatomic, weak) IBOutlet UILabel* dateLabel;
@property (nonatomic, weak) IBOutlet UILabel* retweetCountLabel;
@property (nonatomic, weak) IBOutlet UILabel* favCountLabel;
@property (nonatomic, weak) IBOutlet UIButton* retweetButton;
@property (nonatomic, weak) IBOutlet UIButton* favButton;

@property (nonatomic, strong) Tweet* tweet;

@end

NS_ASSUME_NONNULL_END
