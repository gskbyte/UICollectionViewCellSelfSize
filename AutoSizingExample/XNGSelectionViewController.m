//
//  SelectionViewController.m
//  AutoSizingExample
//
//  Created by Jose Alcalá-Correa on 14/10/14.
//  Copyright (c) 2014 gskbyte. All rights reserved.
//

#import "XNGSelectionViewController.h"

@interface XNGSelectionViewController ()

@end

@implementation XNGSelectionViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Text";
            break;
        case 1:
            cell.textLabel.text = @"Text and image";
            break;
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"text" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"text_image" sender:self];
        default:
            break;
    }
}

@end
