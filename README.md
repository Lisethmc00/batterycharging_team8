# batterycharging_team8
**Descriptions**
A MATLAB project that simulates lithium-ion battery charging with an RC circuit model. It includes plots and analysis of energy loss, and performance. The goal is to model lithium-ion battery charging profiles as a simplified RC circuits using real-world voltage data. By fitting the standard capacitor charging equation *V(t) = V<sub>max</sub>(1 - e<sup>-t/RC</sup>)* to the real dataset, we aim to model the charging behavior, accompanying the goodness-of-fit statistics for this RC circuit approximation.

## Methodologies
Using the fitted RC model, we aim to:\
**Plot** Voltage vs. time  Current vs. time  Power vs. time\
**Analyze** the rate of change of voltage at different stages of charging\
**Compute** the time required to 80% and to reach 100% of the maximum voltage\
**Estimate** the power lost due to series resistance P = IV = I<sup>2</sup>R\
**Calculate** and estimate the total energy delieverd to the battery using integration under the Power vs. time curve\

## Data
The data is fetched from the Matlab internal files ```batteryagingdata/singlecell/v1/singleCellLifeTimeData.zip```.\
Temperature chamber at: 30 degrees Celsius. Single cell that is cycled to failure (80% state of health) in order to provide a comprehensive view of its performance over time. The cycling sequence exercises the battery cell with dynamic fast charging and constant 4C discharging. In each cycle, the battery is fully charged until it reaches 3.6V and fully discharged when it reaches 2V.\
The bulk of the analysis will be focused on the first charging cycle.\

## Model Data Fit
This code section plots the charging voltage response of a simple RC circuit across a 2000s econds window based on a defined input for maximum voltage V<sub>max</sub>, R, and C. Using the standard exponential charging formula *V(t) = V<sub>max</sub>(1 - e<sup>-t/tau</sup>)*, it produces a curve showing the voltage approaching its maximum for the first charging cycle of the battery --- current decreasing as voltage rises, and power as the product of coltage adn current trends similar to that of the graph for current.\
~~possibly let user adjust charging cycle~~\
~~let user adjust time it takes to reach certain voltage~~\

~~link code here~~\
~~image here~~\

*tau = RC* is the time constant of the RC circuit *time it takes to reach 63.2% of the maximum vaoltage which is 3.6v*, together with time *t*, were the two parameters used to fit the voltage data.\
We can roughly see the inverse exponential curve for an ideal RC circuit besides for the drop in voltage inbetween.\
Analyzing the goodness of fit statistics using the ```gof``` command, the fit yields\

```
gof = struct with fields:
           sse: 45.6319
       rsquare: 0.2294
           dfe: 611
    adjrsquare: 0.2294
          rmse: 0.2733
```

~~discussing the sigificance~~\

One interesting note is the shpae of the current's graph tends to stay constant or linear when the voltage is changing.
This perfectly aligns with the behavior of a RC circuit during charging. For the capacitor the current is proportional to the rate of the change of the voltage by a constant *C*.\
*i = C <ins>dv</ins><sub>dt</sub>*\
Because the capacitor acts a short circuit when uncharged, the current flow is maximum at the beginning, and when the capacitor's voltage reaches the supply voltage, the current would be zero in the limit.\

## Rate of Change at Key Intervals
By computing the rate of the change of voltage with respect to time ```dVdt= gradient(voltage, time)```, we expect to see the derivative of voltage vs time to resemeble a form more or less like that of the current.\
~~code~~\
~~image~~\

## Power Delivered to the Battery
The instantaneous power tells us how fast electrical energy is being delivered to the battery at each moment during the charging process.
Power is:\
            *P(t) = V(t)I(t)*\
With *dE / dt = P(t)* the total energy delivered is the integral\
~~code~~\
~~image~~\

## Power Loss due to Resistance
Apply Joule's Law:\
  With Ohm's law *V = IR*\
  The heating formula estimating power loss in watts is given as:\
       *P<sub>loss</sub> = IV = I<sup>2</sup>R*\
The Energy loss is given as:\
       *E<sub>loss</sub> = P<sub>loss</sub>t*\
~~code~~\
~~image~~\

  


