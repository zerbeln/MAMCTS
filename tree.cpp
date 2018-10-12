//
//  tree.cpp
//  MAMCTS
//
//  Created by Nicholas Zerbel on 5/25/17.
//  Copyright © 2017 Nicholas Zerbel. All rights reserved.
//

#include "tree.hpp"

void multi_tree::create_level(int agn){
    level l;
    ag_tree.at(agn).tree_vec.push_back(l); //Add a new level to agent agn's tree
}

void multi_tree::create_node(int lev, int pos, double agx, double agy, int ag_num, int node_num, int p_num, int a){
    node n;
    ag_tree.at(ag_num).tree_vec.at(lev).level_vec.push_back(n);
    
    ag_tree.at(ag_num).tree_vec.at(lev).level_vec.at(pos).a_number = ag_num; //Each node stores the agent's identifier
    ag_tree.at(ag_num).tree_vec.at(lev).level_vec.at(pos).x = agx; //X-coordinate of a state mapped in the tree
    ag_tree.at(ag_num).tree_vec.at(lev).level_vec.at(pos).y = agy; //Y-Coordinate of a state mapped in the tree
    ag_tree.at(ag_num).tree_vec.at(lev).level_vec.at(pos).n_number = node_num; //Node number is used for tree navigation
    ag_tree.at(ag_num).tree_vec.at(lev).level_vec.at(pos).p_number = p_num; //Parent number is used for tree navigation
    ag_tree.at(ag_num).tree_vec.at(lev).level_vec.at(pos).UCB1 = 0; //Q_UCB1 value
    ag_tree.at(ag_num).tree_vec.at(lev).level_vec.at(pos).q_node = 0; //Q-value
    ag_tree.at(ag_num).tree_vec.at(lev).level_vec.at(pos).action = a; //Action identifier
    ag_tree.at(ag_num).tree_vec.at(lev).level_vec.at(pos).visit_count = 1; //Number of times this state has been visited
}

void multi_tree::create_tree(){
    tree t;
    ag_tree.push_back(t); //Each agent has a unique decision tree
}
