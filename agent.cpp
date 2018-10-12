//
//  agent.cpp
//  MAMCTS
//
//  Created by Nick Zerbel on 5/25/17.
//  Copyright © 2017 Nick Zerbel. All rights reserved.
//

#include "agent.hpp"

//Global Functions
void multi_agent::create_config_list(int max_a, int xd, int yd, int nstat){ //nstat = number of stat runs, max_a = max number of agents
    ifstream ac_x("agent_x_coords.txt"); ifstream ac_y("agent_y_coords.txt"); //These files contain agent starting positions
    ifstream gc_x("goal_x_coords.txt"); ifstream gc_y("goal_y_coords.txt"); //These files contain goal positions
    agent a; goal g;
    //Create a master-list of agent and goal initial positions in gridworld. A different set for each statistical run
    for(int j = 0; j < nstat*max_a; j++){ //nstat*max_a = maximum number of configurations
        agent_list.push_back(a); //
        goal_list.push_back(g);
    }
    for(int j = 0; j < nstat*max_a; j++){ //nstat*max_a = maximum number of configurations
        ac_x >> agent_list.at(j).agent_x; //Get agent x-coordinate from txt file
        ac_y >> agent_list.at(j).agent_y; //Get agent y-coordinate from txt file
        gc_x >> goal_list.at(j).goal_x; //Get goal x-coordinate from txt file
        gc_y >> goal_list.at(j).goal_y; //Get goal y-coordinate from txt file
    }
    
    ac_x.close(); ac_y.close(); gc_x.close(); gc_y.close();
}

void multi_agent::create_start_vecs(int stat, int n, int max_a){ //n = current number of agents, max_a = maximum number of agents, stat = current stat run
    n_agents = n;
    agent a; goal g;
    for(int i = 0; i < n_agents; i++){
        agent_start_pos.push_back(a);
        goal_start_pos.push_back(g);
        agent_start_pos.at(i) = agent_list.at(max_a*stat + i); //Keeps track of agent intiial position for the stat run
        goal_start_pos.at(i) = goal_list.at(max_a*stat + i); //Keeps track of goal position for the stat run
    }
}

//AGENT FUNCTIONS-----------------------------------------------------------------------------------------------
void multi_agent::assign_agent_coordinates(){
    double x, y;
    agent_vec = agent_start_pos;
    //Check to make sure no agents are stacked
    for(int i = 0; i < n_agents; i++){
        x = agent_vec.at(i).agent_x;
        y = agent_vec.at(i).agent_y;
        check_agent_coordinates(i, x ,y);
        assert(unique_pos == true);
    }
}

void multi_agent::agent_move(int n, int act){ //Agent Number, Action
    double ax, ay;
    ax = agent_vec.at(n).agent_x;
    ay = agent_vec.at(n).agent_y;
    assert(act <= 4);
    assert(act >= 0);
    
    if(act == 0){
        ax--;
    }
    if(act == 1){
        ay++;
    }
    if(act == 2){
        ay--;
    }
    if(act == 3){
        ax++;
    }
    if(act == 4){
        ax = agent_vec.at(n).agent_x;
        ay = agent_vec.at(n).agent_y;
    }
    agent_vec.at(n).agent_x = ax;
    agent_vec.at(n).agent_y = ay;
}

void multi_agent::check_agent_coordinates(int n, double x, double y){
    unique_pos = true;
    for(int i = 0; i < n_agents; i++){ //Check agent coordinates against other agent coordinates
        if(i != n){
            if(x == agent_vec.at(i).agent_x && y == agent_vec.at(i).agent_y){
                unique_pos = false;
                break;
            }
        }
    }
}

void multi_agent::check_agent_status(int an){ //Checks if agent is at  goal
    double x, y;
    x = agent_vec.at(an).agent_x;
    y = agent_vec.at(an).agent_y;
    
    agent_in_play = true;
    for(int i = 0; i < n_agents; i++){
        if(x == goal_vec.at(i).goal_x && y == goal_vec.at(i).goal_y){ //If agent is at a goal, it is no longer in play
            agent_in_play = false;
            break;
        }
    }
}

//GOAL FUNCTIONS----------------------------------------------------------------------------------------------------
void multi_agent::assign_goal_coordinates(){
    double x, y;
    goal_vec = goal_start_pos;
    //Check to make sure no goals are stacked
    for(int i = 0; i < n_agents; i++){
        x = goal_vec.at(i).goal_x;
        y = goal_vec.at(i).goal_y;
        check_goal_coordinates(i, x, y);
        assert(unique_pos == true);
    }
}

void multi_agent::check_goal_coordinates(int n, double xc, double yc){ //Goal number, goal_x, goal_y
    unique_pos = true;
    for(int i = 0; i < n_agents; i++){ //Check goal coordinates against other goal coordinates and agent coordinates
        if(i != n){
            if(xc == goal_vec.at(i).goal_x && yc == goal_vec.at(i).goal_y){
                unique_pos = false;
                break;
            }
        }
        if(xc == agent_vec.at(i).agent_x && yc == agent_vec.at(i).agent_y){ //Goal cannot start out at same position as agent
            unique_pos = false;
            break;
        }
    }
}

void multi_agent::check_goal_status(int gn){
    double gx, gy;
    gx = goal_vec.at(gn).goal_x;
    gy = goal_vec.at(gn).goal_y;
    goal_in_play = true;
    for(int i = 0; i < n_agents; i++){
        if(gx == agent_vec.at(i).agent_x && gy == agent_vec.at(i).agent_y){
            goal_in_play = false;
        }
    }
}
