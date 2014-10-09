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
    
}

// Override needed to overcome bug with losing UIView background color
// Source: http://stackoverflow.com/questions/5222736/uiview-backgroundcolor-disappears-when-uitableviewcell-is-selected

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor *backgroundColor = self.innerContentView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.innerContentView.backgroundColor = backgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor *backgroundColor = self.innerContentView.backgroundColor;
    [super setSelected:selected animated:animated];
    self.innerContentView.backgroundColor = backgroundColor;
}

// Creating space around each cell in the tableview
// Source: http://stackoverflow.com/questions/10761744/spacing-between-cells-on-uitableview-with-custom-uitableviewcell
// Update for 2.0: No longer needed - I'm using a UIView with Auto Layout within a custom UITableViewCell

@end
