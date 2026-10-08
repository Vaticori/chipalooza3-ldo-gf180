v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {EN threshold: EN swept 0 -> 3.3V, Rload = 660 Ohm, VIN = 4.5 / 5.5V} -700 -700 0 0 0.6 0.6 {}
T {DUT: xschem/ldo.sch (capless LDO, 5.0V -> 3.3V). CL = 2pF models on-chip load/routing capacitance.} -700 -640 0 0 0.3 0.3 {}
C {ldo.sym} 600 0 0 0 {name=x1}
C {devices/lab_pin.sym} 450 -30 0 0 {name=l137 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 450 -10 0 0 {name=l138 sig_type=std_logic lab=VREF}
C {devices/lab_pin.sym} 450 10 0 0 {name=l139 sig_type=std_logic lab=EN}
C {devices/lab_pin.sym} 750 -30 2 0 {name=l140 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 750 -10 2 0 {name=l141 sig_type=std_logic lab=FB_BUF}
C {devices/lab_pin.sym} 750 10 2 0 {name=l142 sig_type=std_logic lab=EAOUT_BUF}
C {devices/lab_pin.sym} 750 30 2 0 {name=l143 sig_type=std_logic lab=0}
C {devices/vsource.sym} 0 -150 0 0 {name=Vvin
value="5"}
C {devices/lab_pin.sym} 0 -180 0 0 {name=l144 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 0 -120 0 0 {name=l145 sig_type=std_logic lab=0}
C {devices/vsource.sym} 120 -150 0 0 {name=Vvref
value="1.2"}
C {devices/lab_pin.sym} 120 -180 0 0 {name=l146 sig_type=std_logic lab=VREF}
C {devices/lab_pin.sym} 120 -120 0 0 {name=l147 sig_type=std_logic lab=0}
C {devices/vsource.sym} 240 -150 0 0 {name=Ven
value="0"}
C {devices/lab_pin.sym} 240 -180 0 0 {name=l148 sig_type=std_logic lab=EN}
C {devices/lab_pin.sym} 240 -120 0 0 {name=l149 sig_type=std_logic lab=0}
C {devices/res.sym} 950 120 0 0 {name=Rload
value=660
footprint=1206
device=resistor
m=1}
C {devices/lab_pin.sym} 950 90 0 0 {name=l150 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 950 150 0 0 {name=l151 sig_type=std_logic lab=0}
C {devices/capa.sym} 1060 120 0 0 {name=CL
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {devices/lab_pin.sym} 1060 90 0 0 {name=l152 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 1060 150 0 0 {name=l153 sig_type=std_logic lab=0}
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
dc Ven 0 3.3 0.005 Vvin 4.5 5.5 1
write tb_en_dc.raw v(vout) v(en)
wrdata tb_en_dc.txt v(vout)
alter Vvin dc = 4.5
dc Ven 0 3.3 0.005
meas dc en_th_45 when v(vout)=1.65 rise=1
echo RESULT en_threshold_V_at_VIN4p5 $&en_th_45
alter Vvin dc = 5.5
dc Ven 0 3.3 0.005
meas dc en_th_55 when v(vout)=1.65 rise=1
echo RESULT en_threshold_V_at_VIN5p5 $&en_th_55
.endc
"}
B 2 -700 250 300 750 {flags=graph
y1=-0.5
y2=3.6
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=3.3
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
rawfile=$netlist_dir/tb_en_dc.raw
sim_type=dc
autoload=1}
