v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 100 150 2140 650 {flags=graph
y1=0
y2=5.5
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=2e-4
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="vin
vout
eaout
fb"
color="4 5 6 7"
dataset=-1
unitx=n
logx=0
logy=0
hilight_wave=-1
linewidth_mult=2}
N 1750 -720 1890 -720 {lab=IREF_FB}
N 2980 -1070 2980 -1000 {lab=CASCB2}
N 2630 -1070 2630 -1000 {lab=CASCB1}
N 2670 -1100 2940 -1100 {lab=CASCB1}
N 2630 -940 2630 -890 {lab=EAREF}
N 2980 -940 2980 -890 {lab=EAOUT}
N 2800 -830 2800 -680 {lab=TAIL}
N 3410 -830 3410 -770 {lab=FB}
N 2630 -830 2980 -830 {lab=TAIL}
N 2540 -680 2540 -650 {lab=IREF}
N 2500 -680 2540 -680 {lab=IREF}
N 2500 -800 2500 -770 {lab=VIN}
N 1710 -900 1930 -900 {lab=VIN}
N 1940 -1150 1940 -1080 {lab=EAOUT_BUF}
N 1720 -1150 1720 -1090 {lab=IREF_EA}
N 1760 -1090 1760 -1060 {lab=IREF_EA}
N 1720 -1090 1760 -1090 {lab=IREF_EA}
N 2670 -970 2940 -970 {lab=EAREF}
N 2630 -920 2700 -920 {lab=EAREF}
N 2700 -970 2700 -920 {lab=EAREF}
N 3340 -1460 3340 -1410 {lab=ENB}
N 3260 -1490 3300 -1490 {lab=EN}
N 3260 -1490 3260 -1380 {lab=EN}
N 3020 -860 3060 -860 {lab=VREF}
N 3060 -860 3090 -860 {lab=VREF}
N 1760 -1060 1900 -1060 {lab=IREF_EA}
N 1720 -1210 1940 -1210 {lab=VIN}
N 1710 -840 1710 -750 {lab=IREF_FB}
N 1710 -750 1750 -750 {lab=IREF_FB}
N 1750 -750 1750 -720 {lab=IREF_FB}
N 1930 -840 1930 -750 {lab=FB_BUF}
N 2430 -860 2590 -860 {lab=FB}
N 3090 -860 3180 -860 {lab=VREF}
N 2630 -1240 2630 -1130 {lab=VIN}
N 2630 -1240 2980 -1240 {lab=VIN}
N 2980 -1240 2980 -1130 {lab=VIN}
N 2980 -920 3120 -920 {lab=EAOUT}
N 3120 -920 3180 -920 {lab=EAOUT}
N 3410 -1110 3410 -1070 {lab=VIN}
N 3310 -1040 3370 -1040 {lab=PGATE}
N 3410 -940 3410 -890 {lab=VOUT}
N 2500 -710 2500 -680 {lab=IREF}
N 2540 -650 2760 -650 {lab=IREF}
N 3360 -920 3410 -920 {lab=VOUT}
N 3250 -920 3300 -920 {lab=EAOUT}
N 3410 -950 3410 -940 {lab=VOUT}
N 3410 -920 3620 -920 {lab=VOUT}
N 3250 -980 3250 -920 {lab=EAOUT}
N 3200 -1380 3300 -1380 {lab=EN}
N 3160 -1520 3160 -1410 {lab=VIN}
N 3160 -1520 3340 -1520 {lab=VIN}
N 3180 -920 3250 -920 {lab=EAOUT}
N 3250 -1040 3250 -980 {lab=EAOUT}
N 3410 -1010 3410 -950 {lab=VOUT}
N 3160 -1350 3160 -920 {lab=EAOUT}
N 3030 -1460 3260 -1460 {lab=EN}
N 3040 -1430 3340 -1430 {lab=ENB}
N 3030 -1430 3040 -1430 {lab=ENB}
N 3620 -920 3790 -920 {lab=VOUT}
C {devices/title.sym} 160 90 0 0 {name=l1 author="LDO first pass (GF180MCU, 5T OTA + pfet_05v0 pass device)"}
C {devices/code_shown.sym} -20 -1340 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"
}
C {devices/code_shown.sym} 470 -1340 0 0 {name=SIM
only_toplevel=true
value="
.ic v(vout)=3.3 v(eaout)=2 v(fb)=1.2 v(earef)=4 v(tail)=1
.control
save all
op
print v(vin) v(vout) v(eaout) v(fb) v(earef) v(tail)
tran 100n 200u
write LDO_GF180.raw
wrdata ldo_tran.txt v(vin) v(vout) v(eaout) v(fb) i(Vvin)
ac dec 20 1 1G
wrdata ldo_ac.txt vout
.endc
"
}
C {devices/launcher.sym} -170 120 0 0 {name=h1
descr="Simulate"
tclcommand="xschem save; xschem netlist; xschem simulate"
}
C {devices/launcher.sym} -180 160 0 0 {name=h2
descr="Load waves"
tclcommand="xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw tran"
}
C {devices/vsource.sym} 2300 -1450 0 0 {name=Vvin
value=5
}
C {devices/vsource.sym} 2200 -1450 0 0 {name=Vvref
value=1.2
}
C {devices/res.sym} 2500 -740 0 0 {name=Rref
value=200k
footprint=1206
device=resistor
m=1
}
C {symbols/nfet_05v0.sym} 2520 -650 2 0 {name=MREF
L=0.6u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {symbols/nfet_05v0.sym} 2780 -650 0 0 {name=MTAIL
L=0.6u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {devices/vsource.sym} 2400 -1450 0 0 {name=VEN
value="PULSE(0 5 20u 1u 1u 160u 400u)"
}
C {devices/lab_pin.sym} 2400 -1480 0 0 {name=lenp sig_type=std_logic lab=EN}
C {devices/lab_pin.sym} 2400 -1420 0 0 {name=lenm sig_type=std_logic lab=0}
C {symbols/pfet_05v0.sym} 3320 -1490 0 0 {name=MENINVP
L=0.6u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
C {devices/lab_pin.sym} 3230 -1520 1 0 {name=lenvps sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 3340 -1490 2 0 {name=lenvpb sig_type=std_logic lab=VIN}
C {symbols/nfet_05v0.sym} 3320 -1380 0 0 {name=MENINVN
L=0.6u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {devices/lab_pin.sym} 3030 -1430 0 0 {name=lenvnd sig_type=std_logic lab=ENB}
C {devices/lab_pin.sym} 3030 -1460 0 0 {name=lenvng sig_type=std_logic lab=EN}
C {devices/lab_pin.sym} 3340 -1350 0 0 {name=lenvns sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 3340 -1380 2 0 {name=lenvnb sig_type=std_logic lab=0}
C {symbols/pfet_05v0.sym} 3180 -1380 2 0 {name=MENPASSOFF
L=0.6u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
C {devices/lab_pin.sym} 3160 -1380 0 0 {name=lenpob sig_type=std_logic lab=VIN}
C {symbols/nfet_05v0.sym} 3770 -890 0 0 {name=MENDISCHARGE
L=0.6u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {devices/lab_pin.sym} 3790 -860 0 0 {name=lendcs sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 3790 -890 2 0 {name=lendcb sig_type=std_logic lab=0}
C {devices/res.sym} 1710 -870 0 0 {name=RrefFB
value=1MEG
footprint=1206
device=resistor
m=1
}
C {devices/lab_pin.sym} 1820 -900 1 0 {name=lrreffbp sig_type=std_logic lab=VIN}
C {symbols/nfet_05v0.sym} 1730 -720 2 0 {name=MREFFB
L=0.6u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {devices/lab_pin.sym} 1820 -720 1 0 {name=lreffbg sig_type=std_logic lab=IREF_FB}
C {devices/lab_pin.sym} 1710 -690 2 0 {name=lreffbs sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 1710 -720 2 0 {name=lreffbb sig_type=std_logic lab=0}
C {symbols/nfet_05v0.sym} 1950 -870 2 0 {name=MFBBUF
L=0.6u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {devices/lab_pin.sym} 1930 -870 0 0 {name=lfbbufb sig_type=std_logic lab=0}
C {symbols/nfet_05v0.sym} 1910 -720 0 0 {name=MBIASFB
L=0.6u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {devices/lab_pin.sym} 1930 -780 2 0 {name=lbiasfbd sig_type=std_logic lab=FB_BUF}
C {devices/lab_pin.sym} 1930 -690 0 0 {name=lbiasfbs sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 1930 -720 0 0 {name=lbiasfbb sig_type=std_logic lab=0}
C {devices/res.sym} 1720 -1180 0 0 {name=RrefEA
value=1MEG
footprint=1206
device=resistor
m=1
}
C {devices/lab_pin.sym} 1830 -1060 1 0 {name=lrrefeam sig_type=std_logic lab=IREF_EA}
C {symbols/nfet_05v0.sym} 1740 -1060 2 0 {name=MREFEA
L=0.6u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {devices/lab_pin.sym} 1720 -1030 2 0 {name=lrefeas sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 1720 -1060 2 0 {name=lrefeab sig_type=std_logic lab=0}
C {symbols/nfet_05v0.sym} 1960 -1180 2 0 {name=MEAOUTBUF
L=0.6u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {devices/lab_pin.sym} 1830 -1210 1 0 {name=leabufd sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 1980 -1180 2 0 {name=leabufg sig_type=std_logic lab=EAOUT}
C {devices/lab_pin.sym} 1940 -1180 2 0 {name=leabufb sig_type=std_logic lab=0}
C {symbols/nfet_05v0.sym} 1920 -1060 0 0 {name=MBIASEA
L=0.6u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {devices/lab_pin.sym} 1940 -1120 2 0 {name=lbiaseadaux sig_type=std_logic lab=EAOUT_BUF}
C {devices/lab_pin.sym} 1940 -1030 0 0 {name=lbiaseas sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 1940 -1060 2 0 {name=lbiaseab sig_type=std_logic lab=0}
C {symbols/nfet_05v0.sym} 2610 -860 0 0 {name=MIN1
L=3u
W=20u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {symbols/nfet_05v0.sym} 3000 -860 2 0 {name=MIN2
L=3u
W=20u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {symbols/pfet_05v0.sym} 2650 -1100 2 0 {name=MLOAD1
L=3u
W=10u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
C {symbols/pfet_05v0.sym} 2960 -1100 0 0 {name=MLOAD2
L=3u
W=10u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
C {symbols/pfet_05v0.sym} 3390 -1040 0 0 {name=MPASS
L=0.55u
W=90u
nf=30
m=7
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
C {devices/vsource.sym} 3280 -1040 3 0 {name=Vinj
value="0 AC 1"
}
C {devices/capa.sym} 3330 -920 3 0 {name=Cc
m=1
value=3p
footprint=1206
device="ceramic capacitor"
}
C {devices/res.sym} 3410 -860 0 0 {name=R1
value=175k
footprint=1206
device=resistor
m=1
}
C {devices/res.sym} 3410 -740 0 0 {name=R2
value=100k
footprint=1206
device=resistor
m=1
}
C {devices/capa.sym} 3520 -890 0 0 {name=Cout
m=1
value=2p
footprint=1206
device="ceramic capacitor"
}
C {devices/isource.sym} 3620 -890 0 0 {name=Iload
value="PULSE(0 10m 10u 1u 1u 40u 100u)"
}
C {devices/lab_pin.sym} 2300 -1480 0 0 {name=lvinp sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 2200 -1480 0 0 {name=lvrefp sig_type=std_logic lab=VREF}
C {devices/lab_pin.sym} 1490 -830 0 0 {name=litp sig_type=std_logic lab=TAIL}
C {devices/lab_pin.sym} 1490 -860 0 0 {name=lvout sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 1970 -870 2 0 {name=lfb sig_type=std_logic lab=FB}
C {devices/lab_pin.sym} 1490 -790 0 0 {name=lgnd sig_type=std_logic lab=0}
C {symbols/pfet_05v0.sym} 2650 -970 2 0 {name=MCASC1
L=0.55u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
C {devices/lab_pin.sym} 2810 -970 1 0 {name=lcasc1g sig_type=std_logic lab=EAREF}
C {devices/lab_pin.sym} 2630 -1030 2 0 {name=lcasc1s sig_type=std_logic lab=CASCB1}
C {devices/lab_pin.sym} 2630 -970 0 0 {name=lcasc1b sig_type=std_logic lab=VIN}
C {symbols/pfet_05v0.sym} 2960 -970 0 0 {name=MCASC2
L=0.55u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
C {devices/lab_pin.sym} 2980 -1030 0 0 {name=lcasc2s sig_type=std_logic lab=CASCB2}
C {devices/lab_pin.sym} 2980 -970 2 0 {name=lcasc2b sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 2300 -1420 0 0 {name=lvisual0 sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 2200 -1420 0 0 {name=lvisual1 sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 2500 -800 0 0 {name=lvisual2 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 2500 -620 2 0 {name=lvisual3 sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 2500 -650 0 0 {name=lvisual4 sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 2800 -620 0 0 {name=lvisual5 sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 2800 -650 0 0 {name=lvisual6 sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 2630 -860 2 0 {name=lvisual7 sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 2980 -860 0 0 {name=lvisual8 sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 2630 -1130 2 0 {name=lvisual9 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 2630 -1100 0 0 {name=lvisual10 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 2980 -1130 0 0 {name=lvisual11 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 2980 -1100 2 0 {name=lvisual12 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 3410 -1040 2 0 {name=lvisual15 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 3410 -710 0 0 {name=lvisual18 sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 3520 -920 1 0 {name=lvisual19 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 3520 -860 0 0 {name=lvisual20 sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 3620 -920 1 0 {name=lvisual21 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 3620 -860 0 0 {name=lvisual22 sig_type=std_logic lab=0}
C {devices/lab_pin.sym} 2800 -760 0 0 {name=lvisual26 sig_type=std_logic lab=TAIL}
C {devices/lab_pin.sym} 2430 -860 0 0 {name=lvisual29 sig_type=std_logic lab=FB}
C {devices/lab_pin.sym} 2810 -1100 1 0 {name=lvisual34 sig_type=std_logic lab=CASCB1}
C {devices/lab_pin.sym} 3410 -800 0 0 {name=lvisual28 sig_type=std_logic lab=FB}
C {devices/lab_pin.sym} 3180 -860 2 0 {name=lvrefp1 sig_type=std_logic lab=VREF}
C {devices/lab_pin.sym} 2810 -1240 1 0 {name=lvisual30 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 3160 -1330 0 0 {name=lcasc1 sig_type=std_logic lab=EAOUT}
C {devices/lab_pin.sym} 3410 -1110 1 0 {name=lvisual14 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 3100 -920 1 0 {name=lcasc2d sig_type=std_logic lab=EAOUT}
C {devices/lab_pin.sym} 3340 -1040 1 0 {name=lpgate sig_type=std_logic lab=PGATE}
C {devices/lab_pin.sym} 2680 -650 1 0 {name=lvisual23 sig_type=std_logic lab=IREF}
C {devices/lab_pin.sym} 3750 -890 0 0 {name=lenvnd1 sig_type=std_logic lab=ENB}
C {devices/lab_pin.sym} 3790 -920 1 0 {name=lvisual13 sig_type=std_logic lab=VOUT}
T {TEST: Line regulation (VIN 4.5-5.5V, Iload=5mA)} -180 180 0 0 0.4 0.4 {}
B 2 -180 220 460 620 {flags=graph,unlocked
y1=3.305
y2=3.315
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
rawfile=/tmp/ldo_report/line_reg.raw
sim_type=dc
autoload=1}
T {TEST: Load regulation (Iload 0-10mA, VIN=5V)} 560 180 0 0 0.4 0.4 {}
B 2 560 220 1200 620 {flags=graph,unlocked
y1=3.305
y2=3.32
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=0.01
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
rawfile=/tmp/ldo_report/load_reg.raw
sim_type=dc
autoload=1}
T {TEST: Dropout voltage (Iload=10mA)} 1300 180 0 0 0.4 0.4 {}
B 2 1300 220 1940 620 {flags=graph,unlocked
y1=3.1
y2=3.32
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=3.3
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
rawfile=/tmp/ldo_report/dropout.raw
sim_type=dc
autoload=1}
T {TEST: Transient load step (0->10mA)} -180 680 0 0 0.4 0.4 {}
B 2 -180 720 460 1120 {flags=graph,unlocked
y1=-0.5
y2=5.0
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=0.00016
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
rawfile=/tmp/ldo_report/tran_load.raw
sim_type=tran
autoload=1}
T {TEST: EN control (vout=green/4, en=gray/7)} 560 680 0 0 0.4 0.4 {}
B 2 560 720 1200 1120 {flags=graph,unlocked
y1=-1.5
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
rawfile=/tmp/ldo_report/tran_en.raw
sim_type=tran
autoload=1}
T {TEST: PSRR (vout_db=4, vin_db=7)} 1300 680 0 0 0.4 0.4 {}
B 2 1300 720 1940 1120 {flags=graph,unlocked
y1=-45
y2=5
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1
x2=6
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="vout db20()
vin db20()"
color="4 7"
dataset=-1
unitx=1
logx=1
logy=0
rawfile=/tmp/ldo_report/psrr.raw
sim_type=ac
autoload=1}
