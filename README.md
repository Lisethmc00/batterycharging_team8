# batterycharging_team8
**Descriptions**
A MATLAB project that simulates lithium-ion battery charging with an RC circuit model. It includes plots and analysis of energy loss, and performance. The goal is to model lithium-ion battery charging profiles as a simplified RC circuits using real-world voltage data. By fitting the standard capacitor charging equation '''V(t) = V<sub>max</sub>(1 - e<sup>-t/RC</sup>)''' to the real dataset, we aim to model the charging behavior, accompanying the goodness-of-fit statistics for this RC circuit approximation.

## Methodologies
Using the fitted RC model, we aim to:
**Plot** Voltage vs. time  Current vs. time  Power vs. time
**Analyze** the rate of change of voltage at different stages of charging
**Compute** the time required to 80% and to reach 100% of the maximum voltage
**Estimate** the power lost due to series resistance P = IV = I<sup>2</sup>R
**Calculate** and estimate the total energy delieverd to the battery using integration under the Power vs. time curve

## Data
The data is fetched from the Matlab internal files '''batteryagingdata/singlecell/v1/singleCellLifeTimeData.zip'''.
Temperature chamber at: 30 degrees Celsius. Single cell that is cycled to failure (80% state of health) in order to provide a comprehensive view of its performance over time. The cycling sequence exercises the battery cell with dynamic fast charging and constant 4C discharging. In each cycle, the battery is fully charged until it reaches 3.6V and fully discharged when it reaches 2V.
The bulk of the analysis will be focused on the first charging cycle.
  


