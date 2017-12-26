//
//  PGBViewController.h
//  iDescuento
//
//  Created by Pablo Gutierrez Barcelo on 11/03/13.
//  Copyright (c) 2013 Pablo Gutierrez Barcelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <QuartzCore/QuartzCore.h>

@interface PGBViewController : UIViewController<UITextFieldDelegate ,ADBannerViewDelegate>{
	ADBannerView *adView;
	BOOL bannerIsVisible;
}

@property(nonatomic, retain) ADBannerView *adView;
@property(nonatomic, assign) BOOL bannerIsVisible;
//Para el iAdBanner

@property (strong, nonatomic) IBOutlet UITextField *precioSinDescuento;
@property (strong, nonatomic) IBOutlet UITextField *descuento;
@property (strong, nonatomic) IBOutlet UITextField *cantidadAhorrada;
@property (strong, nonatomic) IBOutlet UITextField *precioFinal;
- (IBAction)copiarAhorro:(id)sender;

- (IBAction)copiarTotal:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *etiquetaCopiado;

- (IBAction)rellenarCampos:(id)sender;
-(NSString *)calcularAhorro;
-(NSString *)calcularPrecioFinal;
- (IBAction)insertarEuro:(id)sender;
- (IBAction)insertarPorcentaje:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *celdaAhorro;
@property (strong, nonatomic) IBOutlet UITextField *celdaPrecioFinal;

@end
