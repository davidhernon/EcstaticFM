//
//  MediaItemTableViewCell.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-03-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import "MediaItemTableViewCell.h"

@implementation MediaItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAlbumArtworkFromStringURL:(NSString*)stringURL
{
    if([stringURL isEqual:[NSNull null]]){
        //input string is null so use the default
        stringURL = @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi8MYn94Vl1HVxqMb7u31QSRa3cNCJOYhxw7xI_GGDvcSKQ7xwPA370w";
    }
    NSURL *imageURL = [NSURL URLWithString:stringURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *myImage = [UIImage imageWithData:imageData];
    self.sc_album_image.image = (UIImage*)myImage;
}

@end
