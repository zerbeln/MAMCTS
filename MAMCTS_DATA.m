%Nicholas Zerbel
%MAMCTS Data

close all; clear all; clc;
format compact

%% Experimental Parameters
stat_runs = 30;
max_runs = 1000;
starting_agents = 2;
max_agents = 6;
increment = 1;
xdim = 5;
ydim = 5;
max_lev = xdim + ydim;% + 10;
n = stat_runs; %Number of Columns = Number of Stat Runs
m = ((max_agents-starting_agents)/increment) + 1; %Number of Rows = NAgents
xaxis = [2 3 4 5 6];

%Allocate Space----------------------------------------------------------
err_data_1(1:m) = 0;
err_data_2(1:m) = 0;
err_data_3(1:m) = 0;
err_data_4(1:m) = 0;
err_data_5(1:m) = 0;
err_data_6(1:m) = 0;
err_data_7(1:m) = 0;
err_data_8(1:m) = 0;
stdv_ph_1(1:n) = 0;
stdv_ph_2(1:n) = 0;
stdv_ph_3(1:n) = 0;
stdv_ph_4(1:n) = 0;
DE_its(1:m, 1:n) = 0; %(Agent,StatRun)
GE_its(1:m, 1:n) = 0; %(Agent,StatRun)
LE_its(1:m, 1:n) = 0;
DE_steps(1:m, 1:n) = 0; %(Agent,StatRun)
GE_steps(1:m, 1:n) = 0; %(Agent,StatRun)
LE_steps(1:m, 1:n) = 0;

%Import Data From Txt Files
DE_its = load('DE_Data.txt');
GE_its = load('GE_Data.txt');
LE_its = load('LE_Data.txt');

DE_steps = load('DE_Steps.txt');
GE_steps = load('GE_Steps.txt');
LE_steps = load('LE_Steps.txt');

%Average Solution Speed ------------------------------------------------
de_avg_its(1:m) = 0;
ge_avg_its(1:m) = 0;
le_avg_its(1:m) = 0;
for i = 1:m
    de_avg_its(i) = mean(DE_its(i,:));
    ge_avg_its(i) = mean(GE_its(i,:));
    le_avg_its(i) = mean(LE_its(i,:));
end

%MAMCTS Reliability Calculation------------------------------------------
de_succ(1:m) = n;
ge_succ(1:m) = n;
le_succ(1:m) = n;
for i = 1:m
    for j = 1:n
        if DE_its(i,j) >= max_runs
            de_succ(i) = de_succ(i)-1;
        end
        if GE_its(i,j) >= max_runs
            ge_succ(i) = ge_succ(i)-1;
        end
        if LE_its(i,j) >= max_runs
            le_succ(i) = le_succ(i)-1;
        end
    end
end

%Average Agent Steps-----------------------------------------------------
de_avg_steps(1:m) = 0;
ge_avg_steps(1:m) = 0;
le_avg_steps(1:m) = 0;
for i = 1:m
    de_avg_steps(i) = mean(DE_steps(i,:));
    ge_avg_steps(i) = mean(GE_steps(i,:));
    le_avg_steps(i) = mean(LE_steps(i,:));
end

%% Error

%Speed Error Calculation
for (agnt = 1:m) %Number of Agents
    for (srun = 1:n) %Number of Stat Runs
        stdv_ph_1(srun) = DE_its(agnt, srun);
        stdv_ph_2(srun) = GE_its(agnt, srun);
        stdv_ph_3(srun) = LE_its(agnt, srun);
    end
    
    if (~mod(agnt,1))
        err_data_1(agnt) = std(stdv_ph_1)/sqrt(n);
        err_data_2(agnt) = std(stdv_ph_2)/sqrt(n);
        err_data_3(agnt) = std(stdv_ph_3)/sqrt(n);
        err_data_4(agnt) = std(stdv_ph_4)/sqrt(n);
    elseif (agnt == 1)
        err_data_1(agnt) = std(stdv_ph_1)/sqrt(n);
        err_data_2(agnt) = std(stdv_ph_2)/sqrt(n);
        err_data_3(agnt) = std(stdv_ph_3)/sqrt(n);
        err_data_4(agnt) = std(stdv_ph_4)/sqrt(n);
    else
        err_data_1(agnt) = NaN;
        err_data_2(agnt) = NaN;
        err_data_3(agnt) = NaN;
        err_data_4(agnt) = NaN;
    end
end

%Cost Error Calculation
for (agnt = 1:m) %Number of Agentsfit_data = transpose(fit_data)
    for (srun = 1:n) %Number of Stat Runs
        stdv_ph_1(srun) = DE_steps(agnt, srun);
        stdv_ph_2(srun) = GE_steps(agnt, srun);
        stdv_ph_3(srun) = LE_steps(agnt, srun);
    end
    
    if (~mod(agnt,1))
        err_data_5(agnt) = std(stdv_ph_1)/sqrt(n);
        err_data_6(agnt) = std(stdv_ph_2)/sqrt(n);
        err_data_7(agnt) = std(stdv_ph_3)/sqrt(n);
        err_data_8(agnt) = std(stdv_ph_4)/sqrt(n);
    elseif (agnt == 1)
        err_data_5(agnt) = std(stdv_ph_1)/sqrt(n);
        err_data_6(agnt) = std(stdv_ph_2)/sqrt(n);
        err_data_7(agnt) = std(stdv_ph_3)/sqrt(n);
        err_data_8(agnt) = std(stdv_ph_4)/sqrt(n);
    else
        err_data_5(agnt) = NaN;
        err_data_6(agnt) = NaN;
        err_data_7(agnt) = NaN;
        err_data_8(agnt) = NaN;
    end
end


%% Plots
%MAMCTS Reliability Plot------------------------------------------------
n_agents = [starting_agents:increment:max_agents];
plot(n_agents, de_succ, 'k:+', 'Linewidth', 2)
ylim([0 30])
hold on
plot(n_agents, ge_succ, 'g--o', 'Linewidth', 2)
plot(n_agents, le_succ, 'b-.s', 'Linewidth', 2)
set(gca,'xtick', xaxis)
set(gca, 'fontsize', 12)
xlabel('Number of Agents', 'FontSize', 18, 'FontWeight', 'bold')
ylabel('Number of Succesful Runs', 'FontSize', 18, 'FontWeight', 'bold')
title('MCTS Reliability', 'FontSize', 18, 'FontWeight', 'bold')
lgd = legend('Difference', 'Global', 'Local');
lgd.FontSize = 14;

%MAMCTS Speed Plot-------------------------------------------------------
n_agents = [starting_agents:increment:max_agents];
figure()
plot(n_agents, de_avg_its, 'k:+', 'Linewidth', 2)
hold on
plot(n_agents, ge_avg_its, 'g--o', 'Linewidth', 2)
plot(n_agents, le_avg_its, 'b-.s', 'Linewidth', 2)
errorbar(n_agents, de_avg_its, err_data_1, 'k', 'Linewidth', 2)
errorbar(n_agents, ge_avg_its, err_data_2, 'g', 'Linewidth', 2)
errorbar(n_agents, le_avg_its, err_data_3, 'b', 'Linewidth', 2)
set(gca,'xtick', xaxis)
set(gca, 'Ydir','reverse')
set(gca, 'fontsize', 12)
xlabel('Number of Agents', 'FontSize', 18, 'FontWeight', 'bold')
ylabel('Number of Iterations', 'FontSize', 18, 'FontWeight', 'bold')
title('Solution Discovery Speed', 'FontSize', 18, 'FontWeight', 'bold')
lgd = legend('Difference', 'Global', 'Local');
lgd.FontSize = 14;

%MAMCTS Agent Cost-------------------------------------------------------
n_agents = [starting_agents:increment:max_agents];
figure()
plot(n_agents, de_avg_steps, 'k:+', 'Linewidth', 2)
ylim([0 max_lev])
hold on
plot(n_agents, ge_avg_steps, 'g--o', 'Linewidth', 2)
plot(n_agents, le_avg_steps, 'b-.s', 'Linewidth', 2)
errorbar(n_agents, de_avg_steps, err_data_5, 'k', 'Linewidth', 2)
errorbar(n_agents, ge_avg_steps, err_data_6, 'g', 'Linewidth', 2)
errorbar(n_agents, le_avg_steps, err_data_7, 'b', 'Linewidth', 2)
set(gca,'xtick', xaxis)
set(gca, 'fontsize', 12)
xlabel('Number of Agents', 'FontSize', 18, 'FontWeight', 'bold')
ylabel('Average Agent Steps', 'FontSize', 18, 'FontWeight', 'bold')
title('Agent Cost', 'FontSize', 18, 'FontWeight', 'bold')
lgd = legend('Difference', 'Global', 'Local');
lgd.FontSize = 14;