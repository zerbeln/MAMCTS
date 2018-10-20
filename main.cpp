//
//  main.cpp
//  MAMCTS
//
//  Created by Nicholas Zerbel on 11/16/17.
//  Copyright © 2017 Nicholas Zerbel. All rights reserved.
//

#include <cstdlib>
#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <assert.h>
#include "agent.hpp"
#include "sim.hpp"
#include "tree.hpp"
#include "sim.hpp"

using namespace std;

int main() {
    srand( time(NULL) ); //Seed random generator
    
    gridworld g; monte_carlo mcts; multi_tree t; multi_agent m; //Declare instance of classes
    gridworld *gp = &g; monte_carlo *mcp = &mcts; multi_tree *tp = &t; multi_agent *map = &m; //Pointers
    
    //Create Txt Files For Data Output
    ofstream D_sysr, G_sysr, L_sysr, D_succ, G_succ, L_succ;
    D_sysr.open("D_SysRewards.txt"); D_succ.open("D_Runs.txt");
    G_sysr.open("G_SysRewards.txt"); G_succ.open("G_Runs.txt");
    L_sysr.open("L_SysRewards.txt"); L_succ.open("L_Runs.txt");
    
    //Testing Parameters
    int stat_runs = 30; //Number of statistical runs
    int max_run = 1000; //Cuts off the simulation if the number of iterations exceed this amount
    int agent_increment = 1; //Increases the number of agents in a simulation by this amount
    int starting_agents = 2; //Initial number of agents being tested
    int max_agents = 6; //Maximum number of agents to be tested
    g.x_dim = 5; //Maximum X Dimension
    g.y_dim = 5; //Maximum Y Dimension
    mcp->epsilon = 7; //UCB1 exploration constant (0 = greedy action selection)
    mcp->rollout_steps = 20;//Number of rollout moves
    gp->max_lev = g.x_dim + g.y_dim;
    mcp->max_lev = g.x_dim + g.y_dim; //Cutoff point in tree where tree cannot expand any further
    int success_count; //Counts the number of successful runs (all goals captured)
    
    //Rewards and Penalties
    g.goal_reward = 100; //Reward for reaching an unclaimed goal
    g.penalty = 0; //Penalty for reaching a claimed goal
    mcts.rollout_reward = 1; //Reward received during MCTS rollout for discovering a goal
    g.step_penalty = -1; //Cost of each step taken by an agent in Gridworld

    map->create_config_list(max_agents, g.x_dim, g.y_dim, stat_runs);
    for(int c = 1; c < 4; c++){ //1 = local, 2 = global, 3 = difference
        cout << "Credit Eval: " << c << endl;
        g.credit_type = c;
        for(g.n_agents = starting_agents; g.n_agents <= max_agents;){
            for(int s = 0; s < stat_runs; s++){ //Run tests for specific number of stat runs
                m.create_start_vecs(s, g.n_agents, max_agents);
                g.initialize_parameters(map, mcp);
                mcts.create_root_nodes(tp, map);
                for(int its = 0; its < max_run; its++){
                    for(int anum = 0; anum < g.n_agents; anum++){ //anum = agent number
                        mcts.set_mc_parameters(tp, anum);
                        mcts.mc_search(tp, map); //Runs MCTS for defined number of expansions
                        mcts.n_num_vec.at(anum) = mcts.node_number; //Used to track what the current node number is in each tree
                    }
                    g.cred_evals(map, tp, mcp);
                    
                    //Check to see if agents have arrived at goals
                    g.system_rollout(map, tp, mcp);
                    g.all_goals_captured = true;
                    if(its == (max_run-1)){
                        success_count = m.record_goal_captures(); //Record number of goals captured in final iteration
                    }
                    for(int anum = 0; anum < g.n_agents; anum++){
                        m.check_agent_status(anum);
                        m.check_agent_coordinates(anum);
                        if(m.agent_at_goal == false or m.unique_pos == false){
                            g.all_goals_captured = false;
                        }
                    }
                    g.reset_all_agents(map, tp);
                    if(g.n_agents == max_agents){ //Record system reward (only for max agents)
                        if(c == 1){L_sysr << g.sys_reward << "\t";}
                        if(c == 2){G_sysr << g.sys_reward << "\t";}
                        if(c == 3){D_sysr << g.sys_reward << "\t";}
                    }
                }
                if(g.n_agents == max_agents){ //Record system reward (only for max agents)
                        if(c == 1){L_sysr << "\n";}
                        if(c == 2){G_sysr << "\n";}
                        if(c == 3){D_sysr << "\n";}
                }
                if(c == 1){
                    L_succ << success_count << "\t";
                }
                if(c == 2){
                    G_succ << success_count << "\t";
                }
                if(c == 3){
                    D_succ << success_count << "\t";
                }
                g.clear_all_vectors(map, mcp, tp); //Begin new stat run
            }
            if(c == 1){L_succ << "\n";}
            if(c == 2){G_succ << "\n";}
            if(c == 3){D_succ << "\n";}
            g.n_agents += agent_increment;
        }
    }
    D_sysr.close(); G_sysr.close(); L_sysr.close();
    D_succ.close(); G_succ.close(); L_succ.close();
    return 0;
}
