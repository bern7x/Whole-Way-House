//
//  NewsTableViewCell.m
//  WWH
//
//  Created by Michael Whang on 8/23/14.
//  Copyright (c) 2014 Devolution Studios. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.logoImageView.layer.cornerRadius = 20.0;
    
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.layer setBorderColor:[UIColor colorWithRed:87.0/255.0 green:175.0/255.0 blue:193.0/255.0 alpha:1].CGColor];
    [self.layer setBorderWidth:1.0f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Creating space around each cell in the tableview
// Source: http://stackoverflow.com/questions/10761744/spacing-between-cells-on-uitableview-with-custom-uitableviewcell

#define CELL_PADDING 8.0

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += CELL_PADDING;
    frame.origin.x += CELL_PADDING;
    frame.size.height -= CELL_PADDING;
    frame.size.width -= 2 * CELL_PADDING;
    [super setFrame:frame];
}

@end
