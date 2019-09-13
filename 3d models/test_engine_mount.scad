include <SwitecX27_168.scad> 

HOLE_K=1.02;

INST_H=13;
INST_D=70;

CARD_H=1;
CARD_D=9/10*INST_D;

   scale([HOLE_K, HOLE_K, HOLE_K]) {
            SwitecX25_168(enableScrews=true);
        }
        