/*
  Firware do equipamento ULTRACIF
  v0.1 - 16/09/202
  @cadupalmieri
*/

//Coloque o tempo de descontaminação ( em segundos) na configuração abaixo
#define tempo_uv 300 //em segundos

//Configurações do motor
#include "BasicStepperDriver.h"
#define MOTOR_STEPS 200
#define RPM 0.05
#define MICROSTEPS 32
#define DIR 5
#define STEP 6
#define SLEEP 7
BasicStepperDriver stepper(MOTOR_STEPS, DIR, STEP, SLEEP);

//Configurações entradas e saidas.
#define buzzer 3
#define lampada  4
#define botao  10

#define ldr_1 A2
#define ldr_2 A0
#define ldr_3 A1

#define hall   A3
#define led_g  A4
#define led_r  A5
#define led_b  11

//Variaveis
long tempo;
bool start = 1;
bool libera = 0;
long time_pisca;

void setup() {
  Serial.begin(9600);

  pinMode(lampada, OUTPUT);
  pinMode(buzzer, OUTPUT);

  pinMode(led_r, OUTPUT);
  pinMode(led_g, OUTPUT);
  pinMode(led_b, OUTPUT);

  pinMode(botao, INPUT_PULLUP);

  stepper.begin(RPM, MICROSTEPS);
  stepper.setEnableActiveState(LOW);


  sensor_lampadas();
  delay(500);
}

void loop() {
  if (!digitalRead(botao) &  start) {
    sensor_lampadas();
    if (libera) {
      start = 0;

      Serial.println("Inicia Ciclo") ;

      stepper.enable();
      stepper.begin(5, MICROSTEPS);
      stepper.move(-20 * MICROSTEPS);

      while (analogRead(hall) < 225) {
        stepper.move(1 * MICROSTEPS);
        delay(10);
      }

      Serial.println("Bateu sensor inicio") ;
      // Zerou
      digitalWrite(buzzer, HIGH);
      delay(500);
      digitalWrite(buzzer, LOW);


      stepper.begin(10, MICROSTEPS);
      stepper.move(80 * MICROSTEPS);

      delay(100);

      digitalWrite(lampada, HIGH);


      Serial.println("Inicia Descontaminacao") ;
      stepper.begin(1, MICROSTEPS);
      long start_uv = millis();
      azul();

      float rpm = (40.0 * 3) / (tempo_uv / 0.1) ;
      Serial.print("rpm = ");
      Serial.println(rpm, 10);

      stepper.begin(rpm, MICROSTEPS);
      for (int i = 0 ; i < 40; i++) {

        stepper.move(1 * MICROSTEPS);
        delay(10);

        if ((millis() - time_pisca)  > 5000) {
          digitalWrite(buzzer, HIGH);
          azul();
          delay(100);
          digitalWrite(buzzer, LOW);
          apagado();
          time_pisca = millis();
        }
      }
      Serial.println("Fim Descontaminacao") ;
      Serial.print("Tempo_total = ");
      Serial.println((millis() - start_uv) / 1000);

      digitalWrite(lampada, LOW);

      stepper.begin(10, MICROSTEPS);

      while (analogRead(hall) < 225) {
        stepper.move(1 * MICROSTEPS);
        delay(10);
      }

      Serial.println("Bateu sensor fim ") ;
      for (int i = 0 ; i < 10; i++) {
        digitalWrite(buzzer, HIGH);
        delay(80);
        digitalWrite(buzzer, LOW);
        delay(40);
      }
      azul();
      stepper.disable();
      digitalWrite(buzzer, LOW);
      delay(1000);
      verde();
      start = 1;
      Serial.println("Fim Ciclo") ;
    }
  }
}



void sensor_lampadas() {
  digitalWrite(lampada, HIGH);
  delay(500);

  float l_1 = 0, l_2 = 0, l_3 = 0;
  for (int i = 0 ; i < 100; i++) {
    l_1 = analogRead(ldr_1) * 5 / 1023.0;
    l_2 = analogRead(ldr_2) * 5 / 1023.0;
    l_3 = analogRead(ldr_3) * 5 / 1023.0;
    delay(10);
  }
  digitalWrite(lampada, LOW);

  Serial.print("L1 = ");
  Serial.print(l_1);
  Serial.print("   L2 = ");
  Serial.print(l_2);
  Serial.print("   L3 = ");
  Serial.println(l_3);
  delay(100);
  if (l_1 >= 4.5 || l_2 >= 4.5 || l_3 >= 4.5) {
    Serial.println("ha uma lampada queimada");
    apagado();
    digitalWrite(buzzer, HIGH);
    vermelho();
    delay(3000);
    digitalWrite(buzzer, LOW);
    libera = 0;
  }
  else {
    Serial.println("Lampadas ok");
    verde();
    digitalWrite(buzzer, LOW);
    libera = 1;
  }
}


void roxo() {
  digitalWrite(led_r, HIGH);
  digitalWrite(led_g, LOW);
  digitalWrite(led_b, HIGH);
}

void verde() {
  digitalWrite(led_r, LOW);
  digitalWrite(led_g, HIGH);
  digitalWrite(led_b, LOW);
}

void vermelho() {
  digitalWrite(led_r, HIGH);
  digitalWrite(led_g, LOW);
  digitalWrite(led_b, LOW);
}

void azul() {
  digitalWrite(led_r, LOW);
  digitalWrite(led_g, LOW);
  digitalWrite(led_b, HIGH);
}

void branco() {
  digitalWrite(led_r, HIGH);
  digitalWrite(led_g, HIGH);
  digitalWrite(led_b, HIGH);
}

void apagado() {
  digitalWrite(led_r, LOW);
  digitalWrite(led_g, LOW);
  digitalWrite(led_b, LOW);
}
