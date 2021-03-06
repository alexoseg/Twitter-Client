//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"
#import "User.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"s627pPai1ZWoV1P1VjGBsyMFf"; // Enter your consumer key here
static NSString * const consumerSecret = @"urOWycaJThsMxfkLCbPW6P5kcK0EDNcKXLZO6U08l3RSIpR5zh";// Enter your consumer secret here

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getCurrentUserInfoWithCompletion:(void (^)(User *, NSError *))completion{
    [self GET:@"1.1/account/verify_credentials.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        User *user = [[User alloc] initWithDictionary:responseObject];
        completion(user, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)getTweetsAfter:(NSString *)idString withCompletion:(void(^)(NSArray *, NSError *))completion{
    NSString *urlString = [@"1.1/statuses/home_timeline.json?tweet_mode=extended&max_id=" stringByAppendingString:idString];
    [self GET:urlString
    parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {

        // Manually cache the tweets. If the request fails, restore from cache if possible.
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];
         
         NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
         completion(tweets, nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSArray *tweetDictionaries = nil;

        // Fetch tweets from cache if possible
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
        if (data != nil) {
            tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        
        NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        completion(tweets, error);
    }];
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    [self GET:@"1.1/statuses/home_timeline.json?tweet_mode=extended"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {

       // Manually cache the tweets. If the request fails, restore from cache if possible.
       NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
       [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];
        
        NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        completion(tweets, nil);

   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

       NSArray *tweetDictionaries = nil;

       // Fetch tweets from cache if possible
       NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
       if (data != nil) {
           tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
       }
       
       NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
       completion(tweets, error);
   }];
}

-(void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

-(void)performFavoriteActionOn:(Tweet *)tweet withAction:(TweetCellFavActions)tweetCellaction completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString;
    NSDictionary *parameters = @{@"id": tweet.idStr};
    
    switch (tweetCellaction) {
        case Favorite:
            urlString = @"1.1/favorites/create.json?tweet_mode=extended";
            break;
        case UnFavorite:
            urlString = @"1.1/favorites/destroy.json?tweet_mode=extended";
            break;
    }
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

-(void)performRetweetActionOn:(Tweet *)tweet withAction:(TweetCellRetweetActions)tweetCellAction completion:(void (^)(Tweet *, NSError *))completion{
    
    if(tweetCellAction == Retweet){
        NSString *idURLString = [NSString stringWithFormat:@"%@.json?tweet_mode=extended", tweet.idStr];
        NSString *urlString = [@"1.1/statuses/retweet/" stringByAppendingString:idURLString];
        [self POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
            completion(tweet, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil, error);
        }];
    }
    
    if(tweetCellAction == UnRetweet){
        NSString *idStr = (tweet.retweetedByUser == nil) ? tweet.idStr : tweet.retweetedByUser.idStr;
        NSString *urlString = [@"1.1/statuses/show/" stringByAppendingFormat:@"%@.json?include_my_retweet=1", idStr];
        [self GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *retweet_id = (NSString *)responseObject[@"current_user_retweet"][@"id_str"];
            NSString *destroyURLString = [@"1.1/statuses/destroy/" stringByAppendingFormat:@"%@.json?tweet_mode=extended", retweet_id];
            [self POST:destroyURLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
                completion(tweet, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completion(nil, error);
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil, error);
        }];
    }
    
}
    
@end
