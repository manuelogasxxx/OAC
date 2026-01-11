#include <Stepper.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
// Define motor pins connected to ULN2003 driver
#define MP1  4  // IN1 on the ULN2003
#define MP2  5  // IN2 on the ULN2003
#define MP3  6  // IN3 on the ULN2003
#define MP4  7  // IN4 on the ULN2003
#define SPR 2048  // Steps per revolution (for 28BYJ-48 stepper motor)

//pines del sensor
#define APIN 1
#define DPIN 18
//pines de la pantalla
#define SDA 10
#define SCL 11

//pin del botón
#define PSH 12
//variables necesarias
//para controlar los estados
bool flagBotonAbrir = false;
enum EstadoCortina {CERRADO, ABRIENDO, ABIERTO, CERRANDO};
EstadoCortina estadoActual = CERRADO;
//
const int pasosTotales = 18000;
int umbralLuz =1000;
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

void actualizarLCD(int luz){
  lcd.setCursor(0,0);
  lcd.print("Luz: "); lcd.print(luz); lcd.print("    ");
  lcd.setCursor(0,1);
  if(estadoActual == ABIERTO) lcd.print("Estado: ABIERTO ");
  if(estadoActual == CERRADO) lcd.print("Estado: CERRADO ");
}
void setup() {
  //inicializació de pines
  pinMode(PSH,INPUT);
  pinMode(SDA,OUTPUT);
  pinMode(SCL,OUTPUT);
  pinMode(APIN,INPUT); //para recibir los valores del sensor
  pinMode(DPIN,INPUT);
  // Inicialización del stepper
  stepper.setSpeed(10);
  //inicialización de la pantalla
  lcd.init();
  lcd.backlight();
  //INTERRUPCIONES
  attachInterrupt(PSH, intAbrir, RISING);
}

void loop() {
  int valorSensor = analogRead(APIN);
  actualizarLCD(valorSensor);
  switch (estadoActual) { 
    case CERRADO:
      // Si hay mucha luz o presionamos el botón
      if (valorSensor < umbralLuz || flagBotonAbrir) {
        flagBotonAbrir = false; // Limpiar flag
        estadoActual = ABRIENDO;
      }
      break;

    case ABRIENDO:
      lcd.setCursor(0,1); lcd.print("Abriendo...     ");
      stepper.step(pasosTotales); 
      estadoActual = ABIERTO;
      break;

    case ABIERTO:
      // Si hay poca luz o presionamos el botón
      if (valorSensor > umbralLuz || flagBotonAbrir) {
        flagBotonAbrir = false;
        estadoActual = CERRANDO;
      }
      break;

    case CERRANDO:
      lcd.setCursor(0,1); lcd.print("Cerrando...     ");
      stepper.step(-pasosTotales);
      estadoActual = CERRADO;
      break;
  }
  delay(50);
}


cuando se termina de abrir la ventana se vuelve a cerrar