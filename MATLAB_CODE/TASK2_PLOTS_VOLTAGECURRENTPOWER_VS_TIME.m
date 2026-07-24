fig = figure;
% To create the figure handle.

%% Subplot 1: Voltage vs. Time
subplot(3, 1, 1);
% Because general format is subplot(number_of_rows, number_of_columns,
% position), 3 rows refer to the 3 different subplots (Voltage vs. Time,
% Current vs. Time, and Power vs. Time), the 1 column stacks the three
% subplots vertically satisfying the condition that they be presented as
% a visualization with one figure, and lastly, the position is 1 referring
% to the first subplot Voltage vs. Time.
plot(cycleData.DateTime, cycleData.Voltage, 'b-', 'LineWidth', 2)
% Because general format is plot(x, y, 'type of color + line style',
% 'optionally enlarge line width', value for linewidth), for subplot 1
% time is the x axis, voltage is the y axis, color of the line of plot is
% self-dictated as blue, and width of line is increased to 2 for better
% visibility.
xlabel('Time (s)');
% To name the x-axis as its represented value time.
ylabel('Voltage (V)');
% To name the y-axis as its represented value voltage.
title('Voltage vs. Time');
% To name the title
grid on;
% To display grid lines for visibility.

%% Subplot 2: Current vs. Time
subplot(3, 1, 2);
% Once again, general format remains the same, only change: the position is
% 2 now and refers to the second subplot
% Current vs. Time.
plot(cycleData.DateTime, cycleData.Current, 'g-', 'LineWidth', 2)
% General format remains the same, changes: y axis is now current,
% self-dictated color of line is now green.
xlabel('Time (s)');
% To name the x-axis as its represented value time.
ylabel('Current (A)');
% To name the y-axis as its represented value current.
title('Current vs. Time');
% To name the title
grid on;
% To display grid lines for visibility.

%% Subplot 3: Power vs. Time
cycleData.Power = cycleData.Voltage .* cycleData.Current;
% Compute power by using element-by-element operator '.*' and the
% equation P = I * V.
subplot(3, 1, 3);
% Once again, general format remains the same, only change: the position is
% 3 now and refers to the third subplot
% Power vs. Time.
plot(cycleData.DateTime, cycleData.Power, 'r-', 'LineWidth', 2)
% General format remains the same, changes: y axis is now power,
% self-dictated color of line is now red.
xlabel('Time (s)');
% To name the x-axis as its represented value time.
ylabel('Power (W)');
% To name the y-axis as its represented value power.
title('Power vs. Time');
% To name the title
grid on;
% To display grid lines for visibility.
