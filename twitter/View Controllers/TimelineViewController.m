//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DateTools.h"
#import "TweetViewController.h"
#import "ProfileViewController.h"


@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isMoreDataLoading;

@end

@implementation TimelineViewController

#pragma mark - SET UP

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self fetchTweets];
}

-(void)fetchTweets {
    // Get timeline
    typeof(self) __weak weakSelf = self;
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = [[NSMutableArray alloc] initWithArray:tweets];
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [weakSelf.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TABLE VIEW CODE

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    //Properties are wrappers around functions
    cell.tweet = tweet;
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects: indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - EXTRA FUNCTIONALITY

- (void)loadMoreData{
    Tweet *lastTweet = self.tweets[self.tweets.count - 1];
    [[APIManager shared] getTweetsAfter:lastTweet.idStr withCompletion:^(NSArray *tweets, NSError *error) {
        if(error){
            NSLog(@"There was an error fetching tweets");
        }
        else {
            [self.tweets addObjectsFromArray:tweets];
            self.isMoreDataLoading = NO;
            [self.tableView reloadData];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height; //Total content in the scroll view
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height; // bounds size gives us the page size
        
        // When the user has scrolled pas the threshold, start requesting
        // contentOffset tells us how far down we have scrolled
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging){
            self.isMoreDataLoading = true;
            [self loadMoreData];
        }
    }
}

- (void)didTweet:(nonnull Tweet *)tweet {
    NSLog(@"Entered did tweet");
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (void)tweetCell:(nonnull TweetCell *)tweetCell didTap:(nonnull User *)user {
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

- (IBAction)onLogoutTap:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //Main was instantiated programatically in AppDelegate which is why we can access it like this
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"composeSegue"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController *)navigationController.topViewController;
        composeController.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"tweetSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet* selectedTweet = self.tweets[indexPath.row];
        TweetViewController* destinationViewController = [segue destinationViewController];
        destinationViewController.tweet = selectedTweet;
    }
    else if([segue.identifier isEqualToString:@"profileSegue"]){
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = sender;
    }
}

@end
