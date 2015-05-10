//
//  MediaItemTableViewCell.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-03-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *track_title;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UIImageView *sc_album_image;
@property (weak, nonatomic) IBOutlet UIImageView *playing_animation;


-(void)setAlbumArtworkFromStringURL:(NSString*)stringURL;

@end
