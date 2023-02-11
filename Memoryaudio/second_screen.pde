
/************************************************
 2nd ecran
 ************************************************/

public class SecondApplet extends PApplet { // Gestion 2ème écran
  classTuile[] tuile = new classTuile[cartesJ];
  classTuile[] cartesTrouvés = new classTuile[cartesJ]; // Tableau pour les cartes trouvés


  public void settings() {
    size(sizeX, sizeY);
  }

  public void setup() {
    surface.setTitle("Jeu memory audio");
    surface.setResizable(true);
    surface.setLocation(sizeY, 100);
    background(204, 153, 255);

    init();
  }

  public void draw() {
    fill(113, 0, 14);
    strokeWeight(0);
    rect(-1, -1, sizeX+1, sizeY+1);
    int cartesTrouvé = 0; // nombre cartes retourné

    for (int i = 0; i < cartesImagesJ; i++) {
      tuile[i].dessinTuile(); // Drawing tiles

      // Comptes les tuiles trouvé
      if (tuile[i].touched) {
        cartesTrouvé++;
      }
    }
    textSize(20);
    fill(0, 408, 612);

    if (cartesTrouvé >= cartesImagesJ) { // Message de victoire + pause
      strokeWeight(0);
      fill(255);
      rect(0, 0, width, height);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(40);
      text("Tu as gagné!", width/2, height/2);
      text("Clique pour recommencer une partie.", width/2, height/2 + 40);
      noLoop();
      pause = true;
    }
  }
  class classTuile {
    float tuileX; // coordonnées de la tuile pour X
    float tuileY; // coordonnées de la tuile pour Y
    PImage tuileImages; //stock de l'image sur la tuile
    int ID; // ID de l'image (sur la tuile)
    boolean occuped; //bool si occupé ou non
    boolean touched; //bool si tuile touché / trouvé ou non
    boolean trouved; //bool si tuile touché / trouvé ou non

    classTuile (float x, float y) {
      tuileX = x;
      tuileY = y;
      occuped = false;
      touched = false;
    }

    void dessinTuile() {

      if (touched || cheat) {
        if (mode) {
          image(audio, tuileX+D, tuileY+D, cWidth-D, cHeight-D);
        } else {
          image(this.tuileImages, tuileX+D, tuileY+D, cWidth-D, cHeight-D);
        }
        if (trouved) {
          stroke(255, 61, 61);
          strokeWeight(5);
          line(tuileX, tuileY, tuileX+cWidth, tuileY+cHeight);
        } else {
          if (touched & cheat) {
            stroke(0, 0, 0);
            strokeWeight(5);
            line(tuileX, tuileY, tuileX+cWidth, tuileY+cHeight);
          }
        }
      } else { // REMPLACE PAR L IMAGE DE DOS
        fill(113, 0, 14);
        stroke(113, 0, 14);
        strokeWeight(0);
        rect(tuileX, tuileY, cWidth, cHeight);
        image(DOS, tuileX+D, tuileY+D, cWidth-5, cHeight-5);
      }
    }
  }
  void init() {
    for (int jCountC = 0; jCountC < jColonne; jCountC++) {
      for (int iCountC = 0; iCountC < iColonne; iCountC++) { //println(iCountC * jColonne + jCountC+" ");
        tuile[iCountC * jColonne + jCountC] = new classTuile(iCountC*cWidth, jCountC*cHeight); //new classTuile(iCountC*tWidth, jCountC*tHeight) => tableau
        tuile[iCountC * jColonne + jCountC].dessinTuile();
      }
    }
    // Assigne les images
    for (int i = 0; i < cartesImagesJ/2; i++) {
      melangeCartes(i);
      melangeCartes(i);
    }
  }

  void melangeCartes(int carteN) { //defini la tuile de la carte
    do {
      rand = int(random(cartesImagesJ)); //commence à 1 jusqu'à nombre de carte
    } while (tuile[rand].occuped == true); //effectue la relance puis boucle jusqu'à non occupé


    tuile[rand].tuileImages = images[carteN]; //Recup l'image[n°] sur la tuile et stock
    tuile[rand].occuped = true; // La tuile est maintenant occupé par une carte
    tuile[rand].ID = carteN; // permettra de comparé l'ID des 2cartes
    sound[rand] = file[carteN];
  }
  void mousePressed () {//print(mouseX+" ",mouseY+" ");
    for (int i = 0; i < cartesImagesJ; i++) { // Vérifie si la tuile est vide
      if (mouseX >= tuile[i].tuileX && mouseX <= (tuile[i].tuileX + cWidth) && mouseY >= tuile[i].tuileY && mouseY <= (tuile[i].tuileY + cHeight) && tuile[i].touched == false) {
        coups = coups+1;
        //println(i);
        if (mode) {
          sound[i].play();
        }
        if (numRevealed >= 2) {
          //print(cartesTrouvés[0].ID+" "+cartesTrouvés[1].ID+" ");
          if (cartesTrouvés[0].ID != cartesTrouvés[1].ID) { // Vérifie si les 2 tuiles sont les mêmes
            cartesTrouvés[0].touched = cartesTrouvés[1].touched = false;
          } else {
            if (paire < 6) paire++;
            cartesTrouvés[0].trouved = cartesTrouvés[1].trouved = true;
          }
          numRevealed = 0;
        }

        cartesTrouvés[numRevealed] = tuile[i];
        numRevealed++;
        tuile[i].touched = !tuile[i].touched;
      }
    }

    // Unpause avec le clique
    if (pause) {
      boolean temp = cheat;
      cheat = false;
      pause = false;
      coups = 0;
      paire = -1;
      init();
      cheat = temp;
      loop();
    }
  }
}
