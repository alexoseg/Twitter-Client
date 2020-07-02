//
//  ProfileViewController.m
//  twitter
//
//  Created by Alex Oseguera on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;

@end

@implementation ProfileViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.user == nil){
        [[APIManager shared] getCurrentUserInfoWithCompletion:^(User *user, NSError *error) {
               if(error){
                   NSLog(@"%@", [error localizedDescription]);
               } else {
                   [self setUpProfile:user];
               }
           }];
    }
    else {
        [self setUpProfile:self.user];
    }
}

- (void)setUpProfile:(User *)user{
    UIColor *twitterBlue = [UIColor colorWithRed:29.0f/255.0f green:141.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%d", user.tweetCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%d", user.followingCount];
    self.followerCountLabel.text = [NSString stringWithFormat:@"%d", user.followerCount];
    
    [self.profileImageView setImageWithURL:user.profileImageURL];
    
    (user.isDefaultProfile) ? [self.headerImageView setBackgroundColor:twitterBlue] : [self.headerImageView setImageWithURL:user.headerImageURL];
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
