#pragma once

#include <RcppArmadillo.h>
#include <functional>

using namespace std;

struct reaction {
    uint order;
    function<double(const arma::vec&)> propensity;
    function<void(arma::vec&)> update;
};

class reaction_network {
public:
    string name;
    vector<string> species;
    vector<reaction> reactions;
};
