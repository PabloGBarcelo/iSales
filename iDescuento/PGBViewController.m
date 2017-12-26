//
//  PGBViewController.m
//  iDescuento
//
//  Created by Pablo Gutierrez Barcelo on 11/03/13.
//  Copyright (c) 2013 Pablo Gutierrez Barcelo. All rights reserved.
//

#import "PGBViewController.h"

@interface PGBViewController()
@end

@implementation PGBViewController

@synthesize precioSinDescuento, descuento, cantidadAhorrada, precioFinal, celdaAhorro, celdaPrecioFinal, etiquetaCopiado, adView, bannerIsVisible;

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	if (!self.bannerIsVisible) {
		[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
		banner.frame = CGRectOffset(banner.frame, 0, 50);
		[UIView commitAnimations];
		self.bannerIsVisible = YES;
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // assumes the banner view is at the top of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}
- (void)viewDidLoad
{
    // Inserto adbanner
    [super viewDidLoad];
    static NSString * const kADBannerViewClass = @"ADBannerView";
	if (NSClassFromString(kADBannerViewClass) != nil) {
		if (self.adView == nil) {
			self.adView = [[ADBannerView alloc] init];
			self.adView.delegate = self;
			self.adView.frame = CGRectMake(0, -50, 320, 50);
			[self.view addSubview:self.adView];
		}
	}
    
    //Convertimos los bordes de los text label de forma redondeada y en blancos negros o verde.
    precioSinDescuento.layer.cornerRadius=8.0f;
    precioSinDescuento.layer.masksToBounds=YES;
    precioSinDescuento.layer.borderColor=[[UIColor whiteColor]CGColor];
    precioSinDescuento.layer.borderWidth= 1.0f;
    
    descuento.layer.cornerRadius=8.0f;
    descuento.layer.masksToBounds=YES;
    descuento.layer.borderColor=[[UIColor whiteColor]CGColor];
    descuento.layer.borderWidth= 1.0f;
    
    //cantidadAhorrada.layer.cornerRadius=10.0f;
    cantidadAhorrada.layer.masksToBounds=YES;
    cantidadAhorrada.layer.borderColor=[[UIColor greenColor]CGColor];
    cantidadAhorrada.layer.borderWidth= 1.0f;
    cantidadAhorrada.inputView = [[UIView alloc] init];
    
    //celdaPrecioFinal.layer.cornerRadius=10.0f;
    celdaPrecioFinal.layer.masksToBounds=YES;
    celdaPrecioFinal.layer.borderColor=[[UIColor blackColor]CGColor];
    celdaPrecioFinal.layer.borderWidth= 1.0f;
    celdaPrecioFinal.inputView = [[UIView alloc] init];
    etiquetaCopiado.hidden = YES;
    
    //teclado en negro
    precioSinDescuento.keyboardAppearance = UIKeyboardAppearanceAlert;
    descuento.keyboardAppearance = UIKeyboardAppearanceAlert;
	// Do any additional setup after loading the view, typically from a nib.
    
}

    //Copiamos al clipboard al presionar el boton oculto encima de textfield TOTAL
- (IBAction)copiarTotal:(id)sender {
    if(![celdaPrecioFinal.text isEqual:@""])
    {
        [descuento resignFirstResponder];
        [precioSinDescuento resignFirstResponder];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = celdaPrecioFinal.text;
        etiquetaCopiado.text =  NSLocalizedString(@"copiadoTotal", @"");
        [etiquetaCopiado setHidden:NO];
    }

}
    //Copiamos al clipboard al presionar el boton oculto encima de textfield AHORRO
- (IBAction)copiarAhorro:(id)sender {
    if(![cantidadAhorrada.text isEqual:@""])
    {
        [descuento resignFirstResponder];
        [precioSinDescuento resignFirstResponder];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = cantidadAhorrada.text;
        etiquetaCopiado.text =  NSLocalizedString(@"copiadoDescuento", @"");
        [etiquetaCopiado setHidden:NO];
    }

}

//Evitamos que la gente pueda enredar en el resultado
/*-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}*/

//Cambiado por evitar que se puedan meter mas de 12 caracteres.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 12) ? NO : YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Configuracion AdBanner





//Rellenamos los 2 campos con la cuenta.
- (IBAction)rellenarCampos:(id)sender {
    // Si los 2 campos estan cumplimentados se hace la cuenta correspondiente
    if(cantidadAhorrada!=nil & precioSinDescuento!=nil)
    {
        cantidadAhorrada.text = [NSString stringWithFormat:@"%@",[self calcularAhorro]];
        
        celdaPrecioFinal.text = [NSString stringWithFormat:@"%@",[self calcularPrecioFinal]];
    }
    if(etiquetaCopiado.hidden == NO){
        [etiquetaCopiado setHidden:YES];
    }
}

// Con esto ocultamos el teclado al tocar el fondo
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(NSString *)calcularAhorro
{
    //Convierto la cantidad a float
    float cantidadIntroducida = [[precioSinDescuento.text stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue];
    float cantidadDescontada = [[descuento.text stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue];
    
    //Si la cantidad descontada no esta entre 0 y 100
    if( cantidadDescontada>=0 & cantidadDescontada<=100)
    {
    
    float resultado = ((cantidadIntroducida / 100) * cantidadDescontada);
    NSString * ahorroTotal = [NSString stringWithFormat:@"%.2f",resultado];
   
    return ahorroTotal;
    }
    else{
        
    return  NSLocalizedString(@"error porcentaje", @"");
    
    }
}

-(NSString *)calcularPrecioFinal
{
    float cantidadIntroducida = [[precioSinDescuento.text stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue];
    float cantidadDescontada = [[descuento.text stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue];    float resultado = cantidadIntroducida - ((cantidadIntroducida / 100) * cantidadDescontada);
    if( cantidadDescontada>=0 & cantidadDescontada<=100)
    {
    NSString * precioConDescuento = [NSString stringWithFormat:@"%.2f",resultado];
    return precioConDescuento;
    }
    else{
        return  NSLocalizedString(@"error porcentaje", @"");

    }
}

- (IBAction)insertarEuro:(id)sender {
    
    // Asociamos el simbolo antes de mostrar por pantalla.
    NSString *localizedHelloString = NSLocalizedString(@"Moneda", @"");
    //NSLog(@"Esto tiene localized %@",localizedHelloString);
    NSString * euroAnadido = [NSString stringWithFormat:@"%@ %@ ", precioSinDescuento.text,localizedHelloString];
    
    precioSinDescuento.text = euroAnadido;
}

- (IBAction)insertarPorcentaje:(id)sender {
    // Asociamos el simbolo porcentaje antes de mostrar por pantalla.
    NSString * porcentajeAnadido = [NSString stringWithFormat:@"%@ %@", descuento.text,@"% "];
    
    descuento.text = porcentajeAnadido;
}

@end
