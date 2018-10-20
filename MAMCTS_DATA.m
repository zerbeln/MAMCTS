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

D_sysr = load('D_SysRewards.txt');
G_sysr = load('G_SysRewards.txt');
L_sysr = load('L_SysRewards.txt');
D_runs = load('D_Runs.txt');
G_runs = load('G_Runs.txt');
L_runs = load('L_Runs.txt');

D_rewards = mean(D_sysr);
G_rewards = mean(G_sysr);
L_rewards = mean(L_sysr);

D_success = zeros(1, m);
G_success = zeros(1, m);
L_success = zeros(1, m);
num_agents = starting_agents;
for i = 1:m
    D_success(i) = 100*mean(D_runs(i,:))/num_agents;
    G_success(i) = 100*mean(G_runs(i,:))/num_agents;
    L_success(i) = 100*mean(L_runs(i,:))/num_agents;
    num_agents = num_agents + increment;
end

%% Plots
%MAMCTS Learning Curve------------------------------------------------
plot(X, D_rewards, 'k:+', 'Linewidth', 2) %Difference Evals
hold on
plot(X, G_rewards, 'g--o', 'Linewidth', 2) %Global Evals
plot(X, L_rewards, 'b-.s', 'Linewidth', 2) %Local Evals
set(gca, 'fontsize', 12)
%xlim([0,200])
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
%errorbar(n_agents, de_avg_its, err_data_1, 'k', 'Linewidth', 2)
%errorbar(n_agents, ge_avg_its, err_data_2, 'g', 'Linewidth', 2)
%errorbar(n_agents, le_avg_its, err_data_3, 'b', 'Linewidth', 2)
set(gca,'xtick', xaxis)
set(gca, 'fontsize', 12)
xlabel('Number of Agents', 'FontSize', 18, 'FontWeight', 'bold')
ylabel('Goals Captured (%)', 'FontSize', 18, 'FontWeight', 'bold')
title('Goal Capture Rate', 'FontSize', 18, 'FontWeight', 'bold')
lgd = legend('Difference', 'Global', 'Local');
lgd.FontSize = 14;