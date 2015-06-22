//
//  MediaItemTableViewCell.h
//  EcstaticFM
//
//  Created by David Hernon on 2015-03-18.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@interface MediaItemTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *track_title;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UIImageView *sc_album_image;
@property (weak, nonatomic) IBOutlet UIImageView *playing_animation;
@property (weak, nonatomic) IBOutlet UILabel *song_index_label;

-(void)setAlbumArtworkFromStringURL:(NSString*)stringURL;

@end
