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
    srand( time(NULL) );
    
    gridworld g; monte_carlo mcts; multi_tree t; multi_agent m;
    gridworld *gp = &g; monte_carlo *mcp = &mcts; multi_tree *tp = &t; multi_agent *map = &m;
    
    //Create Txt Files For Data Output
    ofstream DE_Def, DE_def_steps, GE_Def, GE_def_steps, LE_Def, LE_def_steps;
    DE_Def.open("DE_Data.txt"); //Outputs number of runs it takes MCTS to find a solution
    DE_def_steps.open("DE_Steps.txt"); //Outputs how many steps agents take to arrive at goals
    GE_Def.open("GE_Data.txt"); //Outputs number of runs it takes MCTS to find a solution
    GE_def_steps.open("GE_Steps.txt"); //Outputs how many steos agents take to arrive at goals
    LE_Def.open("LE_Data.txt");
    LE_def_steps.open("LE_Steps.txt");
    
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
    gp->max_lev = g.x_dim + g.y_dim; //+ 10;
    mcp->max_lev = g.x_dim + g.y_dim; //+ 10;
    
    //Rewards and Penalties
    g.goal_reward = 100; //Reward for reaching an unclaimed goal
    g.penalty = -1; //Penalty for reaching a claimed goal
    mcp->rollout_reward = 1; //Reward received during MCTS rollout for discovering a goal
    g.step_penalty = -1; //Cost of each step taken by an agent in Gridworld

    map->create_config_list(max_agents, g.x_dim, g.y_dim, stat_runs);
    for(int c = 1; c < 4; c++){ //1 = local, 2 = global, 3 = difference
        gp->credit_type = c;
        for(gp->n_agents = starting_agents; gp->n_agents <= max_agents;){
            for(int s = 0; s < stat_runs; s++){
                map->create_start_vecs(s, gp->n_agents, max_agents);
                gp->initialize_parameters(map, mcp);
                mcp->create_root_nodes(tp, map);
                while(gp->gridworld_finished == false){
                    gp->learn_its++; //Tracks the number of learning episodes until MCTS find a solution
                    for(int anum = 0; anum < gp->n_agents; anum++){ //anum = agent number
                        mcp->set_mc_parameters(tp, anum);
                        mcp->mc_search(tp, map); //Runs MCTS for defined number of expansions
                        mcp->n_num_vec.at(anum) = mcp->node_number; //Used to track what the current node number is in each tree
                    }
                    gp->cred_evals(map, tp, mcp);
                    
                    //Check to see if agents have arrived at goals
                    gp->system_rollout(map, tp, mcp);
                    gp->check_goal_conditions(map);
                    if(gp->goal_check == true){
                        gp->gridworld_finished = true;
                    }
                    if(gp->gridworld_finished == false){
                        gp->reset_all_agents(map, tp);
                    }
                    if(gp->learn_its >= max_run){ //If the number of learning iterations is greater or equal to the max, the run has failed
                        break;
                    }
                }
                //Record Information
                if(c == 1){
                    LE_Def << g.learn_its << "\t";
                    if(gp->gridworld_finished == false){
                        g.final_lev = g.max_lev;
                    }
                    LE_def_steps << g.final_lev << "\t";
                }
                if(c == 2){
                    GE_Def << g.learn_its << "\t";
                    if(gp->gridworld_finished == false){
                        g.final_lev = g.max_lev;
                    }
                    GE_def_steps << g.final_lev << "\t";
                }
                if(c == 3){
                    DE_Def << g.learn_its << "\t";
                    if(gp->gridworld_finished == false){
                        g.final_lev = g.max_lev;
                    }
                    DE_def_steps << g.final_lev << "\t";
                }
                g.clear_all_vectors(map, mcp, tp);
            }
            g.n_agents += agent_increment;
            if(c == 1){
                LE_Def << endl;
                LE_def_steps << endl;
            }
            if(c == 2){
                GE_Def << endl;
                GE_def_steps << endl;
            }
            if(c ==3){
                DE_Def << endl;
                DE_def_steps << endl;
            }
        }
    }
    GE_Def.close(); DE_Def.close(); GE_def_steps.close(); DE_def_steps.close();
    LE_Def.close(); LE_def_steps.close();
    
    return 0;
}
