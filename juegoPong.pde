
import ddf.minim.*;

AudioSample jugadorA,jugadorB,mamamia,start,fin;
Minim minim;

int posxA,posyA; //jugador A
int posxB,posyB; //jugador B
int dim1,dim2;
boolean teclasA,teclasB = false;
int puntosA,puntosB;
float ballx,bally;
int desplazamientoX = 5;
int desplazamientoY = 5;
int direccionX; //derecha-izq
int direccionY = 1; //arriba-abajo
boolean inicio = false;
boolean finPartida = false;




/* Falta:
-Pantalla de finalizado
-Plus pelota epileptica
-Pelota inirandom
*/
void setup(){
  //SONIDOS
  minim = new Minim(this);

  jugadorA = minim.loadSample("pika.wav", 512);
  jugadorB = minim.loadSample("squirtle.wav", 512);
  mamamia = minim.loadSample("mario-mamamia.wav", 512);
  start = minim.loadSample("mario-okiedokie.wav", 512);
  fin = minim.loadSample("mario-yahoo.wav", 512);
  
  //Caracteristicas de la pantalla
  size(1000,600);
  dim1 = 20;
  dim2 = 80;
  
  //Inicialización de las variables
  posxA = 0+20;
  posyA = height/2 - 40;
  posxB = width-40;
  posyB = height/2 - 40;
  
  ballx=width/2;
  puntosA = 0;
  puntosB = 0;
  direccionX = -1;
  //frameRate(4);
  
}

void draw(){
  background(0);
  if(inicio && finPartida == false){ //Partida iniciada
    //Pintar la linea del medio
    stroke(255);
    line(width/2, 30, width/2, height-30);
  
    //Movimiento de las palas
    if (teclasA) {
      movimientoA();
    }
    if (teclasB) {
      movimientoB();
    }
    stroke(0);
    fill(255, 249, 53);
    rect(posxA,posyA,dim1,dim2); //Jugador A
    fill(53, 111, 255);
    rect(posxB,posyB,dim1,dim2); //Jugador B 
    
    //Movimiento de la pelota
    ballx = ballx + desplazamientoX*direccionX;//*direccionXX
    bally = bally + desplazamientoY*direccionY; 
    colisionesBall();
    choque();
    marcarPunto();
    
  
    //Pintar la pelota
    
    fill(255,0,0);
    ellipse(ballx,bally,20,20);
  
    //Pintar la puntuación
    textSize(32);
    fill(255);
    text(puntosA,width/2 -40 , 40 ); 
    text(puntosB,width/2 +20 , 40 ); 
    
  }else if(!inicio){ //Partida no iniciada
    fill(255);
    textSize(76); 
    text("Juego Pong", 320, 200 );
    textSize(26); 
    text("Pulse la tecla espacio para empezar", 300, 300 );
    textSize(16);
    text("Controles del jugador 1: W-S\nControles del jugador 2: O-L", 300, 350 );
    if(keyPressed == true && key == 32){
      inicio = true;  
      start.trigger();
    }
  }else if(finPartida){ //finPartida == true
     fill(255);
     textSize(76); 
     text("Juego Pong", 320, 200 );
     if(puntosA>puntosB){
       textSize(26); 
       text("Gana el jugador 1", 300, 300 );
     }else{
       textSize(26); 
       text("Gana el jugador 2", 300, 300 );
     }
     text("Pulse la tecla espacio para volver a jugar", 300, 500 );
     if(keyPressed == true && key == 32){
       inicio = true;  
       finPartida = false;
       puntosA = 0;
       puntosB = 0;
       fin.trigger();
     }
     
  }

}
void randomIni(){
   bally = random(0,height);
   direccionX = (int) random(-1,1);
   while(direccionX == 0) direccionX = (int) random(-1,1);
   direccionY = (int) random(-1,1);
   while(direccionY == 0) direccionY = (int) random(-1,1);  
}

//PUNTUACIÓN
void marcarPunto(){
  if (ballx >= width){ //Punto para A
    puntosA = puntosA +1;
    ballx=width/2;
    bally=height/2;
    direccionX = -1;
    jugadorA.trigger();
  }
  if (ballx <= 0) { //Punto para B
    puntosB = puntosB +1;
    ballx=width/2;
    bally=height/2;
    direccionX = 1;
    jugadorB.trigger();
  }
  if(puntosA == 5 || puntosB == 5){
    finPartida = true;
  }
}

//COLISIONES
void choque(){
  
  if(ballx == posxA+dim1 && bally >= posyA && bally <= posyA+dim2){ 
    direccionX = 1;
    if(bally >= posyA && bally <= posyA+dim2/2){
      direccionY = -1;
    }else{
      direccionY = 1;
    }
    //float aux = ballx*cos(-PI/4)-bally*sin(-PI/4);
    //bally = ballx*sin(-PI/4)+bally*cos(-PI/4);
    //ballx = aux;
  }
  if(ballx == posxB && bally >= posyB && bally <= posyB+dim2){
    direccionX = -1;
    if(bally >= posyB && bally <= posyB+dim2/2){
      direccionY = -1;
    }else{
      direccionY = 1;
    }
  }
}

void colisionesBall(){
  if(bally == 0){ //Choca por la parte de arriba
    direccionY = 1; 
  }
  if(bally == height){ //Choca por la parte de abajo
    direccionY = -1; 
  }
}

//MOVIMIENTOS DE LAS PALAS
void keyPressed() {
  if (key == 119 || key == 115){
    teclasA = true;
  }
  if (key == 111 || key == 108){
    teclasB = true;
  }  
}

void keyReleased() {
  if (key == 119 || key == 115){
    teclasA = false;
  }
  if (key == 111 || key == 108){
    teclasB = false;
  }
}  

void movimientoA() {
  int x = key;
  if(x == 119){ //Tecla W
      posyA = posyA - 10;
      if(posyA < 0){
        posyA = 0;
      }
  }
  if(x == 115){ //Tecla S
      posyA = posyA + 10;
      if(posyA > height-dim2){
        posyA = height-dim2;
      }
  }

}  

void movimientoB() {
  int x = key;
  if(x == 111){  //Tecla O
      posyB = posyB - 10;
      if(posyB < 0){
        posyB = 0;
      }
  }
  if(x == 108){  //Tecla L
      posyB = posyB + 10;
      if(posyB > height-dim2){
        posyB = height-dim2;
      }
  }
}  
