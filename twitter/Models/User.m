//
//  User.m
//  twitter
//
//  Created by Alex Oseguera on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.idStr = dictionary[@"id_str"];
        self.followerCount = [dictionary[@"followers_count"] intValue];
        self.followingCount = [dictionary[@"friends_count"] intValue];
        self.tweetCount = [dictionary[@"statuses_count"] intValue];
        
        self.isDefaultProfile = [dictionary[@"default_profile"] boolValue];
        
        NSString *headerURLString = dictionary[@"profile_banner_url"];
        self.headerImageURL = [NSURL URLWithString:headerURLString];
        
        NSString *urlString = dictionary[@"profile_image_url_https"];
        self.profileImageURL = [NSURL URLWithString:urlString];
    }
    return self;
}

@end
