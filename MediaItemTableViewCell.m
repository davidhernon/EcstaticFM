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
        stringURL =  @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi8MYn94Vl1HVxqMb7u31QSRa3cNCJOYhxw7xI_GGDvcSKQ7xwPA370w";
        NSURL *imageURL = [NSURL URLWithString:stringURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *myImage = [UIImage imageWithData:imageData];
        self.sc_album_image.image = myImage;
        return;
    }
    
//    NSURL *imageURL = [NSURL URLWithString:str];
//    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//    UIImage *myImage = [UIImage imageWithData:imageData];
//    self.sc_album_image.image = (UIImage*)myImage;
    [self replaceArtworkSizeWithTemplateIdentifier:stringURL];
}

-(void)replaceArtworkSizeWithTemplateIdentifier:(NSString*)rawString
{
    NSMutableString *str =[NSMutableString stringWithString:rawString];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"([^-]*)$" options:0 error:nil];
    [regex replaceMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@"SDSTEMPLATE"];
    
    NSURL *imageURL = [NSURL URLWithString:str];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *myImage = [UIImage imageWithData:imageData];
    
    int counter = 0;
    
    while(myImage == nil)
    {
        switch(counter)
        {
            case 0:
                myImage = [UIImage imageWithData:[self getImageDataByReplacingSubstring:[NSString stringWithString:str] withSubstring:@"t500xt500.jpg"]];
                break;
            case 1:
                myImage = [UIImage imageWithData:[self getImageDataByReplacingSubstring:[NSString stringWithString:str] withSubstring:@"crop.jpg"]];
                break;
            case 2:
                myImage = [UIImage imageWithData:[self getImageDataByReplacingSubstring:[NSString stringWithString:str] withSubstring:@"t300x300.jpg"]];
                break;
            case 3:
                myImage = [UIImage imageWithData:[self getImageDataByReplacingSubstring:[NSString stringWithString:str] withSubstring:@"large.jpg"]];
                break;
            case 4:
                myImage = [UIImage imageWithData:[self getImageDataByReplacingSubstring:[NSString stringWithString:str] withSubstring:@"t67x67.jpg"]];
                break;
            case 5:
                myImage = [UIImage imageWithData:[self getImageDataByReplacingSubstring:[NSString stringWithString:str] withSubstring:@"badge.jpg"]];
                break;
            case 6:
                myImage = [UIImage imageWithData:[self getImageDataByReplacingSubstring:[NSString stringWithString:str] withSubstring:@"small.jpg"]];
                break;
            case 7:
                myImage = [UIImage imageWithData:[self getImageDataByReplacingSubstring:[NSString stringWithString:str] withSubstring:@"tiny.jpg"]];
                break;
            case 8:
                myImage = [UIImage imageWithData:[self getImageDataByReplacingSubstring:[NSString stringWithString:str] withSubstring:@"mini.jpg"]];
                break;
            case 9:
                myImage = [UIImage imageWithData:[self getImageDataByReplacingSubstring:[NSString stringWithString:str] withSubstring:@"original.jpg"]];
                break;
        }
        counter++;
    }
    self.sc_album_image.image = myImage;
    
}

-(NSData*)getImageDataByReplacingSubstring:(NSString*)urlString withSubstring:(NSString*)substring
{
    NSMutableString *str =[NSMutableString stringWithString:urlString];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"([^-]*)$" options:0 error:nil];
    [regex replaceMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:substring];
    
    NSURL *imageURL = [NSURL URLWithString:str];
    return [NSData dataWithContentsOfURL:imageURL];
}

@end
