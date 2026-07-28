%STEP 1- load the battery dataset into MATLAB memory and show the first five rows
dataFile=matlab.internal.examples.downloadSupportFile("predmaint","batteryagingdata/singlecell/v1/singleCellLifeTimeData.zip");
unzip(dataFile)
load("singleCellLifeTimeData.mat")
head(data,5)

%STEP 2-Select one battery cycle and only keep the period of time in which the battery was being charged
cycleData=data(data.Cycle_Index==1,:);
cycleData.DateTime=seconds(cycleData.DateTime-cycleData.DateTime(1));
%To identify the cycling phases we will use the batteryTestDataParser. This
%function enables raw data visualization, aids in identifying anomalies, and prepare high-quality data.
%The bParser is an object-parser will analyze Cycle 1
bParser=batteryTestDataParser(data);

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
%Select only the data in which the battery was being charged and that
%belongs to one cycle
chargeData=segmentedRawDataTable(segmentedRawDataTable.CyclingPhases=="Charge" & segmentedRawDataTable.Cycle_Index==1,:);
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

exportgraphics(gcf, 'TASK1_RCModelFit.png', 'Resolution', 300);
% To save the visualization as a PNG image.

%STEP 5- Display the goodness of fit statistics
gof
