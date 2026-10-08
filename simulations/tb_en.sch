v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {EN control: EN 0 -> 3.3V -> 0 (harness 3.3V logic), Rload = 660 Ohm (5mA at 3.3V), VIN = 5V} -700 -700 0 0 0.6 0.6 {}
T {DUT: xschem/ldo.sch (capless LDO, 5.0V -> 3.3V). CL = 2pF models on-chip load/routing capacitance.} -700 -640 0 0 0.3 0.3 {}
C {ldo.sym} 600 0 0 0 {name=x1}
C {devices/lab_pin.sym} 450 -30 0 0 {name=l120 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 450 -10 0 0 {name=l121 sig_type=std_logic lab=VREF}
C {devices/lab_pin.sym} 450 10 0 0 {name=l122 sig_type=std_logic lab=EN}
C {devices/lab_pin.sym} 750 -30 2 0 {name=l123 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 750 -10 2 0 {name=l124 sig_type=std_logic lab=FB_BUF}
C {devices/lab_pin.sym} 750 10 2 0 {name=l125 sig_type=std_logic lab=EAOUT_BUF}
C {devices/lab_pin.sym} 750 30 2 0 {name=l126 sig_type=std_logic lab=0}
C {devices/vsource.sym} 0 -150 0 0 {name=Vvin
value="5"}
C {devices/lab_pin.sym} 0 -180 0 0 {name=l127 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 0 -120 0 0 {name=l128 sig_type=std_logic lab=0}
C {devices/vsource.sym} 120 -150 0 0 {name=Vvref
value="1.2"}
C {devices/lab_pin.sym} 120 -180 0 0 {name=l129 sig_type=std_logic lab=VREF}
C {devices/lab_pin.sym} 120 -120 0 0 {name=l130 sig_type=std_logic lab=0}
C {devices/vsource.sym} 240 -150 0 0 {name=Ven
value="PULSE(0 3.3 20u 1u 1u 100u 400u)"}
C {devices/lab_pin.sym} 240 -180 0 0 {name=l131 sig_type=std_logic lab=EN}
C {devices/lab_pin.sym} 240 -120 0 0 {name=l132 sig_type=std_logic lab=0}
C {devices/res.sym} 950 120 0 0 {name=Rload
value=660
footprint=1206
device=resistor
m=1}
C {devices/lab_pin.sym} 950 90 0 0 {name=l133 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 950 150 0 0 {name=l134 sig_type=std_logic lab=0}
C {devices/capa.sym} 1060 120 0 0 {name=CL
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {devices/lab_pin.sym} 1060 90 0 0 {name=l135 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 1060 150 0 0 {name=l136 sig_type=std_logic lab=0}
C {devices/code_shown.sym} -700 -560 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
"}
C {devices/code_shown.sym} -700 -380 0 0 {name=CONTROL
only_toplevel=true
value="

.control
tran 50n 250u
write tb_en.raw v(vout) v(en)
wrdata tb_en.txt v(vout) v(en)
meas tran voff avg v(vout) from=10u to=19u
meas tran von avg v(vout) from=100u to=119u
meas tran voff2 avg v(vout) from=230u to=249u
meas tran ton when v(vout)=3.2 rise=1
echo RESULT en_vout_off_V $&voff
echo RESULT en_vout_on_V $&von
echo RESULT en_vout_off_after_V $&voff2
let ton_us = (ton - 20u)*1e6
echo RESULT en_turn_on_time_us $&ton_us
.endc
"}
B 2 -700 250 300 750 {flags=graph
y1=-0.5
y2=5.5
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=0.00025
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="vout
en"
color="4 7"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_en.raw
sim_type=tran
autoload=1}
