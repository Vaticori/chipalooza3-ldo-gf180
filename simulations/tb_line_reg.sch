v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Line regulation: VIN 4.5 -> 5.5V, Iload = 5mA} -700 -700 0 0 0.6 0.6 {}
T {DUT: xschem/ldo.sch (capless LDO, 5.0V -> 3.3V). CL = 2pF models on-chip load/routing capacitance.} -700 -640 0 0 0.3 0.3 {}
C {ldo.sym} 600 0 0 0 {name=x1}
C {devices/lab_pin.sym} 450 -30 0 0 {name=l18 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 450 -10 0 0 {name=l19 sig_type=std_logic lab=VREF}
C {devices/lab_pin.sym} 450 10 0 0 {name=l20 sig_type=std_logic lab=EN}
C {devices/lab_pin.sym} 750 -30 2 0 {name=l21 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 750 -10 2 0 {name=l22 sig_type=std_logic lab=FB_BUF}
C {devices/lab_pin.sym} 750 10 2 0 {name=l23 sig_type=std_logic lab=EAOUT_BUF}
C {devices/lab_pin.sym} 750 30 2 0 {name=l24 sig_type=std_logic lab=0}
C {devices/vsource.sym} 0 -150 0 0 {name=Vvin
value="5"}
C {devices/lab_pin.sym} 0 -180 0 0 {name=l25 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 0 -120 0 0 {name=l26 sig_type=std_logic lab=0}
C {devices/vsource.sym} 120 -150 0 0 {name=Vvref
value="1.2"}
C {devices/lab_pin.sym} 120 -180 0 0 {name=l27 sig_type=std_logic lab=VREF}
C {devices/lab_pin.sym} 120 -120 0 0 {name=l28 sig_type=std_logic lab=0}
C {devices/vsource.sym} 240 -150 0 0 {name=Ven
value="3.3"}
C {devices/lab_pin.sym} 240 -180 0 0 {name=l29 sig_type=std_logic lab=EN}
C {devices/lab_pin.sym} 240 -120 0 0 {name=l30 sig_type=std_logic lab=0}
C {devices/isource.sym} 950 120 0 0 {name=Iload
value="5m"}
C {devices/lab_pin.sym} 950 90 0 0 {name=l31 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 950 150 0 0 {name=l32 sig_type=std_logic lab=0}
C {devices/capa.sym} 1060 120 0 0 {name=CL
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {devices/lab_pin.sym} 1060 90 0 0 {name=l33 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 1060 150 0 0 {name=l34 sig_type=std_logic lab=0}
C {devices/code_shown.sym} -700 -560 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} -700 -380 0 0 {name=CONTROL
only_toplevel=true
value="

.control
dc Vvin 4.5 5.5 0.01
write tb_line_reg.raw v(vin) v(vout)
wrdata tb_line_reg.txt v(vout)
meas dc vmax max v(vout)
meas dc vmin min v(vout)
let line_pct = (vmax - vmin)/3.3*100
echo RESULT line_reg_pct $&line_pct
.endc
"}
B 2 -700 250 300 750 {flags=graph
y1=3.25
y2=3.35
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=4.5
x2=5.5
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="vout"
color="4"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_line_reg.raw
sim_type=dc
autoload=1}
