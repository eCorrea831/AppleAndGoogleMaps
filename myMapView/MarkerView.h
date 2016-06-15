//
//  MarkerView.h
//  
//
//  Created by Aditya Narayan on 6/15/16.
//
//

#import <UIKit/UIKit.h>

@interface MarkerView : UIView

@property (weak, nonatomic) IBOutlet UIImageView * markerImage;
@property (weak, nonatomic) IBOutlet UILabel * markerTitle;
@property (weak, nonatomic) IBOutlet UILabel * markerSubtitle;

@end
