import 'dart:math';

double predicao(double elevacao, double gama, double teta){

    if(gama < 1000.0){
      if(elevacao < 1.0){
        return 0.0;
      }

      return 0.0;
    } 

    var f_s = 0.95;
    var rho = 0.94;
    var phi = 0.9;
    // var gama = 2160;
    var alfa_abs = 0.9;
    var e = 0.24;
    var k = 0.06;
    var sigma=0.0000000567;
    var v_vento = 2.77;
    var t_amb = 27+273;
    var ks = 0.55;
    var n_gerador = 1.0;
    // var elevacao = 61.08;
    // var teta = 45;
    var pi = 3.1415;
  
    // formula da energia no concentrador (W)
    var n_conc = f_s * rho * phi;
    var ir_cor = (gama/3.6) * n_conc * cos((pi/180)*(teta-elevacao)); 
    var a_conc = pow(0.6, 2) * (pi/4);
    var p_conc = ir_cor * a_conc;
     
    // formula da energia no receptor
    var a_recep = pow(0.05, 2) * (pi/4);
    var C = a_conc/a_recep;
    var Cmax_real = C*alfa_abs*rho;
    var t_recep_teo1 = (ir_cor*Cmax_real*alfa_abs) * (k/(sigma*e)); 
    var t_recep_teo = sqrt(sqrt(t_recep_teo1));
  
    // perda por convecção
    // hc=7.12*(v_vento  0.775) + 5.129  (-0.6*v_vento)
    var hc = 7.12 * pow(v_vento, 0.775) + pow(5.129, ((-0.6)*v_vento));
    var Q_conv = hc * a_recep * (t_recep_teo - t_amb);
  
    // perda por radiação
    var T_sky = 0.055 * pow(300, 1.5);
    var Q_rad = e * sigma * a_recep * (pow(t_recep_teo, 4) - pow(T_sky, 4));
    
    // energia util no receptor
    var P_recep = p_conc - Q_rad - Q_conv;
  
    // eficiencia Stirling 
    var n_str = ks * 1- t_amb/t_recep_teo;
  
    // energia no Stirling 
    var p_str = P_recep * n_str;
  
    // calculo da enegia no gerador
    var w_gerador = n_gerador * p_str;
  
    return w_gerador;
}