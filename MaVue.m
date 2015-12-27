//
//  MaVue.m
//  ISouvenir
//
//  Created by m2sar on 27/11/2014.
//  Copyright (c) 2014 m2sar. All rights reserved.
//

#import "MaVue.h"
#import "UneAnnotation.h"

@implementation MaVue

UIToolbar *tool;
MKMapView *map;
int compteur;
UISegmentedControl *segment;
CLLocationManager *locMngr;
UIBarButtonItem *plus,*supprimer,*fresh,*book,*appareilPhoto,*liste,*space;
UILabel *type,*pinging;
MKMapCamera *camera;
UIImageView *viewimage;
UIImage *image;
ABPeoplePickerNavigationController * abnav;
NSString *NomPrenom;
UIImageView *unephoto;
UIImagePickerController *photoPicker,*photoPicker2;
UneAnnotation *pin2;
UIPopoverController *pop,*pop2;
CGSize mySize;
UIDevice *terminal;
bool isIpad;
bool portrait;
UILabel *label1;
UILabel *label2;




- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        compteur = 1;
        terminal = [UIDevice currentDevice];
        isIpad = ([terminal userInterfaceIdiom] ==  UIUserInterfaceIdiomPad);
        portrait = ((UIDeviceOrientationIsPortrait(terminal.orientation))||(terminal.orientation == UIDeviceOrientationPortraitUpsideDown));
        if ([CLLocationManager locationServicesEnabled]) {
        
            tool = [[UIToolbar alloc]init];
            
            plus = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(ajouterPin:)];
            
            supprimer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemTrash) target:self action:@selector(supprimer:)];
            supprimer.enabled = false;
            label1 = [[UILabel alloc]init];
            [label1 setText:[NSString stringWithFormat:@""]];
            [label1 setTextColor:[UIColor blackColor]];
            [label1 setTextAlignment:(NSTextAlignmentCenter)];
            [label1 setFont:[UIFont systemFontOfSize:11]];
             label2 = [[UILabel alloc]init];
            [label2 setText:[NSString stringWithFormat:@"Epingles:"]];
            [label2 setTextColor:[UIColor blackColor]];
            [label2 setTextAlignment:(NSTextAlignmentCenter)];
              [label2 setFont:[UIFont systemFontOfSize:11]];
            fresh = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemRefresh) target:self action:@selector(calculPosition:)];
            
            book = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemBookmarks) target:self action:@selector(accesContact:)];
              book.enabled =false;
            
            appareilPhoto = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemCamera) target:self action:@selector(accesPhoto:)];
            appareilPhoto.enabled = false;
            
            liste = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemOrganize) target:self action:@selector(accesBibliotheque:)];
            liste.enabled = false;
            
            space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:@selector(vide:)];
            
            if (isIpad) {
               [tool setItems:[NSArray arrayWithObjects:plus,supprimer,space,space,space,space,fresh,space,space,space,space,book,appareilPhoto,liste, nil]];
                
            }else{
                [tool setItems:[NSArray arrayWithObjects:plus,space,supprimer,space,fresh,space,book,space,appareilPhoto,space,liste, nil]];
            }
            
            segment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"clef-3D", comment=""),NSLocalizedString(@"clef-carte", comment=""),NSLocalizedString(@"clef-sat", comment=""),NSLocalizedString(@"clef-hyp", comment=""), nil]];
            
            [segment addTarget:self action:@selector(changeCarte) forControlEvents:UIControlEventValueChanged];
            [segment setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
            [segment setSelectedSegmentIndex:1];
            [segment setTintColor:[UIColor blackColor]];
            image =[[UIImage alloc]init];
            image = [UIImage imageNamed:@"target.png"];
            viewimage =[[UIImageView alloc]initWithImage:image];
            abnav = [[ABPeoplePickerNavigationController alloc]init];
         map = [[MKMapView alloc]init];
        [map setScrollEnabled:YES];
        [map setZoomEnabled:YES];
        [map setDelegate:self];
        
            
        locMngr = [[CLLocationManager alloc]init];
        [locMngr setDistanceFilter:1.0];
        [locMngr setDelegate:self];
        [locMngr requestAlwaysAuthorization ];
            [self positionner:[[UIScreen mainScreen]bounds].size];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"clef-error", comment="") message:NSLocalizedString(@"clef-loaclisation-dés", comment="") delegate:nil cancelButtonTitle:NSLocalizedString(@"clef-ok", comment="") otherButtonTitles: nil];
            [alert show];
        }
        [self addSubview:map];
        [map release];
        [self addSubview:tool];
        [self addSubview:segment];
        [self addSubview:viewimage];
        [self addSubview:label1];
        [label1 release];
        [self addSubview:label2];
        [label2 release];
        
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [self positionner:[[UIScreen mainScreen]bounds].size];
}

-(void)positionner:(CGSize) size;{
    
    int tbsize = size.height/(size.height*0.015);
    int segsizeh = size.height/(size.height*0.03);
    int segsizew = size.width/(size.width*0.004);
    if (size.width >size.height) {
      
        if (pin2.activate) {
            [map setFrame:CGRectMake(0, 0, (size.width/2), (size.height-tbsize))];
            [viewimage setFrame:CGRectMake((size.width)/4, (size.height- (tbsize/2))/2, tbsize/2, tbsize/2)];
            [segment setFrame:CGRectMake((size.width/2 - segsizew)/2,25 , segsizew, segsizeh)];
        }else{
            [map setFrame:CGRectMake(0, 0, size.width, size.height)];
            [viewimage setFrame:CGRectMake((size.width - tbsize)/2, (size.height- tbsize)/2, tbsize , tbsize)];
            [segment setFrame:CGRectMake((size.width - segsizew)/2,25 , segsizew, segsizeh)];
        }
        
        [tool setFrame:CGRectMake(0 , (size.height - tbsize), size.width, tbsize)];
        [label1 setFrame:CGRectMake(40,(size.height - (tbsize+5)), 200, 30)];
        [label2 setFrame:CGRectMake(size.width - 120,(size.height - (tbsize+5)), 100, 30)];
        [unephoto setFrame:CGRectMake((size.width/2),0 ,  size.width/2, (size.height -  tbsize))];
        
        
    }
        
    else{
        
       
        if (pin2.activate) {
            [map setFrame:CGRectMake(0, 0, size.width, size.height/2)];
            [viewimage setFrame:CGRectMake((size.width - (tbsize/2))/2, (size.height- (tbsize/2))/4, tbsize/2, tbsize/2)];
        }else{
            [map setFrame:CGRectMake(0, 0, size.width, size.height)];
            [viewimage setFrame:CGRectMake((size.width - tbsize)/2, (size.height- tbsize)/2, tbsize , tbsize)];
        }
        [tool setFrame:CGRectMake(0 , (size.height - tbsize), size.width, tbsize)];
          [label1 setFrame:CGRectMake(40,(size.height - (tbsize+5)), 200, 30)];
         [label2 setFrame:CGRectMake(size.width - 120,(size.height - (tbsize+5)), 100, 30)];
        [segment setFrame:CGRectMake((size.width - segsizew)/2,25 , segsizew, segsizeh)];
        [unephoto setFrame:CGRectMake(0, (size.height - (size.height/2)),  size.width, (size.height/2-tbsize))];
       
    }
    }
    

-(void) calculPosition:(id)sender{      //donne la position acctuel ou je trouve
    [locMngr startUpdatingLocation];
    [self afficher:[NSString stringWithFormat:NSLocalizedString(@"clef-coord", comment=""),map.centerCoordinate.latitude, map.centerCoordinate.longitude ]];
}

-(void)vide:(id)sender{
    
}

-(void)supprimer:(id)sender{
    [map removeAnnotation:pin2];
    
    }

-(void)accesContact:(id)sender{
   
    abnav.peoplePickerDelegate = self;
    if (!isIpad) {
        [_mycontroller presentViewController:abnav animated:YES completion:nil];
    }else {
         [pop dismissPopoverAnimated:false];
        pop2 = [[UIPopoverController alloc]initWithContentViewController:abnav ];
        [pop2 setPopoverContentSize:CGSizeMake(250, 500)];
        [pop2 setDelegate:self];
        [pop2 presentPopoverFromBarButtonItem:book permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
    }

    
}
-(void) afficher:(NSString*)chaine{
    [label1 setText:[NSString stringWithFormat:@"%@",NSLocalizedString(chaine, comment="")]];
    
}


-(void)accesPhoto:(id)sender{
    if(!photoPicker){
        photoPicker = [[UIImagePickerController alloc]init];
        [photoPicker setDelegate: self];
    }
    [photoPicker setSourceType:(UIImagePickerControllerSourceTypeCamera)];
    NSArray *mediatype = [UIImagePickerController availableMediaTypesForSourceType:(UIImagePickerControllerSourceTypeCamera)];
    [photoPicker setMediaTypes:mediatype];
    if (!isIpad) {
    [_mycontroller presentViewController:photoPicker animated:YES completion:nil];
    }
  else {
       [pop2 dismissPopoverAnimated:false];
       [pop dismissPopoverAnimated:false];
        pop = [[UIPopoverController alloc]initWithContentViewController:photoPicker ];
        [pop setPopoverContentSize:CGSizeMake(250, 200)];
        [pop setDelegate:self];
        [pop presentPopoverFromBarButtonItem:appareilPhoto permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
        
            }
   
    
    
}

-(void)accesBibliotheque:(id)sender{
    if(!photoPicker2){
        photoPicker2 = [[UIImagePickerController alloc]init];
        [photoPicker2 setDelegate: self];
    }
    [photoPicker2 setSourceType:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)];
    if (!isIpad) {
        [_mycontroller presentViewController:photoPicker2 animated:YES completion:nil];
    }
    else {
        [pop2 dismissPopoverAnimated:false];
        [pop dismissPopoverAnimated:false];
         pop = [[UIPopoverController alloc]initWithContentViewController:photoPicker2 ];
        [pop setPopoverContentSize:CGSizeMake(250,200)];
        [pop setDelegate:self];
        [pop presentPopoverFromBarButtonItem:liste permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
    }
    
}
-(void) changeCarte {
    if([segment selectedSegmentIndex]==0){
        [map setMapType:MKMapTypeStandard];
        [map setPitchEnabled:NO];
        [map setShowsBuildings:NO];
        CLLocationCoordinate2D ouAller = map.centerCoordinate;
        CLLocationDistance alt = 100;
        CLLocationCoordinate2D pointDeVue = CLLocationCoordinate2DMake(map.centerCoordinate.latitude +0.01, map.centerCoordinate.longitude);
       
        [map setPitchEnabled:YES];
        [map setShowsBuildings:YES];
                if (camera!=nil) {
            [camera release];
        }
        camera = [[MKMapCamera cameraLookingAtCenterCoordinate:ouAller fromEyeCoordinate:pointDeVue eyeAltitude: alt] retain];
        [map setCamera:camera];
        [self afficher:[NSString stringWithFormat:@"clef-mode0"]];

    }
    if([segment selectedSegmentIndex]==1){
        [map setMapType:MKMapTypeStandard];
        [map setPitchEnabled:NO];
        [map setShowsBuildings:NO];
        [self afficher:[NSString stringWithFormat:@"clef-mode1"]];
        
    }
    if ([segment selectedSegmentIndex] == 2) {
        [map setMapType:MKMapTypeSatellite];
        [self afficher:[NSString stringWithFormat:@"clef-mode2"]];
    }
    if ([segment selectedSegmentIndex] ==3) {
        [map setMapType:MKMapTypeHybrid];
        [self afficher:[NSString stringWithFormat:@"clef-mode3"]];
    }
  
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];// cacher la fenetre de la bibliothéque
    NSString *mediatype = [info objectForKey:UIImagePickerControllerMediaType];// récupérer le type film ou photo
    if (CFStringCompare((CFStringRef) mediatype, kUTTypeImage, 0)== kCFCompareEqualTo) {// si type est image
        pin2.myImage =[info objectForKey:UIImagePickerControllerEditedImage];

      //  UIImage *img =[info objectForKey:UIImagePickerControllerEditedImage];
        if (!pin2.myImage) {
            pin2.myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if (unephoto) {
            [unephoto removeFromSuperview];
            [unephoto release];
        }
       
        
        unephoto = [[UIImageView alloc]initWithImage:pin2.myImage];
        pin2.activate = true;
        [self addSubview:unephoto];
       
          [unephoto sizeToFit];
        [self positionner:[[UIScreen mainScreen]bounds].size];
        
    }else{
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"clef-problem", comment="") message:NSLocalizedString(@"clef-movie", comment="") delegate:nil cancelButtonTitle:NSLocalizedString(@"clef-ok", comment="") otherButtonTitles:nil]show];
    }
    

}




// quand selectionne une contact qsq ce passe
-(void) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    NSString *firstName= (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName!=nil) {
        NomPrenom = firstName;
    }
    // On récupère le nom et le prénom du contact sélectionné
    NSString *lastName= (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName!=nil) {
        NomPrenom = [NSString stringWithFormat:@"%@ %@",NomPrenom,lastName];
    }
    [pin2 setSubtitle:NomPrenom];
    
}





-(BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return false;
}





-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {  //a chaque fois je déplace
    CLLocationCoordinate2D coord = {.latitude = [[locations objectAtIndex:[locations count]-1]coordinate].latitude,
        .longitude = [[locations objectAtIndex:[locations count]-1]coordinate].longitude };
    MKCoordinateSpan span = {.latitudeDelta = 0.035, .longitudeDelta = 0.035};
    MKCoordinateRegion region = {coord,span};
    [map setRegion:region animated:YES];
    [map setNeedsDisplay];
    [map setShowsUserLocation:YES];  // mettre le clignanté
    [locMngr stopUpdatingLocation]; // arrete la localisation
}




-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{// cas ou on perd la localisation
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"clef-error", comment="")  message:NSLocalizedString(@"clef-loaclisation-dés", comment="")  delegate:nil cancelButtonTitle:NSLocalizedString(@"clef-ok", comment="") otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}




-(void) ajouterPin:(id) sender{             // ajout d'un nouveau pin
    UneAnnotation *newAnnotation = [[UneAnnotation alloc]init];
    [label2 setText:[NSString stringWithFormat:NSLocalizedString(@"clef-pingle", comment=""),compteur]];
    [newAnnotation setTitle:[NSString stringWithFormat:NSLocalizedString(@"clef-contact", comment=""),compteur++]];
   
     newAnnotation.subtitle = NSLocalizedString(@"clef-noContact", comment="");
    [newAnnotation setCoordinate:[map centerCoordinate]];
    [map addAnnotation:newAnnotation];
    [newAnnotation release];
}
/*-(void) mapView:(MKMapView *)theMapView didUpdateUserLocation:(MKUserLocation *)userLocation{ // déplacement de utilisateur
    MKCoordinateSpan span = {.latitudeDelta = 0.035, .longitudeDelta = 0.035};
    MKCoordinateRegion region = {[[userLocation location] coordinate],span};
    [theMapView setRegion:region animated:YES];
}*/

-(MKAnnotationView *)mapView:(MKMapView *)thisMapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if (annotation==[thisMapView userLocation]) {   // le cas ou pin tombe sur la position de utilisateur
        return nil;
    }
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"ppm"];
    [pin setPinColor:MKPinAnnotationColorGreen];
    [pin setCanShowCallout:YES];
    [pin setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
   
    return pin;
    
    
}
/*-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
}*/
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
   
    pin2 = view.annotation;
    appareilPhoto.enabled = true;
    supprimer.enabled = true;
    liste.enabled = true;
    book.enabled =true;
   
    if (pin2.myImage) {
        unephoto.image  = pin2.myImage;
        unephoto.hidden = false;
        pin2.activate = true;
        [self positionner:[[UIScreen mainScreen]bounds].size];
    }

}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    supprimer.enabled = false;
    appareilPhoto.enabled =false;
    book.enabled =false;
    liste.enabled = false;
    pin2.activate = false;   
    unephoto.hidden = true;
    [self positionner:[[UIScreen mainScreen]bounds].size];
}

    

@end
