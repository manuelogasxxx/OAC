//librerias necesarias
#include <Stepper.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
// Define motor pins connected to ULN2003 driver
#define MP1  4  // IN1 on the ULN2003
#define MP2  5  // IN2 on the ULN2003
#define MP3  6  // IN3 on the ULN2003
#define MP4  7  // IN4 on the ULN2003
#define SPR 2048  // Steps per revolution (for 28BYJ-48 stepper motor)

//pines del sensor
#define APIN 33
#define DPIN 18
//pines de la pantalla
#define SDA 10
#define SCL 11

//pin del botón
#define PSH 12
//variables necesarias
//para controlar los estados
bool flagBotonAbrir = false;

// Create Stepper object
Stepper stepper(SPR, MP1, MP3, MP2, MP4);
//crear la pantalla
LiquidCrystal_I2C lcd(0x27, 16, 2);
//funciones para abrir y cerrar 
//(se pueden modificar)
void abrir(int pasos){
  stepper.step(pasos);
}
void cerrar(int pasos){
  stepper.step(-pasos);
}

//interrupciones
void IRAM_ATTR intAbrir() {
  flagBotonAbrir = true;
}
void setup() {
  //inicializació de pines
  pinMode(PSH,INPUT);
  // Inicialización del stepper
  stepper.setSpeed(10);
  //inicialización de la pantalla
  lcd.init();
  lcd.backlight();
  //INTERRUPCIONES
  attachInterrupt(PSH, intAbrir, RISING);
}

void loop() {
  //obtener el valor del sensor
  //comprobar
  int valorSensor = analogRead(APIN);
  //transformación de valores
  //mostrar en la pantalla
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Resistencia");
  lcd.setCursor(0,1);
  lcd.print(valorSensor);
  //
  if(valorSensor<1024){
    //abrir
  }
  else{
    //cerrar
  }
  delay(100);  // Wait for 1 second
}