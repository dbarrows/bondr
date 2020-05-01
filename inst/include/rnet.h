#pragma once

#include <RcppArmadillo.h>
#include <functional>

namespace bondr {

using namespace arma;
using namespace std;

struct reaction {
    uint order;
    function<double(const vec&)> propensity;
    function<void(vec&)> update;
};

class rnet {
public:
    vector<string> species;
    vector<reaction> reactions;
};

}
