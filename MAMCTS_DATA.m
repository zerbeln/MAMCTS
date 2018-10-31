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
spacing = 10;
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
DFR = mean(D_success)*100
GR = mean(G_success)*100
LR = mean(L_success)*100

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
plot(X, D_rewards, 'k:s', 'Linewidth', 2) %Difference Evals
hold on
plot(X, G_rewards, 'g:^', 'Linewidth', 2) %Global Evals
plot(X, L_rewards, 'b:o', 'Linewidth', 2) %Local Evals
errorbar(X, D_rewards, err_Dsys, 'k', 'Linewidth', 2, 'markersize', 5)
errorbar(X, G_rewards, err_Gsys, 'g', 'Linewidth', 2, 'markersize', 5)
errorbar(X, L_rewards, err_Lsys, 'b', 'Linewidth', 2, 'markersize', 5)
set(gca, 'fontsize', 12)
xlim([0,200])
xlabel('Episodes', 'FontSize', 12, 'FontWeight', 'bold')
ylabel('System Reward G(s)', 'FontSize', 12, 'FontWeight', 'bold')
lgd = legend('Difference', 'Global', 'Local');
lgd.FontSize = 12;

%MAMCTS Success Rate-------------------------------------------------------
n_agents = [starting_agents:increment:max_agents];
figure()
plot(n_agents, D_success, 'k:s', 'Linewidth', 2, 'markersize', 10) %Difference Evals
hold on
plot(n_agents, G_success, 'g:^', 'Linewidth', 2, 'markersize', 10) %Global Evals
plot(n_agents, L_success, 'b:o', 'Linewidth', 2, 'markersize', 10) %Local Evals
errorbar(n_agents, D_success, err_Drate, 'k', 'Linewidth', 2)
errorbar(n_agents, G_success, err_Grate, 'g', 'Linewidth', 2)
errorbar(n_agents, L_success, err_Lrate, 'b', 'Linewidth', 2)
set(gca,'xtick', xaxis)
set(gca, 'fontsize', 12)
xlabel('Number of Agents and Goals', 'FontSize', 12, 'FontWeight', 'bold')
ylabel('Percentage of Goals Captured', 'FontSize', 12, 'FontWeight', 'bold')
lgd = legend('Difference', 'Global', 'Local');
lgd.FontSize = 12;