#!/usr/bin/env python3
"""Run every LDO testbench in this directory and summarize against the spec.

    python3 run_sims.py            # typical corner, 27C: all testbenches + plots
    python3 run_sims.py --corners  # also sweep process corners x temperature

Requirements: xschem, ngspice, the gf180mcuD PDK with $PDK_ROOT set,
Python 3 with numpy + matplotlib.

Each tb_*.sch is netlisted by xschem (using ./xschemrc, which pulls in the
PDK via $PDK_ROOT) into ./run/, simulated by ngspice in batch mode, and its
'RESULT <name> <value>' lines are collected. Plots and a markdown summary go
to ./results/. Raw simulator output stays in ./run/ (not committed).
"""
import argparse
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

import numpy as np
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = Path(__file__).resolve().parent
RUN = HERE / "run"
RES = HERE / "results"

XSCHEM = shutil.which("xschem") or "/foss/tools/xschem/bin/xschem"
NGSPICE = shutil.which("ngspice") or "/foss/tools/ngspice/bin/ngspice"

# Target specification (README.md / proposal section 4)
SPEC = {
    "vout_min": 3.201, "vout_max": 3.399,
    "dropout_max_mV": 300,
    "iq_max_uA": 100,
    "line_reg_max_pct": 1.0,
    "load_reg_max_pct": 1.0,
    "psrr_min_dB": 40,
}


def netlist(tb: str) -> Path:
    if "PDK_ROOT" not in os.environ:
        sys.exit("PDK_ROOT is not set (needed to find the gf180mcuD PDK)")
    subprocess.run([XSCHEM, "--rcfile", str(HERE / "xschemrc"), "-n", "-q", "--no_x", str(HERE / f"{tb}.sch")],
                   cwd=HERE, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return RUN / f"{tb}.spice"


def simulate(spice: Path, tag: str) -> dict:
    log = RUN / f"{tag}.log"
    with open(log, "w") as f:
        subprocess.run([NGSPICE, "-b", spice.name], cwd=RUN, stdout=f, stderr=subprocess.STDOUT)
    text = log.read_text()
    if re.search(r"(?m)^(Error|ERROR)|fatal error", text):
        raise RuntimeError(f"ngspice reported an error, see {log}")
    out = {}
    for name, val in re.findall(r"(?m)^RESULT (\S+)\s*(\S*)", text):
        out[name] = float(val) if val else float("nan")
    return out


def export_netlist():
    """Write the LDO + level-shifter subcircuits (no testbench, no absolute
    paths) to ../netlist/schematic/ldo.spice for use in a larger system."""
    src = (RUN / "tb_iq.spice").read_text()
    blocks = re.findall(r"(?ms)^\.subckt .*?^\.ends\s*$", src)
    out = HERE.parent / "netlist" / "schematic" / "ldo.spice"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("* Capless LDO (GF180MCU) - schematic netlist, generated from xschem/ldo.sch\n"
                   "* by simulations/run_sims.py. Devices: gf180mcuD nfet_05v0 / pfet_05v0.\n\n"
                   + "\n\n".join(b.strip() for b in blocks) + "\n")


def load(tb: str) -> np.ndarray:
    return np.loadtxt(RUN / f"{tb}.txt")


def dropout_mV(d: np.ndarray) -> float:
    """VIN - VOUT at the lowest VIN where VOUT is still within 1% of its
    regulated (high-headroom) value, at Iload = 10mA."""
    vin, vout = d[:, 0], d[:, 1]
    target = 0.99 * vout[-1]
    vin_min = vin[vout >= target].min()
    return (vin_min - vout[-1]) * 1e3, vin_min


def figure(name, title, xlabel, ylabel):
    fig, ax = plt.subplots(figsize=(6, 3.6))
    ax.set_title(title)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    ax.grid(alpha=0.3, which="both")
    return fig, ax


def save(fig, name):
    fig.tight_layout()
    fig.savefig(RES / f"{name}.png", dpi=120)
    plt.close(fig)


def typical():
    tbs = sorted(p.stem for p in HERE.glob("tb_*.sch"))
    r = {}
    for tb in tbs:
        print(f"  {tb} ...", flush=True)
        r.update(simulate(netlist(tb), tb))

    # ---- plots
    d = load("tb_line_reg")
    fig, ax = figure("line_reg", f"Line regulation {r['line_reg_pct']:.3f}% (Iload = 5mA)", "VIN (V)", "VOUT (V)")
    ax.plot(d[:, 0], d[:, 1])
    save(fig, "line_reg")

    d = load("tb_load_reg")
    fig, ax = figure("load_reg", f"Load regulation {r['load_reg_pct']:.3f}% (VIN = 5V)", "Iload (mA)", "VOUT (V)")
    ax.plot(d[:, 0] * 1e3, d[:, 1])
    save(fig, "load_reg")
    r["vout_5mA"] = float(np.interp(5e-3, d[:, 0], d[:, 1]))
    r["vout_0mA"], r["vout_10mA"] = float(d[0, 1]), float(d[-1, 1])

    d = load("tb_dropout")
    r["dropout_mV"], vin_min = dropout_mV(d)
    fig, ax = figure("dropout", f"Dropout {r['dropout_mV']:.0f} mV at Iload = 10mA", "VIN (V)", "VOUT (V)")
    ax.plot(d[:, 0], d[:, 1], label="VOUT")
    ax.plot(d[:, 0], d[:, 0], ":", color="gray", label="VIN")
    ax.axvline(vin_min, color="red", ls="--", label=f"VIN min in regulation = {vin_min:.3f} V")
    ax.set_ylim(2.8, 3.6)
    ax.legend(fontsize=8)
    save(fig, "dropout")

    d = load("tb_tran_load")
    fig, ax = figure("tran_load", f"Load step 0 -> 10 mA -> 0 (1 us edges): "
                     f"-{r['load_undershoot_mV']:.0f} / +{r['load_overshoot_mV']:.0f} mV",
                     "time (us)", "VOUT (V)")
    ax.plot(d[:, 0] * 1e6, d[:, 1])
    for t in (20, 61):
        ax.axvline(t, color="gray", ls=":")
    save(fig, "tran_load")

    d = load("tb_tran_line")
    fig, ax = figure("tran_line", f"Line step 5.0 -> 4.5 -> 5.0 V (1 us edges, 5 mA): "
                     f"-{r['line_tran_dip_mV']:.0f} / +{r['line_tran_bump_mV']:.0f} mV",
                     "time (us)", "VOUT (V)")
    ax.plot(d[:, 0] * 1e6, d[:, 3], label="VOUT")
    ax2 = ax.twinx()
    ax2.plot(d[:, 0] * 1e6, d[:, 1], color="gray", ls="--", label="VIN")
    ax2.set_ylabel("VIN (V)")
    save(fig, "tran_line")

    d = load("tb_psrr")
    fig, ax = figure("psrr", f"PSRR (Iload = 5mA): {r['psrr_100Hz_dB']:.1f} dB at 100 Hz, "
                     f"{r['psrr_10kHz_dB']:.1f} dB at 10 kHz", "frequency (Hz)", "PSRR (dB)")
    ax.semilogx(d[:, 0], d[:, 1])
    ax.axhline(SPEC["psrr_min_dB"], color="red", ls="--", label="40 dB spec (low frequency)")
    ax.legend(fontsize=8)
    save(fig, "psrr")

    d = load("tb_en")
    fig, ax = figure("en", f"EN 0 -> 3.3 V -> 0 (660 ohm load): turn-on {r['en_turn_on_time_us']:.1f} us",
                     "time (us)", "voltage (V)")
    ax.plot(d[:, 0] * 1e6, d[:, 1], label="VOUT")
    ax.plot(d[:, 0] * 1e6, d[:, 3], ls="--", color="gray", label="EN")
    ax.legend(fontsize=8)
    save(fig, "en")

    d = load("tb_en_dc")
    fig, ax = figure("en_dc", f"EN threshold: {r['en_threshold_V_at_VIN4p5']:.2f} V (VIN 4.5) / "
                     f"{r['en_threshold_V_at_VIN5p5']:.2f} V (VIN 5.5)", "EN (V)", "VOUT (V)")
    breaks = np.where(np.diff(d[:, 0]) < 0)[0] + 1
    for seg, lbl in zip(np.split(d, breaks), ("VIN = 4.5 V", "VIN = 5.5 V")):
        ax.plot(seg[:, 0], seg[:, 1], label=lbl)
    ax.legend(fontsize=8)
    save(fig, "en_dc")
    return r


# ------------------------------------------------------------------ corners
CORNERS = ["typical", "ff", "ss", "fs", "sf"]
TEMPS = [-40, 27, 110]
CORNER_TBS = ["tb_iq", "tb_line_reg", "tb_load_reg", "tb_dropout", "tb_psrr"]


def corners():
    rows = []
    for tb in CORNER_TBS:
        netlist(tb)
    for c in CORNERS:
        for t in TEMPS:
            row = {"corner": c, "temp": t}
            for tb in CORNER_TBS:
                src = (RUN / f"{tb}.spice").read_text()
                src = re.sub(r"(sm141064\.ngspice) typical", rf"\1 {c}", src)
                src = src.replace(".control", f".temp {t}\n.control", 1)
                tag = f"{tb}_{c}_{t}"
                src = src.replace(f"{tb}.raw", f"{tag}.raw").replace(f"{tb}.txt", f"{tag}.txt")
                (RUN / f"{tag}.spice").write_text(src)
                row.update(simulate(RUN / f"{tag}.spice", tag))
                if tb == "tb_dropout":
                    row["dropout_mV"], _ = dropout_mV(load(tag))
                if tb == "tb_load_reg":
                    d = load(tag)
                    row["vout_5mA"] = float(np.interp(5e-3, d[:, 0], d[:, 1]))
            print(f"  {c:8s} {t:4d}C  VOUT {row['vout_5mA']:.4f} V  Iq {row['iq_uA']:.1f} uA  "
                  f"dropout {row['dropout_mV']:.0f} mV  PSRR {row['psrr_100Hz_dB']:.1f} dB", flush=True)
            rows.append(row)
    return rows


def ok(v, lo=None, hi=None):
    return "PASS" if (lo is None or v >= lo) and (hi is None or v <= hi) else "**FAIL**"


def write_summary(r, rows):
    S = SPEC
    lines = [
        "# Simulation results (schematic, pre-layout)",
        "",
        "Generated by `simulations/run_sims.py`. Typical corner, 27 C, VIN = 5.0 V, VREF = 1.2 V,",
        "EN = 3.3 V (harness logic level), CL = 2 pF, unless noted.",
        "",
        "| Parameter | Spec | Simulated | Result | Testbench |",
        "|---|---|---|---|---|",
        f"| Output voltage (5 mA) | {S['vout_min']} - {S['vout_max']} V | {r['vout_5mA']:.4f} V | "
        f"{ok(r['vout_5mA'], S['vout_min'], S['vout_max'])} | tb_load_reg |",
        f"| Dropout (10 mA) | <= {S['dropout_max_mV']} mV | {r['dropout_mV']:.0f} mV | "
        f"{ok(r['dropout_mV'], hi=S['dropout_max_mV'])} | tb_dropout |",
        f"| Quiescent current (no load) | <= {S['iq_max_uA']} uA | {r['iq_uA']:.1f} uA | "
        f"{ok(r['iq_uA'], hi=S['iq_max_uA'])} | tb_iq |",
        f"| Line regulation (4.5-5.5 V, 5 mA) | <= {S['line_reg_max_pct']} % | {r['line_reg_pct']:.3f} % | "
        f"{ok(r['line_reg_pct'], hi=S['line_reg_max_pct'])} | tb_line_reg |",
        f"| Load regulation (0-10 mA) | <= {S['load_reg_max_pct']} % | {r['load_reg_pct']:.3f} % | "
        f"{ok(r['load_reg_pct'], hi=S['load_reg_max_pct'])} | tb_load_reg |",
        f"| PSRR (100 Hz, 5 mA) | >= {S['psrr_min_dB']} dB | {r['psrr_100Hz_dB']:.1f} dB | "
        f"{ok(r['psrr_100Hz_dB'], lo=S['psrr_min_dB'])} | tb_psrr |",
        f"| PSRR (10 kHz / 1 MHz) | - | {r['psrr_10kHz_dB']:.1f} / {r['psrr_1MHz_dB']:.1f} dB | info | tb_psrr |",
        f"| Load step 0->10 mA, 1 us | - | -{r['load_undershoot_mV']:.0f} / +{r['load_overshoot_mV']:.0f} mV | info | tb_tran_load |",
        f"| Line step 5.0->4.5 V, 1 us | - | -{r['line_tran_dip_mV']:.0f} / +{r['line_tran_bump_mV']:.0f} mV | info | tb_tran_line |",
        f"| EN off -> VOUT | 0 V | {r['en_vout_off_V']*1e3:.2f} mV | PASS | tb_en |",
        f"| EN turn-on time (to 3.2 V) | - | {r['en_turn_on_time_us']:.2f} us | info | tb_en |",
        f"| EN switching threshold | 3.3 V logic | {r['en_threshold_V_at_VIN4p5']:.2f} / "
        f"{r['en_threshold_V_at_VIN5p5']:.2f} V (VIN 4.5 / 5.5) | PASS | tb_en_dc |",
        f"| Shutdown current (EN = 0) | - | {r['ishdn_uA']:.1f} uA | info | tb_iq |",
        "",
        "![line regulation](line_reg.png) ![load regulation](load_reg.png)",
        "![dropout](dropout.png) ![PSRR](psrr.png)",
        "![load transient](tran_load.png) ![line transient](tran_line.png)",
        "![EN transient](en.png) ![EN threshold](en_dc.png)",
    ]
    if rows:
        lines += [
            "",
            "## Process corners x temperature (VIN = 5.0 V)",
            "",
            "| Corner | Temp (C) | VOUT @5 mA (V) | Iq (uA) | Line reg (%) | Load reg (%) | Dropout @10 mA (mV) | PSRR @100 Hz (dB) |",
            "|---|---|---|---|---|---|---|---|",
        ]
        for w in rows:
            lines.append(
                f"| {w['corner']} | {w['temp']} | {w['vout_5mA']:.4f} {'' if S['vout_min'] <= w['vout_5mA'] <= S['vout_max'] else '**FAIL**'} | "
                f"{w['iq_uA']:.1f} {'' if w['iq_uA'] <= S['iq_max_uA'] else '**FAIL**'} | "
                f"{w['line_reg_pct']:.3f} {'' if w['line_reg_pct'] <= S['line_reg_max_pct'] else '**FAIL**'} | "
                f"{w['load_reg_pct']:.3f} {'' if w['load_reg_pct'] <= S['load_reg_max_pct'] else '**FAIL**'} | "
                f"{w['dropout_mV']:.0f} {'' if w['dropout_mV'] <= S['dropout_max_mV'] else '**FAIL**'} | "
                f"{w['psrr_100Hz_dB']:.1f} {'' if w['psrr_100Hz_dB'] >= S['psrr_min_dB'] else '**FAIL**'} |")
    (RES / "summary.md").write_text("\n".join(lines) + "\n")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--corners", action="store_true", help="also run process corners x temperature")
    a = ap.parse_args()
    RUN.mkdir(exist_ok=True)
    RES.mkdir(exist_ok=True)
    print("typical corner:")
    r = typical()
    export_netlist()
    rows = []
    if a.corners:
        print("corners:")
        rows = corners()
    write_summary(r, rows)
    print(f"\nwrote {RES / 'summary.md'}")
    print((RES / "summary.md").read_text())


if __name__ == "__main__":
    main()
