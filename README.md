# GF180MCU Low-Dropout Regulator (Capless, 5.0V → 3.3V)

## 1. Type of IP Block

Capless linear voltage regulator (LDO), 5.0V analog supply in, regulated 3.3V
analog supply out.


## 2. I/O List, Including Test Ports

| Pin | Direction | Type | Description |
|---|---|---|---|
| `VIN` | in | analog  | 5.0V analog supply input |
| `VOUT` | out | analog  | Regulated 3.3V analog output |
| `EN` | in | digital (3.3V logic) | Enables/disables regulator (high = on) |
| `FB_BUF` | out | analog | Buffered tap of the feedback node. |
| `EAOUT_BUF` | out | analog |Buffered error amplifier output (pass transistor gate). |
| `VREF` | in | external resource | Chipalooza's shared bandgap-reference bias voltage.|
| `VSS` | inout | ground | Ground |



## 3. Functional Description

Provides a locally-regulated, low-noise 3.3V rail, isolated from the noise on the shared 5.0V rail.


## 4. Target Specification

| Parameter | Min | Typ | Max |
|---|---|---|---|
| Input voltage (`VIN`) | 4.5V | 5.0V | 5.5V |
| Output voltage (`VOUT`) | 3.201V | 3.3V | 3.399V |
| Dropout voltage | — | — | 300 mV |
| Load current | 0 mA | — | 10 mA |
| Quiescent current | — | — | 100 µA |
| Line regulation (ΔVOUT) | — | — | 1% |
| Load regulation (ΔVOUT) | — | — | 1% |
| PSRR (low frequency) | 40 dB | — | — |

*Specifications are subject to change upon further circuit design :)*

## 5. Test Plan Outline

1. **Line regulation.**
   - Set `EN` high, load current fixed at 5 mA.
   - Step `VIN` from 4.5V to 5.5V.
   - Record `VOUT` at each step.
2. **Load regulation.**
   - Set `EN` high, `VIN` fixed at 5.0V.
   - Step load current from 0 mA to 10 mA.
   - Record `VOUT` at each step.
3. **Transient response.**
   - Set `EN` high, `VIN` fixed at 5.0V.
   - Apply a load step, 0 mA to 10 mA, with a 1 µs rise/fall time.
   - Separately, apply a `VIN` step, 5.0V to 4.5V, with a 1 µs rise/fall time, at fixed 5 mA load.
   - Capture `VOUT` in both cases; report overshoot/undershoot and settling time.
4. **PSRR.** Apply a ripple, a small AC signal added on top of the DC input, standing in for supply noise.
   - Set `EN` high, load current fixed at 5 mA.
   - Hold `VIN` at 5.0V DC, add a 50 mV AC ripple, swept 10 Hz to 1 MHz.
   - Measure ripple amplitude at `VOUT`; report attenuation (dB) vs. frequency.
5. **EN control.**
   - Set `VIN` at 5.0V, load current fixed at 5 mA.
   - Drive `EN` high; confirm `VOUT` rises cleanly to 3.3V with no glitches.
   - Drive `EN` low again; confirm `VOUT=0`. 
6. **Quiescent current.**
   - Set `EN` high, `VIN` at 5.0V, and load current at 0 mA (no load).
   - Measure current drawn from `VIN`


---

## 6. Status

Schematic design and pre-layout simulation are complete; all target
specifications are met in simulation at the typical corner and across
process corners (tt/ff/ss/fs/sf) from -40 C to 110 C. Layout, DRC/LVS
sign-off and post-layout verification have not started yet.

## 7. Harness Resources Required

| Resource | Use |
|---|---|
| 5.0V analog supply | `VIN` (supply and pass-device input) |
| Ground | `VSS` |
| Bandgap-referenced bias voltage | `VREF` (1.2V assumed in simulation) |
| 1 digital control (3.3V) | `EN` |
| Analog output pin | `VOUT` (for measuring regulation under external load) |
| 2 shared analog lines | `FB_BUF`, `EAOUT_BUF` test outputs |
| Bandgap-referenced current sources | none (biasing is internal) |

All transistors are 5V devices (`nfet_05v0` / `pfet_05v0`), matching the 5.0V
`VIN` domain. `EN` comes from the harness's 3.3V logic, so it passes through an
internal 3.3V-to-`VIN` level shifter (`xschem/ldo_levelshift.sch`).

## 8. Simulation Results (schematic, pre-layout)

Typical corner, 27 C, `VIN` = 5.0V, `VREF` = 1.2V, `EN` = 3.3V. Full results,
plots and the process/temperature corner table are in
[`simulations/results/summary.md`](simulations/results/summary.md).

| Parameter | Spec | Simulated |
|---|---|---|
| Output voltage (5 mA) | 3.201V - 3.399V | 3.309V |
| Dropout voltage (10 mA) | max 300 mV | 152 mV (262 mV worst corner) |
| Quiescent current | max 100 uA | 72 uA (82 uA worst corner) |
| Line regulation | max 1% | 0.042% |
| Load regulation | max 1% | 0.270% (0.523% worst corner) |
| PSRR (low frequency) | min 40 dB | 59 dB at 100 Hz (54 dB worst corner) |

## 9. Repository Layout

| Path | Contents |
|---|---|
| `xschem/ldo.sch`, `ldo.sym` | LDO IP block schematic and symbol |
| `xschem/ldo_levelshift.sch`, `.sym` | 3.3V-to-`VIN` level shifter for `EN` |
| `simulations/tb_*.sch` | One xschem testbench per test in the test plan |
| `simulations/run_sims.py` | Runs all testbenches, plots results, checks against spec |
| `simulations/results/` | Result plots and summary table |
| `netlist/schematic/ldo.spice` | Exported schematic netlist |

## 10. Reproducing the Results

Requires [xschem](https://xschem.sourceforge.io/), [ngspice](https://ngspice.sourceforge.io/),
the gf180mcuD PDK with `PDK_ROOT` set, and Python 3 with numpy and matplotlib
(all included in [IIC-OSIC-TOOLS](https://github.com/iic-jku/IIC-OSIC-TOOLS)).

```sh
cd simulations
python3 run_sims.py --corners
```

Testbenches can also be opened and simulated individually in xschem
(`cd simulations && xschem tb_line_reg.sch`). Schematics reference only files
in this repository or in the PDK via `$PDK_ROOT`.

## 11. Open Items

- Replace ideal resistors (`Rref`, `RrefFB`, `RrefEA`, `R1`, `R2`) and the
  compensation capacitor `Cc` with GF180MCU poly resistors and a MIM capacitor
  before layout.
- Add an AC loop-gain / phase-margin testbench across corners (current
  stability evidence: load- and line-step transients).
- Load-step overshoot (+311 mV for a 0-10 mA step in 1 us) is not yet
  specified; decide on a transient spec or reduce it.
- Layout in the harness slot (template TBD), DRC/LVS, post-layout PVT.

## 12. License

Apache License 2.0, see [LICENSE](LICENSE).
