# MZCroppableView

For detailed instructions check out this blog post: 
http://ideamakerz.com/mzeeshanid/mzcroppableview/

## Basic setup

Set up the cropping view above the image view displaying the image to be cropped with the following:
```
[croppingImageView setImage:[UIImage imageNamed:@"cropping_sample.jpg"]];
CGRect rect1 = CGRectMake(0, 0, croppingImageView.image.size.width, croppingImageView.image.size.height);
CGRect rect2 = croppingImageView.frame;
[croppingImageView setFrame:[MZCroppableView scaleRespectAspectFromRect1:rect1 toRect2:rect2]];
mzCroppableView = [[MZCroppableView alloc] initWithImageView:croppingImageView];
[self.view addSubview:mzCroppableView];
```

After the cropping path has been drawn, crop the image with the following:
```
UIImage *croppedImage = [mzCroppableView deleteBackgroundOfImage:croppingImageView];
```

## Credit
This project is based on the logic of JBCroppableView and i just modified it according to my requirement and share with others so all credit goes to
Javier Berlana, [Mobile One2One](http://www.mo2o.com/)
