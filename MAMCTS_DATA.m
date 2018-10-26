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
max_lev = xdim + ydim;
n = stat_runs; %Number of Columns = Number of Stat Runs
m = ((max_agents-starting_agents)/increment) + 1; %Number of Rows = NAgents
xaxis = [2 3 4 5 6];
X = [1:max_runs];

%% System Reward with Max_Agents System
D_sysr = load('D_SysRewards.txt');
G_sysr = load('G_SysRewards.txt');
L_sysr = load('L_SysRewards.txt');
D_rewards = mean(D_sysr);
G_rewards = mean(G_sysr);
L_rewards = mean(L_sysr);

%Standard deviation
spacing = 5;
err_Dsys = zeros(1,max_runs/spacing);
err_Gsys = zeros(1,max_runs/spacing);
err_Lsys = zeros(1,max_runs/spacing);
for i=1:max_runs
    if mod(i, spacing) == 0
        err_Dsys(i) = std(D_sysr(:,i));
        err_Gsys(i) = std(G_sysr(:,i));
        err_Lsys(i) = std(L_sysr(:,i));
    end
end

%% Goal Capture Rate
D_runs = load('D_Runs.txt');
G_runs = load('G_Runs.txt');
L_runs = load('L_Runs.txt');
D_success = zeros(1, m);
G_success = zeros(1, m);
L_success = zeros(1, m);
num_agents = starting_agents;
for i = 1:m
    D_success(i) = mean(D_runs(i,:))/num_agents;
    G_success(i) = mean(G_runs(i,:))/num_agents;
    L_success(i) = mean(L_runs(i,:))/num_agents;
    num_agents = num_agents + increment;
end

%Standard Deviation
err_Drate = zeros(1, m);
err_Grate = zeros(1, m);
err_Lrate = zeros(1, m);
num_agents = starting_agents;
for i = 1:m
    err_Drate(i) = std(D_runs(i,:),1)/(num_agents);
    err_Grate(i) = std(G_runs(i,:),1)/(num_agents);
    err_Lrate(i) = std(L_runs(i,:),1)/(num_agents);
    num_agents = num_agents + increment;
end

%% Plots
%MAMCTS Learning Curve------------------------------------------------
plot(X, D_rewards, 'k:+', 'Linewidth', 2) %Difference Evals
hold on
plot(X, G_rewards, 'g--o', 'Linewidth', 2) %Global Evals
plot(X, L_rewards, 'b-.s', 'Linewidth', 2) %Local Evals
errorbar(X, D_rewards, err_Dsys, 'k', 'Linewidth', 2)
errorbar(X, G_rewards, err_Gsys, 'g', 'Linewidth', 2)
errorbar(X, L_rewards, err_Lsys, 'b', 'Linewidth', 2)
set(gca, 'fontsize', 12)
xlim([0,200])
xlabel('Iterations', 'FontSize', 18, 'FontWeight', 'bold')
ylabel('Average System Reward', 'FontSize', 18, 'FontWeight', 'bold')
title('Learning Curve', 'FontSize', 18, 'FontWeight', 'bold')
lgd = legend('Difference', 'Global', 'Local');
lgd.FontSize = 14;

%MAMCTS Success Rate-------------------------------------------------------
n_agents = [starting_agents:increment:max_agents];
figure()
plot(n_agents, D_success, 'k:+', 'Linewidth', 2) %Difference Evals
hold on
plot(n_agents, G_success, 'g--o', 'Linewidth', 2) %Global Evals
plot(n_agents, L_success, 'b-.s', 'Linewidth', 2) %Local Evals
errorbar(n_agents, D_success, err_Drate, 'k', 'Linewidth', 2)
errorbar(n_agents, G_success, err_Grate, 'g', 'Linewidth', 2)
errorbar(n_agents, L_success, err_Lrate, 'b', 'Linewidth', 2)
set(gca,'xtick', xaxis)
set(gca, 'fontsize', 12)
xlabel('Number of Agents', 'FontSize', 18, 'FontWeight', 'bold')
ylabel('Goals Captured (%)', 'FontSize', 18, 'FontWeight', 'bold')
title('Goal Capture Rate', 'FontSize', 18, 'FontWeight', 'bold')
lgd = legend('Difference', 'Global', 'Local');
lgd.FontSize = 14;