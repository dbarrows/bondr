#pragma once

#include <RcppArmadillo.h>
#include <functional>

namespace bondr {

using namespace arma;
using namespace std;
using uint = unsigned int;

struct reaction {
    uint order;
    function<double(vec&)> propensity;
    function<void(vec&)> update;
};

class rnet {
public:
    vector<string> species;
    vector<reaction> reactions;
};

}
