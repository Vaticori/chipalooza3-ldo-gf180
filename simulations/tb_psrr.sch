v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {PSRR: 1V AC on VIN, 10Hz - 10MHz, Iload = 5mA, VIN = 5V} -700 -700 0 0 0.6 0.6 {}
T {DUT: xschem/ldo.sch (capless LDO, 5.0V -> 3.3V). CL = 2pF models on-chip load/routing capacitance.} -700 -640 0 0 0.3 0.3 {}
C {ldo.sym} 600 0 0 0 {name=x1}
C {devices/lab_pin.sym} 450 -30 0 0 {name=l103 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 450 -10 0 0 {name=l104 sig_type=std_logic lab=VREF}
C {devices/lab_pin.sym} 450 10 0 0 {name=l105 sig_type=std_logic lab=EN}
C {devices/lab_pin.sym} 750 -30 2 0 {name=l106 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 750 -10 2 0 {name=l107 sig_type=std_logic lab=FB_BUF}
C {devices/lab_pin.sym} 750 10 2 0 {name=l108 sig_type=std_logic lab=EAOUT_BUF}
C {devices/lab_pin.sym} 750 30 2 0 {name=l109 sig_type=std_logic lab=0}
C {devices/vsource.sym} 0 -150 0 0 {name=Vvin
value="DC 5 AC 1"}
C {devices/lab_pin.sym} 0 -180 0 0 {name=l110 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 0 -120 0 0 {name=l111 sig_type=std_logic lab=0}
C {devices/vsource.sym} 120 -150 0 0 {name=Vvref
value="1.2"}
C {devices/lab_pin.sym} 120 -180 0 0 {name=l112 sig_type=std_logic lab=VREF}
C {devices/lab_pin.sym} 120 -120 0 0 {name=l113 sig_type=std_logic lab=0}
C {devices/vsource.sym} 240 -150 0 0 {name=Ven
value="3.3"}
C {devices/lab_pin.sym} 240 -180 0 0 {name=l114 sig_type=std_logic lab=EN}
C {devices/lab_pin.sym} 240 -120 0 0 {name=l115 sig_type=std_logic lab=0}
C {devices/isource.sym} 950 120 0 0 {name=Iload
value="5m"}
C {devices/lab_pin.sym} 950 90 0 0 {name=l116 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 950 150 0 0 {name=l117 sig_type=std_logic lab=0}
C {devices/capa.sym} 1060 120 0 0 {name=CL
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {devices/lab_pin.sym} 1060 90 0 0 {name=l118 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 1060 150 0 0 {name=l119 sig_type=std_logic lab=0}
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
ac dec 20 10 10meg
write tb_psrr.raw v(vout) v(vin)
let psrr = -db(v(vout)/v(vin))
wrdata tb_psrr.txt psrr
meas ac psrr_lf find psrr at=100
meas ac psrr_10k find psrr at=10k
meas ac psrr_1meg find psrr at=1meg
echo RESULT psrr_100Hz_dB $&psrr_lf
echo RESULT psrr_10kHz_dB $&psrr_10k
echo RESULT psrr_1MHz_dB $&psrr_1meg
.endc
"}
B 2 -700 250 300 750 {flags=graph
y1=-80
y2=0
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1
x2=7
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="vout db20()"
color="4"
dataset=-1
unitx=1
logx=1
logy=0
rawfile=$netlist_dir/tb_psrr.raw
sim_type=ac
autoload=1}
