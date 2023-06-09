#include(macros.inc)

[top]
components : genSustancias@NodeGenerator system
link : aout@genSustancias in@system

[genSustancias]
distribution : poisson
mean : 3

[system]
%in: in
%link: in in@system(0,0,0)
%portInTransition: in@system(0,0,0) establecerViento

type : cell
%Dim=Nc=LxL%
dim : (16,16,4)

delay : transport
defaultDelayTime : 100
border : wrapped 

neighbors :               system(-1,-1,0) system(-1,0,0) system(-1,1,0) 
neighbors : system(0,0,-2) system(0,-1,0)  system(0,0,0)  system(0,1,0) system(0,0,2) 
neighbors :               system(1,-1,0)  system(1,0,0)  system(1,1,0) 

neighbors : system(-1,-1,1) system(-1,0,1) system(-1,1,1) 
neighbors : system(0,-1,1)  system(0,0,1)  system(0,1,1)
neighbors : system(1,-1,1)  system(1,0,1)  system(1,1,1) 

neighbors : system(-1,-1,-1) system(-1,0,-1) system(-1,1,-1) 
neighbors : system(0,-1,-1)  system(0,0,-1)  system(0,1,-1)
neighbors : system(1,-1,-1)  system(1,0,-1)  system(1,1,-1) 

initialvalue : 0
%initialCellsValue : nodes.val

in : in
link : in in@system(0,0,1)
link : in in@system(15,0,1)

%localtransition : %
zone : Energy { (0,0,0)..(15,15,0) }
zone : Energy_max { (0,0,1)..(15,15,1) }
zone : Energy_min { (0,0,2)..(15,15,2) }
zone : Conductivity { (0,0,3)..(15,15,3) }

[establecerViento]
rule {30} 100 {t}


[Energy]
%%%%%%%%%%%%%%%%%%%%%%%
%rule 1 bis
%%%%%%%%%%%%%%%%%%%%%%%
% if E_t > E_max
% distribute Delta-E: E_vecino= E_vecino + 0.25(E_t - E_min)  
rule : {(0,0,0) + 0.25*(-1,0,0) - 0.25*(0,0,2) } 100 { (-1,0,0)>= #macro(E_max) and cellpos(0)!=0}  
rule : {(0,0,0) + 0.25*(1,0,0) - 0.25*(0,0,2) } 100 { (1,0,0)>= #macro(E_max) and cellpos(0)!= (-1+#macro(CantFilas)) }  
rule : {(0,0,0) + 0.25*(0,1,0) - 0.25*(0,0,2) } 100 { (0,1,0)>= #macro(E_max) and cellpos(1)!= (-1+#macro(CantFilas))}  
rule : {(0,0,0) + 0.25*(0,-1,0) - 0.25*(0,0,2) } 100 { (0,-1,0)>= #macro(E_max) and cellpos(1)!=0}  

%%%%%%%%%%%%%%%%%%%%%%%
%rule 1
%%%%%%%%%%%%%%%%%%%%%%%
% if E_t > E_max
% then E_t+1 = E_min and distribute Delta-E 
rule : {(0,0,2)} 100 { (0,0,0)>= #macro(E_max)}  

%%%%%%%%%%%%%%%%%%%%%%%
%rule -1
%%%%%%%%%%%%%%%%%%%%%%%
% if E_max > 0 and  d*E_max+ E_t < E_max (d=0.02)
% then E_t+1 = d*E_max+ E_t
%rule : {0.02*(0,0,1)+(0,0,0)} 100 { (0,0,1)>0 and (0.02*(0,0,1)+(0,0,0))<=(0,0,1) } 
rule : {#macro(E_max)*0.02 +(0,0,0)} 100 { (0,0,1)>0 }  %Con la restriccion anterior nunca se llega al valor maximo  

%%%%%%%%%%%%%%%%%%%%%%%
%default rule
%%%%%%%%%%%%%%%%%%%%%%%
rule : {(0,0,0)} 100 { t } 

[Energy_max]
%%%%%%%%%%%%%%%%%%%%%%%
%rule 0
%%%%%%%%%%%%%%%%%%%%%%%
%E_max(1,j)=E_max(50,j)=(-Bz)IMF (shifted along the boundaries)
%rule : {(0,-1,0)} 100 { (0,-1,0)= #macro(E_max) and (0,0,0)=0 } 
rule : {(0,-1,0)} 100 {(0,0,0)=0 } 
%rule : 0 100 { (0,0,0)= #macro(E_max) } %esta regla adicional es para que haga shift

%%%%%%%%%%%%%%%%%%%%%%%
%default rule
%%%%%%%%%%%%%%%%%%%%%%%
rule : {(0,0,0)} 100 { t }

[Energy_min]
%%%%%%%%%%%%%%%%%%%%%%%
%default rule
%%%%%%%%%%%%%%%%%%%%%%%
rule : {#macro(E_min)} 100 { (0,0,0)=0 } 

%%%%%%%%%%%%%%%%%%%%%%%
%rule 4
%%%%%%%%%%%%%%%%%%%%%%%
%if C_t < C_max
%then E_min = k*E_max
rule : {0.75 * #macro(E_max) } 100 { (0,0,1) < #macro(C_max) and (0,0,1)!=0}

%if C_t >= C_max
%then E_min = 0
rule : 0.0001  100 { (0,0,1) >= #macro(C_max) }

%%%%%%%%%%%%%%%%%%%%%%%
%default rule
%%%%%%%%%%%%%%%%%%%%%%%
rule : {(0,0,0)} 100 { t }

[Conductivity]
%%%%%%%%%%%%%%%%%%%%%%%
%rule 2 & 3
%%%%%%%%%%%%%%%%%%%%%%%
% if E_t < E_max 
% then C_t= a*C_t + b ; a=0.2  b= 0 
rule : {0.2*(0,0,0)} 100 {(0,0,1) < #macro(E_max) }

% if E_t >= E_max 
% then C_t= a*C_t + b ; a=0.2  b = Delta-E = E - Emin 
rule : {0.2*(0,0,0) + (0,0,1) - (0,0,-1) } 100 {(0,0,1) >= #macro(E_max) }

%%%%%%%%%%%%%%%%%%%%%%%
%default rule
%%%%%%%%%%%%%%%%%%%%%%%
rule : {(0,0,0)} 100 { t }

