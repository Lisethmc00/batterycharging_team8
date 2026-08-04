% Variables
time = chargeData.DateTime;
% Raw data
dVdt = chargeData.("dV/dt");

% dVdt tells us how quickly the voltage is charging at each
% point in time during the charging cycle.

figure
plot(time, dVdt)
xlabel('Time (s)')
ylabel('dV/dt (V/s)')
title('Rate of Change of Voltage During Charging')
grid on

% To save the visualization as a PNG image.
exportgraphics(gcf, 'TASK3_DVDT_VS_TIME.png', 'Resolution', 300);

%xlim([-8 195])
%ylim([-0.020 0.071])

% UNCOMMENT THE LINE OF CODE BELOW TO SEE ALL THE DATA OF CYCLE 1
%openvar('chargeData');

%openvar("dVdt")

% Rate of voltage change at key intervals

% Computed dV/dt from voltage and time
dVdt_Compute = gradient(chargeData.Voltage, chargeData.DateTime);

% dV/dt provided in the raw dataset
dVdt_Raw = chargeData.("dV/dt");

% Representative indices
idxBeginning = 1;
idxMiddle = round(length(dVdt_Compute)/2);
idxEnd = length(dVdt_Compute);

% Computed values
dVdt_beginning = dVdt_Compute(idxBeginning);
dVdt_middle = dVdt_Compute(idxMiddle);
dVdt_end = dVdt_Compute(idxEnd);
dVdt_Cmax = max(dVdt_Compute);
dVdt_Cmin = min(dVdt_Compute);

% Raw-data values
dVdt_beginning_RD = dVdt_Raw(idxBeginning);
dVdt_middle_RD = dVdt_Raw(idxMiddle);
dVdt_end_RD = dVdt_Raw(idxEnd);
dVdt_max = max(dVdt_Raw);
dVdt_min = min(dVdt_Raw);

% Display computed values
fprintf('\nComputed dV/dt values\n');
fprintf('Beginning: %.6f s, dV/dt = %.6f V/s\n', ...
    time(idxBeginning), dVdt_beginning);

fprintf('Middle: %.6f s, dV/dt = %.6f V/s\n', ...
    time(idxMiddle), dVdt_middle);

fprintf('End: %.6f s, dV/dt = %.6f V/s\n', ...
    time(idxEnd), dVdt_end);

fprintf('Maximum computed dV/dt: %.6f V/s\n', dVdt_Cmax);
fprintf('Minimum computed dV/dt: %.6f V/s\n', dVdt_Cmin);

% Display raw-data values
fprintf('\nRaw-data dV/dt values\n');
fprintf('Beginning: %.6f s, dV/dt = %.6f V/s\n', ...
    time(idxBeginning), dVdt_beginning_RD);

fprintf('Middle: %.6f s, dV/dt = %.6f V/s\n', ...
    time(idxMiddle), dVdt_middle_RD);

fprintf('End: %.6f s, dV/dt = %.6f V/s\n', ...
    time(idxEnd), dVdt_end_RD);

fprintf('Maximum raw-data dV/dt: %.6f V/s\n', dVdt_max);
fprintf('Minimum raw-data dV/dt: %.6f V/s\n', dVdt_min);

% Plot computed and raw-data dV/dt

figure
plot(time, dVdt_Compute, 'LineWidth', 1.5)
hold on
plot(time, dVdt_Raw, '--', 'LineWidth', 1.5)

% Mark representative computed values
plot(time(idxBeginning), dVdt_beginning, 'o', ...
    'MarkerSize', 8, 'MarkerFaceColor', 'auto')

plot(time(idxMiddle), dVdt_middle, 'o', ...
    'MarkerSize', 8, 'MarkerFaceColor', 'auto')

plot(time(idxEnd), dVdt_end, 'o', ...
    'MarkerSize', 8, 'MarkerFaceColor', 'auto')

% Mark representative raw-data values
plot(time(idxBeginning), dVdt_beginning_RD, 's', ...
    'MarkerSize', 8)

plot(time(idxMiddle), dVdt_middle_RD, 's', ...
    'MarkerSize', 8)

plot(time(idxEnd), dVdt_end_RD, 's', ...
    'MarkerSize', 8)

xlabel('Time (s)')
ylabel('dV/dt (V/s)')
title('Comparison of Computed and Raw-Data Voltage Change Rates')
legend('Computed dV/dt', ...
       'Raw-data dV/dt', ...
       'Computed beginning', ...
       'Computed middle', ...
       'Computed end', ...
       'Raw beginning', ...
       'Raw middle', ...
       'Raw end', ...
       'Location', 'best')
grid on
hold off

% To save the visualization as a PNG image.
exportgraphics(gcf, 'TASK3_DVDT_COMPUTED_VS_RAW.png', 'Resolution', 300);

%xlim([-17 167])
%ylim([-0.048 0.413])

% Constant current vs constant voltage
time    = chargeData.DateTime;
voltage = chargeData.Voltage;
current = chargeData.Current;
% Raw data
%dVdt    = chargeData.("dV/dt");

% Transition from CC to CV
% CV begins when voltage reaches 99% of its maximum value
% Voltage Threshold = 0.99*3.60=3.564
voltageThreshold = 0.99 * max(voltage);

idx_transition = find(voltage >= voltageThreshold, 1, 'first');

% Indices for each charging region
idx_CC = 1:idx_transition-1;
idx_CV = idx_transition:length(time);

figure

subplot(2,1,1)
plot(time, voltage, 'LineWidth', 1.5)
hold on
xline(time(idx_transition), '--', 'CC to CV')
ylabel('Voltage (V)')
title('Voltage vs Time')
grid on

subplot(2,1,2)
plot(time, current, 'LineWidth', 1.5)
hold on
xline(time(idx_transition), '--', 'CC to CV')
xlabel('Time')
ylabel('Current (A)')
title('Current vs Time')
grid on

% To save the visualization as a PNG image.
exportgraphics(gcf, 'TASK3_CC_VS_CV_VOLTAGECURRENT.png', 'Resolution', 300);

%%%% After adding this line to code in task 1: & segmentedRawDataTable.IsValid==true,:)
%%%% Maybe this part is no needed.
% Keep only valid charge data
validCharge = chargeData.IsValid & ...
    chargeData.CyclingPhases == "Charge";

data = chargeData(validCharge,:);

% Variables
time = data.DateTime;
dVdt = data.("dV/dt");

% Constant-Current (CC) data
CC = data.CyclingModes == "CC";

timeCC = time(CC);
dVdtCC = dVdt(CC);

% Constant-Voltage (CV) data
CV = data.CyclingModes == "CV";

timeCV = time(CV);
dVdtCV = dVdt(CV);

% Plot dV/dt during CC charging
figure
plot(timeCC, dVdtCC,'LineWidth',1.5)
xlabel('Time (s)')
ylabel('dV/dt (V/s)')
title('dV/dt During Constant-Current (CC) Charging')
grid on

% To save the visualization as a PNG image.
exportgraphics(gcf, 'TASK3_DVDT_CC_PHASE.png', 'Resolution', 300);

% Plot dV/dt during CV charging
figure
plot(timeCV, dVdtCV,'LineWidth',1.5)
xlabel('Time (s)')
ylabel('dV/dt (V/s)')
title('dV/dt During Constant-Voltage (CV) Charging')
grid on

% To save the visualization as a PNG image.
exportgraphics(gcf, 'TASK3_DVDT_CV_PHASE.png', 'Resolution', 300);

% Declare Variables
% Maximum charge capacity
% When battery reaches 100% approximately 3.6V
maxCapacity = max(chargeData.Charge_Capacity);

% 80% of the maximum capacity
capacity80 =0.8 * maxCapacity;

% Find the data point when 80% and 100% are reached:

% Find when the battery reaches 80%
charge80 = find(chargeData.Charge_Capacity >= capacity80, 1, 'first');
% Find when the battery reaches 100%
charge100 = find(chargeData.Charge_Capacity >= maxCapacity, 1, 'first');

% Convert data point position to time
time80 = time(charge80);
time100 = time(charge100);

% Display the times
fprintf('Time to reach 80%% charge =%.6f s\n', time80);
fprintf('Time to reach 100%% charge =%.6f s\n', time100);

% Plot Charge Capacity vs Time

figure
plot(time, chargeData.Charge_Capacity, 'b', 'LineWidth', 1.5)
% To keep the current graph and add plots to it
hold on

% Mark the 80% charge point
% The red circle identifies the point at which the battery reaches 80%
% charge.
plot(time80, chargeData.Charge_Capacity(charge80), 'ro', 'MarkerSize', 8, 'LineWidth', 2)

% Mark the 100% charge point
% The green circle identifies the point at which the battery reaches 100%
% charge.
plot(time100, chargeData.Charge_Capacity(charge100), 'go', 'MarkerSize', 8, 'LineWidth', 2)

% Display the points when the battery reaches 80% and 100% charge

text(time80 + 30, chargeData.Charge_Capacity(charge80), + 0.01,'80%', 'Color', 'black')

text(time100 + 30, chargeData.Charge_Capacity(charge100), +0.01, '100%', 'Color', 'black')

% Display the plot
xlabel('Time (s)')
ylabel('Charge Capacity (Ah)')
title('Charge Capacity vs Time')
legend('Charge Capacity', '80% Charge' , '100% Charge', 'Location', 'southoutside')

xlim([127 1945])
ylim([0.04 1.13])

% To save the visualization as a PNG image.
exportgraphics(gcf, 'TASK3_CHARGECAPACITY_80_100.png', 'Resolution', 300);

% Calculate the Energy delivered

% First calculate instantaneous power in watts
% Use (.*)
power = voltage .* current;

% Calculate the area under the power-time curve
% Which is the total energy delivered in joules
energy = trapz(time, power);

% Display the result
fprintf('Total energy delivered = %.2f J\n', energy);
% Power-Time curve represent the total energy delivered
figure
area(time, power, 'FaceAlpha', 0.3)
hold on
plot(time, power, 'b', 'LineWidth',1.5)

xlabel('Time (s)')
ylabel('Power (W)')
title('Power-Time Curve During Battery Charging')
legend('Area representing energy', 'Instantaneous power', 'Location', 'best')

grid on

% To save the visualization as a PNG image.
exportgraphics(gcf, 'TASK3_POWERTIMECURVE_ENERGY.png', 'Resolution', 300);

% Check is the internal resistance is constant
unique(chargeData.Internal_Resistance ...
    )

% Estimate Resistive energy loss

% Get internal resistance
R = chargeData.Internal_Resistance;
% Instantaneous Resistive power loss (W)
powerLoss = current.^2 .* R;

% Total Resistive energy loss (J)
energyLoss = trapz(time, powerLoss);

% Display values
fprintf('Total resistive energy loss = %.2f J\n', energyLoss);
% Plot Power Loss vs Time

figure
% The area represents the energy loss
area(time, powerLoss, 'FaceAlpha', 0.3)
hold on
plot(time, powerLoss, 'LineWidth', 1.5)

xlabel('Time (s)')
ylabel('Power Loss (W)')
title('Resistive Power Loss During Charging')
legend('Area representing energy loss', 'Instantaneous power loss', 'Location', 'best')

grid on

% To save the visualization as a PNG image.
exportgraphics(gcf, 'TASK3_RESISTIVEPOWERLOSS.png', 'Resolution', 300);

% Create summary table
% The results in the summary table correspond to the charging portion of
% Cycle 1.

summaryTable = table( ...
    dVdt_beginning, dVdt_middle, dVdt_end, ...
    dVdt_beginning_RD, dVdt_middle_RD, dVdt_end_RD, ...
    dVdt_Cmax, dVdt_Cmin, ...
    dVdt_max, dVdt_min, ...
    time80, time100, ...
    energy, energyLoss, ...
    'VariableNames', { ...
    'Computed_dVdt_Beginning', ...
    'Computed_dVdt_Middle', ...
    'Computed_dVdt_End', ...
    'Raw_dVdt_Beginning', ...
    'Raw_dVdt_Middle', ...
    'Raw_dVdt_End', ...
    'Computed_dVdt_Max', ...
    'Computed_dVdt_Min', ...
    'Raw_dVdt_Max', ...
    'Raw_dVdt_Min', ...
    'Time_80', ...
    'Time_100', ...
    'Energy_Delivered', ...
    'Resistive_Energy_Loss'});

disp(summaryTable)
