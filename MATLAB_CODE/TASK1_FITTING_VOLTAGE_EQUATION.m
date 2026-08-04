%STEP 1- load the battery dataset into MATLAB memory and show the first five rows
dataFile=matlab.internal.examples.downloadSupportFile("predmaint","batteryagingdata/singlecell/v1/singleCellLifeTimeData.zip");
unzip(dataFile)
load("singleCellLifeTimeData.mat")
head(data,5)

%STEP 2-Select one battery cycle and only keep the period of time in which the battery was being charged
%The following code selects solely the battery cycle with index 1
cycleData=data(data.Cycle_Index==1,:);
%To identify the cycling phases we will use the batteryTestDataParser. This
%function enables raw data visualization, aids in identifying anomalies, and prepare high-quality data.
%The bParser is an object-parser will analyze Cycle 1
bParser=batteryTestDataParser(cycleData);
%Indicates the use of the column called current when current values are
%needed
bParser.CurrentVariable='Current';
%Indicates the use of the column called voltage when voltage values are
%needed
bParser.VoltageVariable="Voltage";
%Indicates the use of the column called DateTime when time information is
%needed
bParser.TimeVariable="DateTime";
%Indicates the use of the column called Cycle Index to know which cycle a
%measurement belongs to
bParser.CycleIndexVariable='Cycle_Index';
%Indicates the use of the column called Step Index to identify the different
%steps inside the cycle
bParser.StepIndexVariable='Step_Index';
%Use segmentData to identify the cycling phase and mode that each data
%point belongs to, and flag invalid data points. 
segmentedRawDataTable=segmentData(bParser);
%Select only the data in which the battery was being charged 
chargeData=segmentedRawDataTable(segmentedRawDataTable.CyclingPhases=="Charge",:); 
% Convert time to seconds starting at charging beginning (makes the exact
% time in which the battery started charging to be time=0 seconds)
chargeData.DateTime = seconds(chargeData.DateTime - chargeData.DateTime(1));

%STEP 3- fit the voltage equation to the selected data 
%The x variable corresponds to time and the y variable corresponds to
%voltage. Obtain these variables from charging data
t=chargeData.DateTime;
V=chargeData.Voltage;
%The battery is fully charged at 3.6 V so Vmax=3.6 V
Vmax=3.6;
%Define the capacitor charging equation V(t)=Vmax�(1−e^(−t/RC)), also known
%as the RC charging equation. 
%Tau equals RC and it represents the time it takes for a capacitor to reach approximately 63.2% of its max voltage.  Our only unknown is tau.  
rcEquation=fittype(@(tau, t) Vmax*(1-exp(-t/tau)), 'independent', 't', 'coefficients', 'tau');
%Give an initial guess for tau and create fitting options
opts=fitoptions(rcEquation);
opts.StartPoint=1000;
opts.Lower=0.0000001;
opts.Upper = 100000;
%Syntax:[fitobject,gof]=fit(x,y,fitType,fitOptions)
[fitobject,gof]=fit(t,V,rcEquation,opts);
%Display fitted time constant
fitobject
%STEP 4-Plot the data and the fitted curve in the same figure 
plot(fitobject,t,V);
xlabel('Time (s)');
ylabel('Voltage (V)');
title('Battery Charging Profile and RC Model Fit');
legend('Voltage Measured','RC Model');
grid on;
% To save the visualization as a PNG image.
exportgraphics(gcf, 'TASK1_RCMODELFIT_MANUAL.png', 'Resolution', 300);

%STEP 5- Display the goodness of fit statistics
gof


%%% STUFF ADDED BY LISETH%%%
%%%WE CAN USE THIS TO ARGUE THE goodness of fit statistics%%%%
This curved was created using the Curve Fitter APP 
The equation used is: 
                                        

Note: Vmax = 3.6 V and Vo = 2.0326 V
% Create RC Model Fit Plot

DateTime = chargeData.DateTime;
Voltage = chargeData.Voltage;


[fitresult, gof] = createRC_Curve(DateTime, Voltage);

xlim("auto")
ylim("auto")
legend(["Voltage vs. DateTime", "RC Model"], "Interpreter", "none", "Location", "none", "Position", [0.5642 0.3519 0.2968, 0.0941])

title("RC Model vs Voltage vs Time")
xlabel("DateTime (s)", "Interpreter", "none")
ylabel("Voltage (v)", "Interpreter", "none")

% To save the visualization as a PNG image.
exportgraphics(gcf, 'TASK1_RCMODELFIT_CURVEFITTERAPP.png', 'Resolution', 300);

%STEP 5- Display the goodness of fit statistics

% Create variable tau = RC
% RC parameters
tau = fitresult.tau;
R = chargeData.Internal_Resistance(1);
C = tau / R;

% Goodness-of-fit table
FitStats = table( ...
    tau, ...
    gof.rsquare, ...
    gof.adjrsquare, ...
    gof.rmse, ...
    gof.sse, ...
    'VariableNames', ...
    {'Tau_s','Rsquare','AdjustedRsquare','RMSE','SSE'});

FitStats
Note: R^2 is 0.7294
This value changed!

% Tau the time constant

% Declare Variables
tau = 4.4285;
Vo = chargeData.Voltage(1);
Vmax = 3.6;

t = linspace(0,5*tau,200);
%voltage = Vmax*(1-exp(-t/tau)); DELETE THIS
voltage = Vo + (Vmax-Vo).*(1-exp(-t/tau));

% 63.2 % out of 100%
%V63 = 0.632 * Vmax; Use this line to use tau from the original model
%starting at 0V

%OR
% Use this when using Vo = 2.0326 V
V63 = Vo + 0.632*(Vmax - Vo);

figure
plot(t,voltage,'b','LineWidth',2)
hold on

% Mark the 63.2% point
plot(tau,V63,'ro','MarkerSize',10,'MarkerFaceColor','r')

% Draw reference lines
xline(tau,'--r','\tau')
yline(V63,'--k','63.2% of V_{max}')

text(tau,V63,...
    sprintf('  (%.4f, %.3f V)',tau,V63),...
    'VerticalAlignment','bottom')

xlabel('Time (S)')
ylabel('Voltage (V)')
title('RC Charging Curve with Time Constant')
grid on
legend('RC Fit','63.2% Point','Location','southeast')

% To save the visualization as a PNG image.
exportgraphics(gcf, 'TASK1_RCCURVE_TIMECONSTANT.png', 'Resolution', 300);
