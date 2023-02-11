/******************************************************************************************************
 Jeu Memory audio
 
 fichier main ()
 
 auteur: Duplessy Lucas / GEII2 TP1IA      -  date 25 Nov 2022
 ********************************************************************************************************/

/************************************************
 Audio
 ************************************************/

import processing.sound.*;
SoundFile[] file;
SoundFile[] sound;

/************************************************
 début boutons
 ************************************************/

import g4p_controls.*;
GLabel label1, label2, label3;
GImageToggleButton switch1, switch2, switch3;
boolean oldstate1, oldstate2, oldstate3, cheat, mode = false;
int switchSizeX = 356;
int switchSizeY = 120;

/************************************************
 Images
 ************************************************/
int cartesJ = 24; // totale de carte JOUER
int cartesImagesJ = cartesJ/2; //nbr de cartes differentes JOUER

PImage[] images = new PImage[cartesImagesJ]; //permet d'écrire qu'une fois pour toutes les images
ArrayList<PImage> imgs;
PImage DOS, audio; // images de dos et images pour le mode audio

/************************************************
 Autres (suppr dans setup)
 ************************************************/

int cWidth = 189; // largeur cartes à def
int cHeight = 294 ; // hauteur cartes à def

int iColonne = 4; //cartesJ/2
int jColonne = 3; //cartesJ/3

int D=5; // decale de D les images pour cadre
int sizeX= cWidth*iColonne+D;
int sizeY= cHeight*jColonne+D;
int numRevealed = 0; // Nombre de cartes retourné
boolean pause, GOOD = false; // si une pause a été mis et assignement des cartes (si carte deja utilisé)

int rand;
int coups, paire=0;

/************************************************************************************************
 Codes
 ************************************************************************************************/

/************************************************
 Setup
 ************************************************/

public void setup() {
  surface.setTitle("Gestion du jeu et afficheur");
  surface.setResizable(false);
  surface.setLocation(100, 100); //fullScreen(1);

  file = new SoundFile[20];
  sound = new SoundFile[20];

  /**
   DEBUT TIRAGE
   **/

  int[] numbers = new int[cartesImagesJ/2];

  for (int i = 0; i < cartesImagesJ/2; i++) { //mets les images à chaque carte
    GOOD = true;
    do {
      GOOD = true;
      rand = int(random(16)); //commence à 1 jusqu'à nombre de carte
      for (int imax=0; imax<i+1; imax++) {
        if (rand == numbers[imax]) {
          GOOD = false;
        }
      }
    } while (!GOOD); //effectue la relance puis boucle jusqu'à non occupé
    numbers[i] = rand;

    /**
     FIN TIRAGE
     **/

    images[i] = loadImage(rand+".png");
    file[i] = new SoundFile(this, "notes/" + rand + ".mp3");
    println(rand);
  }
  for (int i = 0; i < cartesImagesJ/2; i++) {
    print(numbers[i]+" ");
  }
  DOS = loadImage("DOS.png");
  audio = loadImage("audio.png");

  /************************************************************************************************
   début boutons
   ************************************************************************************************/
  switch1 = new GImageToggleButton(this, 100, 100, "VISUAUDIO.png", "VISUAUDIO_Over.png", 2, 1); //"VISUCENTERAUDIO.png", "VISUCENTERAUDIO_Over.png", 3 , 1
  switch1.tag = "ON OFF state1 button ";

  switch2 = new GImageToggleButton(this, 100, 100+switchSizeY*1.5, "ONOFF.png", "ONOFF_Over.png", 2, 1);
  switch2.tag = "ON OFF state2 button ";

  /*
  switch3 = new GImageToggleButton(this, 100, 100+switchSizeY*3, "ONOFF.png", "ONOFF_Over.png", 2, 1);
   switch3.tag = "ON OFF state3 button ";
   */

  createLabels();

  PApplet.runSketch(platformNames, new SecondApplet()); // creer un nouvel écran
}

/************************************************************************************************
 SETTINGS
 ************************************************************************************************/


void settings() {
  size(sizeX, sizeY);
}

/************************************************************************************************
 Draw (boucle)
 ************************************************************************************************/

void draw() {
  background(255);
  fill(255);
  rect(-1, -1, sizeX+1, sizeY+1);
  textSize(20);
  fill(0);
  textAlign(0, TOP);
  text("Nombre de coups joués: " + coups/2 + " | Nombre de paires restantes: " + (cartesImagesJ/2 - paire), 10, 10);

  boolean state1 = boolean (handleToggleButtonEvents(switch1)); //si bouton 3états => non boolean
  boolean state2 = boolean (handleToggleButtonEvents(switch2));
  //boolean state3 = boolean (handleToggleButtonEvents(switch3));

  if (state1!=oldstate1) {
    println("button1   state1: " + state1);
    mode = state1;
  }
  if (state2!=oldstate2) {
    println("button2   state2 " + state2);
    cheat = state2;
  }
  /*if (state3!=oldstate3) {
   println("button3   state3 " + state3);
   }*/
  oldstate1 = state1;
  oldstate2 = state2;
  //oldstate3 = state3;
}

int handleToggleButtonEvents(GImageToggleButton button) {
  //println(button + "   state1: " + button.getState()); //recuperer l'état du bouton
  return button.getState();
}

public void createLabels() {
  label1 = new GLabel(this, 150, switchSizeY*(1-0.5), 356, 120/2);
  label1.setOpaque(false);
  label1.setText("Mode memory visuel / Mode memory audio");

  label2 = new GLabel(this, 150, 60+switchSizeY*(1.5), switchSizeX, switchSizeY/2);
  label2.setOpaque(false);
  label2.setText("Mode cheat");

  /*
  label3 = new GLabel(this, 150, 60+switchSizeY*(3), switchSizeX, switchSizeY/2);
   label3.setOpaque(false);
   label3.setText("Difficulté: Inversion des cartes"); */
}
