#pragma once

#include <RcppArmadillo.h>
#include <functional>
#include <dual.h>

namespace bondr {

using namespace arma;
using namespace std;
using namespace core;
using uint = unsigned int;

struct reaction {
    uint order;
    function<double(vec&)> propensity;
    function<dual(vector<dual>&)> dual_propensity;
    function<void(vec&)> update;
};

class rnet {
public:
    vector<string> species;
    vector<reaction> reactions;
};

}
