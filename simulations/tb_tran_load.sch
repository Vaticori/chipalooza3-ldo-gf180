v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Load transient: Iload 0 -> 10mA -> 0, 1us edges, VIN = 5V} -700 -700 0 0 0.6 0.6 {}
T {DUT: xschem/ldo.sch (capless LDO, 5.0V -> 3.3V). CL = 2pF models on-chip load/routing capacitance.} -700 -640 0 0 0.3 0.3 {}
C {ldo.sym} 600 0 0 0 {name=x1}
C {devices/lab_pin.sym} 450 -30 0 0 {name=l69 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 450 -10 0 0 {name=l70 sig_type=std_logic lab=VREF}
C {devices/lab_pin.sym} 450 10 0 0 {name=l71 sig_type=std_logic lab=EN}
C {devices/lab_pin.sym} 750 -30 2 0 {name=l72 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 750 -10 2 0 {name=l73 sig_type=std_logic lab=FB_BUF}
C {devices/lab_pin.sym} 750 10 2 0 {name=l74 sig_type=std_logic lab=EAOUT_BUF}
C {devices/lab_pin.sym} 750 30 2 0 {name=l75 sig_type=std_logic lab=0}
C {devices/vsource.sym} 0 -150 0 0 {name=Vvin
value="5"}
C {devices/lab_pin.sym} 0 -180 0 0 {name=l76 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 0 -120 0 0 {name=l77 sig_type=std_logic lab=0}
C {devices/vsource.sym} 120 -150 0 0 {name=Vvref
value="1.2"}
C {devices/lab_pin.sym} 120 -180 0 0 {name=l78 sig_type=std_logic lab=VREF}
C {devices/lab_pin.sym} 120 -120 0 0 {name=l79 sig_type=std_logic lab=0}
C {devices/vsource.sym} 240 -150 0 0 {name=Ven
value="3.3"}
C {devices/lab_pin.sym} 240 -180 0 0 {name=l80 sig_type=std_logic lab=EN}
C {devices/lab_pin.sym} 240 -120 0 0 {name=l81 sig_type=std_logic lab=0}
C {devices/isource.sym} 950 120 0 0 {name=Iload
value="PULSE(0 10m 20u 1u 1u 40u 200u)"}
C {devices/lab_pin.sym} 950 90 0 0 {name=l82 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 950 150 0 0 {name=l83 sig_type=std_logic lab=0}
C {devices/capa.sym} 1060 120 0 0 {name=CL
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {devices/lab_pin.sym} 1060 90 0 0 {name=l84 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 1060 150 0 0 {name=l85 sig_type=std_logic lab=0}
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
tran 20n 100u
write tb_tran_load.raw v(vout)
wrdata tb_tran_load.txt v(vout)
meas tran vpre avg v(vout) from=10u to=19u
meas tran vmin min v(vout) from=19u to=40u
meas tran vhi avg v(vout) from=50u to=59u
meas tran vmax max v(vout) from=60u to=90u
meas tran vpost avg v(vout) from=90u to=99u
let undershoot = (vpre - vmin)*1e3
let overshoot = (vmax - vpost)*1e3
echo RESULT load_undershoot_mV $&undershoot
echo RESULT load_overshoot_mV $&overshoot
.endc
"}
B 2 -700 250 300 750 {flags=graph
y1=3.0
y2=3.6
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=0.0001
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
rawfile=$netlist_dir/tb_tran_load.raw
sim_type=tran
autoload=1}
