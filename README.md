# GF180MCU Low-Dropout Regulator (Capless, 5.0V → 3.3V)

## 1. Type of IP Block

Capless linear voltage regulator (LDO), 5.0V analog supply in, regulated 3.3V
analog supply out.


## 2. I/O List, Including Test Ports

| Pin | Direction | Type | Description |
|---|---|---|---|
| `VIN` | in | analog  | 5.0V analog supply input |
| `VOUT` | out | analog  | Regulated 3.3V analog output |
| `EN` | in | digital | Enables/disables regulator |
| `FB_BUF` | out | analog | Buffered tap of the feedback node. |
| `EAOUT_BUF` | out | analog |Buffered error amplifier output (pass transistor gate). |
| `VREF` | in | external resource | Chipalooza's shared bandgap-reference bias voltage.|



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