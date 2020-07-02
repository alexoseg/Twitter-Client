//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"

typedef NS_ENUM(NSInteger, TweetCellFavActions)
{
    Favorite,
    UnFavorite,
};

typedef NS_ENUM(NSInteger, TweetCellRetweetActions)
{
    Retweet,
    UnRetweet,
};

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion;
- (void)performFavoriteActionOn:(Tweet *)tweet withAction:(TweetCellFavActions)tweetCellaction completion:(void (^)(Tweet *, NSError *))completion;
- (void)performRetweetActionOn:(Tweet *)tweet withAction:(TweetCellRetweetActions)tweetCellAction completion:(void (^)(Tweet *, NSError *))completion;

- (void)getCurrentUserInfoWithCompletion:(void (^)(User *, NSError *))completion;

@end
