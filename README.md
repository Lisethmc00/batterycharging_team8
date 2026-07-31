# batterycharging_team8
**Description**
This MATLAB project is the proposed solution to [modeling a battery charging circuit with RC circuit](https://github.com/mathworks/MATLAB-Simulink-Challenge-Project-Hub/tree/main/Classroom%20Challenge%20Projects/Projects/Modeling%20and%20Analyzing%20a%20Battery%20Charging%20Profile). It includes plots and analysis of energy loss, and performance using real-world voltage data. By fitting the standard capacitor charging equation *V(t) = V<sub>max</sub>(1 - e<sup>-t/RC</sup>)* to the real dataset, we aim to explain the charging behavior, accompanying the goodness-of-fit statistics for this RC circuit approximation and CC/CV charging region.

## Code
[```code```](google.com) The analysis and visualizations are presented in the aggregate Matlab live script.

## Methodologies
Using the fitted RC model, we aim to:\
**Plot** Voltage vs. time, Current vs. time, Power vs. time\
**Analyze** the rate of change of voltage at different stages of charging\
**Compute** the time required to 80% and to reach 100% of the maximum voltage\
**Estimate** the power lost due to series resistance P = IV = I<sup>2</sup>R\
**Calculate** and estimate the total energy delivered to the battery using integration under the Power vs. time curve

## Data
The data is fetched from the Matlab internal files ```batteryagingdata/singlecell/v1/singleCellLifeTimeData.zip```.\
Temperature chamber is at 30 degrees Celsius. Single cell that is cycled to failure （80% state of health） in order to provide a comprehensive view of its performance over time. The cycling sequence exercises the battery cell with dynamic fast charging and constant 4C discharging. In each cycle, the battery is fully charged until it reaches 3.6V and fully discharged when it reaches 2V.\
The bulk of the analysis will be focused on the first charging cycle.

## Model Data Fit
This code section plots the charging voltage response of a simple RC circuit across a 2000seconds window based on a defined input for maximum voltage V<sub>max</sub>, R, and C. Using the standard exponential charging formula *V(t) = V<sub>max</sub>(1 - e<sup>-t/tau</sup>)*, it produces a curve showing the voltage approaching its maximum at about 3.6v from 2v for the first charging cycle of the battery --- current decreasing as voltage rises, and power as the product of voltage and current trends similar to that of the graph for current.\
~~image here~~\
*tau = RC* is the time constant of the RC circuit *time it takes to reach 63.2% of the maximum voltage which is 3.6v*, together with time *t*, were the two parameters used to fit the voltage data.\ using the matlab function ```[fitobject,gof]=fit(x,y,fitType,fitOptions)```
We can roughly see the inverse exponential curve for an ideal RC circuit besides for the drop in voltage in-between.\
Analyzing the goodness of fit statistics using the ```gof``` command, the fit yields a r-squared value of 0.229, which is weak indicator of the correlation in the data, however this is without consideration regarding the constant current and constant voltage portion of the charging cycle.\
~~image here~~\
For a standard Li-ion battery, it is typically charged using a Constant Current **CC** phase, where the charger supplies a fixed current until the battery voltage reaches its maximum charge voltage. It then switches to Constant Voltage **CV** mode, holding that voltage constant while the charging current gradually decreases, ending the charge when the current falls below a preset threshold. Here is the graph for voltage and current vs time, displaying the CC to CV phase shift.\
The battery charges quickly at first while protecting it from overvoltage and excessive temperature from the inrush current, improving safety and battery lifespan. This process is usually controlled by a battery management system, which continuously monitors the battery's voltage and current.\
~~image here~~\
The behavior of a RC circuit during charging would predict that for a capacitor, the current is proportional to the rate of the change of the voltage by a constant *C*.\
*i = C <ins>dv</ins><sub>dt</sub>*\

Because the capacitor acts a short circuit when uncharged, the current flow is maximum at the beginning, although controlled, we can still see the voltage climbing in an ideal fashion, before 250seconds. ~~graphs gof?~~\

The current gradually steps down to prevent overheating the battery as excessive current creates power loss. When the capacitor's voltage almost reaches the supply voltage, the charging profile changes to CV, where a standard RC charging circuit is clearly present; as the voltage tops near the maximum voltage, the current drops exponentially similar to that of the ideal model for current. ~~graphs gof?~~\

## Rate of Change at Key Intervals
Originally, we considered V<sub>0</sub> to be zero as expected of off a standard ideal RC charging circuit, which had led to a huge peak at the initial time. After fixing the mistake, we computed the rate of the change of voltage with respect to time ```dVdt= gradient(voltage, time)```, we expect to see the derivative of voltage vs time to resembles a form more or less like that of the current.\
~~image~~\
Initially, the voltage climb similar to that of RC model would predicts, and we can see dv/dt exponentially dips. The two steep negative slopes where the current abruptly drops in the constant current phase are clearly present; the voltage is controlled to be lowered causing the current to dip accordingly. The current is held steady from about 600seconds to 1200seconds?

## Charge capacity over time

## Power Delivered to the Battery
The instantaneous power tells us how fast electrical energy is being delivered to the battery at each moment during the charging process.
Power is:\
            *P(t) = V(t)I(t)*\
With *dE / dt = P(t)* the total energy delivered is the integral\
~~image~~

## Power Loss due to Resistance
Apply Joule's Law:\
  With Ohm's law *V = IR*\
  The heating formula estimating power loss in watts is given as:\
       *P<sub>loss</sub> = IV = I<sup>2</sup>R*\
The Energy loss is given as:\
       *E<sub>loss</sub> = P<sub>loss</sub>t*\
~~image~~\

## Implications
The resistive power loss is split into three sections, as the power loss is scaled quadratically with current **I**, by lowering current, we can improve the energy efficiency by not only linearly but would also double the charging time during the CC phase.\
Alternatively, a higher maximum battery voltage allows the same charging power to be delivered with lower current, reducing resistive losses and heat in the cables and electronics.\
We have not yet explored the impact of recycling usage of the Li-ion battery across multiple charging and discharging cycles.\
More advanced analytics using matlab can be intergraded into the battery management system that learns the specifics of the battery across cycles, and makes more beneficial decisions on the exact value used in CC phase, and to monitor the battery health and degradation over time.


